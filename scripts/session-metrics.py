#!/usr/bin/env python3
"""Cost metrics (tokens, time, tool calls) for a handoff-implement run.

Reads a Claude Code session transcript (~/.claude/projects/<project>/<session>.jsonl)
and reports, for one slice of it, what the run cost. Use it to compare skill versions
with numbers instead of impressions.

Usage:
  session-metrics.py <session.jsonl>                       # list the skill invocations
  session-metrics.py <session.jsonl> --from 1688 --to 2053 # metrics for a line range
  session-metrics.py <session.jsonl> --from-skill 2        # from the 2nd handoff-implement call to the next one
  add --json for machine-readable output.
"""
import argparse
import glob
import json
import os
import sys
from collections import Counter
from datetime import datetime

IDLE_GAP_S = 120  # a gap longer than this between events is the user thinking, not the agent working


def ts(o):
    return datetime.fromisoformat(o["timestamp"].replace("Z", "+00:00"))


def load(path):
    if os.path.isdir(path):  # a project folder: use its most recent session
        path = max(glob.glob(os.path.join(path, "*.jsonl")), key=os.path.getmtime)
    rows = []
    with open(path, encoding="utf8") as f:
        for i, line in enumerate(f):
            try:
                rows.append((i, json.loads(line)))
            except json.JSONDecodeError:
                pass
    return rows


def skill_calls(rows, name="handoff-implement"):
    out = []
    for i, o in rows:
        if o.get("type") != "assistant":
            continue
        for b in o["message"].get("content", []):
            if b.get("type") == "tool_use" and b.get("name") == "Skill" and b["input"].get("skill") == name:
                out.append((i, o["timestamp"]))
    return out


def milestones(sel):
    """Timestamps of the stages of a run, taken from the transcript itself (no extra tool calls)."""
    m = {}
    edits = ("Write", "Edit", "NotebookEdit")
    for _, o in sel:
        t = o.get("type")
        if t == "assistant":
            for b in o["message"].get("content", []):
                if b.get("type") == "tool_use":
                    n = b["name"]
                    if n == "Skill" and "skill_loaded" not in m:
                        m["skill_loaded"] = o["timestamp"]
                    if n in edits and "first_edit" not in m and "skill_loaded" in m and "user_ok" in m:
                        m["first_edit"] = o["timestamp"]
                    if n.startswith("mcp__claude-in-chrome") and "first_browser" not in m:
                        m["first_browser"] = o["timestamp"]
                    m["last_tool"] = o["timestamp"]
        elif t == "user" and "skill_loaded" in m and "user_ok" not in m:
            c = o["message"].get("content")
            if isinstance(c, str) and not c.startswith("<"):
                m["user_ok"] = o["timestamp"]  # first real user message after the skill started
    return m


def metrics(rows, lo, hi):
    sel = [(i, o) for i, o in rows if lo <= i <= hi and "timestamp" in o]
    usage_by_msg = {}
    ctx_sizes = []  # prompt size of every API call: what the model had to carry
    tools = Counter()
    reads = Counter()
    user_turns = 0
    for _, o in sel:
        t = o.get("type")
        if t == "user":
            c = o["message"].get("content")
            if isinstance(c, str) and not c.startswith("<"):
                user_turns += 1
        if t != "assistant":
            continue
        m = o["message"]
        if m.get("usage"):
            usage_by_msg[m.get("id") or o.get("requestId") or o["uuid"]] = m["usage"]  # last block of a message wins
            x = m["usage"]
            ctx_sizes.append(x.get("input_tokens", 0) + x.get("cache_read_input_tokens", 0) + x.get("cache_creation_input_tokens", 0))
        for b in m.get("content", []):
            if b.get("type") == "tool_use":
                tools[b["name"]] += 1
                if b["name"] == "Read":
                    reads[b["input"].get("file_path", "?").replace("\\", "/").split("/")[-1]] += 1
    u = Counter()
    for x in usage_by_msg.values():
        u["calls"] += 1
        u["input_uncached"] += x.get("input_tokens", 0)
        u["cache_read"] += x.get("cache_read_input_tokens", 0)
        u["cache_write"] += x.get("cache_creation_input_tokens", 0)
        cc = x.get("cache_creation") or {}
        w5 = cc.get("ephemeral_5m_input_tokens", x.get("cache_creation_input_tokens", 0))
        w1h = cc.get("ephemeral_1h_input_tokens", 0)
        # price ratios are the same for every model: cache write 1.25x (5m) or 2x (1h), cache read 0.1x, output 5x
        u["cost_units"] += x.get("input_tokens", 0) + 1.25 * w5 + 2 * w1h + 0.1 * x.get("cache_read_input_tokens", 0) + 5 * x.get("output_tokens", 0)
        u["output"] += x.get("output_tokens", 0)
        u["thinking"] += (x.get("output_tokens_details") or {}).get("thinking_tokens", 0)
    times = [ts(o) for _, o in sel]
    wall = (max(times) - min(times)).total_seconds() if times else 0
    gaps = [(b - a).total_seconds() for a, b in zip(times, times[1:])]
    active = sum(g for g in gaps if g <= IDLE_GAP_S)
    return {
        "lines": [lo, hi],
        "wall_s": round(wall),
        "active_s": round(active),
        "user_turns": user_turns,
        "context_start": ctx_sizes[0] if ctx_sizes else 0,  # > ~60k means the session was not clean
        "context_end": ctx_sizes[-1] if ctx_sizes else 0,
        "context_growth": (ctx_sizes[-1] - ctx_sizes[0]) if ctx_sizes else 0,  # what this run itself added
        **u,
        "cost_units": round(u["cost_units"]),  # input-token equivalents: one number to compare runs
        "milestones": milestones(sel),
        "tools": dict(tools.most_common()),
        "reads": dict(reads.most_common()),
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("session")
    ap.add_argument("--from", dest="lo", type=int)
    ap.add_argument("--to", dest="hi", type=int)
    ap.add_argument("--from-skill", type=int, help="1-based index of the handoff-implement invocation")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    rows = load(a.session)
    calls = skill_calls(rows)
    if a.from_skill:
        lo = calls[a.from_skill - 1][0]
        hi = calls[a.from_skill][0] - 1 if a.from_skill < len(calls) else rows[-1][0]
    elif a.lo is not None:
        lo, hi = a.lo, a.hi if a.hi is not None else rows[-1][0]
    else:
        for n, (i, t) in enumerate(calls, 1):
            print(f"#{n}  line {i}  {t}")
        return
    r = metrics(rows, lo, hi)
    if a.json:
        json.dump(r, sys.stdout, indent=2)
        print()
        return
    for k, v in r.items():
        print(f"{k}: {v}")


if __name__ == "__main__":
    main()

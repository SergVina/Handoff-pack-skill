# Lite mode

For contained changes in a known codebase: one feature in one area, a bug fix, a small refactor; roughly five tasks or fewer. Lite reduces the number of areas and files, never the rigor: the interview still runs until closed, the validation gate is still mandatory and there are still no assumptions.

If during the interview the change touches several areas, adds an integration, changes the data model or grows beyond about five tasks, stop and propose switching to Full mode.

## Interview areas

Cover these, using the matching sections of `interview-checklist.md` for depth, plus the extra questions of any lens that applies (`project-types/README.md`) and, for non-technical users, the extra topics in `non-technical-users.md`:

1. **Goal**: what changes for whom, and how to tell it worked (areas 1 and 14).
2. **Scope**: what is in and what is explicitly out (area 2).
3. **Behavior**: the main flow and its variants (area 3).
4. **Edge cases and errors** (area 5).
5. **Existing code**: what to touch, what not to touch, conventions to follow (area 12).
6. **Verification**: how to test it and what "done" means (areas 10 and 14).
7. **Agent behavior**: autonomy, commits, what it must never do, and which agent tools the team uses (area 15).

Other areas are only explored if the user's answers make them relevant (for example, a bug fix that turns out to involve authentication brings in area 6).

## Output

The agent files from `agent-files.md`, plus one file: `handoff/HANDOFF.md`. Create an empty `handoff/reports/` folder as in Full mode.

## Template: `handoff/HANDOFF.md`

Write headings and prose in the user's language. Keep IDs, status emojis, source values, paths and commands unchanged, and keep the `**Pack format:** 1` line as is. Keep the sections and table columns in the order shown: the agent locates them by position and IDs, not by heading text (see `pack-format.md`).

````markdown
# [Change title]: handoff

**Pack format:** 1
**Summary:** [one line]
**Mode:** Lite · **Project:** New | Existing · **Date:** [YYYY-MM-DD]
**Pack status:** Validated by the user on [date]. [n 🔶 and n ❓, see "Pending"]

## Context
[Why this change, for whom, what it must achieve. In the user's own words.]

## Scope
- **In:** ...
- **Out:** ...

## Decisions
| ID | Decision | Reason | Status | Source |
|---|---|---|---|---|
| D-01 | | | ✅ | user |

## Current state of the code
[Only the parts relevant to this change: files, modules, conventions. Source `repo` or confirmed by the user.]

## Requirements
| ID | Requirement | Acceptance criterion | Status | Source |
|---|---|---|---|---|
| RF-01 | | Given... when... then... | ✅ | user |

[Use `RNF-xx` IDs in the same table for non-functional requirements, if any.]

## Edge cases and errors
| ID | Situation | Expected behavior | Status | Source |
|---|---|---|---|---|
| E-01 | | | ✅ | user |

## Tasks
- [ ] T-01 [short title]

### T-01. [Title]
- **Covers:** RF-01
- **Depends on:** none
- **Files:** create `...`; modify `...` (what changes)
- **Steps:** 1. ... 2. ...
- **Acceptance criteria:** [checkable]
- **How to verify:** `[command]` or [concrete action and expected result]
- **Out of scope:** ...

## Progress log
| Date | Task | Status | Agent notes |
|---|---|---|---|

## Rules for the agent
- [Autonomy, commits, what never to do, definition of done]
- Check the current official documentation of any library before using it; do not rely on remembered APIs.

## Statement inventory
| # | What the user said | Recorded in |
|---|---|---|

## Pending
[If there is nothing: "None: everything was validated with the user." Otherwise:]

### Decisions delegated to the agent 🔶
| ID | What the agent may decide | Limits (what it may not do) | When it must stop and ask | Approved by the user |
|---|---|---|---|---|

### External pending items ❓
| ID | What is missing | Who resolves it | Tasks it blocks | Meanwhile |
|---|---|---|---|---|

### Resolved
[When a pending item is resolved, move it here with the date and link the resulting D-xx.]

## Kickoff prompt
```
Read AGENTS.md and handoff/HANDOFF.md. Do not write code yet. Summarize the change
in 5 lines, list anything that blocks T-01 and, if nothing does, start T-01.
```

## Reporting back
[Copy here, verbatim, the agent-side report instructions from `feedback-prompt.md`. Lite packs have a single phase: reports are `handoff/reports/phase-1-<YYYY-MM-DD>.md`.]

## Pack history
| Version | Date | Change |
|---|---|---|
| v1 | [YYYY-MM-DD] | Initial pack, validated by the user. |
````

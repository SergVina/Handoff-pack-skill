# Agent instruction files

Each coding agent reads its own instruction file when it opens a repository. The pack must reach every agent the team uses, without duplicating content and without overwriting files the team already has.

Tool behavior changes over time. If the user says their tool works differently from this table, follow the user.

## Which file each tool reads

| Tool | Reads natively | What to generate |
|---|---|---|
| GitHub Copilot (VS Code agent mode and coding agent) | `AGENTS.md`, also `.github/copilot-instructions.md` | `AGENTS.md` |
| Cursor | `AGENTS.md`, also its own rules in `.cursor/rules/` | `AGENTS.md` |
| Codex, Windsurf, Gemini CLI and most other agents | `AGENTS.md` | `AGENTS.md` |
| Claude Code | `CLAUDE.md`, **not** `AGENTS.md` | `AGENTS.md` plus a `CLAUDE.md` that imports it |

Rules:

- **Always generate `AGENTS.md`**: it is the shared standard and the single source of the instructions.
- **Generate `CLAUDE.md` only if the team uses Claude Code.** Its first line is `@AGENTS.md`, which imports the shared file, so there is only one set of instructions to maintain. Add Claude-specific notes below the import only if the user asked for them.
- **Do not generate `.github/copilot-instructions.md` or Cursor rules by default.** Copilot and Cursor already read `AGENTS.md`. Only touch those files if the team already uses them (see below) or explicitly asks.

## Template: `CLAUDE.md`

````markdown
@AGENTS.md
````

## When files already exist

Ask in the interview (area 15) whether the repo already has `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md` or Cursor rules. Never overwrite them:

- **In a chat**: do not ship a replacement. Instead, include `handoff/AGENT-FILES.md` in the pack, containing the exact section to append to each existing file (a short block pointing to `handoff/README.md` with the working rules), and tell the user which file each snippet goes into.
- **In an agent with repository access**: show the section you would append to each existing file and ask for permission before editing it.
- If the existing `CLAUDE.md` does not import `AGENTS.md`, propose adding `@AGENTS.md` at its top, or appending the handoff section directly to `CLAUDE.md`. Let the user choose.

## Snippet to append to an existing instruction file

In Lite mode, replace `handoff/README.md` with `handoff/HANDOFF.md` and the action-plan line with its task list.

````markdown
## Handoff pack

This project has a handoff pack in `handoff/`. Before making changes, read
`handoff/README.md` and follow its reading order and working rules. Work through
`handoff/04-ACTION-PLAN.md` one task at a time, and report back as described in
`handoff/README.md` ("Reporting back").
````

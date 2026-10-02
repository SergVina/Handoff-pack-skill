# Handoff pack format

**Format version:** 1

This is the single, versioned definition of the handoff pack: the Markdown files that the `handoff-pack` skill writes in a Claude chat and that the `handoff-implement` skill (or any coding agent) reads and executes in the IDE. The writer and the reader are different skills, often used weeks apart and in different tools, so they can only work together if both follow exactly this contract.

The canonical copy lives in `spec/PACK-FORMAT.md`. Each skill ships an identical copy in its own `references/pack-format.md`, because a skill cannot depend on files outside its folder. Never edit a copy: edit the canonical file and copy it again (`scripts/check-format-sync.sh` fails if they differ).

## Contents

1. Language rule (read first)
2. Versioning and compatibility
3. Variants and files
4. Entry file header
5. IDs
6. Statuses
7. Sources
8. Sections and tables of each file
9. Task card
10. Phase report
11. Pack history and statement inventory
12. Agent files

---

## 1. Language rule (read first)

The pack is written in the user's language. This is the most common source of reading errors, so the rule is strict and the reader must not depend on English wording.

**Translated** (written in the user's language): prose, headings, table header labels, task card field labels ("Covers", "Acceptance criteria"...), entry file header labels except `Pack format`, report section titles, and free-text values such as priorities, phase names or log results.

**Never translated** (kept exactly as defined here or as they appear in the project):

- IDs (`RF-01`, `T-03`...) and the `#` numbers of the statement inventory.
- File and folder names (`handoff/04-ACTION-PLAN.md`, `handoff/reports/`), paths, commands and code identifiers.
- Status emojis: ✅ 🔶 ❓.
- Source values: `user`, `summary`, `repo`.
- The `**Pack format:** <n>` line of the entry file, label included.
- The first line of `CLAUDE.md`: `@AGENTS.md`.

**How a reader locates things.** Never by the exact text of a heading. Use, in this order:

1. The file name.
2. The IDs the section contains (the table with `RF-xx` rows is the functional requirements table, whatever its heading says).
3. The position of the section among the required sections of the file, which always appear in the order given in section 8.
4. The shape of the table: number and order of the required columns.
5. The heading text, only as a last hint.

That is why every required section is always present (see "Not applicable" in section 8) and why required columns keep their order.

## 2. Versioning and compatibility

The entry file (`handoff/README.md` or `handoff/HANDOFF.md`) declares the format version in its header with the literal line `**Pack format:** 1`.

The format version is a single integer. It goes up when a change can make a reader of the previous version misread a pack:

- A required file, section, table column or task card field is added, removed, renamed in meaning or reordered.
- The meaning of an ID prefix, a status or a source changes, or a new one is added.
- The path, name or sections of the phase report change.
- A rule a reader relies on to locate things (section 1) changes.

It does **not** go up for wording changes, clarifications that do not change meaning, or new optional content that a reader can safely ignore: extra sections after the required ones, extra columns after the required ones, lens sections.

The pack version (`v1`, `v2`... in "Pack history") is a different thing: it counts revisions of one pack's content. A pack can be at `v5` and still use format `1`.

**Reader behavior:**

| Situation | What the reader does |
|---|---|
| Known version | Read normally. |
| Higher, unknown version | Compatibility mode: read what can be read, list what differs from this contract, and ask the user before acting on anything that depends on the differences. |
| Line missing (packs created before format 1) | Compatibility mode, as above. Most such packs follow format 1 without the line; say so and continue only after the user's OK. |

A reader never rewrites a pack to "upgrade" it to a newer format. Changing the pack is the writer's job, with the user's approval.

## 3. Variants and files

A pack is **Full** or **Lite**. The reader tells them apart by the entry file: `handoff/README.md` means Full, `handoff/HANDOFF.md` means Lite. If both exist, the reader asks which one is current.

### Full

| File | Presence | Purpose |
|---|---|---|
| `AGENTS.md` | Required | Short pointer and working rules for any agent. |
| `CLAUDE.md` | If the team uses Claude Code | First line `@AGENTS.md`. |
| `handoff/AGENT-FILES.md` | If the repo already had agent files and the pack was delivered from a chat | Snippets to append to existing agent files instead of overwriting them. |
| `handoff/00-START-HERE.md` | If the owner is not technical (or asked for it) | Plain-language guide for the person, not for the agent. |
| `handoff/README.md` | Required | Entry point: header, reading order, rules, kickoff, reporting, history. |
| `handoff/01-CONTEXT.md` | Required | Problem, users, goals, constraints, decisions, glossary, statement inventory. |
| `handoff/02-ARCHITECTURE.md` | Required (see merge note) | Stack, current and target state, components, data, integrations, conventions. |
| `handoff/03-REQUIREMENTS.md` | Required | Functional and non-functional requirements, edge cases. |
| `handoff/04-ACTION-PLAN.md` | Required | Phases, progress, task cards, traceability, progress log. |
| `handoff/05-PENDING.md` | Required | Delegated decisions, external pending items, risks, resolved items. |
| `handoff/reports/` | Required (may be empty) | Phase reports written by the agent. |

Merge note: in very small Full packs, `01` and `02` may be merged into `handoff/01-CONTEXT.md`, which then contains all the sections of `01` followed by all the sections of `02`. The reading order in `README.md` says so.

### Lite

| File | Presence |
|---|---|
| `AGENTS.md` | Required |
| `CLAUDE.md` | If the team uses Claude Code |
| `handoff/AGENT-FILES.md` | Same condition as in Full |
| `handoff/00-START-HERE.md` | Same condition as in Full |
| `handoff/HANDOFF.md` | Required |
| `handoff/reports/` | Required (may be empty) |

An empty folder may not survive a ZIP. If `handoff/reports/` is missing, the reader creates it when it writes the first report; this is not an integrity problem.

## 4. Entry file header

The first lines of the entry file, in this order. Labels are translated except `Pack format`; values in brackets are filled in.

Full (`handoff/README.md`):

```markdown
# [Project name]: handoff pack

**Pack format:** 1
**One-line summary:** [what it is and who it is for]
**Mode:** Full · **Project:** New | Existing
**Date:** [YYYY-MM-DD]
**Pack status:** Validated by the user on [date]. [n 🔶 and n ❓]
```

Lite (`handoff/HANDOFF.md`):

```markdown
# [Change title]: handoff

**Pack format:** 1
**Summary:** [one line]
**Mode:** Lite · **Project:** New | Existing · **Date:** [YYYY-MM-DD]
**Pack status:** Validated by the user on [date]. [n 🔶 and n ❓]
```

`Mode` is always the variant (Full or Lite); `Project` is always the project state (New or Existing).

## 5. IDs

Format: prefix, hyphen, number of at least two digits (`RF-01`, `T-12`, `T-100`). Each prefix has its own sequence, starting at `01`.

| Prefix | Designates | Full: lives in | Lite: lives in |
|---|---|---|---|
| `O` | Goal | `01-CONTEXT.md` › Goals | Not used |
| `C` | Constraint | `01-CONTEXT.md` › Constraints | Not used |
| `D` | Decision made by the user | `01-CONTEXT.md` › Decisions made | `HANDOFF.md` › Decisions |
| `RF` | Functional requirement | `03-REQUIREMENTS.md` › Functional | `HANDOFF.md` › Requirements |
| `RNF` | Non-functional requirement | `03-REQUIREMENTS.md` › Non-functional | `HANDOFF.md` › Requirements |
| `E` | Edge case or error | `03-REQUIREMENTS.md` › Edge cases and errors | `HANDOFF.md` › Edge cases and errors |
| `T` | Task | `04-ACTION-PLAN.md` › Progress and Task cards | `HANDOFF.md` › Tasks |
| `DL` | Decision delegated to the agent | `05-PENDING.md` › Delegated decisions | `HANDOFF.md` › Pending |
| `Q` | External pending item | `05-PENDING.md` › External pending items | `HANDOFF.md` › Pending |
| `R` | Known risk | `05-PENDING.md` › Known risks | Not used |

Each ID is **defined** exactly once (as a table row, a goal line or a task card heading) and may be **cited** anywhere. Phases are numbered `1`, `2`... and statement inventory rows `1`, `2`...; neither is an ID.

**Stability rules.** IDs are fixed once the user approves the pack:

- Never reused and never renumbered, including in later updates.
- New items continue the sequence of their prefix.
- An item that no longer applies stays in place, marked as superseded: the ID and text are struck through and followed by the date and the replacing ID, if any. Example: `~~RF-04 Export to CSV~~ Superseded on 2026-05-02 by RF-09`. A reader recognizes a superseded item by the struck-through ID, not by the word.
- A resolved `DL` or `Q` moves to the "Resolved" section of its file, with the date and the `D-xx` it produced.

## 6. Statuses

Exactly three statuses exist. They appear in the Status column of tables and after goal IDs (`O-01 ✅`).

| Status | Meaning |
|---|---|
| ✅ Confirmed | Validated by the user, or verified in the repository. |
| 🔶 Delegated | The agent may decide it, within limits the user explicitly approved. The limits live in the `DL-xx` row. |
| ❓ Pending | External information is missing. The `Q-xx` row says who resolves it and which tasks it blocks. |

There is no "assumed", "derived" or "proposed" status. A reader that finds any other status treats the item as ❓ and asks.

Superseded (section 5) is a marking, not a status. A task's completion is its checkbox, not a status.

## 7. Sources

Tables with a Source column say how each item was approved:

| Source | Meaning |
|---|---|
| `user` | The user stated it, or chose it in a question. |
| `summary` | An assistant proposal the user approved only through the validation summary or the writing delta. Allowed for low-impact items only. |
| `repo` | Verified in the code of the repository. |

`summary` is never upgraded to `user`: the source records how strong the approval was, and a reader weighs a `summary` item as a weaker approval when deciding whether to ask.

## 8. Sections and tables of each file

Required sections appear in the order listed. Every required section is present; if it does not apply, it contains "Not applicable" (translated) and a one-line reason. Optional content (lens sections, extra notes) goes after the last required section of the file. Extra table columns go after the required ones.

Columns are listed in order. **Status** and **Source** take the values of sections 6 and 7.

### `handoff/README.md` (Full)

1. Header (section 4).
2. How to use this pack: reading order, one line per file. With `00-START-HERE.md`, it is first and marked as being for the person.
3. Working rules for the agent: project rules, behavior rules, definition of done, documentation rule; for non-technical owners, the rules of that profile.
4. Kickoff prompt: one block per tool (for example Claude Code; Copilot and Cursor).
5. Recommended first steps.
6. Reporting back: the agent-side report instructions (section 10).
7. Pack history (section 11).

### `handoff/01-CONTEXT.md`

1. Problem or need.
2. Users and use cases: User · What they need to do · Frequency / context.
3. Goals: list of `O-xx` with status.
4. Non-goals.
5. Constraints: ID (`C`) · Constraint · Type · Status · Source.
6. Decisions made: ID (`D`) · Decision · Reason · Discarded alternatives · Status · Source. For non-technical owners an extra last column says what the decision means for them.
7. Glossary: Term · Meaning in this project.
8. Source material.
9. Statement inventory (section 11).

### `handoff/02-ARCHITECTURE.md`

1. Stack: Layer · Technology · Version · Status · Source. Version is from the repo, the one the user pinned, or "Not pinned".
2. Current state (Existing projects).
3. Reference feature (Existing projects adding something new): Layer · Path · Role in the pattern.
4. Reusable code (Existing projects): What · Path · Signature or usage · Used by task.
5. Checklist for adding this kind of change (Existing projects).
6. Target state.
7. Folder structure.
8. Components and responsibilities: Component · Responsibility · Depends on · Path.
9. Data model.
10. Integrations and external contracts: System · Purpose · Contract · Status.
11. Conventions.
12. Deployment and environments.

### `handoff/03-REQUIREMENTS.md`

1. Functional: ID (`RF`) · Requirement · Priority (Must/Should/Could) · Acceptance criterion · Status · Source.
2. Non-functional: ID (`RNF`) · Category · Requirement · How it is measured · Status · Source.
3. Edge cases and errors: ID (`E`) · Situation · Expected behavior · Status · Source.
4. Out of scope for this version.

### `handoff/04-ACTION-PLAN.md`

1. Phase summary: Phase · Goal · Tasks · Visible result.
2. Progress: one checkbox line per task, `- [ ] T-01 [short title]`; `- [x]` when done.
3. Task cards: one card per task (section 9).
4. Traceability requirement → task: Requirement · Tasks.
5. Progress log: Date · Task · Status · Agent notes. Here "Status" is a short free-text result (for example done, blocked, partial), not the status legend of section 6.

### `handoff/05-PENDING.md`

If there is nothing pending, delegated or risky, the file contains only an explicit sentence saying so. Otherwise:

1. Decisions delegated to the agent 🔶: ID (`DL`) · What the agent may decide · Limits · When it must stop and ask · Approved by the user.
2. External pending items ❓: ID (`Q`) · What is missing · Who resolves it · Tasks it blocks · Meanwhile.
3. Known risks: ID (`R`) · Risk · Likelihood · Impact · Agreed mitigation.
4. Resolved.

### `handoff/HANDOFF.md` (Lite)

1. Header (section 4).
2. Context.
3. Scope: In / Out.
4. Decisions: ID (`D`) · Decision · Reason · Status · Source.
5. Current state of the code.
6. Requirements: ID (`RF` or `RNF`) · Requirement · Acceptance criterion · Status · Source.
7. Edge cases and errors: ID (`E`) · Situation · Expected behavior · Status · Source.
8. Tasks: progress checkbox lines followed by one card per task (section 9).
9. Progress log: Date · Task · Status · Agent notes (as in Full).
10. Rules for the agent.
11. Statement inventory (section 11).
12. Pending: delegated decisions (same columns as Full), external pending items (same columns as Full), and a "Resolved" list; or an explicit sentence saying there is nothing pending.
13. Kickoff prompt.
14. Reporting back (section 10).
15. Pack history (section 11).

### `handoff/00-START-HERE.md`

Written for the person, not for the agent: what this is, what is in the folder, before you start, how to work with the agent, how to check the work, when to come back to the chat, words you may see. Its presence tells the reader that the owner is not technical.

## 9. Task card

A card starts with a heading `### T-xx. [Title]` followed by a list of fields in this order. Labels are translated; the reader identifies fields by order and content.

| # | Field | Full | Lite | Content |
|---|---|---|---|---|
| 1 | Covers | Required | Required | `RF`/`RNF` IDs (and `E` IDs if relevant). |
| 2 | Depends on | Required | Required | `T` IDs, or "none". |
| 3 | Goal | Required | — | What must exist when it is done. |
| 4 | Required context | Required | — | Documents and sections to read; applicable `D` IDs. |
| 5 | Files | Required | Required | Files to create or modify, with what changes. |
| 6 | Pattern to follow | Required | — | Reference feature files and reusable code; "none" in New projects. |
| 7 | Steps | Required | Required | Numbered steps. |
| 8 | Acceptance criteria | Required | Required | Checkable items (checkboxes in Full). |
| 9 | How to verify | Required | Required | A command or a concrete action with its expected result. |
| 10 | Out of scope | Required | Required | What not to touch in this task. |
| 11 | Related pending or delegated items | Required | — | `Q`/`DL` IDs, or "none". |

## 10. Phase report

The agent writes one report at the end of each phase of the plan, or as soon as it is blocked.

- **Path:** `handoff/reports/phase-<N>-<YYYY-MM-DD>.md`, where `<N>` is the phase number from the phase summary (Lite packs have a single phase, `1`) and the date is the day the report is written. If that file already exists, add `-2`, `-3`... before `.md`; never overwrite a report.
- **Ad hoc report:** a report requested outside the phase cycle, or produced with the standalone prompt for packs without "Reporting back", is saved as `handoff/reports/report-<YYYY-MM-DD>.md` with the same nine sections.
- **Language:** the user's language. Section titles are translated; their numbers are not, and the reader locates sections by number.

Exactly these nine sections, in this order, as headings numbered `1.` to `9.`:

1. **Summary**: what was done in the phase, in 3 to 5 lines.
2. **Completed tasks**: each `T-xx` with the verification run and its result.
3. **Deviations from the plan**: what was done differently from the task cards, and why.
4. **Decisions taken**: each decision, saying whether it was delegated (`DL-xx`) or not delegated. Non-delegated decisions are always declared.
5. **Findings about the codebase**: facts the pack does not reflect or contradicts, with file paths.
6. **Problems and blockers**: what failed or is blocked, with error messages if relevant.
7. **Questions for the user**: numbered, each with the options the agent sees.
8. **Proposed changes to the pack**: by ID (add, modify, supersede), with the reason.
9. **Next steps**: the next tasks, in order.

A section with nothing to report says so ("None") instead of being dropped. The agent cites IDs and file paths, does not edit `D`, `RF` or `RNF` items (it proposes changes in section 8), and may only tick task checkboxes, append to the progress log and, where the stack says "Not pinned", record the version used.

## 11. Pack history and statement inventory

**Pack history** is the last section of the entry file: a table Version · Date · Change. The first row is `v1`, the initial pack validated by the user; each update adds `v2`, `v3`... with a one-line summary.

**Statement inventory** records everything the user said and where it went: # · What the user said (verbatim or near-verbatim) · Recorded in. "Recorded in" lists the IDs (or the section, when there is no ID) where the statement is reflected. In Full it is the last section of `01-CONTEXT.md`; in Lite, its own section of `HANDOFF.md`.

## 12. Agent files

- `AGENTS.md` is always present at the repository root. It sends agents to the entry file and lists the basic working rules: read the pack first, one task at a time in dependency order, do not change `D`/`RF`/`RNF` without asking, ask on ❓ and decide 🔶 only within limits, tick tasks and update the progress log, report contradictions, write a phase report. A pack is usable without any extra skill because these rules travel in this file.
- `CLAUDE.md`, when present, has `@AGENTS.md` as its first line, so Claude Code (which does not read `AGENTS.md` on its own) loads the same rules. Anything below that line is optional and Claude-specific.
- Existing agent files are never overwritten. In that case the pack carries `handoff/AGENT-FILES.md` with the snippet to append to each existing file.

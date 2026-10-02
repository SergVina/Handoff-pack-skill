# Handoff pack templates

Skeleton of each file of the Full pack (Lite mode uses `lite-mode.md`; extra sections per kind of project live in the lenses in `project-types/`; for non-technical users add `00-START-HERE.md` from `non-technical-users.md`). Fill every section with content already validated by the user; if a section does not apply, write "Not applicable" and a one-line reason (so it is clear it was not forgotten).

Write headings and prose in the user's language. Keep file names, IDs, status emojis, source values, code identifiers, paths and commands unchanged, and keep the `**Pack format:** 1` line as is. Keep the sections in the order shown and the required columns in the order shown: the agent locates them by position and IDs, not by heading text (see `pack-format.md`). Extra sections (lenses) go after the last template section of the file; extra columns go after the template columns.

## Contents

1. `AGENTS.md` (and `CLAUDE.md`, see `agent-files.md`)
2. `handoff/README.md`
3. `handoff/01-CONTEXT.md`
4. `handoff/02-ARCHITECTURE.md`
5. `handoff/03-REQUIREMENTS.md`
6. `handoff/04-ACTION-PLAN.md`
7. `handoff/05-PENDING.md`

Status legend, valid in every file: ✅ Confirmed (validated by the user or verified in the repo) · 🔶 Delegated to the agent (explicitly approved by the user, with limits; see 05-PENDING.md) · ❓ Pending (external information missing; see 05-PENDING.md). Source: `user` (stated or chosen by the user), `summary` (assistant proposal approved only via the validation summary or writing delta; low-impact only) or `repo`. There is no "assumed" or "derived" status.

---

## 1. `AGENTS.md`

Short on purpose. It is what the agent reads automatically when opening the repo.

````markdown
# Instructions for agents

This project has a handoff pack in `handoff/`.

1. Before making any change, read `handoff/README.md` and follow its reading order.
2. Work through `handoff/04-ACTION-PLAN.md`, one task at a time, in dependency order.
3. Do not change a `D-xx` decision or an `RF/RNF` requirement without asking the user.
4. If something marked ❓ blocks your task, ask before moving on. You may decide 🔶 items yourself, within the limits set in `handoff/05-PENDING.md`.
5. When you finish a task, tick its checkbox and update the progress log in `04-ACTION-PLAN.md`.
6. If you find something that contradicts these documents, say so and propose the fix; do not ignore it.
7. At the end of each phase, or as soon as you are blocked, write a report as described in `handoff/README.md` ("Reporting back").
````

If the team uses Claude Code, also generate `CLAUDE.md` with `@AGENTS.md` as its first line. Claude Code does not read `AGENTS.md` on its own. See `agent-files.md`, including what to do when these files already exist.

---

## 2. `handoff/README.md`

````markdown
# [Project name]: handoff pack

**Pack format:** 1
**One-line summary:** [what it is and who it is for]
**Mode:** Full · **Project:** New | Existing
**Date:** [YYYY-MM-DD]
**Pack status:** Validated by the user on [date]. [n delegated decisions 🔶 and n pending items ❓; see 05-PENDING.md]

## How to use this pack
Reading order: 01 → 02 → 03 → 04 → 05. [one line per file saying what it contains]

## Working rules for the agent
- [Project rules: how to run tests, style, branches, commits, what not to touch. Existing mode: branch to work on, commit format and CI checks that must pass, taken from the repo]
- [Behavior rules: ask on ❓, do not expand scope, one task at a time]
- [Definition of "done": acceptance criteria met and verification run]
- Check the current official documentation of every library before using it; do not rely on remembered APIs.
- [New projects with versions "Not pinned": use the current stable version and record the version used in 02-ARCHITECTURE.md and the progress log]

## Kickoff prompt

### Claude Code
```
Read AGENTS.md and every file in handoff/ in order. Do not write code yet.
When you are done, summarize in 10 lines what you are going to build, list any
doubts that block task T-01 and, if there are none, start T-01 following its card.
```

### GitHub Copilot (agent mode) and Cursor
```
Use the files in the handoff/ folder as context (start with README.md).
Confirm you understand the goal and the plan, point out anything missing to
execute T-01, and then implement it following its acceptance criteria.
```

## Recommended first steps
1. [T-01: what to do and why first]
2. [T-02]
3. [T-03]

## Reporting back
[Copy here, verbatim and in the user's language, the agent-side report instructions from `feedback-prompt.md` (Part A). Reports are saved in `handoff/reports/` and the user brings them back to the chat to update this pack.]

## Pack history
| Version | Date | Change |
|---|---|---|
| v1 | [YYYY-MM-DD] | Initial pack, validated by the user. |
````

---

## 3. `handoff/01-CONTEXT.md`

````markdown
# 01. Context

## Problem or need
[What needs solving and why now. In the user's own words and examples.]

## Users and use cases
| User | What they need to do | Frequency / context |
|---|---|---|

## Goals
- O-01 ✅ [measurable or verifiable goal]

## Non-goals (out of scope)
- [What will explicitly not be done, and why]

## Constraints
| ID | Constraint | Type (technical, legal, deadline, budget, platform) | Status | Source |
|---|---|---|---|---|
| C-01 | | | ✅ | user |

## Decisions made
| ID | Decision | Reason | Discarded alternatives | Status | Source |
|---|---|---|---|---|---|
| D-01 | | | | ✅ | user |

## Glossary
| Term | Meaning in this project |
|---|---|

## Source material
[Examples, links, texts or screenshots the user provided, copied or described. It is the source of truth when in doubt. If this pack replaces an earlier draft (for example a CLAUDE.md written in the conversation), say so here and state that the draft must not be used as a source.]

## Statement inventory
Everything the user said, and where it was recorded. It makes the coverage check auditable.

| # | What the user said (verbatim or near-verbatim) | Recorded in |
|---|---|---|
| 1 | | D-01, RF-03 |
````

---

## 4. `handoff/02-ARCHITECTURE.md`

````markdown
# 02. Architecture

## Stack
| Layer | Technology | Version | Status | Source |
|---|---|---|---|---|

[Version: from the repo in Existing projects. In New projects, the version the user pinned or "Not pinned" (the agent uses the current stable version and records it here).]

## Current state (Existing mode only)
[Actual repo structure, modules, how it runs, tests, detected conventions. Everything with source `repo` or confirmed by the user.]

## Reference feature (Existing mode, when adding something new)
[The existing feature most similar to the new one, confirmed by the user as the pattern to imitate. Layer, path and role in the pattern, plus a few lines on the pattern itself. If none exists, say so.]

| Layer | Path | Role in the pattern |
|---|---|---|

## Reusable code (Existing mode)
| What | Path | Signature or usage | Used by task |
|---|---|---|---|

## Checklist for adding this kind of change (Existing mode)
[Ordered places normally touched (routing, auth, migration, types, tests, i18n, docs...). Each item points to the task that covers it or is marked "not needed" with the reason.]

## Target state
[How the system should end up.]

## Folder structure
```text
[tree, marking [NEW] and [MODIFY] in Existing mode]
```

## Components and responsibilities
| Component | Responsibility | Depends on | Path |
|---|---|---|---|

## Data model
[Entities, fields, types, relationships. A mermaid diagram if it helps.]

## Integrations and external contracts
| System | Purpose | Contract (endpoint, format, auth) | Status |
|---|---|---|---|

## Conventions
[Code style, naming, error handling, logging, tests, commits. In Existing mode, the ones the repo already uses.]

## Deployment and environments
[Where it runs, required environment variables (names only, never values), commands.]
````

---

## 5. `handoff/03-REQUIREMENTS.md`

````markdown
# 03. Requirements

## Functional
| ID | Requirement | Priority (Must/Should/Could) | Acceptance criterion | Status | Source |
|---|---|---|---|---|---|
| RF-01 | | Must | Given... when... then... | ✅ | user |

## Non-functional
| ID | Category (performance, security, accessibility, i18n...) | Requirement | How it is measured | Status | Source |
|---|---|---|---|---|---|

## Edge cases and errors
| ID | Situation | Expected behavior | Status | Source |
|---|---|---|---|---|
| E-01 | | | ✅ | user |

## Out of scope for this version
[What might be requested later but not now.]
````

---

## 6. `handoff/04-ACTION-PLAN.md`

````markdown
# 04. Action plan

## Phase summary
| Phase | Goal | Tasks | Visible result |
|---|---|---|---|
| 1 | | T-01 to T-0x | |

## Progress
- [ ] T-01 [short title]
- [ ] T-02 ...

## Task cards

### T-01. [Title]
- **Covers:** RF-01, RNF-02
- **Depends on:** none
- **Goal:** [what must exist when it is done]
- **Required context:** [documents and sections to read; applicable D-xx decisions]
- **Files:** create `path/a.ext`; modify `path/b.ext` (what changes)
- **Pattern to follow:** [Existing mode: the file(s) of the reference feature to imitate and the reusable code to use; "none" in New mode]
- **Steps:**
  1. ...
  2. ...
- **Acceptance criteria:**
  - [ ] [checkable]
- **How to verify:** `[command]` or [concrete action and expected result]
- **Out of scope:** [what not to touch in this task]
- **Related pending or delegated items:** [Q-xx / DL-xx, if any]

(repeat for each task)

## Traceability requirement → task
| Requirement | Tasks |
|---|---|
| RF-01 | T-01, T-03 |

## Progress log
| Date | Task | Status | Agent notes |
|---|---|---|---|
````

Guidelines for splitting tasks: the first one should leave something runnable end to end (even if minimal); each task fits in one agent session; risky changes (migrations, deletions, wide refactors) are isolated and have an explicit verification step; test tasks go with the functionality, not all at the end.

---

## 7. `handoff/05-PENDING.md`

It only contains what the user explicitly approved leaving this way. In each delegated decision, "Limits" also says where any parameter it introduces will live (configuration, settings panel) and which task exposes it, and defines every term the limits rely on. If there is nothing, write "No pending items or delegated decisions: everything was validated with the user."

````markdown
# 05. Pending items, delegated decisions and risks

## Decisions delegated to the agent 🔶
| ID | What the agent may decide | Limits (what it may not do) | When it must stop and ask | Approved by the user |
|---|---|---|---|---|

## External pending items ❓
| ID | What is missing | Who resolves it | Tasks it blocks | Meanwhile |
|---|---|---|---|---|

["Meanwhile" says what is implemented or assumed while it is open. For a decision that is already implemented but not confirmed by the user, add an optional last column "How to revert" (files to change); extra columns go after the required ones.]

## Known risks
| ID | Risk | Likelihood | Impact | Agreed mitigation |
|---|---|---|---|---|
| R-01 | | | | |

## Resolved
[When a pending item is resolved, move it here with the date and link the resulting D-xx.]
````

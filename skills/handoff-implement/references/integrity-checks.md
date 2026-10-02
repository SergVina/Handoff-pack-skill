# Integrity checks

Run these at startup, after reading the whole pack and before the understanding gate. When resuming, re-run the ones that concern the next task. The point is to find, before any code exists, the places where the pack cannot be executed as written, so the user can settle them in a sentence instead of discovering them in a broken implementation.

You never fix the pack yourself. Each finding goes to the user at the gate (with file, ID and your proposal) and, if it is still open at the end of the phase, to the report (section 6 or 8).

Locate everything as `pack-format.md` describes: by file, IDs, position and table shape, not by English headings. In Lite, every "file" below is the matching section of `handoff/HANDOFF.md`.

## How to collect IDs

1. **Definitions.** An ID is defined only where its prefix lives (section 5 of the contract): a row in that table (first column), a goal line in Goals (`O-xx`), or a task card heading (`### T-xx.`). A row in any other table, such as the traceability table of `04-ACTION-PLAN.md`, is a citation even when the ID is in its first column; counting it as a definition produces false duplicates.
2. **Citations.** Every other appearance of an ID-shaped token (`\b(O|C|D|RF|RNF|E|T|DL|Q|R)-\d{2,}\b`) in any file of the pack, including `AGENTS.md` and the reports.
3. **Superseded.** An ID whose definition is struck through (`~~RF-04 ...~~`) is superseded. It still exists, but it is no longer in force.

Keep a small map: ID → where defined, status, source, superseded or not, cited by.

## Checks

| # | Check | How to detect it | Severity | What to do |
|---|---|---|---|---|
| 1 | Format version | Header line `**Pack format:** <n>` missing or not `1`. | Blocking until the user answers | Compatibility mode: list the differences from the contract and ask before continuing. |
| 2 | Missing required file or section | Compare against the contract's file list (Full or Lite) and the required sections of each file. A section saying "Not applicable" with a reason is present, not missing. A missing `handoff/reports/` is not a problem. | Blocking only if the next task needs it | Report it; ask how to proceed if it affects the next task. |
| 3 | Duplicate ID | The same ID defined twice (two rows, two cards), in the same or different files. | Blocking if the next task covers or depends on it | Show both definitions and ask which one is valid. Never renumber. |
| 4 | Citation of an ID that does not exist | A cited ID with no definition anywhere in the pack. | Blocking if it appears in the next task's card | Show where it is cited and ask what it should point to. A typo is likely, but confirm it rather than guess which ID was meant. |
| 5 | Citation of a superseded ID | A task or requirement in force cites a struck-through ID. | Blocking if it is the next task | Ask whether the citation should move to the replacing ID named in the superseded line. |
| 6 | Requirement without a task | An `RF`/`RNF` in force that no card cites in "Covers" and that is missing from the traceability table. | Not blocking for other tasks | Report it: either a task is missing or the requirement is out of this plan. The user decides. |
| 7 | Task without a requirement | A card whose "Covers" field is empty or cites no `RF`/`RNF`. Setup or test tasks may legitimately cover only `RNF` or `E` items; check what they cite. | Not blocking by itself | Report it and ask which requirement it serves. Implementing it means doing work nobody traced to a need. |
| 8 | Traceability mismatch | The traceability table and the "Covers" fields of the cards disagree (Full only). | Not blocking | Report both versions; trust neither silently. |
| 9 | Card without acceptance criteria or way to verify | The "Acceptance criteria" or "How to verify" field is missing, empty, or not checkable ("works well", "looks fine", an "obvious" case with no concrete input, fixture or value). | Blocking for that task | Propose concrete criteria or a verification step and ask for approval. You cannot claim "done" without them. |
| 10 | Incomplete card | Any other required field of the card (contract section 9) is missing. | Blocking only if the gap matters for this task (for example no "Files" in an existing project) | Report it; ask if it affects how you would implement. |
| 11 | Dependency problems | "Depends on" cites a task that does not exist, depends on a later task in a way that forms a cycle, or depends on a task that is not ticked. | Blocking for the dependent task | Report the cycle or missing task; for unticked dependencies, offer to do them first. |
| 12 | ❓ blocking the next task | A `Q-xx` whose "Tasks it blocks" includes the task, or a ❓ item cited in the card (Related pending items, Covers, Required context), or any ❓ status on a requirement, decision or edge case the task covers. | Blocking for that task | Do not implement it. Say what is missing and who resolves it (the `Q-xx` row). Offer tasks that are not blocked, if the plan allows. |
| 13 | 🔶 without limits | A 🔶 item with no `DL-xx` row, or a `DL-xx` row without limits or a "stop and ask" condition. | Blocking when you reach that decision | Treat the decision as not delegated: ask. |
| 14 | Unknown or absent status | A status other than ✅, 🔶 or ❓ (for example "assumed", "TBD", "?"), or a table with no Status column (older packs; not the tables of `05-PENDING.md`, whose rows are 🔶 or ❓ by definition of the table). | Same as ❓, except for an absent column | Unknown status: treat it as ❓ and ask. Absent column: if the pack status in the entry file header says it was validated by the user, the items inherit that; say so in your status and continue. Otherwise treat them as ❓. |
| 15 | Contradiction between files | Two parts of the pack state incompatible things: a decision vs a requirement, an architecture choice vs a task's files, a name used differently from the glossary, a header count of 🔶/❓ that does not match `05-PENDING.md`, an out-of-scope item that a task implements. | Blocking if it touches the next task | Quote both places with file and ID and ask which is right. Do not pick one. |
| 16 | Pack vs code | In existing projects, and in new projects once any task is ticked or the repository already has code, compare what the pack says about the code (current state, paths, versions, reference feature, reusable code, commands) with the repository. Look at the files the next task touches, at least. A card that says "create" for a file that already exists is the typical finding: an earlier task pulled it forward. | Blocking if it touches the next task | Report with exact paths: what the pack says and what the code shows. The user decides; you do not edit the pack. Never overwrite the existing file: complete it, and propose the card update in the report (section 8). |
| 17 | Unreported progress | Ticked tasks with no progress log entry, or log entries for tasks that are not ticked. | Not blocking | Mention it in the status; do not tick or untick on your own. |

"Blocking" means you do not implement the affected task until the user answers. Other tasks may proceed if they do not depend on it and the user agrees.

## When resuming

A resumption does not repeat all 17 checks. Always re-run checks 1, 3, 4, 9, 10, 11, 12, 14, 15, 16 and 17, limited to the IDs the next card covers or cites. In compatibility mode (no `Pack format` line) list, after the three-line status, only the differences from the contract that affect the next task, one line each, say how many others exist, and ask for a single OK. The full list is only required at first startup.

## How to present the findings at the gate

Group them so the user can answer fast:

```markdown
**Integrity check:** 17 checks, 3 findings.

Blocking T-01:
1. T-01 covers RF-07, which does not exist (04-ACTION-PLAN.md, card T-01). Did you mean RF-01?

Not blocking now:
2. RF-05 has no task (03-REQUIREMENTS.md). Add a task, or is it out of this plan?
3. 02-ARCHITECTURE.md says the API lives in `server/api/`; the code has it in `src/api/`. Which is current?
```

If there are no findings, say so in one line. Saying nothing would leave the user unsure whether you checked.

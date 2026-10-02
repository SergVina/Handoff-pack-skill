# Phase report template

The report is how the IDE side talks back to the chat side. The user takes it to the Claude chat and the `handoff-pack` skill, in Update mode, turns it into changes to the pack, after the user confirms each one. It must follow section 10 of `pack-format.md` exactly, because the chat side reads it section by section.

## When to write it

- At the end of each phase of the plan (the last task of the phase is done and verified).
- As soon as you are blocked: a ❓ stops the next tasks, a non-delegated decision is needed and the user is not available, the code contradicts the pack, or a criterion cannot be met.
- When the user asks for one. Outside the phase cycle, use the ad hoc name `report-<YYYY-MM-DD>.md`.

## Path

`handoff/reports/phase-<N>-<YYYY-MM-DD>.md`

- `<N>`: the phase number from the phase summary of `04-ACTION-PLAN.md`. A Lite pack has a single phase, `1`. A report written because you got blocked uses the number of the phase in progress.
- `<YYYY-MM-DD>`: the day you write it.
- If the file exists, use `-2`, `-3`... before `.md`. Never overwrite a report: the chat may already have used it.
- Create `handoff/reports/` if it is missing.

## Rules

- Write it in the user's language (the language of the pack). Translate section titles, keep their numbers `1.` to `9.`: the chat side finds sections by number.
- All nine sections, in order. A section with nothing to report says "None" (translated); never drop it.
- Be factual. Cite IDs (`T-xx`, `RF-xx`, `RNF-xx`, `E-xx`, `D-xx`, `DL-xx`, `Q-xx`) and file paths.
- Declare every decision you took that was not delegated, even small ones and even if the user approved it in this session. The pack does not know about it until the report says so.
- Do not edit `D-xx`, `RF-xx` or `RNF-xx` in the pack; propose changes in section 8.

## Template

````markdown
# Phase [N] report: [project or change name]

**Pack format:** 1 · **Pack version:** [vN from Pack history] · **Date:** [YYYY-MM-DD] · **Phase status:** [completed | blocked | partial]

## 1. Summary
[What was done in this phase, in 3 to 5 lines.]

## 2. Completed tasks
| Task | Verification run | Result |
|---|---|---|
| T-01 | `[command]` / [manual check] | [passed: details] |

## 3. Deviations from the plan
| Task | What the card said | What was done | Why |
|---|---|---|---|

## 4. Decisions taken
| Decision | Task | Delegated? | Notes |
|---|---|---|---|
| [what was decided] | T-02 | Delegated (DL-01), within its limits | |
| [what was decided] | T-03 | **Not delegated**: approved by the user in the IDE on [date] / taken by the agent because [reason] | Needs confirmation in the chat |

## 5. Findings about the codebase
- [Fact the pack does not reflect or contradicts], in `path/to/file.ext`.

## 6. Problems and blockers
- [What failed or is blocked, which task, error message if relevant, which Q-xx or decision it waits on.]

## 7. Questions for the user
1. [Question]. Options: (a) ... (b) ... [Recommendation, if any, and why.]

## 8. Proposed changes to the pack
| Change | ID | Proposal | Reason |
|---|---|---|---|
| Modify | RF-04 | [new text] | [why] |
| Add | (new) | [new requirement or task] | [why] |
| Supersede | T-06 | [replaced by ...] | [why] |

## 9. Next steps
1. T-xx [title]: [why next]
````

The status line and the tables inside sections are a recommended layout; the nine numbered sections are mandatory.

## After writing it

Tell the user, in their language:

1. Where the report is (exact path).
2. What needs their attention: questions (section 7), non-delegated decisions (section 4) and proposed changes (section 8).
3. What to do: open the Claude chat where the pack was made (or a new one with the `handoff/` folder attached), paste or attach the report, and ask to update the pack with `handoff-pack`. Then bring the updated files back into the repository before continuing with the next phase.

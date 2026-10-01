# Task loop

The procedure for each task, in detail. One task at a time, in dependency order, and only after the understanding gate (or the resumption status) has been accepted.

## 1. Pre-check

Before anything else, confirm the task can be done now:

- **Dependencies.** Every task in "Depends on" is ticked in the progress list. If not, say which one is missing and offer to do it first.
- **No ❓ blocks it.** Look at the `Q-xx` rows whose "Tasks it blocks" include this task, the card's related pending items, and the status of every `RF`, `RNF`, `E` and `D` the card covers or cites. One ❓ is enough to stop: say what is missing and who resolves it, and do not implement. Writing code around an unknown means guessing, and the guess becomes the de facto decision.
- **Delegations.** Note which `DL-xx` items apply, with their limits and their "stop and ask" condition.
- **Read the card and only what it cites.** The required context, the decisions it names, the requirements and edge cases it covers, the pattern to follow. Loading the whole pack again is unnecessary and dilutes attention; skipping the cited context is how decisions get violated.

## 2. Mini-plan

Write a short plan before touching code and show it to the user (unless they asked you to work through several tasks without stopping, in which case keep it in your notes and in the progress log):

```markdown
**T-xx mini-plan**
- Files: create `...`; modify `...` (what changes)
- Approach: [2 to 4 lines; which pattern or reusable code you follow]
- Decisions: [DL-xx you will exercise and within which limits, or "none"]
- Verification: [how each acceptance criterion will be checked; the "How to verify" command]
- Open points: [anything the card does not settle, or "none"]
```

If "Open points" is not empty, ask before implementing. The card is the user's specification; a gap in it is a question for the user, not a design choice for you. If the open point falls inside a `DL-xx`, decide within its limits and record it.

If the plan shows the card is wrong (a file that does not exist, a pattern that does not fit, a step that contradicts a decision), stop and report it with exact paths. Do not adapt the plan silently.

## 3. Implementation

- Stay inside the card: its files, its steps, its "Out of scope". If you notice something else worth doing, note it for the report (section 8), do not do it.
- Follow the conventions in `02-ARCHITECTURE.md` (Lite: "Current state of the code") and the card's "Pattern to follow": imitate the reference feature and reuse the listed code instead of creating new styles or duplicates.
- Use the versions in the stack table. Where it says "Not pinned", use the current stable version and record it in `02-ARCHITECTURE.md` (Stack table) and in the progress log, as the pack's rules ask.
- Check the current official documentation of each library before using it. Remembered APIs are often outdated, and an outdated call that compiles is a hidden defect.
- Write the tests the card asks for together with the code, not afterwards.

## 4. Literal verification

For each acceptance criterion, as written:

1. Check it in the way the criterion implies (run, open, call, inspect).
2. Run the card's "How to verify" step and compare the result with the expected result stated there.
3. Run the project's checks the working rules require (tests, linter, build).

A task is done only when every criterion passes. If one fails and you cannot fix it within the card's scope, the task is not done: leave it unticked, log it as blocked or partial with the reason, and report it. Do not reinterpret a criterion so it passes, and do not replace it with an easier one; if it seems wrong, propose the change.

## 5. Record

- Tick the task in the progress list: `- [x] T-xx ...`.
- Tick the card's acceptance criteria checkboxes, if the card has them.
- Append one line to the progress log (Date · Task · Status · Agent notes), in the user's language:

```markdown
| 2026-03-14 | T-03 | done | Verified with `npm test` (12 passing) and manual check of the empty state. DL-02: chose `date-fns` for formatting. |
```

Notes include: decisions taken under `DL-xx`, any non-delegated decision the user made during the task, deviations, versions used, and anything the next task needs to know.

Only these edits to the pack are yours to make: checkboxes, progress log lines, and recorded versions where the stack says "Not pinned". Everything else is proposed in the report.

## 6. Version control

Only if the pack's working rules or the user ask for it, and exactly as they say: branch name, commit format, one commit per task or per phase, checks that must pass before committing. If the rules say nothing and the user did not ask, do not commit; tell them the task is ready to be committed.

## 7. Tell the user and continue

Tell the user what was done and how it was verified, in two to four lines (plain language and how to try it, for a non-technical owner). Then:

- If this was the last task of a phase, write the phase report (`report-template.md`) before moving on.
- If you are blocked, write the report now; do not wait for the end of the phase.
- Otherwise go on to the next task only if the user asked you to keep going.

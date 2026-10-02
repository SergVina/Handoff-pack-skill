# Task loop

The procedure for each task, in detail. One task at a time, in dependency order, and only after the understanding gate (or the resumption status) has been accepted.

## 1. Pre-check

Before anything else, confirm the task can be done now:

- **Dependencies.** Every task in "Depends on" is ticked in the progress list. If not, say which one is missing and offer to do it first.
- **No ❓ blocks it.** Look at the `Q-xx` rows whose "Tasks it blocks" include this task, the card's related pending items, and the status of every `RF`, `RNF`, `E` and `D` the card covers or cites. One ❓ is enough to stop: say what is missing and who resolves it, and do not implement. Writing code around an unknown means guessing, and the guess becomes the de facto decision.
- **Delegations.** Note which `DL-xx` items apply, with their limits and their "stop and ask" condition.
- **Read the card and only what it cites**, from the files at the start of each task. You may skip re-reading a section only if you read those exact lines earlier in this same session and the files have not changed since (check with git or the modification time); in a new session always read them. The required context, the decisions it names, the requirements and edge cases it covers, the pattern to follow. Loading the whole pack again is unnecessary and dilutes attention; skipping the cited context is how decisions get violated.

## 2. Mini-plan

Write a short plan before touching code and show it to the user (unless they asked you to work through several tasks without stopping, in which case keep it in your notes and in the progress log):

```markdown
**T-xx mini-plan**
- Files: create `...`; modify `...` (what changes)
- Approach: [2 to 4 lines; which pattern or reusable code you follow]
- Decisions: [DL-xx you will exercise and within which limits; implementation details you will decide yourself (the user can veto them at the gate); or "none"]
- New APIs: [libraries or framework APIs used for the first time in this task, or "no new APIs"]
- Verification: [how each acceptance criterion will be checked; the "How to verify" command]
- Open points: [anything the card does not settle that changes what the user sees or can do: text the pack defines in only one language that you would have to translate, new text the pack does not define (with your proposed wording), values the user could want to tune, terms the pack leaves open, files the card does not list but the steps need; or "none"]
```

If "Open points" is not empty, ask before implementing. The card is the user's specification; a gap in it is a question for the user, not a design choice for you. If the open point falls inside a `DL-xx`, decide within its limits and record it.

If the plan shows the card is wrong (a file that does not exist, a pattern that does not fit, a step that contradicts a decision), stop and report it with exact paths. Do not adapt the plan silently.

If the card is not wrong but incomplete, because its "Files" are not enough to complete its steps (shared types, configuration, i18n dictionaries, a state holder), list the extra files under "Open points" and ask. Once approved, record them as a deviation in the progress log and in the report.

What needs the user's OK and what you may decide yourself is the line drawn in the hard limits of `SKILL.md`: anything that changes what the user sees or can do, a tunable value, an open term or the data model needs an OK; internal implementation details do not, but they are listed, marked and declared.

## 3. Implementation

- Stay inside the card: its files, its steps, its "Out of scope". If you notice something else worth doing, note it for the report (section 8), do not do it.
- Follow the conventions in `02-ARCHITECTURE.md` (Lite: "Current state of the code") and the card's "Pattern to follow": imitate the reference feature and reuse the listed code instead of creating new styles or duplicates.
- Use the versions in the stack table. Where it says "Not pinned", use the current stable version and record it where the pack's own rules say (for example only in `package.json`, if `02-ARCHITECTURE.md` says so). If they say nothing, record it in the Stack table of `02-ARCHITECTURE.md` and in the progress log.
- Check the current official documentation of each library or framework API you use for the first time in this task. Remembered APIs are often outdated, and an outdated call that compiles is a hidden defect. If the task uses nothing new, say "no new APIs" in the mini-plan.
- If the card says to create a file that already exists (typically because an earlier task pulled it forward), do not overwrite it: complete it, say so in the mini-plan, record it in the progress log and propose the card update in the report (section 8).
- Text the pack defines in only one language (labels, category names, messages) is not yours to translate or reword, and new text the pack does not define is yours to word only if a `DL-xx` covers UI copy. Otherwise put your proposed wording under "Open points", all together, and ask once.
- If your change breaks tests of an earlier task, change only their fixtures (the data they use), not their expected results, unless a requirement changed; record it as a deviation with the reason. If an expected result must change, ask. An earlier task's test is not yours to "fix" so that it passes.
- When you decide an implementation detail yourself, mark it in the progress log as not delegated at that moment, in the user's language. Do not leave it to be reconstructed when you write the report.
- Write the tests the card asks for together with the code, not afterwards.

## 4. Literal verification

For each acceptance criterion, as written:

1. Check it in the way the criterion implies (run, open, call, inspect).
2. Run the card's "How to verify" step and compare the result with the expected result stated there.
3. Run the project's checks the working rules require (tests, linter, build).

A task is done only when every criterion passes. If one fails and you cannot fix it within the card's scope, the task is not done: leave it unticked, log it as blocked or partial with the reason, and report it. Do not reinterpret a criterion so it passes, and do not replace it with an easier one; if it seems wrong, propose the change.

When a criterion is checked by a test you wrote in this task, show once that the test can fail: violate the criterion itself, that is, make the forbidden case happen (for example add the import the criterion forbids, or remove the condition that implements the rule), see the test fail, and revert it. Do not break an arbitrary line: a violation that fails nothing, or a line the code does not need, proves nothing. If no test fails, the test is not checking the criterion. An empty or badly written test "passes" every criterion.

## 5. Record

- Tick the task in the progress list: `- [x] T-xx ...`.
- Tick the card's acceptance criteria checkboxes, if the card has them.
- Append one line to the progress log (Date · Task · Status · Agent notes), in the user's language:

```markdown
| 2026-03-14 | T-03 | done | Verified with `npm test` (12 passing) and manual check of the empty state. DL-02: chose `date-fns` for formatting. |
```

Notes include: decisions taken under `DL-xx`, any non-delegated decision the user made during the task, deviations, versions used, and anything the next task needs to know.

Only these edits to the pack are yours to make: checkboxes, progress log lines, and recorded versions for "Not pinned" stack entries where the pack's rules say to. Everything else is proposed in the report.

## 6. Version control

Only if the pack's working rules or the user ask for it, and exactly as they say: branch name, commit format, one commit per task or per phase, checks that must pass before committing. If the rules require one branch per task and the previous task's branch is not merged yet, branch from the previous task's branch and say so in your status; ask if the rules say otherwise. If the rules say nothing and the user did not ask, do not commit; tell them the task is ready to be committed.

## 7. Tell the user and continue

Tell the user what was done and how it was verified, in two to four lines (plain language and how to try it, for a non-technical owner). Then:

- If this was the last task of a phase, write the phase report (`report-template.md`) before moving on.
- If you are blocked, write the report now; do not wait for the end of the phase.
- Otherwise go on to the next task only if the user asked you to keep going.

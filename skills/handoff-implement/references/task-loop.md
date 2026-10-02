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
- Verification: [how each acceptance criterion will be checked, in the fewest tool calls that cover it, the instrument that will measure what the criterion promises (for example counting the messages sent to a worker), and the tool it needs (browser, device, account) with whether you have it; if you lack a tool a criterion needs, list it under Open points; the "How to verify" command. If a criterion cannot be met as written with the pack's own rules and values, say so here and list it under Open points]
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
- If a test of the same task, or of an earlier one, fixes behavior that the pack has just changed (a reopened task), update its expected result and declare it as a deviation with the decision that changed it. If your change breaks tests of an earlier task, change only their fixtures (the data they use), not their expected results, unless a requirement changed; record it as a deviation with the reason. If an expected result must change, ask. An earlier task's test is not yours to "fix" so that it passes.
- Open the task's line in the progress log as soon as you start implementing (status "in progress", in the user's language). When you decide an implementation detail yourself, append it to that line at the next checkpoint (after each group of files or each test run, never only at the end), marked as not delegated. The log is the only place that survives a long session, so this is how the report can be written later without reconstructing anything.
- Write the tests the card asks for together with the code, not afterwards.

## 4. Literal verification

For each acceptance criterion, as written:

1. Check it in the way the criterion implies (run, open, call, inspect). Every tool call re-reads the whole conversation, so the longer the session, the more each call costs: group the checks. For an app, write one script that sets up the state, runs the steps and prints a compact pass or fail per criterion, instead of one call per click or per probe; if it fails, fix the script and rerun it whole. Print the whole table or output before and after the change and compute the difference; do not choose beforehand which row you expect to change. Browser tools may time out (about 45 seconds was observed): keep each script short, and poll the state in separate calls instead of waiting inside one script. To feed a fixture to the browser, copy it temporarily into the served folder and delete it afterwards, then check `git status` is clean; typing it by hand is how rows get lost, or you may read the wrong one and conclude that a criterion fails. Use screenshots only for criteria that are visual, and then once, never to read text that a script can print.
2. Run the card's "How to verify" step and compare the result with the expected result stated there.
3. Run the project's checks the working rules require (tests, linter, build).

A task is done only when every criterion passes. If one fails and you cannot fix it within the card's scope, the task is not done: leave it unticked, log it as blocked or partial with the reason, and report it. Do not reinterpret a criterion so it passes, and do not replace it with an easier one; if it seems wrong, propose the change.

When a criterion is checked by a test you wrote in this task, show once that the test can fail: violate the criterion itself, that is, make the forbidden case happen (for example add the import the criterion forbids, or remove the condition that implements the rule), see the test fail, and revert it. Do not break an arbitrary line: a violation that fails nothing, or a line the code does not need, proves nothing. If no test fails, the test is not checking the criterion. An empty or badly written test "passes" every criterion.

### A criterion the pack makes impossible

Sometimes a criterion cannot be met as written, and the cause is the pack, not your code. Typical case: it promises that something changes when an input changes, while the pack's own formulas make that thing independent of the input (for example "changing a threshold updates the labels and the score", when the score depends only on the loss).

Check for this at the mini-plan, when you write how each criterion will be verified, and raise it there under "Open points" together with the others: it costs one sentence at the gate instead of a rework at the end. If you only find it while verifying:

1. Verify everything that can be measured, and say exactly what you verified and what you could not.
2. Do not tick that criterion and do not tick the task. Do not reinterpret the criterion so it passes, and do not call it failed: your code did what the pack can express.
3. Write it in the task's progress log line ("criterion N: pending the user's decision") and in the report (section 8, as a proposed change to the criterion).
4. Tell the user at the end of the task, with the options: accept the measurable reading (then you tick it), or change the criterion in the pack through the chat.

Only the user can accept a different reading of a criterion.

### A criterion you cannot verify

A different case: the criterion is fine, but you cannot run its verification because a tool is missing (the criteria are measured in a browser and you have none; a device; an account). Raise it at the mini-plan, under "Open points" (see the Verification line). If you only find it later:

1. Run everything you can (tests, types, lint, build) and say exactly what you verified and what you could not.
2. Do not tick the criteria or the task, and do not claim them from indirect evidence such as passing tests.
3. Mark the task's progress log line "implemented, pending verification", with what is missing and which tool would settle it.
4. Tell the user at the end of the task what is missing and how to complete it. Nothing else is blocked by this: continue with tasks that do not depend on it, if the user asked you to keep going.
5. Do not install tools or dependencies to get around it without asking (a new dependency needs the user's OK).

When the tool is available later, the line tells the next session to skip the implementation, check the code is unchanged, run the missing verification and tick the task.

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

Only if the pack's working rules or the user ask for it, and exactly as they say: branch name, commit format, one commit per task or per phase, checks that must pass before committing. If the rules require one branch per task and the previous task's branch is not merged yet, branch from the previous task's branch (if the current branch is not a task branch, for example a pack-update branch, branch from it when the user's request says so, and otherwise state the base you chose in your status) and say so in your status; ask if the rules say otherwise. If the pack or the user say anything about commit authorship or trailers, follow it exactly. If the rules say nothing and the user did not ask, do not commit; tell them the task is ready to be committed.

## 7. Tell the user and continue

If you will start a development server or any background process, say in the mini-plan how you will stop it, and that you may not be able to: with restricted permissions the process a tool started can outlive the tool's own "stop" (a child process keeps listening). Stop it before you finish. After stopping it, check with a request to its port that it no longer responds: a tool saying "stopped" is not proof. If it still responds, do not say it is stopped. If you cannot (the process outlives the command that started it), say so in your last message with its port or PID and how to stop it, so it is not left running unnoticed.

Tell the user what was done and how it was verified, in two to four lines (plain language and how to try it, for a non-technical owner). Then:

- If this was the last task of a phase, write the phase report (`report-template.md`) before moving on.
- If you are blocked, write the report now; do not wait for the end of the phase.
- Otherwise go on to the next task only if the user asked you to keep going.

---
name: handoff-implement
description: Reads and executes, with rigor, a handoff pack created by the handoff-pack skill (handoff/README.md or handoff/HANDOFF.md). Before writing code it validates the pack's integrity and stops at an understanding gate for the user's OK; then it implements one task at a time within its card, verifies every acceptance criterion literally, records progress, never changes the user's decisions or requirements, and writes the phase report that handoff-pack uses to update the pack. ALWAYS use it in the IDE when the repository contains handoff/README.md or handoff/HANDOFF.md and the user asks to implement, build or continue something, or says "start the handoff", "read the handoff pack", "implement T-03", "continue with the plan", "next task", "what is blocked", "write the phase report". Spanish triggers too, such as "empieza con el traspaso", "lee el paquete de traspaso", "sigue con el plan", "haz la siguiente tarea", "implementa la T-03", "escribe el informe de fase".
license: MIT
compatibility: Designed for coding agents with repository access (Claude Code, GitHub Copilot agent mode, Cursor and other Agent Skills compatible agents). Reads packs written in pack format 1 by the handoff-pack skill.
metadata:
  version: "1.2.3"
---

# Handoff Implement

Execute a handoff pack the way its author intended: read it whole, check that it holds together, confirm your understanding with the user, then build it one task at a time without leaving the boundaries the user set. At the end of each phase, report back in the exact format the chat side needs to update the pack.

## Why this skill exists

The pack was written in a Claude chat by the `handoff-pack` skill, after interviewing the user until every important detail was settled. Every decision, requirement and limit in it was approved by the user. The pack is the user's voice in a conversation they are not watching line by line.

Agents fail packs in predictable ways: they skim and start coding, fill gaps with plausible guesses, quietly "improve" a decision, mark a task done because it compiles, or expand scope because something looked easy. Each of these turns a validated plan back into guesswork. This skill exists to prevent exactly those failures, and to send back a report that lets the user and the chat keep the pack true.

If the repository has no pack, do not improvise one: tell the user to create it with the `handoff-pack` skill in a Claude chat (web or desktop), which interviews them first. A plan you invent here would contain exactly the unvalidated assumptions the pack exists to remove.

## The pack format

`references/pack-format.md` is the contract: files, IDs, statuses, sources, required sections, task card fields and report format. Read it in full the first time you open a pack (Startup). When you are resuming a pack that already has progress, do not read it: the two rules below, `references/task-loop.md` (task card fields, checks) and `references/report-template.md` (phase report) carry what you need, and the contract is 5,000 tokens you would carry in every call of the session. Open only the section you are unsure about (its Contents lists them). Two rules from it matter on every read:

- **The pack is in the user's language.** Headings, table labels and field labels are translated; IDs, file names, paths, status emojis (✅ 🔶 ❓) and source values (`user`, `summary`, `repo`) are not. Locate sections by file, by the IDs they contain, by their position and by table shape, never by English heading text. A Spanish pack has "Criterios de aceptación", not "Acceptance criteria", and both are the same field.
- **Only three statuses exist.** ✅ confirmed, 🔶 delegated within written limits, ❓ pending external information. Anything else is treated as ❓. A table with no Status column (older packs) inherits the pack status in the entry file header when that says the pack was validated by the user: say so in your status and continue. If the header does not say that, treat those items as ❓.

Talk to the user in their language, which is the language of the pack. Write the progress log and reports in that language too.

## Startup (before touching any code)

Do these steps in order the first time you open a pack, and whenever the user says "start the handoff" or equivalent.

1. **Locate the pack.** `handoff/README.md` means a Full pack; `handoff/HANDOFF.md` means a Lite pack. If both exist, ask which one is current. If neither exists, stop and point the user to `handoff-pack` (see above).
2. **Read the format version.** The entry file header has `**Pack format:** <n>`. If it is `1`, continue. If it is missing or unknown, work in compatibility mode: read what you can, list what differs from the contract, and ask the user before continuing. Do not rewrite the pack to fit the contract; that is the chat's job, with the user's approval. When you are resuming a pack that already has progress, use the shortened form described under "Resuming in a later session".
3. **Read the whole pack** in the reading order given in the entry file. Read `00-START-HERE.md` too if it exists: it tells you the owner is not technical (see "Non-technical owner"). Read `AGENTS.md`, `CLAUDE.md` and the latest report in `handoff/reports/`, if any. Do not start from the task list: a task card cites decisions and constraints that only make sense with the context.
4. **Check integrity.** Run every check in `references/integrity-checks.md`: duplicate IDs, citations of IDs that do not exist, requirements without a task, tasks without a requirement, cards without acceptance criteria or a way to verify, ❓ items blocking the next task, contradictions between files, and the pack against the code. Collect the findings; do not fix the pack.
5. **Understanding gate.** Present to the user, in this order:
   - What will be built, in 10 lines at most, in your own words (this is how the user sees whether you understood).
   - The integrity problems found, each with file and ID and what you propose.
   - The doubts that block the next task, and the ❓ items that block it.
   - The task you would start with, and why.

   Then wait for an explicit OK. Do not write code before it. This is the agent-side twin of the validation gate in `handoff-pack`: a misunderstanding caught here costs a sentence, caught after implementation it costs a rewrite.

**Resuming in a later session.** When the pack already has ticked tasks or progress log entries, you do not need the full gate again. Read only what the next task needs, not whole files (a Full action plan is about 6,000 tokens that every later call re-reads): the entry file header; from `04-ACTION-PLAN.md` the progress list, the log and the next task card, found by their headings or with grep; the pending items; and the whole latest report (see below on what it means). Find the other IDs with grep. Then re-run checks 1, 3, 4, 9, 10, 11, 12, 14, 15, 16 and 17 of `references/integrity-checks.md`, limited to the IDs the next card covers or cites. Give the user a three-line status (where things stand, next task, anything blocking). If the pack has no `Pack format` line, add after the status only the differences from the contract that affect the next task, one line each, say that others exist (do not give a number you did not verify) and ask for a single OK, then wait for it: this OK is required even when the user already told you to continue, because they have not seen the differences. Ask once per session; do not ask again for later tasks of the same session unless something new appears. The full list is only needed at first startup. In a pack that has the `Pack format` line, if the user already named what to do and nothing new blocks it, continue; if anything changed or blocks, wait for their OK.

**An "in progress" line in the progress log means a task was interrupted.** Read the notes in it and check the repository (`git status`, `git diff`) before continuing, and tell the user what you found instead of starting the task over.

**Reports are your own earlier output, not the user's decisions.** What a report in `handoff/reports/` contains (decisions taken, answers it assumed, proposed changes) counts as approved only if the user answered it explicitly in this session, or if the pack's history has a row that cites that report, which means the chat processed it. If neither is visible, treat all of it as not approved, say so in one line in your status, and do not build on it. Do not guess which case applies: when the pack has no history, treat the report as not processed unless the user says otherwise.

## Task loop

One task at a time, in dependency order. The full procedure, with a mini-plan template, is in `references/task-loop.md`. In short:

1. **Pre-check.** Every task in "Depends on" is ticked; no ❓ blocks this task (check the "Tasks it blocks" column of the pending items and the card's related items); read the card and only the context it cites, from the files, unless you read those exact sections earlier in this session and the files have not changed since (check with git or the modification time).
2. **Mini-plan.** In a few lines: files, approach, how you will verify. If the plan reveals something the card does not settle, ask before implementing.
3. **Implement** within the card's scope, following the conventions and the pattern to follow in `02-ARCHITECTURE.md` (or "Current state of the code" in Lite). Check the current official documentation of every library or framework API you use for the first time in this task, and write "no new APIs" in the mini-plan if there are none; do not rely on remembered APIs, which drift between versions.
4. **Verify literally.** Check each acceptance criterion exactly as written and run the "How to verify" step. A task is not done if any criterion fails, even if the rest works: the criteria are what the user approved as "done". If a criterion cannot be met as written because the pack contradicts itself (not because your code fails), do not tick it, do not reinterpret it and do not call it failed: see "A criterion the pack makes impossible" in `references/task-loop.md`. While you verify, read the errors and warnings that what you ran prints (terminal, browser console). When a criterion is checked by a test you wrote in this task, show once that the test fails when the criterion itself is violated (make the forbidden case happen, not an arbitrary line) and then revert it: a test that cannot fail proves nothing, and if no test fails the test is not checking the criterion.
5. **Record.** Open the task's line in the progress log when you start implementing (status "in progress", in the user's language) and add each implementation detail you decide yourself to it at that moment, marked as not delegated, so nothing has to be reconstructed later. When the task ends, complete the line and tick the task's checkbox: date, task, result, notes (decisions taken under a `DL-xx`, those details, deviations, work pulled forward from another task, versions used for "Not pinned" stack entries where the pack says to record them).
6. **Version control.** Branch and commit only if the pack's working rules or the user ask for it, and then exactly as they say (branch names, commit format, checks that must pass).

After each task, tell the user in a few lines what was done and how it was verified, then move to the next task only if the user asked you to keep going.

## Hard limits

Each limit protects the user's authority over their own project. Keep them even when breaking one would be faster.

- **Do not modify `D-xx` decisions or `RF`/`RNF` requirements**, in the code or in the pack. They are the user's decisions, taken in an interview you did not attend. If one looks wrong or impossible, propose the change in the report (section 8) and, if it blocks you, ask.
- **Decide 🔶 items only within their written limits** (the `DL-xx` row: what you may decide, what you may not, when to stop and ask) and record every such decision in the progress log and the report. The user delegated a bounded choice, not a blank cheque.
- **Stop and ask on any non-delegated decision that changes what the user sees or can do:** anything visible in the interface or output, a value they could want to tune, how to read a requirement or term the pack leaves open, and the data model or shared types. This includes text the pack defines in only one language (labels, category names, messages), which you may not translate or reword, and new text the pack does not define at all: unless a `DL-xx` covers UI copy, list your proposed wording under "Open points" of the mini-plan, so that one OK settles them. The user approved those words, not your version of them. The practical test: if the user, trying it, could say "I expected it to work differently", it is not a detail, even when it feels small (whether a change applies on typing or on a button, whether a confirmation appears and where, which control is used, what is shown while something loads). Pure implementation details (a helper's name, an internal structure, a test layout) you may decide yourself, but list each one under "Decisions" of the mini-plan, or mark it as not delegated in the progress log when it appears during the work, and declare it in the report. If the user is not available, do not decide: mark the task as blocked in the progress log, say what you need, and move on only to tasks that do not depend on it. A guess presented as progress is worse than a visible block.
- **If the code contradicts the pack, stop and report it** with exact file paths and the IDs involved. Do not "fix" the pack on your own initiative and do not silently follow either side: the user decides which one is right.
- **Do not expand scope**, even when something looks easy or obviously useful. Respect each card's "Out of scope". Note the idea in the report as a proposed change instead; unapproved extras are untested surface the user never asked for.
- **Do not hide anything.** Every non-delegated decision, deviation and failed check goes into the report.

## Non-technical owner

If the pack has `handoff/00-START-HERE.md`, the owner does not code. The work is the same; how you talk changes:

- After each task, explain in plain language what now exists and exactly how to try it (what to open, what to click, what they should see).
- Ask for explicit permission before anything that costs money, creates accounts or deletes data, and before installing paid services. Explain the consequence in their terms.
- When something needs their action (create an account, add a key), give step-by-step instructions.
- Save progress often with version control, if the pack's rules include it, and tell them how to go back if something breaks.

## Phase report

At the end of each phase, or as soon as you are blocked, write a report following `references/report-template.md`:

- Path `handoff/reports/phase-<N>-<YYYY-MM-DD>.md` (`N` from the phase summary; Lite packs have phase `1`). Create `handoff/reports/` if it is missing. Never overwrite an existing report; add `-2`, `-3`.
- Exactly the nine numbered sections of the contract, in the user's language. A section with nothing to say says "None"; it is never dropped, because the chat side reads sections by number.
- Non-delegated decisions are always declared, even small ones and even if the user approved them in this session: the pack does not know about them until the report says so.

When the report is written, tell the user where it is and what to do with it: open the Claude chat (where the pack was made, or a new one with the pack attached), paste or attach the report, and ask to update the pack with `handoff-pack`. That closes the loop: the pack stays the single source of truth.

## When the user asks for something else

- **"Implement T-07"** out of order: run the pre-check. If its dependencies are not done or a ❓ blocks it, say so and offer the options (do the dependencies first, or proceed only if the user accepts the risk and you record it as a deviation).
- **A change not in the pack** ("also add a dark mode"): it is a scope change. Explain that it is not in the pack, offer to note it as a proposed change in the report, and implement it only if the user explicitly asks you to anyway; then record it as a non-delegated deviation.
- **"What is blocked?"**: list ❓ items with their owners and blocked tasks, tasks marked blocked in the log, and open questions from the latest report.

## References

- `references/pack-format.md`: the pack format contract (identical copy of the canonical spec). Read it on first use in a session.
- `references/integrity-checks.md`: every integrity check, how to detect it and what to do. Read it at startup.
- `references/task-loop.md`: the per-task procedure in detail, with the mini-plan template.
- `references/report-template.md`: the phase report template, consistent with the contract. Read it before writing a report.

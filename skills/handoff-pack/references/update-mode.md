# Update mode

Use it when a pack already exists and something has changed: the IDE agent sent a progress report, a decision changed, scope grew or shrank, a pending item was resolved. The goal is to keep the pack the single source of truth without regenerating it, so IDs, progress and history survive.

The same rules apply as in creation: interview until closed, validation gate before writing, no assumptions.

## Procedure

### 1. Get the current pack
Work from the real files, never from memory of a previous conversation. In a chat, ask the user to attach or paste the current `handoff/` (at least the files likely to change and the entry file, `README.md` or `HANDOFF.md`). In an agent with repository access, read them from disk.

### 2. Identify the trigger
What changed and where it comes from: an agent report (see `feedback-prompt.md`), a new decision by the user, a scope change, a resolved ❓. Capture its statements verbatim, as in Step 1 of creation.

### 3. Impact analysis
List every ID affected, directly or by knock-on effect (a changed decision can invalidate requirements, tasks and acceptance criteria). Classify each change:

| Type | Meaning |
|---|---|
| Added | New item with a new ID (continue the numbering; never reuse an ID). |
| Modified | Same ID, content changes. |
| Superseded | The item no longer applies; it stays in the file, marked as superseded, with the date and the ID that replaces it, if any. |
| Completed | A task finished and verified, according to the report. |
| Resolved | A ❓ or 🔶 settled by the user; it moves to "Resolved" in `05-PENDING.md` and produces a `D-xx`. A ❓ the user has not answered stays open: registered, not resolved. |

### 4. Interview about the change only
Ask only about what changed and its knock-on effects, with the same rules as the creation interview. If there is no question tool or the user is not available, show the change summary of step 5 and end your turn: the answer arrives in the next message. Pay special attention to agent reports:
- **Deviations** from the plan: confirm or reject each one.
- **Decisions the agent took that were not delegated**: the user must confirm them (they become `D-xx`) or ask for them to be reverted (a new task). If someone other than the user approved them (an orchestrating agent, an assistant), they do not become `D-xx` with source `user`: record each as a ❓ with the user as owner, what is implemented meanwhile and how to revert it, until the user confirms. Group low-impact ones by topic; a high-impact one (a formula, a threshold, a rule) gets its own ❓.
- **Proposals that would add scope** (a new requirement, a new rule for the agent): record them as ❓ marked "proposal", never as a task or a `D-xx`.
- **A conflict between the pack and the code that no `D-xx`, `RF` or `RNF` contradicts literally**: first check the literal text of each ID the report cites (it may not say what is claimed); keep the original text, add a visible note with the ID of the ❓ that tracks it, and do not align the pack to the code without the user's OK.
- **A report row that reads two ways** (for example a parenthesis that may be a discarded alternative or an implemented notice): check the agent's progress log to disambiguate, and ask if it stays unclear.
- **A report that replaces an earlier one** of the same phase: the earlier one is history; do not edit it, and cite the replacement in the "Pack history" row.
- **New findings** about the codebase: they become facts with source `repo` once confirmed.
- **Questions from the agent**: each one is answered or recorded as ❓.
- **Criteria the agent could not meet because the pack contradicts itself**: the agent leaves the task unticked until the user decides, so settle it with them: change the criterion (and any decision that clashes with it) or accept the measurable reading the agent verified. Tell the user the agent is waiting for that answer.

### 5. Validation gate with a change summary
Before editing, show a table in the chat and ask for an explicit OK:

| ID | Change | Before | After | Reason |
|---|---|---|---|---|

No answer is not an OK: even if you were told that nobody will answer in this turn, do not edit anything before an explicit OK on this table. Show it, say what you are waiting for and end your turn; the user, or whoever answers for them, replies in the next message. (Applying the changes because nobody could object is exactly the silent decision this skill exists to prevent.)

The same safeguards as in creation apply: high-impact changes get their own question, and anything you find while editing that the change summary did not settle goes through a writing delta before delivery.

### 6. Apply the changes
- Edit only the affected files and sections. Do not rewrite or reformat unrelated content.
- Keep checkboxes and the progress log; append a new log entry describing the update.
- Mark superseded items in place, for example: `~~RF-04 ...~~ Superseded on [date] by RF-09`.
- Bump the pack version in the "Pack history" table of the entry file (`README.md` in Full, `HANDOFF.md` in Lite) with date and a one-line summary (v1, v2...). This is the pack's content version, not the `Pack format` line, which only changes with the format contract.
- Keep the section and column order of the templates, so the agent can still locate everything by position and IDs (see `pack-format.md`).
- If the pack predates the format contract (no `Pack format` line, no "Reporting back" or "Pack history" sections, tables without Status or Source columns), include the alignment in the change summary as separate rows, so the user approves it, and apply it with the update: add the line, the sections and the columns, without renumbering any ID.
- Update the traceability table if requirements or tasks changed, and add new user statements to the statement inventory.
- Facts verified in the code that the user has not confirmed yet (for example the shape of an export) go in an optional section at the end of `02-ARCHITECTURE.md`, each with the ❓ that tracks it, as source `repo`.
- Tick a task's checkboxes only as far as the report states the verification it ran; the implementing agent ticks its own tasks, the update only reflects it.

### 7. Verify and deliver
Run the creation checklist again, plus this closing checklist: IDs are stable (compare the IDs defined before and after, for example with `git diff` on the tables), no unrelated content changed (`01-CONTEXT.md` and `03-REQUIREMENTS.md` stay as they were unless the summary said otherwise), the counters of the entry file header (🔶 and ❓) are recalculated, the change summary matches the files, and the pack still meets the contract's required sections (if it does not, add the alignment as rows of the summary). In a chat, deliver the full updated pack as `handoff.zip` and list the changed files in one line each. In an agent with repository access, edit the files in place.

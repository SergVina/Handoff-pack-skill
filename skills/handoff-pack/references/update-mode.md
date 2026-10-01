# Update mode

Use it when a pack already exists and something has changed: the IDE agent sent a progress report, a decision changed, scope grew or shrank, a pending item was resolved. The goal is to keep the pack the single source of truth without regenerating it, so IDs, progress and history survive.

The same rules apply as in creation: interview until closed, validation gate before writing, no assumptions.

## Procedure

### 1. Get the current pack
Work from the real files, never from memory of a previous conversation. In a chat, ask the user to attach or paste the current `handoff/` (at least the files likely to change and `README.md`). In an agent with repository access, read them from disk.

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
| Resolved | A ❓ or 🔶 settled; it moves to "Resolved" in `05-PENDING.md` and produces a `D-xx`. |

### 4. Interview about the change only
Ask only about what changed and its knock-on effects, with the same rules as the creation interview. Pay special attention to agent reports:
- **Deviations** from the plan: confirm or reject each one.
- **Decisions the agent took that were not delegated**: the user must confirm them (they become `D-xx`) or ask for them to be reverted (a new task).
- **New findings** about the codebase: they become facts with source `repo` once confirmed.
- **Questions from the agent**: each one is answered or recorded as ❓.

### 5. Validation gate with a change summary
Before editing, show a table in the chat and ask for an explicit OK:

| ID | Change | Before | After | Reason |
|---|---|---|---|---|

The same safeguards as in creation apply: high-impact changes get their own question, and anything you find while editing that the change summary did not settle goes through a writing delta before delivery.

### 6. Apply the changes
- Edit only the affected files and sections. Do not rewrite or reformat unrelated content.
- Keep checkboxes and the progress log; append a new log entry describing the update.
- Mark superseded items in place, for example: `~~RF-04 ...~~ Superseded on [date] by RF-09`.
- Bump the pack version in the "Pack history" table of `README.md` (v1, v2...) with date and a one-line summary.
- Update the traceability table if requirements or tasks changed, and add new user statements to the statement inventory.

### 7. Verify and deliver
Run the creation checklist again, plus: IDs are stable, no unrelated content changed, the change summary matches the files. In a chat, deliver the full updated pack as `handoff.zip` and list the changed files in one line each. In an agent with repository access, edit the files in place.

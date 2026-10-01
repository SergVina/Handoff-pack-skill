# Progress report: the loop back to the chat

The handoff goes from the chat to the IDE. This file closes the loop: at the end of each phase (or when blocked), the agent writes a structured report that the user brings back to the chat, and the skill uses it in Update mode to keep the pack accurate.

It has two parts: the instructions that travel inside the pack for the agent, and what you do when the report arrives.

## Part A. Agent-side instructions (included in the pack)

Copy this block verbatim into the "Reporting back" section of `handoff/README.md` (Full) or `handoff/HANDOFF.md` (Lite), translated into the user's language. Keep the section names, so reports are easy to process.

````markdown
At the end of each phase of the action plan, or as soon as you are blocked, write a
report in `handoff/reports/phase-<N>-<YYYY-MM-DD>.md` with exactly these sections.
Be factual and cite IDs (T-xx, RF-xx, D-xx, DL-xx, Q-xx) and file paths.

1. Summary: what was done in this phase, in 3 to 5 lines.
2. Completed tasks: each T-xx with the verification you ran and its result.
3. Deviations from the plan: what you did differently from the task cards, and why.
4. Decisions taken: each decision you made, saying whether it was delegated (DL-xx)
   or NOT delegated. Never hide a non-delegated decision.
5. Findings about the codebase: facts you discovered that the pack does not reflect
   or contradicts, with file paths.
6. Problems and blockers: what failed or is blocked, with error messages if relevant.
7. Questions for the user: numbered, each with the options you see.
8. Proposed changes to the pack: by ID (add, modify, supersede), with the reason.
9. Next steps: the next tasks you would do, in order.

Do not edit D-xx decisions or RF/RNF requirements yourself: propose the change in
section 8. You may tick task checkboxes and append to the progress log.
````

## Part B. Standalone prompt (for packs created without Part A)

If the user's pack predates this feature, or they want a report at any moment, give them this to paste into their IDE agent:

````text
Write a progress report about the work done on this project following the handoff
pack in handoff/. Save it as handoff/reports/report-<YYYY-MM-DD>.md with these
sections: summary; completed tasks with verification; deviations from the plan;
decisions taken (delegated DL-xx or not delegated); findings about the codebase;
problems and blockers; questions for the user; proposed changes to the pack by ID;
next steps. Be factual, cite IDs and file paths, and do not modify the pack itself.
````

## Part C. When the report arrives in the chat

Treat it as the trigger for Update mode (`update-mode.md`). Everything in the report is information from the agent, not a decision by the user: deviations, non-delegated decisions and proposed changes are confirmed or rejected by the user in the update interview before anything changes in the pack.

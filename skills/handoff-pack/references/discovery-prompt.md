# Discovery prompt (Existing mode)

The user's repository cannot be seen from a chat. This prompt makes the agent in their IDE inspect it and return real facts, which are then pasted back into the chat so the pack is written on a verified base.

## How to offer it to the user

Explain it in two sentences, in the user's language, along these lines: "Paste this into the agent in your VS Code (Claude Code, Copilot in agent mode, etc.). It will give you a report: copy it here and I will write the pack from it." Deliver it in a code block so it is easy to copy, and adapt the "Focus" line to what the user wants to do. Translate the prompt into the user's language if that makes it easier for them; the agent understands either.

## Prompt

````text
I need you to inspect this repository and give me a READ-ONLY report.
Do not modify files, do not install anything and do not run commands with side effects
(tests and linters are fine if they are safe). If you cannot check something, write
"NOT VERIFIED" instead of guessing. Do not include secrets or environment variable values,
only their names.

Focus: [describe in one line what the user wants to do: new feature, refactor, migration...]

Give me, in Markdown and with these sections:

1. Summary: what the project does, in 5 lines at most.
2. Stack: languages, frameworks, package manager, versions (from the dependency files).
3. Structure: folder tree up to 3 levels, with one line per relevant folder.
4. How it runs: exact commands to install, start, test, build and lint,
   as they appear in package.json, Makefile, pyproject, README, etc.
5. Entry points and flow: main entry points and how a typical request or run flows.
6. Data model: relevant entities, schemas or migrations and where they live.
7. External integrations: APIs, services, databases, queues, and the environment
   variables required (names only).
8. Detected conventions: code style, naming, error handling, logging, test layout,
   commit format, linter/formatter configuration.
9. Tests: framework, location, approximate coverage, whether they pass or fail right now.
10. Areas related to the focus: files and modules that would need to change or would
    be affected, with exact paths.
11. Visible debt and risks: dead code, TODOs, duplication, outdated dependencies,
    fragile or untested parts.
12. What I could not verify.

Cite exact file paths for every statement.
````

## How to use the result

- Treat every statement with a file path as a verified fact (source `repo`) and use it in `02-ARCHITECTURE.md` under "Current state".
- Anything marked "NOT VERIFIED" is not taken as true: ask the user during the interview or ask them to have the agent check it. It only goes to `05-PENDING.md` if it remains unresolved and the user agrees to leave it that way.
- Section 10 feeds the file lists of the plan's tasks directly.
- If the report contradicts what the user said in the chat, do not pick silently: take it to the interview and let the user decide which is correct.

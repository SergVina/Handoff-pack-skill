---
name: handoff-pack
description: Interviews the user until every important detail is settled and, only after they approve a summary, writes a Markdown handoff pack (context, architecture, requirements, task-by-task action plan, next steps and pending items) so a coding agent in the IDE (Claude Code, GitHub Copilot agent mode, Cursor, etc.) can start implementing without losing context. ALWAYS use it when the user wants to hand an idea, need or project, new or existing, from the chat to an agent in their IDE; asks for a detailed action plan, PRD, spec, brief, CLAUDE.md, AGENTS.md or copilot-instructions; or says "prepare the docs for the agent", "give me the context for Copilot", "don't lose anything" or "handoff", even without mentioning .md files. Spanish triggers too, such as "prepárame la documentación para el agente", "dame el contexto para Copilot", "que no se pierda nada", "traspaso".
license: MIT
compatibility: Designed for Claude chats (web and desktop); also works in Claude Code and other Agent Skills compatible agents. The generated pack is tool-agnostic Markdown for Claude Code, GitHub Copilot, Cursor and similar agents.
metadata:
  version: "1.0.0"
---

# Handoff Pack

Turn an idea, a need or an existing project into a pack of Markdown files that a coding agent in the IDE can read and execute on its own. Everything in the pack has already been validated by the user: first you interview, then you summarize for approval, and only then you write.

## Why this skill exists

The IDE agent has no access to this conversation. Whatever is not written down does not exist for it: decisions made, constraints, exact names, edge cases, things the user ruled out. When a detail is missing, the agent fills it with a guess, and that guess is usually wrong and expensive to undo.

That is why this skill leaves **no assumptions, silent or explicit**. If something important is unknown, ask. Correcting a document that already looks complete is much worse than answering a question before it is written: people tend to accept what they read, and a well-written assumption slips through unnoticed.

## Language

Talk to the user in their language, and write the pack in that language too (prose and headings). Keep IDs, file names, status emojis, code identifiers, paths and commands exactly as defined here or as they appear in the project.

## Workflow

Follow the steps in order. Do not write any file of the pack before the OK in Step 4.

### Step 0. Detect the mode

- **New**: a project from scratch.
- **Existing**: there is code already (improvement, refactor, new feature, migration, fix).
- If it is not stated, infer it from what the user says. Only ask if it truly cannot be inferred.

### Step 1. Capture everything the user said

Build an inventory of **every atomic statement** the user makes: goals, preferences, named technologies, constraints, examples, numbers, "I don't want X", "it must be Y". Each one must end up in some file with its ID, and this inventory is the basis for the coverage check in Step 5.

Keep proper names, numbers, field names, paths and quotes verbatim. Paraphrasing is where information gets lost.

### Step 2. Discovery (Existing mode only)

You cannot see the user's repository from a chat, and you must not invent its structure. In order of preference:

1. If the user attached files or pasted code, read them and use them as the source.
2. If not, offer the prompt in `references/discovery-prompt.md`. The user pastes it into their IDE agent, which can see the repo, and brings back the report.
3. If the user would rather not, continue, but every fact about the existing code has to go through the interview: you ask, you do not assume.

Anything that comes from real code has source `repo`. If the report contradicts what the user said, do not pick silently: take it to the interview.

If you are running inside an agent that can read the repository (Claude Code, Copilot, Cursor...), inspect it yourself following the same discovery prompt, read-only.

### Step 3. Interview until closed

This is the core step. Interview the user in rounds until no important nuance is left unverified.

**What to cover.** Use `references/interview-checklist.md` as a map of areas (goal, scope, flows, data, edge cases, errors, security, integrations, technical constraints, testing, deployment, untouchable areas of existing code, priorities, definition of done, how the agent should behave...). Each area must end in one of two states: *covered* with the user's answer, or *not applicable* confirmed by them. Do not ask again what the user already said or what the repo already shows.

**How to ask.**
- Rounds of 1 to 3 questions. If you have a multiple-choice question tool (for example `ask_user_input_v0` in Claude.ai or `AskUserQuestion` in Claude Code), use it for decisions with discrete options (2 to 4 short options) and wait for the answer before continuing. For open questions, or if there is no such tool, write them in the chat.
- Ask what is not obvious: edge cases, failures, decisions with trade-offs, things the user has probably not considered. Trivial questions are tiring and add nothing.
- When you propose an option, present it as a proposal with its reason and mark it "(recommended)". A recommendation the user explicitly chooses is a confirmed decision; one you take for granted is an assumption, and that is not allowed.
- Each answer can open new questions. Keep digging while important nuances remain.
- Before each round, tell the user in one line where the interview stands (for example, which areas are covered), so they know how much is left.

**When the user does not know or says "whatever".** Briefly explain the options and their consequences, with a recommendation. If they still cannot decide:
- If it is a low-impact implementation detail, propose **delegating it to the agent** with clear limits and ask for explicit approval. It is recorded as 🔶 in `05-PENDING.md`.
- If it depends on external information (an account, a permission, someone else's decision), record it as ❓ with who resolves it and which tasks it blocks, and ask the user to confirm they want to leave it that way.

Never decide silently.

**When to stop.** When every checklist area is covered or confirmed as not applicable, and no recent answer has opened a new doubt. If the user wants to stop earlier, tell them what would remain open and record only what they agree to leave that way.

### Step 4. Validation gate

Before writing anything, present a **validation summary** in the chat, complete but compact (one line per item), using the same IDs the files will have so the user can say "change RF-03":

- Goal and users.
- Scope: what is in and what is out.
- Decisions made (`D-xx`), with their reason.
- Main requirements (`RF`/`RNF`) with their acceptance criteria.
- Architecture in a few lines and, in Existing mode, what is touched and what is not.
- Planned phases and tasks (`T-xx`), in order.
- Items delegated to the agent (🔶) and external pending items (❓), if any.

End by asking for an explicit OK (with the question tool if available: "Yes, generate the files" / "I want to correct something"). If the user corrects something, apply the changes, re-validate what changed and, if the change opens new doubts, go back to Step 3. Do not write the files without a clear OK.

### Step 5. Write and verify

Use the templates in `references/templates.md` (read them before writing) and the writing rules below. Then go through the "Verification" checklist. If something fails, fix it before delivering.

### Step 6. Delivery

Adapt delivery to the environment where the skill is running:

- **Claude chat (web or desktop)**, the main case: create `AGENTS.md` and the `handoff/` folder in the outputs directory (in Claude.ai, `/mnt/user-data/outputs/`), package everything as `handoff.zip` and present it to the user (in Claude.ai, with `present_files`, showing the zip and `handoff/README.md`). Close with short instructions: unzip at the root of the repo, open the IDE agent and paste the kickoff prompt from `handoff/README.md`.
- **Agent with repository access (Claude Code, Copilot, Cursor...)**: write the files directly at the root of the repository. If an `AGENTS.md`, `CLAUDE.md` or `.github/copilot-instructions.md` already exists, do not overwrite it: propose adding a section that points to `handoff/README.md` and ask before editing it. If a `handoff/` folder already exists, ask whether to replace it or create a dated one.

In both cases, remind the user at the end of anything delegated (🔶) or pending (❓).

Do not repeat the content of the files in the chat.

## Pack structure

| File | Purpose |
|---|---|
| `AGENTS.md` | Short, stable pointer. Agents read it automatically when opening the repo, and it sends them to `handoff/README.md`. It can be copied as `CLAUDE.md` or `.github/copilot-instructions.md`. |
| `handoff/README.md` | Entry point: what this is, reading order, working rules and the **kickoff prompt**. |
| `handoff/01-CONTEXT.md` | Vision, problem, users, goals, non-goals, glossary, decisions and their reasons. |
| `handoff/02-ARCHITECTURE.md` | Stack, structure, components, data, integrations, conventions. In Existing mode: current state and target state. |
| `handoff/03-REQUIREMENTS.md` | Functional and non-functional requirements with IDs and verifiable acceptance criteria. |
| `handoff/04-ACTION-PLAN.md` | Phased plan with self-contained tasks (`T-xx`), progress and a progress log. |
| `handoff/05-PENDING.md` | Decisions delegated to the agent (`DL-xx`), external pending items (`Q-xx`) and risks. If there are none, the file says so explicitly. |

For very small projects you may merge `01` and `02`, but always keep `README.md`, `03`, `04` and `05`. Do not add files that bring no new information.

## Writing rules

**Explicit over elegant.** Write for a very capable reader who knows nothing about the project and cannot ask. Avoid "etc.", "as discussed", "the usual" or "similar to X" without saying what X is.

**Stable IDs and cross-references.** `RF-01` functional requirement, `RNF-01` non-functional, `D-01` decision, `T-01` task, `DL-01` delegated decision, `Q-01` pending item. Tasks cite the requirements they cover. IDs are never reused or renumbered after the OK.

**Status on what matters.** ✅ Confirmed (validated by the user or verified in the repo) · 🔶 Delegated to the agent (explicitly approved by the user, with limits) · ❓ Pending (external information missing; state who resolves it and what it blocks). There is no "assumed" status.

**Do not invent technical facts.** Versions, endpoints, field names or repository structure only appear if the user or the repo provided them. Everything else is asked in the interview.

**Small, self-contained tasks.** Each task must be executable in one agent session by reading its card and the documents it cites. Always include goal, context, files to create or modify, steps, verifiable acceptance criteria, how to verify, dependencies and what is out of scope. Order them so that the first ones deliver something that works end to end.

**Tool-agnostic.** Tasks do not use commands specific to a single tool. `README.md` does include kickoff prompts for Claude Code, Copilot (agent mode) and Cursor.

**Readable in a CLI and an editor.** Plain Markdown: hierarchical headings, lists, simple tables, code blocks with a language. No HTML or images. Diagrams in `mermaid` or ASCII. A short table of contents if a file goes beyond ~150 lines; split it if it goes beyond ~400.

**What not to do.** Do not write the project's code inside the pack (except minimal snippets that pin a contract, such as a signature or a schema). Do not include anything the user has not validated. Do not hide an ambiguity to make the document look more complete.

## Verification

Check each point before delivering:

1. **Prior OK**: the user explicitly approved the Step 4 summary and the files reflect it, with corrections applied.
2. **Coverage**: every statement in the Step 1 inventory appears in some file with its ID, and every checklist area is covered or confirmed as not applicable.
3. **Zero assumptions**: no important fact is unvalidated. Everything is ✅, approved 🔶 or ❓ accepted by the user.
4. **Traceability**: every requirement is covered by at least one task and every task cites at least one requirement.
5. **Executable tasks**: each task has verifiable acceptance criteria and a concrete way to check them.
6. **Clear first step**: `README.md` ends with a kickoff prompt that says where to start.
7. **Consistency**: names, paths and terms are the same across files and match the glossary.
8. **No inventions**: no versions, endpoints or repository structure without a source.

## References

- `references/interview-checklist.md`: areas the interview must cover and examples of non-obvious questions. Read it at the start of Step 3.
- `references/templates.md`: skeleton of every file in the pack. Read it before writing.
- `references/discovery-prompt.md`: read-only prompt for the IDE agent to inspect an existing repository.

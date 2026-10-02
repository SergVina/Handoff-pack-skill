---
name: handoff-pack
description: Interviews the user until every important detail is settled and, only after they approve a summary, writes a Markdown handoff pack (context, architecture, requirements, task-by-task plan, pending items) so a coding agent in the IDE (Claude Code, GitHub Copilot, Cursor, etc.) can build it without losing context; also updates the pack from the agent's progress reports. Works for developers and teams and for non-technical people with an idea, adapting its language. ALWAYS use it when the user wants to take an idea, need or project, new or existing, from the chat to an IDE agent; asks for an action plan, PRD, spec, brief, CLAUDE.md or AGENTS.md for an agent; brings back an agent report; or says "prepare the docs for the agent", "don't lose anything" or "handoff", even without mentioning .md files. Spanish triggers too, such as "prepárame la documentación para el agente", "quiero que la IA me programe mi idea", "que no se pierda nada", "traspaso".
license: MIT
compatibility: Designed for Claude chats (web and desktop); also works in Claude Code and other Agent Skills compatible agents. The generated pack is tool-agnostic Markdown for Claude Code, GitHub Copilot, Cursor and similar agents.
metadata:
  version: "1.2.0"
---

# Handoff Pack

Turn an idea, a need or an existing project into a pack of Markdown files that a coding agent in the IDE can read and execute on its own, and keep that pack up to date as the work progresses. Everything in the pack has already been validated by the user: first you interview, then you summarize for approval, and only then you write.

## Why this skill exists

The IDE agent has no access to this conversation. Whatever is not written down does not exist for it: decisions made, constraints, exact names, edge cases, things the user ruled out. When a detail is missing, the agent fills it with a guess, and that guess is usually wrong and expensive to undo.

That is why this skill leaves **no assumptions, silent or explicit**. If something important is unknown, ask. Correcting a document that already looks complete is much worse than answering a question before it is written: people tend to accept what they read, and a well-written assumption slips through unnoticed.

## Language and audience

Talk to the user in their language, and write the pack in that language too (prose and headings). Keep IDs, file names, status emojis, source values (`user`, `summary`, `repo`), code identifiers, paths and commands exactly as defined here or as they appear in the project, and keep the `**Pack format:** 1` line as is. The reader of the pack finds sections by file, IDs and position, not by heading text, so the order of the template sections must not change (see `references/pack-format.md`).

The skill serves two kinds of people, and you adapt to each:

- **Technical users** (developers, tech leads, technical teams): technical vocabulary, direct technical questions.
- **Non-technical users** (freelancers, small business owners, anyone with an idea who does not code): plain language, questions about their world rather than about technology, technical choices proposed and explained for their approval, and an extra guide in the pack written for them. Read `references/non-technical-users.md` whenever the user is not technical, or is not technical in the area being discussed.

The rigor is the same for both: interview until closed, validation before writing, no assumptions. Only the way of asking and the extra guide change.

## Modes

Pick the mode in Step 0. Propose it to the user with a one-line reason and let them confirm or change it.

| Mode | When | Output |
|---|---|---|
| **Full** (default) | New projects, substantial features, anything touching several areas, new integrations or the data model. | The complete pack (see "Pack structure"). |
| **Lite** | A contained change in a known codebase: one feature in one area, a bug fix, a small refactor; roughly five tasks or fewer. | A single `handoff/HANDOFF.md` plus agent files. See `references/lite-mode.md`. |
| **Update** | A pack already exists and something changed: the IDE agent sent a progress report, a decision changed, scope grew or shrank. | Only the affected files, with stable IDs and a change log. See `references/update-mode.md`. |

All modes keep the same non-negotiables: interview until closed, validation gate before writing, no assumptions. Lite reduces the number of areas and files, never the rigor. If the scope grows during a Lite interview, propose switching to Full.

## Workflow (Full and Lite)

Follow the steps in order. Do not write any file of the pack before the OK in Step 4. Update mode has its own procedure in `references/update-mode.md`.

### Step 0. Detect the situation

Work out, inferring from what the user said and asking only what cannot be inferred:

- **Project state**: *New* (from scratch) or *Existing* (there is code already).
- **Mode**: Full, Lite or Update (see "Modes"). If the user pasted or attached a progress report or an existing `handoff/` folder, it is Update.
- **User profile**: technical or non-technical (see "Language and audience"). Infer it from how they write; if unclear, ask once.
- **Kind of project**: any kind is valid. Read `references/project-types/README.md` and load the lenses that apply (frontend, API, data, migration, website, automation), combining them if needed. If none fits, derive an equivalent lens from the domain as that README explains.
- **Agent tools**: which coding agents the user or team uses (Claude Code, Copilot, Cursor, others), and whether the repo already has `AGENTS.md`, `CLAUDE.md` or `.github/copilot-instructions.md`. This decides which agent files you generate; see `references/agent-files.md`.

### Step 1. Capture everything the user said

Build an inventory of **every atomic statement** the user makes: goals, preferences, named technologies, constraints, examples, numbers, "I don't want X", "it must be Y". Each one must end up in some file with its ID, and this inventory is the basis for the coverage check in Step 5.

Keep proper names, numbers, field names, paths and quotes verbatim. Paraphrasing is where information gets lost.

**Earlier drafts and proposals.** The conversation may already contain drafts (a `CLAUDE.md`, a plan, a spec), including ones written by the assistant. Treat everything the assistant proposed as a **proposal, not a decision**: it does not enter the user's inventory, and each relevant point goes through the interview. Tell the user at the start that you will do this, and say at delivery which earlier drafts the pack replaces.

### Step 2. Discovery (Existing projects only)

You cannot see the user's repository from a chat, and you must not invent its structure. In order of preference:

1. If the user attached files or pasted code, read them and use them as the source.
2. If not, offer the prompt in `references/discovery-prompt.md`. The user pastes it into their IDE agent, which can see the repo, and brings back the report.
3. If the user would rather not, continue, but every fact about the existing code has to go through the interview: you ask, you do not assume.

Anything that comes from real code has source `repo`. Confirm with the user that the reference feature is the right one to imitate: if the repo has several styles, they decide which is the current one. If the report contradicts what the user said, do not pick silently: take it to the interview.

**New feature in an existing repo.** Discovery must find more than the structure: the *reference feature* (the most similar one already implemented, layer by layer), the *reusable code*, and the *checklist of places touched* when adding something of that kind. These are what let the plan imitate how this repo does things instead of inventing a new style. In a large repo, ask the user (or infer from the feature) which modules matter and limit the deep inspection to them, stating what was left out.

If you are running inside an agent that can read the repository (Claude Code, Copilot, Cursor...), inspect it yourself following the same discovery prompt, read-only.

### Step 3. Interview until closed

This is the core step. Interview the user in rounds until no important nuance is left unverified.

**What to cover.** Use `references/interview-checklist.md` as the map of areas (Lite mode uses the reduced set in `references/lite-mode.md`), plus the extra questions of the lenses you loaded or derived, and the extra topics for solo builders when the user is not technical. Each area must end in one of two states: *covered* with the user's answer, or *not applicable* confirmed by them. Do not ask again what the user already said or what the repo already shows.

**How to ask.**
- Rounds of 1 to 3 questions. If you have a multiple-choice question tool (for example `ask_user_input_v0` in Claude.ai or `AskUserQuestion` in Claude Code), use it for decisions with discrete options (2 to 4 short options) and wait for the answer before continuing. For open questions, or if there is no such tool, write them in the chat.
- Ask what is not obvious: edge cases, failures, decisions with trade-offs, things the user has probably not considered. Trivial questions are tiring and add nothing.
- When you propose an option, present it as a proposal with its reason and mark it "(recommended)". A recommendation the user explicitly chooses is a confirmed decision; one you take for granted is an assumption, and that is not allowed.
- Each answer can open new questions. Keep digging while important nuances remain.
- **High-impact decisions always get their own question**: anything that defines how the product behaves (formulas, thresholds, rules, categories), the stack, costs, personal data, money or legal matters. They are never approved only as part of a bundle or of the validation summary.
- **Quick confirmation rounds for low-impact defaults.** When several low-impact choices have a clear recommendation (a styling library, a test runner, a naming convention), group them in one multi-select question: "Mark the defaults you accept". Selected items become confirmed decisions; unselected ones are discussed in the next round. Never use this format for high-impact decisions.
- **Answers that are questions or new requests.** If the user replies with a question ("what does that mean?"), a new request ("can you automate that for me?") or something that raises feasibility, legal or technical limits, answer it first, honestly, including any limits. Then ask the original question again with the options updated by what you learned.
- Before each round, tell the user in one line where the interview stands (for example, which areas are covered), so they know how much is left.

**When the user does not know or says "whatever".** Briefly explain the options and their consequences, with a recommendation. If they still cannot decide:
- If it is a low-impact implementation detail, propose **delegating it to the agent** with clear limits and ask for explicit approval. It is recorded as 🔶 in `05-PENDING.md` (or the pending section in Lite).
- If it depends on external information (an account, a permission, someone else's decision), record it as ❓ with who resolves it and which tasks it blocks, and ask the user to confirm they want to leave it that way.

Never decide silently.

**Closing sweep.** Before stopping, list in one multi-select question the areas you believe do not apply, each with a short reason ("Security and privacy: no accounts, only local storage"), and ask the user to mark the ones they confirm as not applicable. Any area left unmarked gets its own questions. This is how an area becomes *not applicable confirmed by the user*; never mark it on your own.

**When to stop.** When every area is covered or confirmed as not applicable through the sweep, and no recent answer has opened a new doubt. If the user wants to stop earlier, tell them what would remain open and record only what they agree to leave that way.

### Step 4. Validation gate

Before writing anything, present a **validation summary** in the chat, complete but compact (one line per item), using the same IDs the files will have so the user can say "change RF-03". It must contain **every value the templates will need**, so that writing does not require inventing anything: priorities (Must/Should/Could) of each requirement, every edge case with its expected behavior, concrete values (thresholds, formulas, defaults, limits, names), and the proposed folder structure when there is one. Items that reach the summary as proposals the user never discussed must be low-impact, marked "(proposal)", and recorded with source `summary` (see "Writing rules").

The summary includes:

- Goal and users.
- Scope: what is in and what is out.
- Decisions made (`D-xx`), with their reason.
- Main requirements (`RF`/`RNF`) with their acceptance criteria.
- Architecture in a few lines and, for Existing projects, what is touched and what is not.
- Planned phases and tasks (`T-xx`), in order.
- Agent files that will be generated (see `references/agent-files.md`).
- Items delegated to the agent (🔶) and external pending items (❓), if any.

End by asking for an explicit OK (with the question tool if available: "Yes, generate the files" / "I want to correct something"). If the user corrects something, apply the changes, re-validate what changed and, if the change opens new doubts, go back to Step 3. Do not write the files without a clear OK.

### Step 5. Write, check the writing delta and verify

Use the templates in `references/templates.md` (Full) or `references/lite-mode.md` (Lite), the extra sections from the lenses, the adaptations in `references/non-technical-users.md` when the user is not technical, and the writing rules below.

**Writing delta.** While writing, you will find things the summary did not settle: a behavior detail, a value, an extra edge case, a gap such as an input format nobody mentioned. Do not fill them in, and do not hide them as risks. Collect them, and before delivering show them in the chat as a short list with your proposal for each, asking the user to mark what they accept (multi-select if available). Accepted items enter the pack; the rest are discussed or recorded as ❓. If the delta is empty, say so in one line. A gap that the user prefers to leave open becomes a ❓ with an owner, never an unasked risk.

Then go through the "Verification" checklist. If something fails, fix it before delivering.

### Step 6. Delivery

Adapt delivery to the environment where the skill is running:

- **Claude chat (web or desktop)**, the main case: create the agent files and the `handoff/` folder in the outputs directory (in Claude.ai, `/mnt/user-data/outputs/`), package everything as `handoff.zip` and present it to the user (in Claude.ai, with `present_files`, showing the zip and the entry file: `handoff/README.md` in Full, `handoff/HANDOFF.md` in Lite). Close with short instructions: unzip at the root of the repo, open the IDE agent and paste the kickoff prompt.
- **Agent with repository access (Claude Code, Copilot, Cursor...)**: write the files directly at the root of the repository, following the rules for existing agent files in `references/agent-files.md`. If a `handoff/` folder already exists, this is probably Update mode; ask before replacing anything.

In both cases, say which earlier drafts the pack replaces (if any), remind the user of anything delegated (🔶) or pending (❓), and that the pack includes a progress-report prompt (`references/feedback-prompt.md`) so they can bring the agent's results back to the chat and update the pack.

If the user has the `handoff-implement` skill installed in their IDE agent, the agent will use it to execute the pack: integrity checks, an understanding gate before coding, one task at a time and phase reports in the exact format Update mode expects. Without it the pack works just the same, because `AGENTS.md` carries the basic working rules; mention this in one line.

Do not repeat the content of the files in the chat.

## Pack structure (Full mode)

| File | Purpose |
|---|---|
| `AGENTS.md` | Short, stable pointer read natively by Copilot, Cursor and most agents. It sends them to `handoff/README.md`. |
| `CLAUDE.md` | Only if the team uses Claude Code, which does not read `AGENTS.md`: its first line imports it with `@AGENTS.md`. |
| `handoff/00-START-HERE.md` | Only for non-technical users (or anyone who asks): a plain-language guide for the person, with setup, how to work with the agent and how to check results. See `references/non-technical-users.md`. |
| `handoff/README.md` | Entry point for the agent: reading order, working rules, kickoff prompts, how to report back, pack history. |
| `handoff/01-CONTEXT.md` | Vision, problem, users, goals, non-goals, glossary, decisions and their reasons. |
| `handoff/02-ARCHITECTURE.md` | Stack, structure, components, data, integrations, conventions. For Existing projects: current state and target state. |
| `handoff/03-REQUIREMENTS.md` | Functional and non-functional requirements with IDs and verifiable acceptance criteria. |
| `handoff/04-ACTION-PLAN.md` | Phased plan with self-contained tasks (`T-xx`), progress and a progress log. |
| `handoff/05-PENDING.md` | Decisions delegated to the agent (`DL-xx`), external pending items (`Q-xx`) and risks. If there are none, the file says so explicitly. |
| `handoff/reports/` | Empty at first. The agent writes its phase reports here (see `references/feedback-prompt.md`). |

For very small Full projects you may merge `01` and `02`; if it is smaller than that, it is probably Lite. Do not add files that bring no new information.

## Writing rules

**Explicit over elegant.** Write for a very capable reader who knows nothing about the project and cannot ask. Avoid "etc.", "as discussed", "the usual" or "similar to X" without saying what X is.

**Stable IDs and cross-references.** `O-01` goal, `C-01` constraint, `D-01` decision, `RF-01` functional requirement, `RNF-01` non-functional, `E-01` edge case, `T-01` task, `DL-01` delegated decision, `Q-01` pending item, `R-01` risk. Tasks cite the requirements they cover. IDs are never reused or renumbered after the OK, including in later updates.

**Status on what matters.** ✅ Confirmed (validated by the user or verified in the repo) · 🔶 Delegated to the agent (explicitly approved by the user, with limits) · ❓ Pending (external information missing; state who resolves it and what it blocks). There is no "assumed" or "derived" status: anything derived goes through the writing delta.

**Honest sources.** `user`: the user stated it or chose it in a question. `summary`: an assistant proposal approved only through the validation summary or the writing delta (allowed for low-impact items only). `repo`: verified in the code. The source shows how strong each approval is; never upgrade `summary` to `user`.

**Versions.** In Existing projects, versions come from the repo. In New projects, if the user does not pin a version, write "Not pinned" and add an agent rule: use the current stable version, check its official documentation, and record the version used in `02-ARCHITECTURE.md` and the progress log.

**Do not invent technical facts.** Versions, endpoints, field names or repository structure only appear if the user or the repo provided them. Everything else is asked in the interview.

**Small, self-contained tasks.** Each task must be executable in one agent session by reading its card and the documents it cites. Always include goal, context, files to create or modify, steps, verifiable acceptance criteria, how to verify, dependencies and what is out of scope. Order them so that the first ones deliver something that works end to end.

**Tool-agnostic.** Tasks do not use commands specific to a single tool. Kickoff prompts and agent files are the only tool-specific parts.

**Readable in a CLI and an editor.** Plain Markdown: hierarchical headings, lists, simple tables, code blocks with a language. No HTML or images. Diagrams in `mermaid` or ASCII. A short table of contents if a file goes beyond ~150 lines; split it if it goes beyond ~400.

**What not to do.** Do not write the project's code inside the pack (except minimal snippets that pin a contract, such as a signature or a schema). Do not include anything the user has not validated. Do not hide an ambiguity to make the document look more complete.

## Verification

Check each point before delivering:

1. **Prior OK**: the user explicitly approved the Step 4 summary and the files reflect it, with corrections applied.
2. **Coverage**: every statement in the Step 1 inventory appears in some file with its ID, and every area (including lens extras) is covered or confirmed as not applicable.
3. **Zero assumptions**: no important fact is unvalidated. Everything is ✅, approved 🔶 or ❓ accepted by the user.
4. **Traceability**: every requirement is covered by at least one task and every task cites at least one requirement.
5. **Executable tasks**: each task has verifiable acceptance criteria and a concrete way to check them.
6. **Clear first step**: the entry file ends with a kickoff prompt that says where to start, and explains how to report back.
7. **Agent files**: the files match the tools the user confirmed, and no existing file is overwritten.
8. **Consistency**: names, paths and terms are the same across files and match the glossary.
9. **No inventions**: no versions, endpoints or repository structure without a source.
10. **Writing delta**: nothing in the files is absent from the approved summary or the approved writing delta.
11. **Closing sweep**: every area marked not applicable was confirmed by the user in the sweep.
12. **Honest sources**: proposals approved only in the summary or delta carry source `summary`.
13. **Right for the reader**: for non-technical users, `00-START-HERE.md` exists, every technical term is in the glossary, and the first tasks have checks they can do by hand.
14. **Pack format**: the entry file declares `**Pack format:** 1`, every template section is present in template order (or says "Not applicable" with a reason), required columns keep their order, and IDs use the prefixes of `references/pack-format.md`.

## References

Read only what the current situation needs:

- `references/interview-checklist.md`: the 15 interview areas for Full mode. Read at the start of Step 3.
- `references/pack-format.md`: the pack format contract (format 1): files, IDs, statuses, sources, required sections and columns, task card and report. Templates follow it; read it when in doubt about structure.
- `references/templates.md`: skeleton of every file in the Full pack. Read before writing.
- `references/lite-mode.md`: reduced areas and the single-file template for Lite mode.
- `references/update-mode.md`: procedure to update an existing pack.
- `references/feedback-prompt.md`: the progress-report prompt the agent uses to report back.
- `references/agent-files.md`: which agent instruction files to generate for each tool, and how to handle existing ones.
- `references/discovery-prompt.md`: read-only prompt for the IDE agent to inspect an existing repository.
- `references/non-technical-users.md`: how to interview and adapt the pack for people who do not code.
- `references/project-types/README.md`: how lenses work and how to derive one for any kind of project. Lenses: `frontend.md`, `api.md`, `data.md`, `migration.md`, `website.md`, `automation.md`.

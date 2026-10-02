# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

## [1.2.8] - 2026-10-02

Reliability fixes from the run that reopened a finished task (T-10 adjusted to a decision the user delegated), which the skill had no flow for.

### Changed
- `handoff-implement`: a task reopened by the pack (empty checkbox, an earlier "done" line, a pack history row explaining why) is expected, not an inconsistency. The criteria already ticked are kept and only what changed is redone; a new log line is added instead of editing the old one; if the phase already has a report that the rework makes untrue, a new one takes the next suffix. A test that fixes the behavior the pack just changed is updated and declared as a deviation.
- `handoff-implement`, check 12: a pending item cited in a card whose own row says it blocks no task is not a blocker; the "Tasks it blocks" column prevails over a citation, and the status says so in one line.
- `handoff-implement`: the mini-plan says how a background server will be stopped and that it may not be possible (the child process can outlive the tool's "stop"); browser scripts stay short and the state is polled in separate calls (about 45 seconds were observed as the limit); fixtures are fed to the browser through a temporary file that is deleted afterwards, checking `git status`; when the current branch is a pack-update branch, the base of the task branch is stated.

### Added
- Two evals for `handoff-implement`: a task reopened by the pack (24) and a cited pending item that blocks nothing (25).

## [1.2.7] - 2026-10-02

First run of `handoff-pack` in Update mode inside an agent with repository access, closing the loop after phase 3. It protected the pack well (it refused to turn unconfirmed decisions into `D-xx` with source `user`, caught that D-17 did not say what the report claimed, and rejected proposals that would add scope); its feedback showed what Update mode did not say.

### Changed
- `handoff-pack` (Update mode, contract section 7): an approval given by anyone other than the user (an orchestrating agent, an assistant acting for them) is never source `user`; the item is a ❓ with the user as owner, what is implemented meanwhile and how to revert it. The pending-items template documents an optional "How to revert" column.
- `handoff-pack` (Update mode): when the user cannot answer, show the change summary and end the turn; proposals that add scope are ❓ marked "proposal", never tasks or `D-xx`; a pack-versus-code conflict that no ID contradicts literally is tracked as a ❓ with a visible note and the original text kept, after checking the literal text of each cited ID; report rows that read two ways are disambiguated with the agent's log; a report that replaces an earlier one is history and is cited in the pack history; a ❓ the user has not answered stays open ("registered, not resolved"); unconfirmed `repo` facts go in an optional section at the end of `02-ARCHITECTURE.md`.
- `handoff-pack` (Update mode): no answer is not an OK. Running the new eval against a model showed the agent applying the changes without the gate because it was told nobody would answer; the gate now states that it is not waived in that case.
- `handoff-pack` (Update mode): closing checklist: IDs compared before and after, `01` and `03` untouched unless the summary said otherwise, header counters recalculated, contract sections still met.
- `handoff-implement`: the phase report's decisions table has a "Discarded alternative" column, so an alternative is never read as an implemented notice.
- Contract (format 1, no version change): approvals by someone other than the user.

### Added
- One eval for `handoff-pack`: an Update with decisions approved provisionally by a third party.

## [1.2.6] - 2026-10-02

Reliability fixes from the second autonomous run (task T-10, which closed a phase and had to deal with an earlier partial report). The worker followed the skill and verified every criterion in a browser; the run showed four gaps.

### Changed
- `handoff-implement`: when a report for the same phase already exists and is no longer true (for example a partial one written when blocked), write the new one with the next suffix (`-2`, `-3`), list in its section 6 what the earlier one no longer gets right, and do not edit it. `report-template.md` also says: every task of the phase goes in section 2 (even if verified in another session), unprocessed decisions of an earlier report are repeated in section 4, and what could not be verified is stated per task.
- `handoff-implement`: after stopping a background server, check with a request to its port that it no longer responds; a tool saying "stopped" is not proof.
- `handoff-implement`: the mini-plan lists every visible text of each new screen (headers, empty states, errors, warnings); a text that turns up later is recorded as not approved and proposed for confirmation. In doubt between detail and visible behavior, it is visible.
- `handoff-implement`: verification scripts print the whole table or output before and after a change and compute the difference, instead of picking the row expected to change.
- `handoff-implement`: on resumption, open `integrity-checks.md` and apply only the named checks.
- `handoff-implement`: the description now says that the pack's own reporting notes do not replace the skill. Running the phase-report request against a model showed the skill was not invoked and an earlier report was overwritten, because the pack's notes do not say never to overwrite.
- `handoff-pack`: "How to verify" also names the observable change to expect; fixtures contain the cases a criterion needs on purpose; later cards of a new project cite the files an earlier task created as the pattern; rules that define a metric define its formula and how edge categories count.

### Added
- Two evals for `handoff-implement`: a phase report written when an earlier partial report of the same phase exists (22, naming the skill) and the same request without naming it (23, to check activation).

## [1.2.5] - 2026-10-02

Reliability fixes from the first fully autonomous run (task T-09, executed by a headless Sonnet 5.5 worker driven by an orchestrator). The worker followed the skill without breaking any rule and was honest about what it could not verify; the run showed what the skill did not cover.

### Changed
- `handoff-implement`: a criterion that cannot be verified because a tool is missing (a browser, a device, an account) is handled like an impossible criterion: raised at the mini-plan under "Open points" together with the tool each criterion needs and the instrument that measures it; if found later, run everything possible, do not tick the criteria or the task, do not claim them from indirect evidence, mark the progress log line "implemented, pending verification" and tell the user. No dependency is installed to get around it.
- `handoff-implement`: a line marked "implemented, pending verification" tells the next session not to implement again: check the code is unchanged, run the missing verification and tick the task. Check 17 treats it as expected.
- `handoff-implement`: a task that only waits for a verification is not a reason for a phase report by itself (status in the final message; the phase report when the phase ends; `partial` if one is written).
- `handoff-implement`: implementation details are appended to the progress log at each checkpoint (after each group of files or each test run), never only at the end.
- `handoff-implement`: development servers and other background processes are stopped before finishing; if that is not possible, the last message says the port or PID and how to stop it.
- Contract (format 1, no version change): "implemented and pending verification" as an example status of a progress log line.

### Added
- Two evals for `handoff-implement`: a criterion that needs a tool the agent does not have, and an "implemented, pending verification" task that must not be implemented again.

## [1.2.4] - 2026-10-02

Cost optimization of `handoff-implement` (tokens and time), measured with `scripts/session-metrics.py` on a clean run of task T-08 (baseline with 1.2.2: 41 API calls, 1,438,515 input-token equivalents, 60% of the cache reads in the verification phase).

### Changed
- `handoff-implement`: when resuming a pack that already has progress, the agent no longer reads the 20 KB contract (`pack-format.md`); `SKILL.md`, `task-loop.md`, `integrity-checks.md` and `report-template.md` carry what a resumption needs. Reading load per resumed session goes from about 51.6 KB to 31.8 KB (-38%). Each task runs in a fresh session in practice, so this is the common case.
- `integrity-checks.md`: check 10 lists the task card fields itself, so a resumption does not need the contract for them.
- `report-template.md`: states that it carries section 10 of the contract in full.
- `handoff-implement`: when resuming, reads only what the next task needs: progress list, log and next card of the action plan (not the whole file), and other IDs are found with grep. The latest report is still read whole, because its handling as not approved depends on it.
- `handoff-implement`: verification is grouped. Every tool call re-reads the whole conversation, so the checks go in one script per group of criteria instead of one call per probe; screenshots only for visual criteria, once. In the field run of T-08 the verification took 22 of 46 calls and 60% of the cache reads.

### Added
- `scripts/session-metrics.py`: tokens, time, tool calls, starting context size and cost in input-token equivalents (`cost_units`) of a run, from a Claude Code session transcript. Replaces the manual event log and measuring script of the test harness, which cost extra tool calls.
- Evals 18 and 19 for `handoff-implement`: resuming must not load the full contract, and verification must be grouped.

## [1.2.3] - 2026-10-02

Reliability fixes from the third field run of `handoff-implement` (task T-08) and from an audit of its real session transcript against the skill's rules. The audit found one failure the agent did not report: it ticked a criterion that, as written, could not be met.

### Changed
- `handoff-implement`: a criterion that cannot be met as written because the pack contradicts itself is raised at the mini-plan, under "Open points", with the other questions. If it is only found while verifying, the agent verifies what is measurable, does not tick the criterion or the task, does not reinterpret it, logs it as pending the user's decision and tells the user with the options. Integrity check 9 also looks for criteria the pack's own formulas make unreachable.
- `handoff-implement`: a report in `handoff/reports/` is the agent's own earlier output. Its decisions and proposed changes count as approved only if the user answered them in the session or the pack's history cites the report; otherwise they are treated as not approved and the status says so.
- `handoff-implement`: the progress log line of a task is opened when implementation starts ("in progress") and each implementation detail the agent decides is appended to it at that moment, marked as not delegated. A line left "in progress" means an interrupted task: read its notes and check the repository before continuing. Check 17 no longer flags it.
- `handoff-implement`: a practical test separates decisions from details: if the user, trying it, could say "I expected it to work differently", it needs an OK (when a change applies, whether a confirmation appears and where, which control, what is shown while loading).
- `handoff-implement`: in compatibility mode the single OK is required even when the user only said to continue (found by running eval 8 against a model: the agent went straight to coding); it is asked once per session.
- `handoff-implement`: do not give a precise count of other compatibility differences on resumption, because nothing scans for them; say that others exist.
- `handoff-implement`: read the errors and warnings printed by what you verify (terminal, browser console); follow the pack's and the user's rules on commit authorship or trailers exactly.
- `handoff-pack`: the verification checks that every criterion is reachable with the pack's own formulas and decisions; Update mode explains how to settle a criterion the agent could not meet (change it, or accept the measurable reading).
- Contract (format 1, no version change): the "in progress" status of a progress log line.

### Added
- Four evals for `handoff-implement`: unprocessed report, criterion made impossible by the pack, interaction behavior that is not an implementation detail, and an interrupted task. Eval 8 no longer expects an exact count of other differences.

## [1.2.2] - 2026-10-02

Fixes from the second field run of `handoff-implement` (task T-07, which closed a phase and produced the first phase report). The agent scored the skill 4/5; the 1.2.1 fixes all activated and helped.

### Changed
- `handoff-implement`: the rule "stop and ask on any non-delegated decision" is now workable. The user's OK is needed for what changes what they see or can do (anything visible, a tunable value, an open requirement or term, the data model or shared types, and text the pack defines in one language or not at all). Pure implementation details may be decided by the agent, but are listed in the mini-plan or marked as not delegated in the progress log at the moment they are taken, and declared in the report, so nothing has to be reconstructed.
- `handoff-implement`: new text not defined by the pack goes to "Open points" with proposed wording, all together, so a single OK settles it, unless a delegated decision covers UI copy.
- `handoff-implement`: a card whose "Files" are not enough for its steps is incomplete, not wrong: list the extra files under "Open points", ask, and record the deviation.
- `handoff-implement`: the deliberate violation that proves a test can fail must violate the criterion itself, not an arbitrary line.
- `handoff-implement`: tests of earlier tasks broken by a new task change only their fixtures, never their expected results, unless a requirement changed; recorded as a deviation.
- `handoff-implement`: cited context is re-read from the files at the start of each task, unless the same lines were read earlier in the same session and have not changed.
- Phase report: a status line for packs without `Pack format` or "Pack history" (`none (compatibility)`), decisions go in the report of the phase in which they were taken, and section 4 is built from the decisions marked in the progress log.
- Contract (format 1, no version change): the tables of `05-PENDING.md` have a fixed status (🔶 or ❓) by definition, and a decision goes in the report of the phase in which it was taken.
- `handoff-pack`: card "Files" list every file the steps touch (shared types, configuration, i18n dictionaries); criteria state the observable result of a control and rules define their terms; delegated decisions say where their parameters live and which task exposes them; Update mode aligns a pack that predates the contract as separate rows of the change summary.

### Added
- Three evals for `handoff-implement`: user-visible decision versus implementation detail, the report status line in compatibility mode, and a card with insufficient files.

## [1.2.1] - 2026-10-02

Fixes from the first real run of `handoff-implement` (task T-06 of a Spanish pack written before the format contract).

### Changed
- `handoff-implement`: translating or wording text that the pack defines in only one language (labels, category names, messages) is now a non-delegated decision, listed under "Open points" of the mini-plan. It was the one rule the agent skipped in the field test.
- `handoff-implement`: resuming a pack in compatibility mode (no `Pack format` line) now lists only the differences that affect the next task, says how many others exist and asks for a single OK. The checks to re-run on resumption are named (1, 3, 4, 9 to 12, 14 to 17).
- `handoff-implement`: a table with no Status column (older packs) inherits the pack status when the header says it was validated by the user.
- `handoff-implement`: the traceability table and any table other than the one where a prefix lives only cite IDs, so they no longer produce false duplicates (also clarified in the contract, section 5).
- `handoff-implement`: the pack-versus-code check also applies to new projects once a task is ticked or code exists, and a card that says "create" for an existing file means completing it, never overwriting it.
- `handoff-implement`: a test written to verify a criterion must be shown to fail once against a deliberate violation; documentation checks apply to APIs used for the first time in the task ("no new APIs" otherwise); versions for "Not pinned" entries are recorded where the pack's own rules say; branching from an unmerged previous task branch is covered.
- `handoff-pack`: "How to verify" must name a concrete input (fixture, command, value) instead of "an obvious case"; cards say "create or complete" when an earlier task may have created the file and whether a shared structure is created complete or partial; the interview asks for user-facing names in every language of a multilingual product.
- Contract (format 1, no version change): clarification of where IDs are defined and of where the agent records stack versions.

### Added
- Three evals for `handoff-implement`: resuming in compatibility mode with a table without Status column, translation of one-language text, and a traceability table that must not count as a duplicate definition.

## [1.2.0] - 2026-10-01

### Added
- New skill `handoff-implement`, for the IDE agent: locates the pack and checks its format version, reads it whole, runs integrity checks, stops at an understanding gate for the user's OK, implements one task at a time (pre-check, mini-plan, literal verification, progress log), keeps hard limits on decisions, delegation and scope, adapts to non-technical owners, and writes phase reports in the exact format Update mode expects. References: `pack-format.md`, `integrity-checks.md`, `task-loop.md`, `report-template.md`.
- Pack format contract `spec/PACK-FORMAT.md` (format 1): variants and files, entry file header, IDs and stability rules, statuses, sources, required sections and columns, task card fields, phase report, pack history, statement inventory, agent files and the language rule. Each skill ships an identical copy in `references/pack-format.md`.
- `handoff-pack` modes and references previously shipped only in the packaged skill: Lite mode, Update mode, progress report loop, agent files (`AGENTS.md` and `CLAUDE.md` importing it), non-technical users with `00-START-HERE.md`, project lenses, statement inventory and the `summary` source.
- `scripts/check-format-sync.sh` and the `checks.yml` workflow: format copies in sync, validation of both skills, the manifest and the evals, and ZIP layout on every push and pull request.
- Evaluation sets in `evals/handoff-pack/` and `evals/handoff-implement/` (behavior evals with synthetic packs, and trigger evals in English and Spanish).

### Changed
- Packs declare `**Pack format:** 1` in the entry file header. `Mode` is always Full or Lite and `Project` is New or Existing; Lite uses `Pack status` like Full.
- New ID prefixes: `O` goals, `C` constraints, `E` edge cases, `R` risks.
- Lite template: Source column and `RNF` IDs in requirements, `Depends on` in task cards, a progress log, pending items as tables with a Resolved list, and pack history.
- Report instructions fix the nine numbered sections, never overwrite an existing report, and say "None" instead of dropping a section.
- Lens sections and extra columns go after the template ones, so agents can locate sections by position.
- `handoff-pack` delivery mentions the optional `handoff-implement` skill; verification checks the pack format.
- `scripts/build-zip.sh` builds one ZIP per skill, named with the repository version (`handoff-pack-<version>.zip`, `handoff-implement-<version>.zip`); the release attaches both. The marketplace plugin lists both skills.
- `scripts/validate.sh` checks every skill (name, description length, YAML frontmatter, line count, cited references), version consistency, JSON validity and old evals paths. `checks.yml` replaces `validate.yml`.

## [1.1.0] - 2026-10-01

### Added
- Discovery prompt for Existing mode now asks for the reference feature (most similar existing feature, layer by layer), reusable code, the checklist of places touched when adding something of that kind, and git/CI state.
- Discovery scope guidance for large repositories.
- `02-ARCHITECTURE.md` template: "Reference feature", "Reusable code" and "Checklist for adding this kind of change" sections.
- Task cards now include a "Pattern to follow" field.
- Interview checklist: which feature to imitate, shared code boundaries, feature flags and uncommitted work.

## [1.0.0] - 2026-10-01

### Added
- First public release (1.0.0) of the `handoff-pack` skill.
- Interview-until-closed workflow guided by a 15-area checklist.
- Mandatory validation gate before any file is written.
- Handoff pack templates: `AGENTS.md`, `README.md`, context, architecture, requirements, action plan and pending items.
- Read-only discovery prompt for existing repositories.
- Delivery adapted to Claude chat (web and desktop) and to agents with repository access.
- Claude Code marketplace manifest, build script and release workflow.
- Skill instructions in English; the skill talks to the user and writes the pack in the user's language.

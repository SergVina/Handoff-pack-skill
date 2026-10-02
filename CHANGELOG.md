# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

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

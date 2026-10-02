# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

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

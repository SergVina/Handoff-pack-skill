# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

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

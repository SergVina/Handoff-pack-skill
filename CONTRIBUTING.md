# Contributing to Handoff Pack

Thanks for your interest in improving Handoff Pack.

## Ways to contribute

- **Report a problem**: open an issue describing what you asked, what the skill did and what you expected. Anonymized excerpts of the conversation or the generated pack help a lot.
- **Suggest an improvement**: open an issue before large changes so we can agree on the approach.
- **Submit a pull request**: small, focused changes are easiest to review.

## Project layout

- `spec/PACK-FORMAT.md`: the pack format contract, the single definition of the handoff pack.
- `skills/handoff-pack/`: the chat-side skill that interviews the user and writes and updates the pack.
- `skills/handoff-implement/`: the IDE-side skill that validates and executes the pack and writes phase reports.
- `evals/<skill>/`: behavior evals (`evals.json`) and trigger evals (`trigger-evals.json`) for each skill.
- `.claude-plugin/marketplace.json`: Claude Code marketplace manifest.

Keep each `SKILL.md` under 500 lines and move detail into its `references/`.

## The pack format contract

The two skills are used apart, in different tools and often weeks apart: one writes the pack, the other reads it. They only work together if both follow the same format, so the format lives in one place: `spec/PACK-FORMAT.md`.

**Copies must stay identical.** Each skill is distributed as its own ZIP and cannot depend on files outside its folder, so each one ships a copy of the contract in `references/pack-format.md`. Never edit a copy. Edit `spec/PACK-FORMAT.md` and copy it over both:

```bash
cp spec/PACK-FORMAT.md skills/handoff-pack/references/pack-format.md
cp spec/PACK-FORMAT.md skills/handoff-implement/references/pack-format.md
./scripts/check-format-sync.sh
```

CI fails if any copy differs.

**Keep the contract and the skills consistent.** A change to the contract usually needs matching changes in `handoff-pack`'s templates (`templates.md`, `lite-mode.md`, `feedback-prompt.md`) and in `handoff-implement`'s references (`integrity-checks.md`, `report-template.md`). Do not change the format in a template without changing the contract, or the other way round.

**When the format version goes up.** Bump `**Format version:**` in the contract and the `**Pack format:**` line in the templates when a change can make a reader of the previous version misread a pack:

- A required file, section, table column or task card field is added, removed, renamed in meaning or reordered.
- The meaning of an ID prefix, a status or a source changes, or a new one is added.
- The path, name or sections of the phase report change.
- A rule a reader relies on to locate things changes.

Wording changes, clarifications and new optional content that readers can ignore (extra sections or columns after the required ones, lens sections) do not bump the format. A format bump also needs `handoff-implement` to explain how it treats packs in the previous format.

## Guidelines

- Follow the [Agent Skills specification](https://agentskills.io): `name` in lowercase with hyphens and identical to the folder name, `description` up to 1024 characters, valid YAML frontmatter (quote the description if it contains `: `).
- Keep the core principles intact: no silent assumptions, validation before output, tool-agnostic Markdown, and the agent never overriding the user's decisions.
- Explain *why* a rule exists in the instructions, not only *what* to do. Models follow reasons better than bare commands.
- Write skills, references, docs and evals in English. The skills talk to the user, and write packs and reports, in the user's language.
- Do not include content from real user projects in evals or docs; use synthetic examples.
- Test your change on at least one new and one existing project (for `handoff-pack`) or one Full and one Lite pack (for `handoff-implement`), and describe the result in the pull request. Add or update evals when behavior changes.
- Update `CHANGELOG.md` and bump the version in both `SKILL.md` files, `marketplace.json` and the README badge when the behavior changes. They share one repository version.

## Validating

```bash
./scripts/check-format-sync.sh
./scripts/validate.sh
```

`validate.sh` needs Python 3 with PyYAML (`pip install pyyaml`). It checks, for every skill, the frontmatter, the name, the description length, the 500-line limit and that every reference cited in `SKILL.md` exists inside the skill's folder; it also checks that versions match across files, that `marketplace.json` lists every skill, that every JSON file under `evals/` is valid and that nothing cites the old flat `evals/` layout. CI runs both scripts on every push and pull request.

## Building the ZIPs locally

```bash
./scripts/build-zip.sh
```

The result is `dist/handoff-pack-<version>.zip` and `dist/handoff-implement-<version>.zip` (the version comes from `marketplace.json`), each with the skill folder at its root, ready to upload to Claude.

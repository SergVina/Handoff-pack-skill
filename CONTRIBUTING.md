# Contributing to Handoff Pack

Thanks for your interest in improving Handoff Pack.

## Ways to contribute

- **Report a problem**: open an issue describing what you asked, what the skill did and what you expected. Anonymized excerpts of the conversation or the generated pack help a lot.
- **Suggest an improvement**: open an issue before large changes so we can agree on the approach.
- **Submit a pull request**: small, focused changes are easiest to review.

## Project layout

- `skills/handoff-pack/SKILL.md`: workflow and rules. Keep it under ~500 lines; move detail into `references/`.
- `skills/handoff-pack/references/`: interview checklist, templates and discovery prompt.
- `.claude-plugin/marketplace.json`: Claude Code marketplace manifest.

## Guidelines

- Follow the [Agent Skills specification](https://agentskills.io): `name` in lowercase with hyphens, `description` up to 1024 characters.
- Keep the core principles intact: no silent assumptions, validation before output, tool-agnostic Markdown.
- Explain *why* a rule exists in the instructions, not only *what* to do. Models follow reasons better than bare commands.
- Test your change by running the skill on at least one new project and one existing project, and describe the result in the pull request.
- Update `CHANGELOG.md` and bump the version in `SKILL.md` and `marketplace.json` when the behavior changes.

## Building the ZIP locally

```bash
./scripts/build-zip.sh
```

The result is `dist/handoff-pack.zip`, ready to upload to Claude.

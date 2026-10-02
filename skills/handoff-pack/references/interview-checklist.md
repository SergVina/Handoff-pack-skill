# Interview checklist

Map of the areas Step 3 must cover in Full mode (Lite mode uses a subset, see `lite-mode.md`; lenses in `project-types/` add extra questions; for non-technical users, ask in plain language as described in `non-technical-users.md`). For each one, the result is *covered* (with the user's answer) or *not applicable* confirmed by them. Keep track internally and do not ask what the user already said or what the repo already shows.

The example questions are not a script: they show the expected depth. Adapt them to the project, ask them in the user's language and skip the obvious ones.

## Contents

1. Goal and users
2. Scope
3. Flows and behavior
4. Data
5. Edge cases and errors
6. Security and privacy
7. Interface and experience
8. Integrations
9. Technical constraints
10. Quality and testing
11. Environment and deployment
12. Existing code (Existing mode only)
13. Priorities, phases and size
14. Definition of done
15. How the agent should work

---

## 1. Goal and users
- What concrete problem is solved, and what happens if it is not.
- Who uses it, in what context and how often; whether there are several user types with different permissions.
- How you will know it worked (a measurable or observable signal).

## 2. Scope
- What is in this first version and what is explicitly out.
- What may be requested later and should not be blocked now.
- What you have seen in other tools that you do **not** want to copy.

## 3. Flows and behavior
- Main journey step by step, from start to finish.
- Variants of the journey: what changes depending on user type, state or data?
- What happens in the background and when (scheduled jobs, events, notifications).

## 4. Data
- Which entities exist, which fields each has, which are required and in what format.
- Where the data comes from and who modifies it; expected volume.
- What happens on delete or edit: is history kept? Is there data to migrate?

## 5. Edge cases and errors
- What should happen if an external dependency fails, data is missing or input is invalid.
- Concurrency: two users doing the same thing at the same time.
- Empty states, huge lists, odd input (long text, special characters, time zones).
- Expected message or behavior for each relevant failure.

## 6. Security and privacy
- Authentication and authorization: who can see or do what.
- Personal or sensitive data, applicable regulations (GDPR or others), retention.
- Handling of secrets and credentials (only variable names in the documentation).

## 7. Interface and experience
- Screens or commands needed, and visual references if any.
- Languages, accessibility, supported devices.
- Tone and wording of important messages.

## 8. Integrations
- External systems it talks to, what for and under which contract (endpoint, format, authentication, limits).
- Accounts, keys or permissions needed and who holds them.
- What happens if the external service is unavailable.

## 9. Technical constraints
- Mandatory or forbidden languages, frameworks and versions, and why.
- Platform, operating system, browsers, resource limits.
- Licenses, allowed or banned dependencies.

## 10. Quality and testing
- Expected level of testing (unit, integration, end to end) and preferred tools.
- Performance, availability and observability requirements (logs, metrics).
- Code style, linters and formatting that must be respected.

## 11. Environment and deployment
- Where it runs (local, server, cloud, container) and how it is deployed.
- Environments (development, staging, production) and how they differ.
- Required environment variables (names only) and how to obtain them.

## 12. Existing code (Existing mode only)
- Which parts can be touched, which are untouchable and which must stay compatible.
- Repo conventions to follow and known debt that should **not** be fixed now.
- Branches, commits, review: how changes get integrated.
- Which tests exist today and whether they pass; any contradiction between what the user said and what the repo shows.
- Which existing feature is the right one to imitate for the new one (if the repo mixes styles, which is the current one), and which existing code must be reused.
- Whether the new feature may touch shared code (models, utilities, config) or must stay isolated, and whether it goes behind a feature flag.
- Uncommitted changes or work in progress in the repo that the agent must not disturb.

## 13. Priorities, phases and size
- What is essential, what is desirable and what can wait, down to the priority (Must/Should/Could) of each requirement, so the pack never has to guess it.
- What should work first so it can be validated early.
- Real deadlines or milestones, if any.

## 14. Definition of done
- Which concrete checks prove that a task and the project are finished.
- Who validates and how (automated tests, manual review, demo).

## 15. How the agent should work
- How much autonomy it has: what it can decide alone and when it must stop and ask.
- Whether it should commit, create branches, run install commands or touch configuration files.
- What it must never do (delete data, change dependencies without notice, expand the scope).
- Where and how it should record progress.
- Which coding agents the team uses (Claude Code, Copilot, Cursor, others), and whether the repo already has `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md` or Cursor rules. This decides the agent files (see `agent-files.md`).

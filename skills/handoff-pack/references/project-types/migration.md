# Lens: migration and refactor

Load this when the work changes how existing functionality is built without changing (much of) what it does: framework or library upgrades, refactors, database migrations, moving platforms.

## Extra interview questions

- **Current and target**: exactly what changes (versions, libraries, structure, platform) and what must stay identical from the user's point of view.
- **Behavior parity**: which features and behaviors must be preserved and how parity will be checked; known differences that are acceptable.
- **Safety net**: which tests exist today, whether they pass, and which tests must be added before changing anything.
- **Strategy**: big bang or incremental (strangler, feature flags, parallel run); how long old and new coexist.
- **Data**: whether data has to be migrated or transformed; how to verify it (counts, checksums, samples); downtime tolerance.
- **Rollback**: how to go back at each step and what the point of no return is.
- **Freeze**: which areas must not receive other changes during the migration.
- **Debt**: what known problems should be fixed along the way and which explicitly should not.

## Extra sections in the pack

- In `02-ARCHITECTURE.md`: a **current versus target table** and the **coexistence plan**.
- In `03-REQUIREMENTS.md`: a **parity checklist**, one line per behavior that must be preserved, each with how it is verified.
- In `05-PENDING.md`: the **rollback plan** per phase among the risks.

## Task-splitting hints

First task: make the safety net green (add or fix the tests that prove current behavior). Then migrate in small steps that each leave the system working and verifiable, with risky steps (data migrations, removals) isolated and with an explicit rollback.

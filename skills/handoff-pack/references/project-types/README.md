# Project lenses

The files in this folder are **lenses**: optional sets of extra questions, pack sections and task-splitting hints for common kinds of work. They are examples, not a closed list. The skill handles any kind of project.

## Available lenses

| Lens | Typical work |
|---|---|
| `frontend.md` | Screens, components, tables, forms, client-side behavior |
| `api.md` | Endpoints, services, server-side logic |
| `data.md` | Pipelines, ETL, reports, analytics, data stores |
| `migration.md` | Refactors, upgrades, database or platform migrations |
| `website.md` | Websites for a business or a person: landing pages, portfolios, bookings, small online shops |
| `automation.md` | Automating repetitive work: scripts, spreadsheets, connecting apps, scheduled tasks |

## How to use them

- Lens sections are added **after** the last template section of the file they go into, never between template sections: the agent reading the pack locates the template sections by their order (see `../pack-format.md`).
- Load only the lenses that apply. Combine them freely (a booking website may use `website.md` and `api.md`).
- If the project fits none of them (a mobile app, a game, a browser extension, a chatbot, a hardware project, a desktop tool...), **derive an equivalent lens yourself** from the domain, following the same three parts:
  1. **Extra questions**: what is specific to this kind of project and would break the result if guessed (for a mobile app: platforms, store publishing, offline use, push notifications, device permissions).
  2. **Extra pack sections**: the tables or diagrams an agent needs for this domain (for a game: rules, controls, levels).
  3. **Task-splitting hints**: what the first visible, working slice is, and in what order to grow it.
- A derived lens follows every rule of the skill: its questions go through the interview, and nothing it suggests is written without the user's approval.
- For non-technical users, ask a lens's questions in plain language (see `../non-technical-users.md`).

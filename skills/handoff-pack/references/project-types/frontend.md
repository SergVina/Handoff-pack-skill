# Lens: frontend

Load this when the work involves screens, components or client-side behavior. It adds questions to the interview and sections to the pack. Ask only what the user has not already answered or the repo does not already show.

## Extra interview questions

- **Placement and navigation**: where the new view lives (route, menu entry, modal, tab), who can reach it and from where.
- **Existing patterns**: which design system or component library is used, and which existing screen is the closest reference to copy patterns from.
- **Data fetching**: which endpoint provides the data; whether pagination, sorting and filtering happen on the server or in the client; expected volume (tens, thousands, millions of rows).
- **States**: what the user sees while loading, when there is no data, on error, and with partial data. Exact wording of each message.
- **Tables and lists** (if any): columns with their order, format (dates, currency, units, decimals) and alignment; which columns sort and filter; default sort; page size; whether rows are clickable and what that opens; whether export is needed.
- **State management**: where state lives (component, global store, URL query params) and whether filters must survive a reload or be shareable by URL.
- **Responsive and devices**: breakpoints that matter; what happens on mobile (horizontal scroll, card view, hidden columns).
- **Accessibility**: required level (for example WCAG 2.1 AA), keyboard navigation, screen readers.
- **Internationalization**: languages, date and number formats, time zone used to display dates.
- **Performance**: limits that matter (initial load time, scroll smoothness with many rows) and whether virtualization is acceptable.
- **Testing**: component tests, end-to-end tests, visual regression; which tools the repo already uses.

## Extra sections in the pack

- In `02-ARCHITECTURE.md`: a **component tree** of the new view (mermaid or ASCII) and a **UI states table**:

| State | Trigger | What the user sees | Text |
|---|---|---|---|

- In `03-REQUIREMENTS.md`, for tables: a **column specification**:

| Column | Source field | Format | Sortable | Filterable | Notes |
|---|---|---|---|---|---|

## Task-splitting hints

Start with a vertical slice: the view reachable from navigation, showing real data with the simplest rendering. Then add sorting and filtering, then the loading, empty and error states, then responsive and accessibility polish. Component tests go with each step.

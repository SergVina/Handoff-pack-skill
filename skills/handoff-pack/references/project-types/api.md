# Lens: API and backend

Load this when the work involves endpoints, services or server-side logic.

## Extra interview questions

- **Contract**: for each endpoint, method, path, request parameters and body, response body, status codes and error format. Is there an existing OpenAPI or similar spec to follow?
- **Consumers**: who calls it (own frontend, mobile app, third parties) and whether backward compatibility matters; versioning strategy.
- **Authentication and authorization**: mechanism in use and which roles can call each endpoint.
- **Validation**: rules per field and how validation errors are reported.
- **Lists**: pagination style (offset, cursor), sorting and filtering parameters, maximum page size.
- **Writes**: idempotency, concurrent updates (optimistic locking, last write wins), transactions.
- **Limits**: rate limiting, timeouts, payload size.
- **Persistence**: tables or collections involved, migrations needed, indexes.
- **Observability**: logs, metrics and traces expected; what must never be logged (personal data, secrets).
- **Testing**: unit, integration and contract tests; test database or fixtures.

## Extra sections in the pack

- In `02-ARCHITECTURE.md` or `03-REQUIREMENTS.md`: an **endpoint contract table** and the **error format**:

| Method | Path | Request | Response | Status codes | Auth |
|---|---|---|---|---|---|

## Task-splitting hints

Define the contract first (types or schema and a stub returning fixed data), then implement the happy path end to end, then validation and errors, then pagination and filters, then limits and observability. Migrations go in their own task with a verification step.

# Lens: data

Load this when the work involves pipelines, ETL, reporting, analytics or data stores.

## Extra interview questions

- **Sources and sinks**: where the data comes from and where it goes; formats; access and credentials (names only).
- **Schemas**: fields, types, keys and nullability of inputs and outputs; who owns each schema and how changes are announced.
- **Volume and freshness**: rows per run, growth, how fresh the output must be, run schedule.
- **Correctness**: idempotency, deduplication, late or out-of-order data, backfills and reprocessing.
- **Data quality**: checks to run (row counts, nulls, ranges, referential integrity) and what happens when one fails.
- **Personal data**: which fields are sensitive, masking or anonymization, retention, applicable regulations.
- **Failures**: retries, alerts, who gets notified, partial runs.
- **Lineage and documentation**: how outputs are documented and traced back to sources.

## Extra sections in the pack

- In `02-ARCHITECTURE.md`: a **data flow diagram** (mermaid) and a **dataset table**:

| Dataset | Source / sink | Schema location | Volume | Freshness | Owner |
|---|---|---|---|---|---|

- In `03-REQUIREMENTS.md`: a **data quality checks table** with the check, threshold and action on failure.

## Task-splitting hints

Start by reading one source and writing one output end to end with a small sample, then add the full schema, then quality checks, then scheduling, retries and alerts, then backfill. Each task includes a verification query or command.

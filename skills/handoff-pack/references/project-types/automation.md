# Lens: automation

Load this for automating repetitive work: scripts, spreadsheet automations, connecting apps that do not talk to each other, scheduled tasks, document generation. Very common among freelancers and small businesses.

## Extra interview questions

- **Today's process**: the exact steps the person does by hand today, how often, how long it takes and where mistakes happen. Ask for a real example (a file, an email, a screenshot description).
- **Trigger**: what starts the automation (a time, a new email, a new row, a file dropped in a folder, a button).
- **Inputs and outputs**: which files, apps or accounts it reads from and writes to, with formats and real examples. Names of columns, folders and fields, verbatim.
- **Rules**: the decisions the person makes along the way ("if the amount is over 500, I check it first"), including exceptions.
- **Where it runs**: their computer, a spreadsheet tool, a no-code platform, a small server; whether it must work when their computer is off.
- **Access**: accounts, permissions and keys needed (names only), and who holds them.
- **Failures**: what should happen if an input is missing or wrong, and how the person gets notified.
- **Control**: whether a human must review before anything is sent, paid or deleted.
- **Volume and cost**: how many items per day or month, and limits or prices of the services involved.

## Extra sections in the pack

- In `01-CONTEXT.md`: the **current manual process**, step by step, as the person described it.
- In `03-REQUIREMENTS.md`: a **rules table** and a **sample input → expected output** table built from the person's real examples:

| Case | Input | Expected output | Notes |
|---|---|---|---|

## Task-splitting hints

First task: automate one run of the process on one real example, triggered by hand, with the result checked by the person. Then cover the rules and exceptions, then error handling and notifications, then the automatic trigger and scheduling. Anything that sends, pays or deletes stays behind a human confirmation until the person approves removing it.

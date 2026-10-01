# Working with non-technical users

Many people with a good idea are not developers: a physiotherapist who wants online bookings, a shop owner who wants to automate orders, someone at home with an app idea. AI coding agents make building possible for them, but only if the handoff is precise. This file adapts the skill to them without lowering the bar: the agent still gets an exact, validated pack, and the person gets a process and a pack they can actually follow.

## Contents

1. Detecting the profile
2. How to interview
3. Technical decisions
4. Extra topics for solo builders
5. Pack adaptations
6. Template: `handoff/00-START-HERE.md`

---

## 1. Detecting the profile

Infer it from how the person writes: business outcomes instead of technical terms, "I don't know how to code", questions about what things mean. If it is unclear, ask once, in a friendly way, whether they prefer technical or plain language. Profiles can be mixed (a technical founder who knows nothing about one area): adapt per topic, not once and for all.

## 2. How to interview

- **Plain language.** One idea per question. If a technical word is unavoidable, explain it in one short sentence the first time it appears.
- **Ask about their world, not about technology.** Translate each checklist area into everyday terms. For example:
  - Edge cases → "What should happen if two patients try to book the same slot at the same time?"
  - Authorization → "Who should be able to see the list of all bookings: only you, or also your assistant?"
  - Data → "What do you need to know about each customer? Name, phone, something else?"
  - Errors → "If the payment fails, what should the customer see, and should you get a notification?"
- **Use examples and options.** People answer concrete choices better than open questions about abstract concepts. Show two or three options with what each means for them.
- **Respect their time.** Keep rounds short and tell them how much is left. Their answers are just as important as a developer's: the same "interview until closed" rule applies.

## 3. Technical decisions

A non-technical user cannot be expected to choose a framework or a database, and they must not be asked to. But the skill still cannot decide silently. So:

1. **Propose**, in plain language, the option you recommend and one alternative, explaining each in terms that matter to them: monthly cost, how hard it is to change later, who can maintain it, how fast it gets something working.
2. **Ask for explicit approval.** The approved choice becomes a confirmed decision (`D-xx`) with its plain-language reason.
3. **Delegate only low-impact details** (naming, folder layout, styling details within an approved look) to the agent, with limits and their approval, as usual.

High-impact decisions (stack, hosting, paid services, anything that stores personal data or handles money) are always explained and approved, never delegated by default.

Prefer simple, well-documented, low-maintenance options that a solo person can run without a team, and say why.

## 4. Extra topics for solo builders

Cover these in addition to the checklist areas, in plain language:

- **Budget**: what they can spend per month on hosting, domains and paid services, and whether a free option is required.
- **Accounts and access**: which accounts they will need (domain, hosting, payments, email sending) and whether they already have them. Missing accounts are pending items (❓) with the person as owner.
- **Their tools**: whether they already have an editor with a coding agent (VS Code with Copilot, Claude Code, Cursor...). If not, the pack includes setup steps (see section 6) pointing to the official documentation; do not invent installation details.
- **Who maintains it**: who will fix things or add features later, and how much time the person can dedicate.
- **Backups and safety net**: how to avoid losing work. Recommend version control explained simply ("a history of every change you can go back to") and agree on it.
- **Legal and data basics**: whether they collect personal data, need a privacy policy, terms of use or invoices. Flag these topics and record what the person decides; do not give legal advice, and suggest a professional where it matters.
- **What success looks like for them**: in their terms (for example, "patients book without calling me").

## 5. Pack adaptations

Keep the technical files exactly as precise as for a developer: the agent needs them. Add a layer for the person:

- **`handoff/00-START-HERE.md`**, written for the person, not the agent (template below). It becomes the first item in the reading order of `handoff/README.md`, marked as "for the person".
- **Decisions with a "what this means for you" line** in `01-CONTEXT.md`.
- **Acceptance criteria they can check by hand** (open this page, click this button, you should see this), alongside any automated check.
- **A visible first result**: the first task produces something they can open and try.
- **Agent rules for working with a non-technical owner** in `handoff/README.md`:
  - Explain what you did after each task in plain language, and how to try it.
  - Ask before installing paid services, creating accounts or anything that costs money.
  - Never run destructive commands or delete data without explicit confirmation.
  - Save progress often with version control and say how to go back if something breaks.
  - When something needs the owner's action (create an account, add a key), give exact step-by-step instructions.
- **Glossary**: every technical term that appears in the pack is defined in plain language in the glossary of `01-CONTEXT.md`.

## 6. Template: `handoff/00-START-HERE.md`

Write it in the person's language, in a warm and direct tone.

````markdown
# Start here

## What this is
[Two or three sentences: what will be built, for whom, and that these files are the
instructions for the AI agent that will build it.]

## What is in this folder
| File | What it is | Do you need to read it? |
|---|---|---|
| 00-START-HERE.md | This guide | Yes |
| README.md and 01 to 05 | Detailed instructions for the agent | Optional; the agent reads them |

## Before you start
- [ ] [Tools: editor and agent, with links to official installation guides]
- [ ] [Accounts you need and whether you already have them]
- [ ] [Anything else pending on your side, from 05-PENDING.md]

## How to work with the agent, step by step
1. Put the files of this pack in your project folder (unzip them there).
2. Open the folder in your editor and open the agent's chat.
3. Copy the kickoff prompt from README.md and paste it into the agent.
4. When the agent finishes a task, try it as described in the task's checks.
5. If something does not look right, tell the agent what you expected and what you see.

## How to check the work
[For the first tasks: what to open, what to click, what you should see.]

## When to come back to the chat
At the end of each phase the agent writes a report in handoff/reports/.
Paste it into the Claude chat where you prepared this pack (or a new one with the
pack attached) and ask to update the documentation. Also come back if you want to
change something important.

## Words you may see
[Short glossary of the technical terms that appear in the pack.]
````

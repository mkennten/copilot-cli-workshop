# GitHub Copilot CLI Workshop – Exercise Guide

All hands-on exercises of the day: GitHub Copilot CLI in Windows Terminal, on the small Python
**Book Collection App** in `samples/book-app-project`.

**You do not need Python skills.** The app is only the shared vehicle – every step works the same
way in your .NET, Java, TypeScript or PowerShell repositories, and each exercise says how.

**Levels:** every exercise has a **Starter** path (new to Copilot) and a **Stretch** goal (already
experienced).

## Contents

| # | Exercise | Daily-work situation | Session | Time | Start branch |
|---|---|---|---|---:|---|
| 1 | [Quick wins](#exercise-1--quick-wins) | Explain a log, write a script, small change on a feature branch, commit message, automation | 1 | 15 min | `main` |
| 2 | [You inherit an application](#exercise-2--you-inherit-an-application) | Onboarding · the build is red · MCP | 2 | 15 min | `main`, `demo/broken-build` |
| 3 | [From ticket to pull request](#exercise-3--from-ticket-to-pull-request) | Bug ticket BOOK-17 end to end | 3 | 42 min | `main` |
| A | [Team instructions for your stack](#exercise-a--team-instructions-for-your-stack) | Make Copilot follow your team's rules | 6 | 45 min | `main` |
| B | [Small feature: `unread`](#exercise-b--small-feature-unread) | A feature with tests and review | 6 | 45 min | `main` |
| C | [Fleet Design Challenge](#exercise-c--fleet-design-challenge) | Split work across several agents | 6 | 45 min | `exercise/reading-report` |
| D | [Bring your own workflow](#exercise-d--bring-your-own-workflow) | A real task from your job | 6 | 45 min | your repository or `main` |
| E | [Try a structured kit: Spec Kit or HVE Core](#exercise-e--try-a-structured-kit-spec-kit-or-hve-core) | A larger feature with a spec or an evidence trail | 5, after the workshop | 60–90 min | `demo/csv-import-base` |

---

## Before you start

The commands assume the repository in `C:\Labs\copilot-cli-workshop`
([LEARNER-START.md](../LEARNER-START.md)) – adjust the path if you cloned it elsewhere.

### Follow the demos live – or wait for the exercise

Exercises 1–3 contain **the same steps as the trainer's demos** in sessions 1–3. You decide:

- **Follow along:** type the steps while the trainer shows them. In the exercise time
  that follows, do the **Stretch** part.
- **Watch first:** just watch the demo, then do the exercise – Starter, then Stretch – in the
  exercise time.

Either way works. Nothing later in the day depends on what you did: every exercise starts from a
published branch, and the reset script brings you back to it.

### Where you type

| Mark | Where | What you see |
|---|---|---|
| **[Terminal]** | PowerShell 7 in Windows Terminal | Prompt like `PS C:\Labs\copilot-cli-workshop>` |
| **[Copilot]** | Inside Copilot CLI | The Copilot input box; leave it with `/exit` |

Each prompt and command is in its own copy block. Inside Copilot, `!command` runs a single shell
command (for example `!git status`) without leaving Copilot.

### The three commands you need all day

Start Copilot the workshop way (sample app folder, `git push` blocked) **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

then, inside Copilot **[Copilot]**:

```text
/permissions assisted
```

Start over on a clean `main` – **discards uncommitted changes** **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

Clean start on the branch an exercise names (example: exercise C) **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1 -Branch exercise/reading-report
```

The reset script runs in the plain terminal: leave Copilot first with `/exit`.

Tip: you can also run Copilot CLI in the integrated terminal of your IDE (Visual Studio, VS Code,
IntelliJ, Eclipse). In VS Code it connects automatically – selected code becomes context and edits
appear as diffs in the editor (`/ide` shows the connection).

## New to Copilot? Five things to know

1. Copilot CLI is an **agent**: it can read files, run commands and edit code – but asks first.
2. **You are accountable** for every change. Read permission prompts and diffs like a colleague's pull request.
3. **Plan before changing** anything that touches more than one file: press `Shift+Tab` for plan mode.
4. **Context decides quality:** name files with `@`, show output with `!command`, say what "done" means.
5. **Start fresh per task** with `/clear` – long, mixed conversations get worse answers.

## Prompt pattern card

| Part | Ask yourself | Example |
|---|---|---|
| **Goal** | What do I want? | "Find the most likely cause of these errors." |
| **Context** | What should it look at? | "`!Get-Content …\orders-service.log` – a .NET 8 API with SQL Server." |
| **Constraints** | What must not happen? | "No code changes yet. Config cannot change today." |
| **Done** | What does a good answer look like? | "Three ranked hypotheses with evidence and the next check." |

## Working rules for all exercises

1. Plan before multi-file changes.
2. Work on a branch for every change, not on `main`.
3. Read permission prompts – approve once, for the session, or deny.
4. Verify: tests, `git diff`, `git status --short` – or the `/run-tests` skill.
5. Never let an agent edit `data.json`, add packages or run `git push` (the hooks will stop it anyway).
6. **Never paste confidential data** (customer data, credentials, internal logs) unless your
   organisation's policy explicitly allows it for Copilot.
7. Note **one prompt that worked well and one that didn't** – we share them later.

## What you can use in this repository

| Tool | How to use it |
|---|---|
| Instruction file with the Book App rules | Applied automatically to `samples/book-app-project/**` |
| Skills: `run-tests`, `book-data-check`, `triage-build-failure`, `commit-message`, `pr-summary`, `feature-contract` | "Use the /commit-message skill" |
| Agents: `code-reviewer`, `feature-planner` (read-only); `domain-engineer`, `cli-engineer`, `test-engineer`, `documentation-writer` | `/agent`, or "Use the code-reviewer agent to …" |
| MCP servers: `book-catalog` (local), `microsoft-learn`, GitHub (built in) | `/mcp`, "Use the microsoft-learn MCP server to …" |
| Scenarios: ticket, red-build message, production log | `workshop/scenarios/` |
| Team kit for .NET, Java, TypeScript, PowerShell, pipelines | `workshop/team-kit/` |

---

## Exercise 1 – Quick wins

**Session 1 · 15 min · start on `main` · same steps as the trainer's demo**

Start from a clean `main` and start Copilot **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

**[Copilot]**:

```text
/permissions assisted
```

If you have not chosen a model yet, do it once now – the choice is saved:

```text
/model
```

### Starter

**1. Ask about code** (no files change) **[Copilot]**:

```text
What does this application do and how is it structured? Answer in 5 bullet points.
```

```text
Explain @books.py for someone who does not know Python.
```

**2. Explain a production log** from another team's .NET service **[Copilot]**:

```text
!Get-Content ..\..\workshop\scenarios\logs\orders-service.log
```

```text
This log is from a .NET 8 order service using SQL Server and a message broker. What is most likely going on? Give three ranked hypotheses, the evidence for each from the log, and what I should check first. Do not propose code changes yet.
```

**3. Write a script, read it, then run it** **[Copilot]**:

```text
Write a PowerShell 7 command that lists the 10 largest files in this repository, excluding .git, with size in KB. Explain each part before I run it.
```

Read the explanation, then let Copilot run it – approve **once** in the permission prompt.

**4. Plan, then change – on a feature branch** **[Copilot]**. First create the branch:

```text
!git switch -C feature/mark-command
```

Press **Shift+Tab** until the mode shows *plan*, then:

```text
Plan how to add a "mark" command that marks a book as read. Identify affected files and acceptance criteria. Do not change any files.
```

Check the plan. Press **Shift+Tab** until you are back in the normal mode, then:

```text
Implement the plan.
```

Read every permission prompt before you approve it. Then look at the result:

```text
!git diff
```

### Stretch

**5. Commit message from a team skill** **[Copilot]**:

```text
!git add -A
```

```text
Use the /commit-message skill.
```

Does the message follow Conventional Commits? There is **no** `Refs:` line, because the branch name
contains no ticket ID – the skill tells you so. (In exercise 3 the branch name contains `BOOK-17`.)
Then commit:

```text
Commit the staged changes with this message.
```

**6. Guardrails** – try to push **[Copilot]**:

```text
Push this branch to origin.
```

What stops it – and where is that configured? (Hint: the start command, and
`.github/hooks/governance.json`.)

**7. Automate** – leave Copilot first **[Copilot]**:

```text
/exit
```

then run one prompt without a chat **[Terminal]**:

```powershell
copilot -p "Summarise the commits on this branch that are not on main, for a stand-up update, in 3 bullet points" --allow-tool "shell(git)"
```

Where could you use this in a script, a scheduled job or a pipeline?
If you see `Error: No supported model available`: start Copilot, choose a model with `/model`, and
try again – or add `--model <model-id>` with an ID that `/model` lists.

**Finish:** back to a clean `main` **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

**Done when** you can explain which steps changed files and which did not, and why the log answer
is trustworthy (or not). Post *"1"* in the chat.

**In your stack:** steps 1–3 work unchanged in any repository; for step 4 the instruction file tells
Copilot your build and test commands (exercise A).

---

## Exercise 2 – You inherit an application

**Session 2 · 15 min · branches `main` and `demo/broken-build` · same steps as the trainer's demo**

Start from a clean `main` **[Terminal]** (skip this if Copilot is already running on a clean `main`):

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

```text
/permissions assisted
```

### Starter – onboarding

**1. Architecture** **[Copilot]**:

```text
Using @book_app.py @books.py @utils.py: draw the architecture as a short ASCII diagram and explain the data flow for "add".
```

**2. Risks with evidence** **[Copilot]**:

```text
What are the three most relevant risks in this codebase for operations and data quality? Rank them and give the evidence (file and line).
```

**3. A skill with a script** – which problems could the code have prevented? **[Copilot]**:

```text
Use the /book-data-check skill to check our data quality.
```

**4. Explore agent** **[Copilot]**:

```text
Use the explore agent to find every place where data.json is read or written, and whether writes can lose data.
```

**5. A real deliverable** **[Copilot]**:

```text
Write a one-page onboarding note for a new team member: purpose, structure, how to run and test, known risks.
```

### Stretch – the build is red

Read `workshop/scenarios/RED-BUILD.md` (a message from your colleague Alex), then switch to the
broken branch **[Copilot]**:

```text
!Get-Content ..\..\workshop\scenarios\RED-BUILD.md
```

```text
!git switch demo/broken-build
```

```text
Use the /triage-build-failure skill. CI is red on this branch since yesterday's commits.
```

Find the commit, explain the cause, decide whether the code or the test is wrong:

```text
Is the code or the test wrong? Propose the smallest fix and a regression test. Do not change files yet.
```

```text
Draft a short reply to Alex: cause, fix, and what would have prevented it.
```

**Do not** fix it by changing the test. Hint: ask for evidence (file, line, commit);
`!git log --oneline main..HEAD` shows what changed. Afterwards switch back:

```text
!git switch main
```

**Extra – MCP:** see what is connected, then ask the "internal system" and the documentation server:

```text
/mcp
```

```text
Use the book-catalog MCP server to suggest two Science Fiction books that are not in data.json.
```

```text
Use the microsoft-learn MCP server: how are MCP servers governed for GitHub Copilot in an organisation?
```

**Extra – GitHub MCP:** the built-in GitHub MCP server can read pull requests and workflow runs of
the published workshop repository. Workflow runs need the Actions toolset – leave Copilot (`/exit`)
and start it with **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1 -GitHubActions
```

Then name the server, otherwise Copilot may use the GitHub CLI (`gh`) instead **[Copilot]**:

```text
Use the GitHub MCP server, not the gh CLI: show the latest workflow runs in this repository and which branch failed.
```

**Post in the chat:** one risk or the root cause you found, and the prompt that found it.

---

## Exercise 3 – From ticket to pull request

**Session 3 · guided: the trainer shows each phase, then you repeat it · start on `main`**

If you only watched in session 3, do this exercise in session 6 or after the workshop.

Start from a clean `main` **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

```text
/permissions assisted
```

### Starter – the eight phases

**Phase 0 – Read the ticket** – acceptance criteria and Definition of Done **[Copilot]**:

```text
!Get-Content ..\..\workshop\scenarios\BOOK-17-invalid-books.md
```

**Phase 1 – Branch** – the ticket ID in the branch name is used by the commit message later:

```text
!git switch -C fix/BOOK-17-input-validation
```

**Phase 2 – Understand** – confirm the bug before you fix it:

```text
Read @../../workshop/scenarios/BOOK-17-invalid-books.md. Which of the reported inputs are accepted today? Show where in @books.py and @book_app.py.
```

(If `@` outside the folder is refused: the ticket is already in the context from phase 0 – ask
without the first `@` reference.)

**Phase 3 – Plan** – press **Shift+Tab** until the mode shows *plan*:

```text
Plan the fix for BOOK-17. Map every acceptance criterion to the code change and to a test. List affected files. Do not change files.
```

Correct the plan if something is missing – that is your decision.

**Phase 4 – Implement** – accept the plan (or **Shift+Tab** back to the normal mode and type
`Implement the plan.`). Read every permission prompt.

**Phase 5 – Test**:

```text
Use the /run-tests skill.
```

**Phase 6 – Review** – fix real findings:

```text
Use the code-reviewer agent to review the change against BOOK-17.
```

**Phase 7 – Commit**:

```text
!git add -A
```

```text
Use the /commit-message skill.
```

The message should end with `Refs: BOOK-17`. Then:

```text
Commit the staged changes with this message.
```

**Phase 8 – Pull request text**:

```text
Use the /pr-summary skill.
```

### Stretch

Edge cases the plan may have missed:

```text
Which edge cases does our BOOK-17 change not handle yet - for example whitespace-only input, a year given as text, or duplicates that differ only in case? Add tests for the ones that matter.
```

A data fix is a separate ticket – why?

```text
Propose - do not execute - a plan to clean up the existing invalid record in data.json, including how to roll it back.
```

VS Code users: run the CLI in the VS Code terminal and review the edits as diffs in the editor.

**Self-check**

- [ ] Every acceptance criterion has at least one test, and all tests pass
- [ ] `git status --short` does not list `data.json`
- [ ] The reviewer agent found no blocking issue – or you fixed it
- [ ] The commit message references BOOK-17
- [ ] You can name one thing you corrected in Copilot's plan

Stuck? Look at one possible solution **[Terminal]** (discards your uncommitted changes):

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1 -Branch demo/validation-complete
```

**Finish:** back to a clean `main`:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

**In your stack:** identical phases; the `run-tests` skill in `workshop/team-kit` detects
`dotnet test`, `mvn test`, `npm test` …

---

## Exercise A – Team instructions for your stack

**Session 6 (option) · 45 min · branch `main`**

Make Copilot follow your team's rules without being told each time.

Start **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

**[Copilot]**:

```text
/permissions assisted
```

```text
!git switch -C feature/team-instructions
```

### Starter – for the Book App

1. Look at `.github/instructions/book-app.instructions.md` (path-specific rules) and
   `workshop/team-kit/copilot-instructions.template.md`.
2. Create `.github/copilot-instructions.md` for this repository from the template **[Copilot]**:

```text
Using @../../workshop/team-kit/copilot-instructions.template.md, draft .github/copilot-instructions.md for this repository: purpose, architecture, build/run/test, conventions, way of working, never-list. Do not repeat .github/instructions/book-app.instructions.md. Max 40 lines.
```

3. Edit the draft yourself – make every rule specific and testable.
4. **Prove it works** – start a fresh conversation, then ask for a small change. Does Copilot follow
   your rules unprompted?

```text
/clear
```

```text
Add a "count" command that prints the number of books.
```

### Stretch – for your own stack

1. Pick your main language from `workshop/team-kit/instructions/` (.NET, Java, TypeScript,
   PowerShell, pipelines) and adapt it to your team's real conventions.
2. Write down where it would go in your repository and which `applyTo` pattern it needs.
3. Compare it with one other stack file in the team kit: what is the same, what differs?
4. Which rule cannot be *requested* and must be *enforced* (hook, branch protection, CI)?

**Done when** the file is specific, under ~40 lines, and you can show one behaviour that changed because of it.

---

## Exercise B – Small feature: `unread`

**Session 6 (option) · 45 min · branch `main`**

Add `python book_app.py unread`, which lists all books that have not been read yet.

Start **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

**[Copilot]**:

```text
/permissions assisted
```

```text
!git switch -C feature/unread-command
```

### Acceptance criteria

1. `BookCollection.list_unread()` returns the unread books in collection order.
2. `python book_app.py unread` prints them in the same format as `list`;
   if there are none it prints `All books read - nice!`.
3. `help` lists the new command.
4. Tests for the domain method and the CLI output; all tests pass; data.json unchanged.

### Starter

Same loop as exercise 3. Press **Shift+Tab** for plan mode, then **[Copilot]**:

```text
Plan the "unread" command with these acceptance criteria: BookCollection.list_unread() returns the unread books in collection order; "python book_app.py unread" prints them in the same format as "list", or "All books read - nice!" if there are none; help lists the command; tests for the domain method and the CLI output, data.json unchanged. List affected files. Do not change files.
```

Check the plan, **Shift+Tab** back to the normal mode, then one prompt at a time:

```text
Implement the plan.
```

```text
Use the /run-tests skill.
```

```text
Use the code-reviewer agent to review the change against the acceptance criteria.
```

```text
!git add -A
```

```text
Use the /commit-message skill.
```

```text
Use the /pr-summary skill.
```

### Stretch

- Add an optional author filter, for example `python book_app.py unread --author Orwell`, with tests.
- Ask the `code-reviewer` agent to look for edge cases (empty collection, every book read) and act on
  its findings.

**Hints:** domain logic in `books.py`, printing in `book_app.py`; `show_books()` already formats a
list; for CLI tests set `sys.argv` with `monkeypatch` and read `capsys.readouterr().out`; copy the
temporary data file pattern from `tests/test_books.py`.

**Self-check:** `unread` and `help` work · tests pass · `data.json` unchanged.

---

## Exercise C – Fleet Design Challenge

**Session 6 (option, recommended for experienced users) · 45 min · branch `exercise/reading-report`**

You design how a team of agents builds a feature safely – the hard part of multi-agent work.
The same skill applies when you split a change across several services or modules in your own
applications.

### Task: Markdown Reading Progress Report

The `stats` feature from the Fleet demo already exists. Design – and optionally implement –
a new command:

```powershell
python book_app.py report .\out\reading-progress.md
```

The target file should contain:

```markdown
# Reading Progress

- Total books: 8
- Read: 3
- Unread: 5
- Completion: 37.5%

## Unread Books

- Clean Code — Robert C. Martin (2008)
- Domain-Driven Design — Eric Evans (2003)
```

### Requirements

- The report uses `get_reading_stats()`.
- Unread books are sorted alphabetically by title.
- If there are no unread books, the report contains: `No unread books.`
- Missing target directories are created.
- The file is written in UTF-8.
- data.json must not be modified.
- Existing commands keep working.
- No external packages.
- Tests cover at least: mixed collection; fully read collection; creation of a missing
  target directory.

### Fleet constraints

- At least three subagents.
- At least two custom agents.
- A shared function contract must be defined **before** `/fleet`.
- No agent may edit the same file as another agent.
- Integration and the full test run happen after the parallel tracks.
- `git push` is forbidden.

### Deliverables

1. Partition table (track, agent, file, parallel?, dependency)
2. Function contract
3. Complete `/fleet` prompt
4. Tool and permission concept (which agent needs which tools – and which not)
5. Validation checklist
6. Optional: executed implementation

Helpers: the `feature-contract` skill, the `feature-planner` agent, and
`samples/book-app-project/docs/features/reading-statistics.md` as an example contract.

### Timetable

| Time | Activity |
|---|---|
| 0–5 min | Read the task, collect open questions |
| 5–12 min | Define the function contract and acceptance criteria |
| 12–20 min | Assign agents, files and dependencies |
| 20–30 min | Write the Fleet prompt and permissions |
| 30–40 min | Optional: run Fleet or simulate the decomposition |
| 40–45 min | Capture the result and one key trade-off |

Use the answer template at the end of this exercise.

### Starter

Work through the deliverables 1–5 on paper (or in the template) with the help of the
`feature-planner` agent:

```text
Use the feature-planner agent to create a feature contract and a partition table for the "Markdown Reading Progress Report" described in workshop/EXERCISE-GUIDE.md, exercise C. Pay special attention to file ownership and to what cannot run in parallel.
```

Then challenge the result – do not accept it as it is.

Start **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1 -Branch exercise/reading-report
```

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

```text
/permissions assisted
```

### Stretch

Run your `/fleet` prompt on the branch and watch the subagents **[Copilot]**:

```text
/tasks
```

Then verify with your checklist, one command at a time:

```text
!python -m pytest tests -q
```

```text
!git diff --check
```

```text
!git status --short
```

**Hints**

- Start with the contract: what exactly does the new function take, return and promise? If two
  tracks need to see each other's code, the contract is not precise enough.
- Every file has **exactly one** owner. Who owns `book_app.py`? Who must **not** touch it?
- The agent files say "For the Reading Statistics demo, edit only …" – your prompt must state the
  file boundaries for **this** feature.
- Which agent needs no shell access? Which needs `execute` – and for what?
- How will you *prove* that `data.json` did not change?

### Answer template

Name:

#### 1. Function contract

```python
# module, signature, return value, side effects
```

#### 2. Partition table

| Track | Agent | Owned file(s) | Parallel? | Dependency |
|---|---|---|---|---|
| | | | | |

#### 3. Fleet prompt

```text
/fleet ...
```

#### 4. Tool and permission concept

| Agent | Needed tools | Not needed |
|---|---|---|
| | | |

#### 5. Validation checklist

- [ ]

#### 6. Key trade-off we made

---

## Exercise D – Bring your own workflow

**Session 6 (option) · 45 min · your repository (only if your organisation allows it) or `main`**

Take something from your real work and do it with Copilot CLI.

> Check first: may you open this repository with Copilot on this machine (licence, policy, data
> classification)? If not, use the Book App with *your* workflow – the conventions and procedures
> are what matter.

### Starter – pick one

Start Copilot in your repository **[Terminal]** – in that repository's folder:

```powershell
copilot --deny-tool='shell(git push)'
```

or, with the Book App:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

**Onboarding note for your application** **[Copilot]**:

```text
Write a one-page onboarding note for this repository: purpose, structure, how to build, run and test, known risks.
```

**A ticket from your backlog:** branch → plan with acceptance criteria → implement → test → review –
the phases of exercise 3.

**A script you need** – replace `<task>` first:

```text
Write a PowerShell 7 script that <task>. Use parameters, -WhatIf support and comment-based help. Explain it before I run it.
```

**A recurring procedure as a skill** – replace `<name>` and `<does X>` first:

```text
Create a skill in .github/skills/<name>/SKILL.md for how our team <does X>: steps, commands, output format.
```

### Stretch

- Turn what you did into a **team artefact**: an instruction rule, a skill or an agent from
  `workshop/team-kit/` adapted to your stack.
- Write down the one rule that must be **enforced** (hook, CI, branch protection) rather than requested.

**Bring to the discussion:** what worked, where you had to correct Copilot, what you will keep.

---

## Exercise E – Try a structured kit: Spec Kit or HVE Core

**Session 5 follow-up · optional, after the workshop · 60–90 min per kit · branch `demo/csv-import-base`**

In session 5 the trainer showed two structured approaches on the same feature – the CSV import in
`docs/features/csv-import.md` – as prepared results. Now run one yourself. The first phases are
enough to see how each kit structures the work; a full run including implementation takes longer.

| | GitHub Spec Kit | HVE Core (Microsoft) |
|---|---|---|
| Idea | Spec-driven: the specification is the primary artefact | Research → Plan → Implement → Review, evidence first |
| Comes as | a command-line tool (`specify`) that adds skills and templates to your repository | a Copilot CLI plugin |
| Artefacts | `.specify/memory/constitution.md`, `specs/<feature>/spec.md`, `plan.md`, `tasks.md` | `.copilot-tracking/research/…`, `plans/…`, plan critique, review |

> Check first: Spec Kit is installed from the Python package index (blocked on some company
> networks – see Starter A, step 1) and needs **Python 3.11 or later** (`python -V`). HVE Core is a
> Copilot CLI plugin from GitHub – your organisation's plugin policy must allow it.

### Starter A – GitHub Spec Kit

**1. Install the Spec Kit tool – once** **[Terminal]**. It goes into its own folder (not under
AppData – the Microsoft Store Python would redirect it there):

```powershell
python -m venv C:\Labs\.tools\specify-cli
```

```powershell
C:\Labs\.tools\specify-cli\Scripts\python.exe -m pip install specify-cli
```

Blocked package index? Add `--index-url <package-index-url-from-your-IT>` to the second command. Check:

```powershell
C:\Labs\.tools\specify-cli\Scripts\specify.exe version
```

**2. Your own branch from the starting point** **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1 -Branch demo/csv-import-base
```

```powershell
git -C C:\Labs\copilot-cli-workshop switch -c try/spec-kit
```

**3. Add Spec Kit to the app** **[Terminal]** – it copies the Spec Kit skills, templates and scripts
into the app folder; commit them so you can see later what the run changed:

```powershell
Set-Location C:\Labs\copilot-cli-workshop\samples\book-app-project
C:\Labs\.tools\specify-cli\Scripts\specify.exe init --here --force --integration copilot --script ps
git add -A
git commit -m "chore: initialise Spec Kit"
Set-Location C:\Labs\copilot-cli-workshop
```

**4. Start Copilot** **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

Check that the Spec Kit skills are there **[Copilot]** – you see `speckit-constitution`,
`speckit-specify`, … (older Spec Kit versions show them as `/speckit.*` prompts):

```text
/skills list
```

**5. Run the phases one by one** **[Copilot]**. After **every** phase open the file it wrote and note
what you would correct.

- **Skill `speckit-constitution`:** writes the project's principles to `.specify/memory/constitution.md`.
- **Why here:** every later phase is checked against these rules – they replace repeating them in each prompt.

```text
/speckit-constitution
Create project principles for this Python Book Collection App:
- Preserve backward compatibility for all existing CLI commands.
- Use only the Python standard library unless a dependency is explicitly approved.
- Keep persistence and domain behavior out of command-line display code.
- Every behavior change requires pytest tests.
- Tests must not modify the repository's data.json.
- Errors must identify the failed input and provide an actionable reason.
- Human review is required before accepting implementation results.
```

- **Skill `speckit-specify`:** turns the feature into a specification (`specs/<feature>/spec.md`) –
  user behaviour and acceptance scenarios, no technical decisions.
- **Why here:** *what* before *how* – the spec is what the plan and the tests are measured against.

```text
/speckit-specify
Define the feature in @docs/features/csv-import.md.
Focus on user behavior, acceptance scenarios, edge cases, and measurable outcomes.
Do not choose the implementation architecture or add requirements outside the supplied feature.
```

- **Skill `speckit-clarify`:** looks for gaps and ambiguities in the spec and asks you about them.
- **Why here:** open decisions become explicit before anyone plans or codes. Answer from the
  feature document where it already decides the question.

```text
/speckit-clarify
Review the CSV import specification for ambiguity.
Prioritize duplicate handling, partial success when rows are invalid, accepted boolean values,
dry-run behavior, and missing files and missing headers.
Use the supplied feature document as the authoritative answer where it already resolves a question.
Ask only decision-relevant questions.
```

- **Skill `speckit-plan`:** writes the technical plan (`plan.md`, plus research and data-model notes).
- **Why here:** now the *how* – checked against the constitution from the first phase.

```text
/speckit-plan
Create the technical plan for the approved CSV import specification.
Constraints: Python standard library only; pytest for tests; preserve the current data.json schema;
preserve existing commands; keep CSV parsing testable independently from terminal input;
include a verification strategy.
```

### Starter B – HVE Core

**1. Install the plugin – once** **[Terminal]**. First check whether it is already there:

```powershell
copilot plugin list
```

If `hve-core` is not listed:

```powershell
copilot plugin marketplace add microsoft/hve-core
```

```powershell
copilot plugin install hve-core@hve-core
```

(If the first command reports that the marketplace is already registered, just run the second.)

**2. Your own branch from the starting point** **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1 -Branch demo/csv-import-base
```

```powershell
git -C C:\Labs\copilot-cli-workshop switch -c try/hve-core
```

**3. Start Copilot** **[Terminal]**:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

Check the skills **[Copilot]**. Skills from a plugin carry the plugin name as a prefix:
`hve-core:rpi-research`, `hve-core:rpi-plan`, … If your list shows them without the prefix, type
the short form (`/rpi-research`) in the prompts below.

```text
/skills list
```

**4. Run the phases one by one** **[Copilot]** and open each artefact. HVE Core writes them to
`.copilot-tracking/` – that folder is git-ignored, so `git status` does not show them.

- **Skill `hve-core:rpi-research`:** collects evidence from the repository – patterns, dependencies,
  risks, open questions – and writes a research document. It does not plan or change code.
- **Why here:** evidence first – the plan builds on what is really in the code, not on assumptions.

```text
/hve-core:rpi-research topic="Assess implementation readiness for the CSV import feature in @docs/features/csv-import.md. Inspect the current repository, existing persistence behavior, command structure, and tests. Identify requirements, relevant patterns, dependencies, risks, and evidence gaps. Do not plan or implement."
```

- **Skill `hve-core:rpi-plan`:** turns the research into a phased, verifiable plan – and writes an
  independent critique of that plan.
- **Why here:** the critique is HVE Core's built-in second opinion before any code is written.

```text
/hve-core:rpi-plan
Create a bounded, verifiable implementation plan for @docs/features/csv-import.md using the completed research evidence.
The plan must map each acceptance criterion to tasks, define file boundaries and dependencies,
preserve the existing JSON schema and commands, include test and validation requirements,
record unresolved decisions, and not modify source files.
```

### Stretch

**Implement and verify** – with the kit you started:

- **Spec Kit** **[Copilot]**: `/speckit-tasks` (task list from the plan), then `/speckit-implement`
  (works through the tasks).
- **HVE Core** **[Copilot]**: implement, then the separate review:

```text
/hve-core:rpi-implement
Implement the approved CSV import plan. Use the approved plan as the scope boundary.
Record material deviations and validation evidence. Do not push or create a pull request.
Stop and report if a decision would materially change the approved requirements or plan.
```

```text
/hve-core:rpi-review
Review the CSV import implementation against @docs/features/csv-import.md, the approved plan,
the plan critique, the recorded changes, and the test and validation evidence.
Do not modify source files. Route defects, evidence gaps, or residual work explicitly.
```

Then check the result yourself **[Copilot]** – the tests, a dry run with the sample file, and that
`data.json` is unchanged:

```text
!python -m pytest -q
```

```text
!python book_app.py import-csv samples/books-import.csv --dry-run
```

```text
!git status --short
```

**Compare** – do the other kit too, or compare with the trainer's results from session 5:

| Question | Spec Kit | HVE Core |
|---|---|---|
| What did you have to decide yourself? | | |
| Which artefacts would a reviewer read? | | |
| Which questions did Copilot ask? | | |
| How long did the phases take? | | |
| For which change in your team would you use it? | | |

**Finish** **[Terminal]** – back to a clean `main` (leave Copilot with `/exit` first):

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

Remove the tools if you no longer need them:

```powershell
copilot plugin uninstall hve-core
```

```powershell
Remove-Item C:\Labs\.tools\specify-cli -Recurse -Force
```

---

## After the exercises

Bring to the discussion (session 7):

1. Your plan, contract or instruction file – what made it precise enough?
2. One place where you overruled or corrected Copilot.
3. One task you would **not** give to an agent – or not to several agents in parallel.
4. One prompt or skill you will use next week.

## Quick reference

**[Terminal]**

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

```powershell
copilot -p "<prompt>" --allow-tool "shell(git)"
```

**[Copilot]**

| You want to … | Do this |
|---|---|
| Choose permissions | `/permissions assisted` |
| Plan before changing | `Shift+Tab` |
| Point at a file / run a command | `@path` / `!command` |
| See what is loaded | `/instructions`, `/agent`, `/skills list`, `/mcp` |
| Use a skill / an agent | "Use the /run-tests skill" / "Use the code-reviewer agent to …" |
| Choose the model | `/model` |
| Start fresh | `/clear` |
| Connect to VS Code | `/ide` |
| Run several agents in parallel | `/fleet <prompt>`, watch with `/tasks` |
| Leave Copilot | `/exit` |

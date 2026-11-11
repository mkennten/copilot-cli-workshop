# GitHub Copilot CLI Workshop – Agenda

One-day hands-on workshop: **working effectively with GitHub Copilot CLI** in an enterprise team
that builds applications in several languages and frameworks, with different IDEs.
Copilot CLI in Windows Terminal is the common ground – the same agent, the same team rules and the
same workflows for everyone.

**Who it is for:** developers and admins who build, operate and support enterprise applications.
Some of you use Copilot already, some not yet – both are fine. No Python knowledge is needed: the
small Python sample app is only the shared training object.

**Before the workshop:** prepare your machine with [LEARNER-START.md](LEARNER-START.md) (about 20 minutes).

## How the online day works

- The workshop runs **online**. Everyone works **on their own machine, in their own copy** of the
  repository – there is no shared working copy and nobody pushes.
- Each session starts with a few slides on the concepts, followed by demos and exercises.
- **Demos:** the trainer shares the screen. You can type along in your copy, or watch and do the same
  steps in the exercise afterwards – your choice. Nothing later depends on it.
- **Exercises:** you work alone with the [Exercise Guide](workshop/EXERCISE-GUIDE.md); questions go
  into the meeting chat, and the trainer helps via screen sharing if needed.

## Schedule

Seven sessions of 50 minutes, each followed by a 10-minute break.

| Time | Session | Topic | Format |
|---|---|---|---|
| 09:00–09:50 | 1 | **GitHub Copilot CLI Fundamentals** – ask, plan, execute; quick wins for daily work | Short intro, demo, individual exercise |
| 09:50–10:00 | | Break | |
| 10:00–10:50 | 2 | **Context & Repository Understanding** – inherit an application, triage a red build, connect tools (MCP) | Scenario demos, individual exercise |
| 10:50–11:00 | | Break | |
| 11:00–11:50 | 3 | **Development Workflow** – from a ticket to a pull request with tests and review | Guided demo – repeat each step in your copy |
| 11:50–12:00 | | Break | |
| 12:00–12:50 | 4 | **Multi-Agent Development with Fleet** – one feature, four agents, clear ownership | Live demo, discussion |
| 12:50–13:40 | | Lunch | |
| 13:40–14:30 | 5 | **Structured AI Development: Spec Kit & HVE Core** – how much structure does a change need? | Prepared results, comparison |
| 14:30–14:40 | | Break | |
| 14:40–15:30 | 6 | **Hands-on Exercise** – choose: team instructions for your stack · small feature · Fleet design challenge · your own workflow | Individual exercise |
| 15:30–15:40 | | Break | |
| 15:40–16:30 | 7 | **Solutions, Q&A and Next Steps** – results, your stacks and questions, adoption plan | Discussion |

Net learning time: 7 × 50 min = 5 h 50 min.

## Sessions in detail

| Session | You will … |
|---|---|
| 1 Fundamentals | start Copilot CLI safely, ask about code, explain a production log, write a script, plan and make a small change, write a commit message, run Copilot from a script |
| 2 Context | onboard to an unfamiliar application, find the commit that broke the build, use MCP servers for documentation and internal systems |
| 3 Workflow | take bug ticket BOOK-17 through branch → plan → implement → test → review → commit → pull request |
| 4 Fleet | see a feature split into a contract and four parallel agent tracks, watched with `/tasks`, verified at the end – and discuss where this fits your work |
| 5 Spec Kit & HVE Core | compare two structured approaches on the same feature, using prepared pull requests and artefacts |
| 6 Exercise | apply the day to a task of your choice, at starter or stretch level |
| 7 Wrap-up | compare approaches, get answers for your stacks and IDEs, plan your first week and the team's next steps |

## Learning outcomes

By the end of the day you can …

1. **Use Copilot CLI safely** for everyday tasks: ask, plan, execute, with permissions you understand.
2. **Give the right context** – files, logs, tickets, tools – and get grounded answers.
3. **Run a complete change** from ticket to pull request with tests and review as proof of done.
4. **Triage a red build** and explain a failure with evidence from Git history.
5. **Decide when to delegate or parallelise** (subagents, `/fleet`) – and when not to.
6. **Set up shared team customizations** for *your* stack: instructions, skills, agents, hooks, MCP.
7. **Name the governance controls** an enterprise uses: policies, permissions, hooks, MCP allowlists, review.
8. **Choose the right level of structure** for a change (prompt, plan, spec, research-first).

## Daily workflow map

Every session maps to one or more of these everyday situations.

| Daily workflow | Copilot CLI pattern | Where today |
|---|---|---|
| Understand an unfamiliar application or a colleague's code | Ask with `@` context, explore agent | S1, S2 |
| Make sense of an error, log or stack trace (any language) | Paste or `!Get-Content` the log, ask for root-cause hypotheses | S1 |
| Write or explain a script (PowerShell, Bash, SQL) | Ask → review → run with approval | S1 |
| Implement a ticket | Branch → plan with acceptance criteria → implement → test → review | S3 |
| Write tests for existing code | Plan + test skill, test-engineer agent | S3, S4 |
| The build or pipeline is red | `triage-build-failure` skill, Git history, GitHub MCP | S2 |
| Review a change before a pull request | `code-reviewer` / `security-reviewer` agents | S3, S6 |
| Commit messages, PR descriptions, release notes | Skills: `commit-message`, `pr-summary`, `release-notes` | S1, S3 |
| Look up internal or vendor documentation | MCP servers (Microsoft Learn, internal systems) | S2 |
| Cross-cutting change across modules | `/fleet` with a contract and file ownership | S4 |
| Larger feature with stakeholders / audit needs | Spec Kit or HVE Core | S5 |
| Automate a recurring task | `copilot -p` in scripts and pipelines | S1 |
| Share team rules across stacks and IDEs | `.github/` instructions, skills, agents, hooks, MCP config | S6, S7 |

## The thread through the day

1. **Copilot CLI** – How do I work effectively and safely with a coding agent in my daily work?
2. **Fleet / multi-agent** – How do I delegate and parallelise work?
3. **Spec Kit / HVE Core** – How do I structure larger AI-assisted engineering work?
4. **Adoption** – Which practices does our team adopt, and how do we share them across stacks?

# GitHub Copilot CLI Workshop – Book App

Repository for a one-day hands-on workshop on **GitHub Copilot CLI** for teams that build
enterprise applications in several languages and frameworks, with different IDEs.

## Learner: start here

1. **[LEARNER-START.md](LEARNER-START.md)** – prepare your machine before the workshop (about 20 minutes).
2. [AGENDA.md](AGENDA.md) – what the day looks like.
3. [workshop/EXERCISE-GUIDE.md](workshop/EXERCISE-GUIDE.md) – the exercises, on the workshop day.

## Branches

Every exercise and demo starts from a branch of this repository. Switch with the reset script – it
discards uncommitted changes and runs the tests (replace the branch name):

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1 -Branch exercise/reading-report
```

| Branch | Used for |
|---|---|
| `main` | Starting point for sessions 1–3 and most exercises |
| `demo/broken-build` | Exercise 2, stretch: CI is red – find out why |
| `demo/validation-complete` | Exercise 3: one possible solution (BOOK-17 input validation) |
| `demo/fleet-start` | Session 4: starting point – try Fleet (several agents in parallel) yourself |
| `exercise/reading-report` | Exercise C: starting point (reading statistics already built) |
| `demo/csv-import-base` | Exercise E (optional, after the workshop): try the CSV import with Spec Kit or HVE Core yourself |
| `solutions/*` | Sample solutions for exercises A–C (published after the workshop) |

## What is in this repository

| Path | Content |
|---|---|
| `samples/book-app-project/` | The sample application (Python Book Collection App from the official *Copilot CLI for Beginners* course) |
| `.github/` | Copilot customizations: instructions, custom agents, skills, hooks, CI workflow |
| `workshop/EXERCISE-GUIDE.md` | All exercises |
| `workshop/scenarios/` | Ticket, red-build message and production log used in the exercises |
| `workshop/team-kit/` | Starter files to take the customizations to your own .NET, Java, TypeScript or PowerShell repositories |
| `scripts/` | `check-prereqs`, `setup`, `start-copilot`, `reset-demo` |

Licence notes: [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

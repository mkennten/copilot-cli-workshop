# Fleet demo – evidence

This folder belongs to the session 4 demo: one feature (`stats` – reading statistics) built by
several Copilot CLI agents in parallel with `/fleet`, from the starting point `demo/fleet-start`.

**Where the code on this branch comes from:**

- If `RUN-INFO.md` is in this folder, the code was written by the agents of a real `/fleet` run on
  the date shown there (Copilot CLI version, model and timeline included).
- Without `RUN-INFO.md` the code is a **reference build**: written by hand to the same feature
  contract, not by a `/fleet` run – the commit messages say so.

| File | Content |
|---|---|
| `01-feature-contract.md` | The contract every agent worked against (interfaces, file ownership, acceptance criteria) |
| `03-fleet-prompt.md` | The exact `/fleet` prompt |
| `04-tasks-screenshot.png` | `/tasks` view with the parallel agents (from the real run) |
| `04-subagent-timeline.md`, `04-subagents.log` | When each agent started and stopped, and how many ran in parallel |
| `05-session.md` | The Copilot session of the run |
| `06-test-output.txt` | Test run of the result |
| `07-command-output.txt` | Output of `python book_app.py stats` |
| `08-final-diff.patch` | All changes against `demo/fleet-start` |
| `09-acceptance-review.md` | Acceptance criteria and their evidence |
| `RUN-INFO.md` | Date, Copilot CLI version, model and settings of the run |

Files that are not here were not produced for this branch. For **Exercise C** compare your own
contract and Fleet prompt with `01-feature-contract.md` and `03-fleet-prompt.md`.

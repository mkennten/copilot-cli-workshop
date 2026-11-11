---
name: triage-build-failure
description: Investigates a failing build or test run (CI red) - reproduces locally, finds the failing step and the commit that introduced it, explains the root cause and proposes the smallest fix. Use when asked why the build, pipeline, CI or tests are failing.
---

# Triage a failing build

1. **Get the failure.** If a CI run is referenced and the GitHub MCP server is available, read
   the failed job log (summarise, do not paste thousands of lines). Otherwise ask for the log or
   reproduce locally with the `run-tests` skill.
2. **Reproduce locally** with the same command as CI. If it does not reproduce, compare
   environment (runtime version, OS, env vars, dependency lock files).
3. **Narrow the change.** `git log --oneline <last-green>..HEAD`, then `git log -p` for the files
   involved in the failure. Use `git bisect run <test command>` when the range is large.
4. **Explain** the root cause in two or three sentences: which commit, which line, why it breaks
   the failing test or step. Decide explicitly whether the code or the test is wrong.
5. **Propose** the smallest fix and a regression test. Do not change anything until the user agrees.
6. **Draft a reply** to the commit author: cause, fix, prevention (missing test, review rule).

Never "fix" a build by deleting or skipping tests, or by weakening the pipeline.

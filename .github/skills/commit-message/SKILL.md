---
name: commit-message
description: Writes a Conventional Commits message for the currently staged changes, with a ticket reference when one is available. Use when asked to write, suggest or improve a commit message.
---

# Commit message

1. Read the staged changes: `git diff --staged --stat` and `git diff --staged`.
   If nothing is staged, say so, list the changed files (`git status --short`) and ask whether to
   stage all of them (`git add -A`) - do not stop silently.
2. Look for a ticket reference (for example `BOOK-17`, `PROJ-123`, `#42`):
   - in the branch name (`git branch --show-current`, e.g. `fix/BOOK-17-input-validation`), or
   - in what the user said.
   **The ticket reference is optional.** If there is none, write the message without the `Refs:`
   line and add one sentence after it: "No ticket reference found - add `Refs: <ID>` if this change
   belongs to a ticket." Never invent a ticket ID and never refuse because one is missing.
3. Write:

```text
<type>(<scope>): <imperative summary, max 72 chars>

<why the change was needed, 1-3 lines>
<what changed, as short bullet points if more than one thing>

Refs: <TICKET-ID>          (only when a ticket reference was found)
```

   `type` is one of feat, fix, refactor, test, docs, build, ci, chore.
4. Show the message. Commit only if the user asks (`git commit -F` with the message, or
   `git commit -m ...`); never push.

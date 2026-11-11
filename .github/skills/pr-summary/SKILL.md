---
name: pr-summary
description: Writes a pull request title and description from the current branch's changes, mapped to the feature contract's requirements. Use when asked to summarise changes, prepare a PR, or write a PR or commit message.
---

# PR summary

1. Collect facts, do not guess: `git log --oneline <base>..HEAD`, `git diff --stat <base>...HEAD`
   and the diff of the files that matter (`<base>` is usually `main`, or `demo/csv-import-base`
   for the method comparison).
2. If a feature contract exists in `samples/book-app-project/docs/features/`, map each
   requirement to implementation and test.
3. Run the `run-tests` skill and include the result.
4. Output:

```markdown
## <Imperative title, max 60 characters>

### Feature
### Requirement coverage
| Requirement | Implementation | Test | Result |
|---|---|---|---|
### Verification
- Existing tests:
- New tests:
- Manual CLI verification:
### Human interventions
| Point | Reason | Decision |
|---|---|---|
### Residual risks
-
```

5. Never push and never create the PR yourself unless the user explicitly asks.

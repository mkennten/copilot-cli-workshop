---
name: run-tests
description: Runs the Book App test suite and the standard post-change checks (pytest, git diff --check, data.json unchanged) and summarises the result. Use when asked to run tests, verify a change, check acceptance criteria, or after any code change made by an agent.
---

# Run tests and post-change checks

Run from `samples/book-app-project` (use `python3` if `python` is not available):

1. `python -m pytest tests -q`
2. `git diff --check`
3. `git status --short` - confirm `data.json` is **not** listed as modified
4. `git diff --stat` - list the changed files

Report in this format:

```text
Tests:        <passed> passed, <failed> failed
diff --check: clean | <issues>
data.json:    unchanged | MODIFIED
Changed:      <files>
Failures:
- <test>: <assertion> -> likely owner: <domain-engineer | cli-engineer | test-engineer>
```

Do not change code to make tests pass unless explicitly asked. Do not hide failures.

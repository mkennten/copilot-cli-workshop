---
applyTo: "samples/book-app-project/**"
---

# Book App development rules

- Use Python standard-library functionality only.
- Preserve the existing JSON data format.
- Do not modify data.json during tests.
- Every behavior change must include pytest coverage.
- Keep domain logic in books.py.
- Keep command-line orchestration in book_app.py.
- Use type hints for new public functions.
- Prefer small, focused changes over broad refactoring.
- Before implementation, identify affected files and acceptance criteria.
- After implementation, run the full test suite and inspect the Git diff.
- Never run git push as part of an agent task.

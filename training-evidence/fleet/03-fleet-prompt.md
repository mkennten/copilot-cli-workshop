# Fleet prompt (step 5)

```text
/fleet Implement the approved Reading Statistics plan using the
contract in @docs/features/reading-statistics.md.

Create four independent work tracks:

TRACK 1 — DOMAIN
Use @domain-engineer.
Edit only books.py.
Implement get_reading_stats() exactly as specified.

TRACK 2 — CLI
Use @cli-engineer.
Edit only book_app.py.
Add the stats command and output exactly as specified.
Use the documented domain contract; do not duplicate the calculation.

TRACK 3 — TESTS
Use @test-engineer.
Create only tests/test_stats.py.
Cover empty, mixed, and all-read collections.
Do not modify production files or data.json.

TRACK 4 — DOCUMENTATION
Use @documentation-writer.
Edit only README.md.
Document the command, behavior, and representative output.

Hard boundaries:
- No two tracks may edit the same file.
- Do not edit data.json.
- Do not add external packages.
- Do not run git push.
- If a task requires a file owned by another track, report the
  dependency instead of editing that file.

After all tracks complete, the orchestrator must:
1. list all changed files;
2. run python -m pytest tests -q;
3. run python book_app.py stats;
4. inspect git diff --check;
5. verify every acceptance criterion;
6. report failures, assumptions, and residual risks.
```

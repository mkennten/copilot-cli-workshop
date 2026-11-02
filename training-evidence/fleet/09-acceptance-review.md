# Acceptance review – Reading Statistics

| # | Criterion | Evidence | Result |
|---|---|---|---|
| 1 | `BookCollection.get_reading_stats()` exists | books.py | |
| 2 | Result has exactly: total, read, unread, percent_read | test_stats_has_exactly_the_contract_keys | |
| 3 | Empty collection → percent_read 0.0 | test_stats_empty_collection | |
| 4 | percent_read rounded to one decimal | test_stats_percent_rounded_to_one_decimal | |
| 5 | `stats` does not change data.json | test_stats_does_not_modify_data_file + `git status --short` | |
| 6 | Existing commands unchanged | existing tests + `python book_app.py help` | |
| 7 | Tests: empty, mixed, all-read | tests/test_stats.py | |
| 8 | README documents the command | README.md | |
| 9 | Only books.py, book_app.py, tests/test_stats.py, README.md changed | `git diff --stat demo/fleet-start` | |
| 10 | No ownership violations, `git diff --check` clean | | |

Residual risks / assumptions:

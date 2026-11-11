---
name: feature-contract
description: Writes a feature contract for the Book App (user story, command, domain contract, rules, CLI output, required tests, out of scope, file ownership) before implementation starts. Use when asked to write a feature contract or feature file, to prepare a feature for /fleet or multi-agent work, or to decompose a feature into parallel tracks.
---

# Feature contract

A feature contract is the stable agreement that lets several agents work in parallel:
they code against the contract, not against each other's work in progress.

1. Read the request and the relevant code in `samples/book-app-project/`
   (`books.py`, `book_app.py`, `tests/`).
2. Copy `contract-template.md` from this skill's directory to
   `samples/book-app-project/docs/features/<feature-name>.md` and fill in every section.
3. Make the **domain contract** exact: class or module, function name, parameters,
   return type and keys, error behavior. No "TBD" - an open interface blocks parallel work.
4. Make the **CLI output** exact, so the CLI and test tracks produce and expect the same text.
5. Fill the **file ownership** table: every file has exactly one owner; integration and
   full validation run after all tracks.
6. Every rule must map to at least one required test.

Reference examples: `samples/book-app-project/docs/features/reading-statistics.md`
and `samples/book-app-project/docs/features/csv-import.md`.

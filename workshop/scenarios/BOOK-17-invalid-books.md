# BOOK-17 – Invalid books can be added to the collection

| Field | Value |
|---|---|
| Type | Bug |
| Priority | Medium |
| Component | Book App – `add` command |
| Reported by | Service desk (2 user reports this week) |
| Labels | data-quality, validation |

## Description

Users can add books that break reports downstream: books without a title or author,
books with the year `0`, and the same title twice. The current data already contains one
such record ("Mysterious Book", empty author, year 0).

## Steps to reproduce

1. `python book_app.py add`
2. Title: `Dune`, Author: *(empty)*, Year: *(empty)*
3. `python book_app.py list` → the book is stored with an empty author and year 0.

## Expected behaviour

Invalid input is rejected with a clear message; nothing is stored.

## Acceptance criteria

1. Title and author must not be empty (after trimming whitespace).
2. Year must be an integer between 1450 and the current year.
3. A book with the same title (case-insensitive) is rejected.
4. Validation lives in the domain layer (`books.py`, `add_book` raises `ValueError` with a clear
   message); the CLI prints `Error: <message>` and does not crash.
5. Existing data is not migrated or changed in this ticket.

## Definition of done

- Automated tests for every acceptance criterion; all tests pass; CI green.
- `data.json` unchanged by tests.
- Branch `fix/BOOK-17-input-validation`, pull request with requirement-to-test mapping.

# Feature: CSV Book Import

## User story

As a user, I want to import books from a CSV file so that I can add an existing collection without entering each book manually.

## Command

```text
python book_app.py import-csv <path>
python book_app.py import-csv <path> --dry-run
```

## CSV format

Required columns:

- title
- author
- year

Optional column:

- read

## Validation rules

- title must not be empty.
- author must not be empty.
- year must be an integer from 1 through 2100.
- read may be true, false, yes, no, 1, 0, or empty.
- An empty read value means false.
- Header names and read values are case-insensitive.
- Leading and trailing whitespace is ignored.

## Duplicate rule

A duplicate has the same title and author, ignoring case and surrounding whitespace.

Duplicates against the existing collection and duplicates within the same CSV file are skipped.

## Error behavior

- Invalid rows do not stop processing of later rows.
- Each invalid row is reported with its CSV line number and reason.
- A missing file or missing required header stops the import with a clear error.
- --dry-run performs parsing and validation but must not modify data.json.

## Summary output

The command reports:

- imported
- skipped as duplicate
- invalid

## Quality requirements

- Use only the Python standard library.
- Preserve all existing commands.
- Do not change the JSON schema.
- Add automated tests for valid, invalid, duplicate, missing-header, missing-file, and dry-run scenarios.
- Update README.md.

## Out of scope

- Excel files.
- Remote URLs.
- Interactive column mapping.
- Rollback across multiple files.

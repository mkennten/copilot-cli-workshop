---
name: book-data-check
description: Validates the Book App data file (data.json) and reports invalid records such as empty titles or authors, implausible years and duplicate titles. Use when asked to check data quality, find data risks, or before changing validation rules.
---

# Book data check

1. Run `validate_data.py` from this skill's directory and pass the data file, for example
   from the repository root:
   `python .github/skills/book-data-check/validate_data.py samples/book-app-project/data.json`
2. The script is read-only. It prints one line per problem and exits with code 1 if
   problems were found.
3. Report the problems as a table: record, field, problem, suggested validation rule.
4. Suggest rules for `BookCollection.add_book()` that would have prevented each problem.
   Do **not** edit data.json.

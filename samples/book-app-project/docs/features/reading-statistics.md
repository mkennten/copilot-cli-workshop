# Feature: Reading Statistics

## User story

As a reader, I want to see a summary of my reading progress so that I can understand how much of my collection I have completed.

## Command

```text
python book_app.py stats
```

## Domain contract

BookCollection provides:

```python
get_reading_stats() -> dict
```

The returned dictionary contains exactly these keys:

- total
- read
- unread
- percent_read

## Rules

- total is the number of books in the collection.
- read is the number of books where read is true.
- unread is total minus read.
- percent_read is read / total * 100.
- percent_read is rounded to one decimal place.
- percent_read is 0.0 for an empty collection.
- Calculating statistics must not modify data.json.
- Existing commands and behavior must remain compatible.

## CLI output

```text
Reading Statistics
------------------
Total books: <value>
Read: <value>
Unread: <value>
Completion: <value>%
```

## Required tests

- Empty collection.
- Mixed read and unread collection.
- All books read.

## Out of scope

- Graphs or charts.
- Per-author statistics.
- Changes to the JSON file format.
- New external packages.

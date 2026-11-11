"""Read-only data quality check for the Book App data file."""
import datetime
import json
import sys
from pathlib import Path

REQUIRED = {"title": str, "author": str, "year": int, "read": bool}


def check(records: list) -> list[str]:
    """Return a list of human-readable problems found in the records."""
    problems: list[str] = []
    seen: dict[str, int] = {}
    max_year = datetime.date.today().year
    for i, rec in enumerate(records, start=1):
        label = f"#{i} {rec.get('title', '<no title>')!r}"
        for field, ftype in REQUIRED.items():
            if field not in rec:
                problems.append(f"{label}: missing field '{field}'")
            elif not isinstance(rec[field], ftype):
                problems.append(f"{label}: field '{field}' should be {ftype.__name__}")
        title = str(rec.get("title", "")).strip()
        if not title:
            problems.append(f"{label}: empty title")
        if not str(rec.get("author", "")).strip():
            problems.append(f"{label}: empty author")
        year = rec.get("year")
        if isinstance(year, int) and not (1450 <= year <= max_year):
            problems.append(f"{label}: implausible year {year}")
        key = title.lower()
        if key in seen:
            problems.append(f"{label}: duplicate title (first seen at #{seen[key]})")
        else:
            seen[key] = i
    return problems


def main() -> int:
    """Entry point: validate the file given on the command line."""
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "data.json")
    try:
        records = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Cannot read {path}: {exc}")
        return 2
    problems = check(records)
    for p in problems:
        print(p)
    print(f"\n{len(records)} records checked, {len(problems)} problem(s) found.")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())

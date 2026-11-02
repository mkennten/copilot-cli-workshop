import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
import books
import book_app
from books import BookCollection


def make_collection(tmp_path, monkeypatch, records):
    """Create a BookCollection backed by a temporary data file."""
    data_file = tmp_path / "data.json"
    data_file.write_text(json.dumps(records))
    monkeypatch.setattr(books, "DATA_FILE", str(data_file))
    return BookCollection(), data_file


def book(title, read):
    return {"title": title, "author": "A", "year": 2000, "read": read}


def test_stats_empty_collection(tmp_path, monkeypatch):
    collection, _ = make_collection(tmp_path, monkeypatch, [])
    assert collection.get_reading_stats() == {"total": 0, "read": 0, "unread": 0, "percent_read": 0.0}


def test_stats_mixed_collection(tmp_path, monkeypatch):
    records = [book("a", True), book("b", True), book("c", True)] + [book(f"u{i}", False) for i in range(5)]
    collection, _ = make_collection(tmp_path, monkeypatch, records)
    assert collection.get_reading_stats() == {"total": 8, "read": 3, "unread": 5, "percent_read": 37.5}


def test_stats_percent_rounded_to_one_decimal(tmp_path, monkeypatch):
    collection, _ = make_collection(tmp_path, monkeypatch, [book("a", True), book("b", False), book("c", False)])
    assert collection.get_reading_stats()["percent_read"] == 33.3


def test_stats_all_books_read(tmp_path, monkeypatch):
    collection, _ = make_collection(tmp_path, monkeypatch, [book("a", True), book("b", True)])
    stats = collection.get_reading_stats()
    assert stats["unread"] == 0
    assert stats["percent_read"] == 100.0


def test_stats_has_exactly_the_contract_keys(tmp_path, monkeypatch):
    collection, _ = make_collection(tmp_path, monkeypatch, [book("a", False)])
    assert set(collection.get_reading_stats()) == {"total", "read", "unread", "percent_read"}


def test_stats_does_not_modify_data_file(tmp_path, monkeypatch):
    collection, data_file = make_collection(tmp_path, monkeypatch, [book("a", True), book("b", False)])
    before = data_file.read_bytes()
    collection.get_reading_stats()
    assert data_file.read_bytes() == before


def test_cli_stats_output(tmp_path, monkeypatch, capsys):
    collection, _ = make_collection(tmp_path, monkeypatch, [book("a", True), book("b", False)])
    monkeypatch.setattr(book_app, "collection", collection)
    monkeypatch.setattr(sys, "argv", ["book_app.py", "stats"])
    book_app.main()
    out = capsys.readouterr().out
    for line in ("Reading Statistics", "------------------", "Total books: 2", "Read: 1", "Unread: 1", "Completion: 50.0%"):
        assert line in out

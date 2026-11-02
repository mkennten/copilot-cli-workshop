import builtins
import datetime
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
import books
import book_app
from books import BookCollection


@pytest.fixture(autouse=True)
def use_temp_data_file(tmp_path, monkeypatch):
    """Use a temporary data file for each test."""
    temp_file = tmp_path / "data.json"
    temp_file.write_text("[]")
    monkeypatch.setattr(books, "DATA_FILE", str(temp_file))


def test_add_book_rejects_empty_title():
    with pytest.raises(ValueError, match="Title"):
        BookCollection().add_book("   ", "Some Author", 2000)


def test_add_book_rejects_empty_author():
    with pytest.raises(ValueError, match="Author"):
        BookCollection().add_book("Some Title", "", 2000)


def test_add_book_rejects_year_zero():
    with pytest.raises(ValueError, match="Year"):
        BookCollection().add_book("Some Title", "Some Author", 0)


def test_add_book_rejects_future_year():
    with pytest.raises(ValueError, match="Year"):
        BookCollection().add_book("Some Title", "Some Author", datetime.date.today().year + 1)


def test_add_book_rejects_duplicate_title_case_insensitive():
    collection = BookCollection()
    collection.add_book("Dune", "Frank Herbert", 1965)
    with pytest.raises(ValueError, match="already exists"):
        collection.add_book("dune", "Frank Herbert", 1965)


def test_add_book_trims_whitespace():
    book = BookCollection().add_book("  Dune  ", " Frank Herbert ", 1965)
    assert (book.title, book.author) == ("Dune", "Frank Herbert")


def test_add_book_accepts_boundary_years():
    collection = BookCollection()
    collection.add_book("Old", "Gutenberg", 1450)
    collection.add_book("New", "Someone", datetime.date.today().year)
    assert len(collection.books) == 2


def test_cli_add_shows_error_for_non_numeric_year(monkeypatch, capsys):
    monkeypatch.setattr(book_app, "collection", BookCollection())
    answers = iter(["Dune", "Frank Herbert", "nineteen sixty-five"])
    monkeypatch.setattr(builtins, "input", lambda _prompt="": next(answers))
    book_app.handle_add()
    assert "Error: Year must be a whole number" in capsys.readouterr().out
    assert book_app.collection.books == []

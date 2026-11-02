import datetime
import json
from dataclasses import dataclass, asdict
from typing import List, Optional

DATA_FILE = "data.json"
MIN_YEAR = 1450  # first printed books


@dataclass
class Book:
    title: str
    author: str
    year: int
    read: bool = False


class BookCollection:
    def __init__(self):
        self.books: List[Book] = []
        self.load_books()

    def load_books(self):
        """Load books from the JSON file if it exists."""
        try:
            with open(DATA_FILE, "r") as f:
                data = json.load(f)
                self.books = [Book(**b) for b in data]
        except FileNotFoundError:
            self.books = []
        except json.JSONDecodeError:
            print("Warning: data.json is corrupted. Starting with empty collection.")
            self.books = []

    def save_books(self):
        """Save the current book collection to JSON."""
        with open(DATA_FILE, "w") as f:
            json.dump([asdict(b) for b in self.books], f, indent=2)

    def add_book(self, title: str, author: str, year: int) -> Book:
        """Validate and add a new book, then persist the collection.

        Raises:
            ValueError: if title/author are empty, the year is out of range,
                or a book with the same title (case-insensitive) already exists.
        """
        title = (title or "").strip()
        author = (author or "").strip()
        if not title:
            raise ValueError("Title must not be empty.")
        if not author:
            raise ValueError("Author must not be empty.")
        max_year = datetime.date.today().year
        if not isinstance(year, int) or isinstance(year, bool) or not MIN_YEAR <= year <= max_year:
            raise ValueError(f"Year must be between {MIN_YEAR} and {max_year}.")
        if self.find_book_by_title(title):
            raise ValueError(f"A book titled '{title}' already exists.")
        book = Book(title=title, author=author, year=year)
        self.books.append(book)
        self.save_books()
        return book

    def list_books(self) -> List[Book]:
        return self.books

    def find_book_by_title(self, title: str) -> Optional[Book]:
        for book in self.books:
            if book.title.lower() == title.lower():
                return book
        return None

    def mark_as_read(self, title: str) -> bool:
        book = self.find_book_by_title(title)
        if book:
            book.read = True
            self.save_books()
            return True
        return False

    def remove_book(self, title: str) -> bool:
        """Remove a book by title."""
        book = self.find_book_by_title(title)
        if book:
            self.books.remove(book)
            self.save_books()
            return True
        return False

    def find_by_author(self, author: str) -> List[Book]:
        """Find all books by a given author."""
        return [b for b in self.books if b.author.lower() == author.lower()]

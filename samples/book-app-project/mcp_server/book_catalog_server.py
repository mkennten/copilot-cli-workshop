"""Local MCP server for the workshop: an offline 'book catalog'.

Shows how a team can expose internal data or tools to Copilot CLI through MCP
without any network access or credentials. Registered in samples/book-app-project/.mcp.json
and loaded when Copilot CLI is started in samples/book-app-project and the folder is trusted.

Requires:  the 'mcp' package, version 1.x (installed by ./scripts/setup.ps1)
           The code also builds with MCP Python SDK v2 (MCPServer), but Copilot CLI cannot
           connect to a v2 stdio server yet: it sends the 2025 'initialize' after the 2026
           'server/discover' probe and the v2 server rejects it with -32022
           (github/copilot-cli#4888). --check therefore fails on v2.
Run alone: python mcp_server/book_catalog_server.py           (waits on stdio - Ctrl+C to quit)
Self-test: python mcp_server/book_catalog_server.py --check   (builds the server and exits)
"""
import json
import sys
from pathlib import Path

try:  # MCP Python SDK v2: FastMCP was renamed to MCPServer
    from mcp.server import MCPServer
    SDK_API = "MCPServer (SDK v2)"
except ImportError:  # MCP Python SDK v1
    from mcp.server.fastmcp import FastMCP as MCPServer
    SDK_API = "FastMCP (SDK v1)"

CATALOG = json.loads((Path(__file__).parent / "catalog.json").read_text(encoding="utf-8"))

mcp = MCPServer("book-catalog")


@mcp.tool()
def search_catalog(query: str) -> list[dict]:
    """Search the catalog by title, author or genre (case-insensitive substring match)."""
    q = query.lower().strip()
    return [
        {k: b[k] for k in ("title", "author", "year", "genre")}
        for b in CATALOG
        if q in b["title"].lower() or q in b["author"].lower() or q in b["genre"].lower()
    ]


@mcp.tool()
def get_book_details(title: str) -> dict:
    """Return catalog details (author, year, genre, summary) for an exact title."""
    for book in CATALOG:
        if book["title"].lower() == title.lower().strip():
            return book
    return {"error": f"'{title}' is not in the catalog"}


@mcp.tool()
def suggest_next_read(genre: str, exclude_titles: list[str] | None = None) -> list[dict]:
    """Suggest up to three catalog books of a genre, skipping titles the reader already owns."""
    owned = {t.lower() for t in (exclude_titles or [])}
    matches = [
        {k: b[k] for k in ("title", "author", "year")}
        for b in CATALOG
        if b["genre"].lower() == genre.lower().strip() and b["title"].lower() not in owned
    ]
    return matches[:3]


if __name__ == "__main__":
    if "--check" in sys.argv:
        from importlib.metadata import version
        installed = version("mcp")
        if int(installed.split(".")[0]) >= 2:
            print(f"mcp {installed} is installed - Copilot CLI cannot connect to MCP SDK 2.x stdio servers yet "
                  "(error -32022, github/copilot-cli#4888). Run ./scripts/setup.ps1 to install mcp 1.x.")
            sys.exit(1)
        print(f"book-catalog MCP server OK - mcp {installed}, {SDK_API}, {len(CATALOG)} catalog entries")
        sys.exit(0)
    mcp.run()

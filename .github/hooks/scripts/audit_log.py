"""Append a one-line audit record for hook events to .copilot-logs/.

Used by sessionStart, postToolUse, subagentStart and subagentStop. During the
fleet demo, tail .copilot-logs/subagents.log in a second Windows Terminal pane
to watch subagents start and stop in parallel:

    Get-Content .copilot-logs/subagents.log -Wait
"""
import datetime
import json
import sys
from pathlib import Path

LOG_DIR = Path(".copilot-logs")


def main() -> None:
    event = sys.argv[1] if len(sys.argv) > 1 else "unknown"
    try:
        payload = json.loads(sys.stdin.read() or "{}")
    except Exception:
        payload = {}
    try:
        LOG_DIR.mkdir(exist_ok=True)
        now = datetime.datetime.now().strftime("%H:%M:%S")
        if event in ("subagentStart", "subagentStop"):
            name = payload.get("agentDisplayName") or payload.get("agentName") or "?"
            arrow = "START" if event == "subagentStart" else "STOP "
            line = f"{now}  {arrow}  {name}"
            with open(LOG_DIR / "subagents.log", "a", encoding="utf-8") as f:
                f.write(line + "\n")
        record = {
            "time": now,
            "event": event,
            "tool": payload.get("toolName"),
            "agent": payload.get("agentName"),
            "args": str(payload.get("toolArgs", ""))[:200] or None,
        }
        with open(LOG_DIR / "audit.jsonl", "a", encoding="utf-8") as f:
            f.write(json.dumps({k: v for k, v in record.items() if v}) + "\n")
    except Exception:
        pass  # logging must never break the session
    print("{}")


if __name__ == "__main__":
    main()

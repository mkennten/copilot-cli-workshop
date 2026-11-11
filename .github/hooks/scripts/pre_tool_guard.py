"""preToolUse guardrail for the workshop repository.

Second safety layer next to `copilot --deny-tool='shell(git push)'` and the permission mode.
Reads the hook payload from stdin and prints exactly ONE JSON decision:

- deny  any `git push` and destructive shell commands (rm -rf, Remove-Item -Recurse,
        git reset --hard, git clean -f)
- deny  changes to the hook configuration itself (agents must not disable guardrails)
- ask   before an agent edits or creates data.json (the app's live data)
- {}    for everything else (normal permission flow)

Only file *paths* and shell *commands* are inspected - never file content - so a test file
that merely mentions data.json does not trigger a prompt.

Fail-safe: on any internal error it prints {} and exits 0, because a crashing preToolUse
command hook would deny every tool call.
"""
import json
import re
import sys

SHELL_TOOLS = {"bash", "powershell", "shell"}
WRITE_TOOLS = {"edit", "create", "str_replace_editor", "apply_patch", "write"}
PATH_KEYS = ("path", "file_path", "filePath", "filename", "file")

DENY_SHELL = [
    (r"\bgit\s+push\b", "git push (agents never push - the human does)"),
    (r"\brm\s+-[a-z]*r[a-z]*f|\brm\s+-[a-z]*f[a-z]*r", "recursive force delete (rm -rf)"),
    (r"remove-item\b.*-recurse", "recursive delete (Remove-Item -Recurse)"),
    (r"\bgit\s+reset\s+--hard", "git reset --hard"),
    (r"\bgit\s+clean\s+-[a-z]*f", "git clean -f"),
]
SHELL_WRITES = r"(>|set-content|add-content|out-file|remove-item|\bdel\b|\brm\b|\bmv\b|move-item|sed\s+-i|copy-item|\bcp\b)"


def _args(payload: dict) -> dict:
    """Return the tool arguments as a dict (they may arrive as a JSON string)."""
    raw = payload.get("toolArgs", payload.get("tool_input", {}))
    if isinstance(raw, str):
        try:
            raw = json.loads(raw)
        except json.JSONDecodeError:
            return {"command": raw}
    return raw if isinstance(raw, dict) else {}


def _norm(value: object) -> str:
    return str(value or "").replace("\\", "/").lower()


def decide(payload: dict) -> dict:
    """Return the preToolUse decision for one tool call."""
    tool = str(payload.get("toolName", payload.get("tool_name", ""))).lower()
    args = _args(payload)

    if tool in SHELL_TOOLS:
        command = _norm(args.get("command"))
        for pattern, label in DENY_SHELL:
            if re.search(pattern, command):
                return {
                    "permissionDecision": "deny",
                    "permissionDecisionReason": f"Workshop guardrail (.github/hooks): {label} is not allowed for agents.",
                }
        if ".github/hooks" in command and re.search(SHELL_WRITES, command):
            return {
                "permissionDecision": "deny",
                "permissionDecisionReason": "Workshop guardrail: agents may not modify hook configuration.",
            }

    if tool in WRITE_TOOLS:
        paths = [_norm(args.get(k)) for k in PATH_KEYS if args.get(k)]
        if any(".github/hooks" in p for p in paths):
            return {
                "permissionDecision": "deny",
                "permissionDecisionReason": "Workshop guardrail: agents may not modify hook configuration.",
            }
        if any(p == "data.json" or p.endswith("/data.json") for p in paths):
            return {
                "permissionDecision": "ask",
                "permissionDecisionReason": "data.json is the app's live data. Confirm this edit explicitly.",
            }
    return {}


def main() -> None:
    try:
        payload = json.loads(sys.stdin.read() or "{}")
        result = decide(payload if isinstance(payload, dict) else {})
    except Exception:  # never crash: a crashing hook would deny every tool call
        result = {}
    print(json.dumps(result))


if __name__ == "__main__":
    main()

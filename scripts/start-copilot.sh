#!/usr/bin/env bash
# Starts GitHub Copilot CLI the way the workshop uses it. Unix equivalent of start-copilot.ps1.
#
#   - activates the workshop Python environment (.venv), so the tests Copilot runs use it
#   - changes to the Book App folder (samples/book-app-project)
#   - starts Copilot CLI with 'git push' denied for the whole session:
#         copilot --deny-tool='shell(git push)'
#   Extra arguments are passed on to copilot.
#
#   --github-actions additionally switches on the GitHub Actions toolset of the built-in GitHub MCP
#   server (workflow runs and logs). By default the built-in server only has its read-only default
#   tools, which do not include workflow runs:
#         copilot --deny-tool='shell(git push)' --add-github-mcp-toolset actions
#
# Examples:
#   ./scripts/start-copilot.sh
#   ./scripts/start-copilot.sh --path ~/labs/fleet-live/samples/book-app-project
#   ./scripts/start-copilot.sh --github-actions      # session 2: GitHub MCP can read workflow runs
set -o pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
path=''
extra=()
while [ $# -gt 0 ]; do
    case "$1" in
        --path) path="${2:?--path needs a folder}"; shift ;;
        --path=*) path="${1#*=}" ;;
        --github-actions) extra+=(--add-github-mcp-toolset actions) ;;
        -h|--help) sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) extra+=("$1") ;;
    esac
    shift
done
export PYTHONUTF8=1
[ -n "$path" ] || path="$root/samples/book-app-project"

if [ -t 1 ]; then c_cyan=$'\e[36m'; c_yellow=$'\e[33m'; c_reset=$'\e[0m'; else c_cyan=''; c_yellow=''; c_reset=''; fi

activate="$root/.venv/bin/activate"
if [ -f "$activate" ]; then
    # shellcheck disable=SC1090
    . "$activate"
else
    printf '%sWARNING: Workshop environment not found - run ./scripts/setup.sh first.%s\n' "$c_yellow" "$c_reset"
fi

cd "$path" || exit 1
printf '%sFolder:  %s%s\n' "$c_cyan" "$path" "$c_reset"
printf "%sCommand: copilot --deny-tool='shell(git push)' %s%s\n" "$c_cyan" "${extra[*]}" "$c_reset"
printf '%sInside Copilot: confirm folder trust, /login if asked, then /permissions assisted. Leave with /exit.%s\n\n' "$c_cyan" "$c_reset"

exec copilot '--deny-tool=shell(git push)' ${extra[@]+"${extra[@]}"}

#!/usr/bin/env bash
# Puts the repository back into a clean state - between demos, between exercises, or to start over.
# WARNING: discards all uncommitted changes in the working folder. Unix equivalent of reset-demo.ps1.
#
#   1. Discards uncommitted changes (also new, untracked files) - .venv and logs are kept
#   2. Switches to the branch (default: main)
#   3. Warns if that branch contains commits that are not in the published repository
#      (e.g. a demo change committed on main by mistake); --pristine removes them
#   4. Runs the sample app's tests
#   Work you committed on your own branches (e.g. feature/mark-command, fix/BOOK-17-...) is kept -
#   those branches stay available with: git branch
#
# Examples:
#   ./scripts/reset-demo.sh                                    # clean main
#   ./scripts/reset-demo.sh --branch exercise/reading-report   # clean start for exercise C
#   ./scripts/reset-demo.sh --pristine                         # main exactly as published
set -o pipefail

branch=main
pristine=0
while [ $# -gt 0 ]; do
    case "$1" in
        --branch) branch="${2:?--branch needs a name}"; shift ;;
        --branch=*) branch="${1#*=}" ;;
        --pristine) pristine=1 ;;
        -h|--help) sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
    shift
done

if [ -t 1 ]; then
    c_green=$'\e[32m'; c_yellow=$'\e[33m'; c_red=$'\e[31m'; c_cyan=$'\e[36m'; c_reset=$'\e[0m'
else
    c_green=''; c_yellow=''; c_red=''; c_cyan=''; c_reset=''
fi

root="$(cd "$(dirname "$0")/.." && pwd)"
export PYTHONUTF8=1
cd "$root" || exit 1
printf "%sDiscarding uncommitted changes and switching to '%s' ...%s\n" "$c_cyan" "$branch" "$c_reset"
git restore --staged --worktree . 2>/dev/null
git clean -fd -e .venv -e .copilot-logs >/dev/null
if ! git switch "$branch"; then
    printf "%sBranch '%s' not found. List branches with: git branch -a%s\n" "$c_red" "$branch" "$c_reset" >&2
    exit 1
fi
[ -d .copilot-logs ] && find .copilot-logs -maxdepth 1 -type f -delete

# Commits on this branch that are not in the published repository?
if git rev-parse --verify --quiet "origin/$branch" >/dev/null 2>&1; then
    extra="$(git rev-list --count "origin/$branch..$branch")"
    if [ "$extra" -gt 0 ] && [ "$pristine" -eq 1 ]; then
        git reset --hard "origin/$branch" >/dev/null
        printf "%sRemoved %s local commit(s) - '%s' is now exactly as published.%s\n" "$c_cyan" "$extra" "$branch" "$c_reset"
    elif [ "$extra" -gt 0 ]; then
        printf "%sWARNING: '%s' has %s local commit(s) that are not in the published repository.%s\n" "$c_yellow" "$branch" "$extra" "$c_reset"
        printf '%s  Keep them, or start from the published state with:  ./scripts/reset-demo.sh --pristine%s\n' "$c_yellow" "$c_reset"
    fi
fi

venv_python="$root/.venv/bin/python"
if [ -x "$venv_python" ]; then
    (cd "$root/samples/book-app-project" && "$venv_python" -m pytest tests -q -p no:cacheprovider)
else
    printf '%sWARNING: Workshop environment (.venv) not found - tests skipped. Run ./scripts/setup.sh first.%s\n' "$c_yellow" "$c_reset"
fi
git status --short
printf "%sClean state on '%s'. Start Copilot with ./scripts/start-copilot.sh%s\n" "$c_green" "$branch" "$c_reset"

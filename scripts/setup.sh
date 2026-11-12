#!/usr/bin/env bash
# Learner setup in one run (LEARNER-START.md, step 3). Unix equivalent of setup.ps1.
#
#   1. Tools     - checks Git, GitHub CLI, Python and Copilot CLI; installs missing ones with Homebrew
#                  (scripts/check-prereqs.sh --install)
#   2. Python    - creates the workshop Python environment in .venv
#   3. Packages  - installs pytest and the 'mcp' package (for the local book-catalog MCP server)
#   4. Check     - runs the sample app's tests, starts the book-catalog MCP server once (self-test) and
#                  sets a Git identity for this repository if none is configured (from your GitHub CLI sign-in)
#   Safe to run again at any time: existing parts are reused.
#
# Examples:
#   ./scripts/setup.sh
#   ./scripts/setup.sh --no-install     # only check tools, do not install anything
#   ./scripts/setup.sh --skip-mcp       # without the MCP package (e.g. if a proxy blocks it)
#   ./scripts/setup.sh --index-url https://pkgs.example.com/pypi/simple   # company package index
#
# --index-url: Python package index to install from, if your network blocks the public one (pypi.org) -
#   ask your IT for the URL. pip's own configuration (pip.conf, PIP_INDEX_URL) is used when not given.
set -eo pipefail

no_install=0
skip_mcp=0
index_url=''
skip_tool_check=0   # used by the trainer setup, which checks the tools itself
no_next_step=0      # used by the trainer setup
while [ $# -gt 0 ]; do
    case "$1" in
        --no-install) no_install=1 ;;
        --skip-mcp) skip_mcp=1 ;;
        --index-url) index_url="${2:?--index-url needs a URL}"; shift ;;
        --index-url=*) index_url="${1#*=}" ;;
        --skip-tool-check) skip_tool_check=1 ;;
        --no-next-step) no_next_step=1 ;;
        -h|--help) sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
    shift
done

export PYTHONUTF8=1
script_dir="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"
app="$root/samples/book-app-project"
venv_python="$root/.venv/bin/python"

if [ -t 1 ]; then
    c_green=$'\e[32m'; c_yellow=$'\e[33m'; c_red=$'\e[31m'; c_cyan=$'\e[36m'; c_gray=$'\e[90m'; c_reset=$'\e[0m'
else
    c_green=''; c_yellow=''; c_red=''; c_cyan=''; c_gray=''; c_reset=''
fi
say() { printf '%s%s%s\n' "$1" "$2" "$c_reset"; }   # color text
warn() { say "$c_yellow" "WARNING: $1"; }
die() { say "$c_red" "$1" >&2; exit 1; }

# Step labels: 4 parts on their own, 3 when the trainer setup has already checked the tools
if [ "$skip_tool_check" -eq 1 ]; then offset=0; else offset=1; fi
total=$((3 + offset))
step() { printf '\n'; say "$c_cyan" "[$(($1 + offset))/$total] $2"; }

# Runs a command in the background and shows a spinner with the elapsed time, then [OK] or [FAIL].
# On failure the last lines of the command's output are shown. Returns the command's success.
run_with_progress() { # label command...
    local label="$1"; shift
    local log pid rc=0 i=0 start elapsed
    # shellcheck disable=SC1003
    local frames='|/-\'
    log="$(mktemp)"
    start=$SECONDS
    "$@" >"$log" 2>&1 &
    pid=$!
    while [ -t 1 ] && kill -0 "$pid" 2>/dev/null; do
        elapsed=$((SECONDS - start))
        printf '\r      %s %s  %02d:%02d   ' "${frames:$((i % 4)):1}" "$label" $((elapsed / 60)) $((elapsed % 60))
        sleep 0.15
        i=$((i + 1))
    done
    wait "$pid" || rc=$?
    elapsed=$((SECONDS - start))
    elapsed="$(printf '%02d:%02d' $((elapsed / 60)) $((elapsed % 60)))"
    [ -t 1 ] && printf '\r\033[K'
    if [ "$rc" -eq 0 ]; then
        say "$c_green" "      [OK]   $label  ($elapsed)"
    else
        say "$c_red" "      [FAIL] $label  ($elapsed)"
        tail -n 15 "$log" | sed "s/^/             /" | while IFS= read -r line; do say "$c_gray" "$line"; done
    fi
    rm -f "$log"
    return "$rc"
}

if [ "$skip_tool_check" -eq 0 ]; then
    printf '\n'; say "$c_cyan" "[1/$total] Tools"
    check_args=(--no-next-step)
    [ "$no_install" -eq 1 ] || check_args+=(--install)
    "$script_dir/check-prereqs.sh" "${check_args[@]}" || exit 1
fi

step 1 'Python environment (.venv)'
if [ ! -x "$venv_python" ]; then
    run_with_progress 'Creating the Python environment' python3 -m venv "$root/.venv" ||
        die 'Could not create .venv - run ./scripts/check-prereqs.sh to see what is missing.'
else
    say "$c_green" '      [OK]   already exists - reusing it'
fi

step 2 'Installing packages  (the first run downloads them - this can take a minute or two)'
pip_args=(--disable-pip-version-check --no-input)
if [ -n "$index_url" ]; then
    pip_args+=(--index-url "$index_url")
    echo "      package index: $(printf '%s' "$index_url" | sed -E 's#://[^/@[:space:]]+@#://***@#')"
fi
run_with_progress 'Updating pip' "$venv_python" -m pip install --upgrade pip "${pip_args[@]}" ||
    warn 'pip could not be updated - continuing with the installed version.'
run_with_progress 'Installing pytest' "$venv_python" -m pip install 'pytest>=8.0' "${pip_args[@]}" ||
    die 'pip could not install pytest - check network / proxy settings (see the lines above).'
if [ "$skip_mcp" -eq 0 ]; then
    # mcp 1.x on purpose: Copilot CLI cannot connect to stdio servers built with MCP SDK 2.x yet
    # (github/copilot-cli#4888). An installed 2.x is replaced by the newest 1.x.
    run_with_progress 'Installing mcp 1.x (for the local MCP server)' "$venv_python" -m pip install 'mcp>=1.2,<2' "${pip_args[@]}" ||
        warn "The 'mcp' package could not be installed. Everything works except the local book-catalog MCP server."
fi

step 3 'Checking the sample app, the MCP server and your Git identity'
# Commits in the exercises need a Git identity. If none is configured, set one for THIS repository
# only, from the GitHub account GitHub CLI is signed in with (LEARNER-START.md, step 2).
git_name="$(git -C "$root" config user.name || true)"
git_email="$(git -C "$root" config user.email || true)"
if [ -n "$git_name" ] && [ -n "$git_email" ]; then
    say "$c_green" "      [OK]   Git identity: $git_name <$git_email>"
else
    gh_user=''
    if command -v gh >/dev/null 2>&1; then
        gh_user="$(gh api user --jq '[.login, (.id | tostring), (.name // "")] | @tsv' 2>/dev/null || true)"
    fi
    if [ -n "$gh_user" ]; then
        IFS=$'\t' read -r gh_login gh_id gh_name <<<"$gh_user"
        if [ -z "$git_name" ]; then git_name="${gh_name:-$gh_login}"; git -C "$root" config user.name "$git_name"; fi
        if [ -z "$git_email" ]; then git_email="$gh_id+$gh_login@users.noreply.github.com"; git -C "$root" config user.email "$git_email"; fi
        say "$c_green" "      [OK]   Git identity set for this repository: $git_name <$git_email>"
    else
        say "$c_yellow" '      [WARN] No Git identity - commits in the exercises will fail. Sign in to GitHub CLI'
        say "$c_yellow" '             (LEARNER-START.md, step 2) and run this script again.'
    fi
fi

tests_ok=1
(cd "$app" && "$venv_python" -m pytest tests -q -p no:cacheprovider) || tests_ok=0
if [ "$skip_mcp" -eq 0 ]; then
    # Builds the MCP server once with the installed SDK - catches problems before Copilot does
    if mcp_check="$(cd "$app" && "$venv_python" mcp_server/book_catalog_server.py --check 2>&1)"; then
        say "$c_green" "      [OK]   $mcp_check"
    else
        say "$c_red" '      [FAIL] book-catalog MCP server does not start:'
        printf '%s\n' "$mcp_check" | tail -n 5 | while IFS= read -r line; do say "$c_gray" "             $line"; done
        warn 'Everything else works; only the local MCP server demo (session 2) is affected.'
    fi
fi
[ "$tests_ok" -eq 1 ] || die 'Tests failed. Make sure you are on branch main (git switch main) and run setup again.'

printf '\n'; say "$c_green" 'Setup complete.'
if [ "$no_next_step" -eq 0 ]; then
    say "$c_green" 'Next step (LEARNER-START.md, step 4):  ./scripts/start-copilot.sh'
fi

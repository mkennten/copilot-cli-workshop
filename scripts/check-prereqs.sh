#!/usr/bin/env bash
# Checks - and with --install installs - the tools the GitHub Copilot CLI workshop needs.
# Unix equivalent of check-prereqs.ps1 (macOS / Linux, installs with Homebrew).
#
# Without --install the script is read-only: it reports OK / MISS per tool.
# With --install it installs every missing tool with Homebrew and checks again.
#
# You normally do not call it directly:
#   - learners:  ./scripts/setup.sh           (calls it with --install)
#   - trainers:  the trainer setup script     (calls it with --trainer --install)
# Run it on its own to diagnose a machine.
#
# Learners and trainers need Git, GitHub CLI, Python 3.10+ and Copilot CLI.
# --trainer additionally requires uv.
#
# Examples:
#   ./scripts/check-prereqs.sh                     # check only
#   ./scripts/check-prereqs.sh --install           # install what is missing
#   ./scripts/check-prereqs.sh --trainer --install
set -o pipefail

trainer=0
install=0
no_next_step=0   # used by setup.sh / trainer setup
for arg in "$@"; do
    case "$arg" in
        --trainer) trainer=1 ;;
        --install) install=1 ;;
        --no-next-step) no_next_step=1 ;;
        -h|--help) sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; exit 2 ;;
    esac
done

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
venv_python="$repo_root/.venv/bin/python"

if [ -t 1 ]; then
    c_green=$'\e[32m'; c_yellow=$'\e[33m'; c_cyan=$'\e[36m'; c_gray=$'\e[90m'; c_reset=$'\e[0m'
else
    c_green=''; c_yellow=''; c_cyan=''; c_gray=''; c_reset=''
fi

# name|command|brew package|required for learners|required for trainers
tools=(
    'Git|git|git|1|1'
    'Python 3.10+|python3|python@3.12|1|1'
    'Copilot CLI|copilot|--cask copilot-cli|1|1'
    'GitHub CLI|gh|gh|1|1'
    'uv|uv|uv|0|1'
)

write_line() { # status name detail color
    printf '%s[%-4s] %-20s %s%s\n' "$4" "$1" "$2" "$3" "$c_reset"
}

tool_version() { # command -> prints version, fails if missing
    local v
    if [ "$1" = python3 ]; then
        # The project's .venv Python counts; without it, a python3 that can create the .venv is needed.
        local py=python3 where=''
        if [ -x "$venv_python" ]; then py="$venv_python"; where=' (.venv)'; fi
        v="$("$py" -c 'import sys; print("%d.%d" % sys.version_info[:2]) if sys.version_info >= (3, 10) else sys.exit(1)' 2>/dev/null)" || return 1
        echo "Python $v$where"
        return 0
    fi
    command -v "$1" >/dev/null 2>&1 || return 1
    v="$("$1" --version 2>/dev/null | head -n 1)"
    echo "${v:-installed}"
}

missing=()
run_check() {
    missing=()
    local entry name cmd pkg learner trainer_req required found
    for entry in "${tools[@]}"; do
        IFS='|' read -r name cmd pkg learner trainer_req <<<"$entry"
        if [ "$trainer" -eq 1 ]; then required=$trainer_req; else required=$learner; fi
        if found="$(tool_version "$cmd")"; then
            write_line OK "$name" "$found" "$c_green"
        elif [ "$required" -eq 1 ]; then
            write_line MISS "$name" "brew install $pkg" "$c_yellow"
            missing+=("$entry")
        else
            write_line INFO "$name" 'optional, not installed' "$c_gray"
        fi
    done
}

if [ "$trainer" -eq 1 ]; then role=trainer; else role=learner; fi
printf '\nGitHub Copilot CLI workshop - prerequisite check (%s)\n\n' "$role"
run_check

if [ "$install" -eq 1 ] && [ "${#missing[@]}" -gt 0 ]; then
    if ! command -v brew >/dev/null 2>&1; then
        printf '\n%sHomebrew is not available on this machine (https://brew.sh). Install the tools marked MISS manually, then run this again.%s\n' "$c_yellow" "$c_reset"
        exit 1
    fi
    for entry in "${missing[@]}"; do
        IFS='|' read -r _ _ pkg _ _ <<<"$entry"
        printf '\n%sInstalling %s - Homebrew shows its own progress; this can take a few minutes ...%s\n' "$c_cyan" "$pkg" "$c_reset"
        # shellcheck disable=SC2086  # $pkg may contain "--cask <name>"
        brew install $pkg
    done
    hash -r
    printf '\n%sChecking again%s\n\n' "$c_cyan" "$c_reset"
    run_check
fi

# Workshop Python environment (created by setup.sh - nothing to install by hand)
env_ready=0
if [ -x "$venv_python" ] && "$venv_python" -c 'import pytest' >/dev/null 2>&1; then env_ready=1; fi
if [ "$no_next_step" -eq 0 ]; then
    if [ "$env_ready" -eq 1 ]; then write_line OK 'Workshop environment' '.venv with pytest' "$c_green"
    else write_line TODO 'Workshop environment' 'created by ./scripts/setup.sh' "$c_cyan"; fi
fi

echo
if [ "${#missing[@]}" -gt 0 ]; then
    names=''
    for entry in "${missing[@]}"; do names="${names:+$names, }${entry%%|*}"; done
    if [ "$install" -eq 1 ]; then
        printf '%sStill missing: %s%s\n' "$c_yellow" "$names" "$c_reset"
        printf '%sOpen a new terminal and run the script again (new installs are sometimes only found in a new shell).%s\n' "$c_yellow" "$c_reset"
    else
        printf '%sMissing: %s%s\n' "$c_yellow" "$names" "$c_reset"
        printf '%sInstall them with the commands shown, or let the setup script do it.%s\n' "$c_yellow" "$c_reset"
    fi
    exit 1
fi

printf '%sAll required tools are installed.%s\n' "$c_green" "$c_reset"
if [ "$no_next_step" -eq 0 ] && [ "$trainer" -eq 0 ]; then
    if [ "$env_ready" -eq 1 ]; then printf '%sNext step (LEARNER-START.md, step 4):  ./scripts/start-copilot.sh%s\n' "$c_green" "$c_reset"
    else printf '%sNext step (LEARNER-START.md, step 3):  ./scripts/setup.sh%s\n' "$c_green" "$c_reset"; fi
fi
exit 0

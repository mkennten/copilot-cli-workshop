#!/usr/bin/env bash
# Docker-only workshop setup: everything (Git, GitHub CLI, Python, Copilot CLI, .venv) lives in a
# container - on the host you only need Docker. The repository is mounted into the container, so
# changes made inside are visible on the host and the other way round.
#
#   setup   (default) builds the image, signs in to GitHub CLI if needed and runs ./scripts/setup.sh
#           inside the container
#   copilot [args]    starts Copilot CLI in the container (./scripts/start-copilot.sh, args passed on)
#   shell             opens a bash shell in the container (e.g. for ./scripts/reset-demo.sh)
#   clean             removes the image and the volumes (sign-ins, Copilot settings, container .venv)
#
# Sign-ins and settings are kept in the Docker volume copilot-workshop-home, the container's Python
# environment in copilot-workshop-venv (separate from a .venv on the host).
#
# Examples:
#   ./scripts/docker-setup.sh
#   ./scripts/docker-setup.sh copilot
#   ./scripts/docker-setup.sh copilot --github-actions
#   ./scripts/docker-setup.sh shell
set -eo pipefail

image=copilot-cli-workshop
home_volume=copilot-workshop-home
venv_volume=copilot-workshop-venv
root="$(cd "$(dirname "$0")/.." && pwd)"

if [ -t 1 ]; then c_cyan=$'\e[36m'; c_green=$'\e[32m'; c_red=$'\e[31m'; c_reset=$'\e[0m'; else c_cyan=''; c_green=''; c_red=''; c_reset=''; fi
say() { printf '%s%s%s\n' "$1" "$2" "$c_reset"; }

command -v docker >/dev/null 2>&1 || { say "$c_red" 'Docker is not installed: https://docs.docker.com/get-docker/' >&2; exit 1; }
docker info >/dev/null 2>&1 || { say "$c_red" 'Docker is not running - start Docker Desktop (or the Docker service) and try again.' >&2; exit 1; }

# Runs a command in the workshop container (interactive when a terminal is attached)
in_container() {
    local tty=(-i)
    if [ -t 0 ] && [ -t 1 ]; then tty=(-it); fi
    docker run --rm "${tty[@]}" \
        -v "$root:/workshop" \
        -v "$home_volume:/home/workshop" \
        -v "$venv_volume:/workshop/.venv" \
        "$image" "$@"
}

build_image() {
    say "$c_cyan" "Building the workshop image '$image' (the first build downloads the tools - a few minutes) ..."
    docker build -t "$image" \
        --build-arg "USER_UID=$(id -u)" --build-arg "USER_GID=$(id -g)" \
        - <"$root/docker/Dockerfile"
}

ensure_image() {
    docker image inspect "$image" >/dev/null 2>&1 || build_image
}

command="${1:-setup}"
[ $# -gt 0 ] && shift
case "$command" in
    setup)
        build_image
        if ! in_container gh auth status >/dev/null 2>&1; then
            if [ -t 0 ]; then
                say "$c_cyan" 'Sign in to GitHub CLI (LEARNER-START.md, step 2) - open the link shown and enter the code:'
                in_container gh auth login --hostname github.com --git-protocol https --web
            else
                echo 'Not signed in to GitHub CLI - run this script in a terminal to sign in.'
            fi
        fi
        in_container ./scripts/setup.sh --no-install --no-next-step
        say "$c_green" 'Next step (LEARNER-START.md, step 4):  ./scripts/docker-setup.sh copilot'
        ;;
    copilot)
        ensure_image
        in_container ./scripts/start-copilot.sh "$@"
        ;;
    shell)
        ensure_image
        in_container bash
        ;;
    clean)
        docker image rm "$image" 2>/dev/null || true
        docker volume rm "$home_volume" "$venv_volume" 2>/dev/null || true
        say "$c_green" 'Removed the workshop image and volumes.'
        ;;
    -h|--help)
        sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
        ;;
    *)
        echo "Unknown command: $command (setup, copilot, shell, clean)" >&2
        exit 2
        ;;
esac

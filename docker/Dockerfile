# Workshop toolbox: Git, GitHub CLI, Python 3.12 and Copilot CLI in one image.
# Built and used by scripts/docker-setup.sh - the repository is mounted at /workshop, not copied in.
FROM python:3.12-slim-bookworm

ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git less \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://gh.io/copilot-install | PREFIX=/usr/local bash \
    && copilot --version

# Same UID/GID as the host user, so files written to the mounted repository belong to them.
# /workshop/.venv exists here so the named volume mounted over it is owned by that user.
RUN (getent group "$USER_GID" >/dev/null || groupadd -g "$USER_GID" workshop) \
    && useradd -m -o -u "$USER_UID" -g "$USER_GID" -s /bin/bash workshop \
    && mkdir -p /workshop/.venv \
    && chown -R "$USER_UID:$USER_GID" /workshop \
    && git config --system --add safe.directory /workshop

USER workshop
WORKDIR /workshop
CMD ["bash"]

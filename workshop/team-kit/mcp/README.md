# MCP examples

- The **GitHub MCP server is built into Copilot CLI** – no configuration needed. By default it has
  read-only tools (repositories, issues, pull requests …). Further toolsets are switched on per
  session, e.g. workflow runs: `copilot --add-github-mcp-toolset actions`; all toolsets:
  `copilot --enable-all-github-mcp-tools`. Check what is active with `/mcp show github-mcp-server`.
- Copilot picks the tool itself: with the GitHub CLI installed it often uses `gh` instead of the MCP
  server. Name the server in the prompt when it matters ("Use the GitHub MCP server, not the gh CLI").
- `microsoft-learn` – official Microsoft documentation (remote, read-only).
- `azure-devops` – work items, repos, pipelines in Azure DevOps (local, via Node.js). Check the
  current setup and authentication in the server's README before use.
- `playwright` – browser automation for UI checks.

Before committing an MCP configuration:

1. Check your organisation's **MCP registry / allowlist policy** – only allowed servers run.
2. Replace `"tools": ["*"]` with an explicit list, **read-only tools first**.
3. Pin versions instead of `@latest` for reproducible team setups.
4. Never put tokens in the file; use environment variables or the server's sign-in flow.

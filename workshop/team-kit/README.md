# Team kit – take Copilot CLI customizations into your own repositories

Stack-neutral starting points for teams that build enterprise applications in **.NET, Java,
TypeScript/JavaScript, Python and PowerShell** with different IDEs. Everything here is plain
files in the repository, so it works for every team member – whichever IDE they use – and
for Copilot CLI, the Copilot cloud agent and Copilot code review. Support for each feature
differs per IDE: check GitHub Docs → *Copilot customization cheat sheet*.

| File | Copy to | Purpose |
|---|---|---|
| `copilot-instructions.template.md` | `.github/copilot-instructions.md` | Repository-wide team rules (fill the placeholders) |
| `instructions/*.instructions.md` | `.github/instructions/` | Language / area rules, applied by path (`applyTo`) |
| `skills/run-tests` | `.github/skills/run-tests` | Detects the build tool and runs the right test command |
| `skills/triage-build-failure` | `.github/skills/triage-build-failure` | "The build is red" procedure |
| `skills/commit-message` | `.github/skills/commit-message` | Conventional Commit message from staged changes |
| `skills/release-notes` | `.github/skills/release-notes` | Release notes from merged changes |
| `agents/code-reviewer.agent.md` | `.github/agents/` | Read-only reviewer for any stack |
| `agents/security-reviewer.agent.md` | `.github/agents/` | Read-only security review |
| `mcp/mcp.example.json` | `.github/mcp.json` | Example MCP servers (docs, Azure DevOps, browser tests) |
| `../../.github/hooks/` (this repo) | `.github/hooks/` | Guardrails + audit log (needs Python on PATH) |

## Adoption path (one pilot repository)

1. **Week 1** – `copilot-instructions.md` + one `*.instructions.md` for your main language + `run-tests` skill.
2. **Week 2** – `code-reviewer` agent; hooks for guardrails.
3. **Week 3** – one MCP server with **read-only** tools (docs, work items).
4. **Week 4** – review together: what did Copilot get wrong, which rule or skill would have prevented it?

Treat these files like code: review them in pull requests, keep them short, and remove rules
nobody needs. Instructions guide the model – they do not guarantee compliance. Enforce what
must never happen with hooks, permissions and branch protection.

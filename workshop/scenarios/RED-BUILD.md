# Scenario – "The build is red"

> **Teams message from Alex (09:12):**
> Morning! CI on `demo/broken-build` has been red since my refactoring commits yesterday.
> I only cleaned up some code, nothing functional. Could you have a look before the release
> branch is cut at noon? Thanks!

## Your job

1. Reproduce the failure locally.
2. Find the commit that introduced it and explain *why* it fails.
3. Propose the smallest correct fix and a regression test – or decide that the test is wrong.
4. Write a short reply to Alex: cause, fix, and how to avoid it next time.

## Starting point

```powershell
Set-Location C:\Labs\copilot-cli-workshop
git switch demo/broken-build
Set-Location samples\book-app-project
copilot --deny-tool='shell(git push)'
```

If the repository is published on GitHub, the failing workflow run is also visible in the
Actions tab – and Copilot CLI can read it through the built-in GitHub MCP server.

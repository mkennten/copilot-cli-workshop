---
name: release-notes
description: Drafts release notes for a range of commits or merged pull requests, grouped for users and for operations. Use when asked for release notes, a changelog entry or a summary of what changed since a tag or date.
---

# Release notes

1. Determine the range: `git describe --tags --abbrev=0` for the last tag, or the range the user gives.
2. Collect `git log --oneline --no-merges <range>`; with the GitHub MCP server, also read the merged
   pull request titles and labels in that range.
3. Group into: **New**, **Improved**, **Fixed**, **Operations** (config, migrations, pipeline,
   dependencies), **Breaking changes**. Drop pure refactoring and test-only changes unless asked.
4. Write one line per item in user language, with the ticket or PR reference.
5. List anything that needs an action from operators (new settings, migrations, rollback notes).

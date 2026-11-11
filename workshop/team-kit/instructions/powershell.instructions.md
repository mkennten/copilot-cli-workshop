---
applyTo: "**/*.ps1,**/*.psm1"
---

# PowerShell rules

- Target PowerShell 7+; start scripts with `[CmdletBinding()]` and a `param()` block.
- `Set-StrictMode -Version Latest` and `$ErrorActionPreference = 'Stop'` in scripts.
- Support `-WhatIf` / `-Confirm` (`SupportsShouldProcess`) for anything that changes systems.
- No hard-coded credentials, tenants or server names – parameters or a secret store.
- Use approved verbs; comment-based help for every script.

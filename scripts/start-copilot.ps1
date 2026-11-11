<#
.SYNOPSIS
  Starts GitHub Copilot CLI the way the workshop uses it.

.DESCRIPTION
  - activates the workshop Python environment (.venv), so the tests Copilot runs use it
  - sets PYTHONUTF8=1, so the sample app's output works when Copilot runs it (Windows)
  - changes to the Book App folder (samples/book-app-project)
  - starts Copilot CLI with 'git push' denied for the whole session:
        copilot --deny-tool='shell(git push)'
  Extra arguments are passed on to copilot.

  -GitHubActions additionally switches on the GitHub Actions toolset of the built-in GitHub MCP
  server (workflow runs and logs). By default the built-in server only has its read-only default
  tools, which do not include workflow runs:
        copilot --deny-tool='shell(git push)' --add-github-mcp-toolset actions

.EXAMPLE
  ./scripts/start-copilot.ps1
  ./scripts/start-copilot.ps1 -Path C:\Labs\fleet-live\samples\book-app-project
  ./scripts/start-copilot.ps1 -GitHubActions      # session 2: GitHub MCP can read workflow runs
#>
[CmdletBinding()]
param(
    [string]$Path,
    [switch]$GitHubActions,
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$CopilotArgs
)
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$env:PYTHONUTF8 = '1'   # UTF-8 output from Python on Windows (the app prints a check mark)
if (-not $Path) { $Path = Join-Path $root 'samples\book-app-project' }

$activate = Join-Path $root '.venv\Scripts\Activate.ps1'
if (Test-Path $activate) { . $activate }
else { Write-Warning 'Workshop environment not found - run ./scripts/setup.ps1 first.' }

Set-Location $Path
Write-Host "Folder:  $Path" -ForegroundColor Cyan
$extra = @()
if ($GitHubActions) { $extra += @('--add-github-mcp-toolset', 'actions') }
$extra += @($CopilotArgs | Where-Object { $_ })
Write-Host "Command: copilot --deny-tool='shell(git push)' $($extra -join ' ')" -ForegroundColor Cyan
Write-Host "Inside Copilot: confirm folder trust, /login if asked, then /permissions assisted. Leave with /exit.`n" -ForegroundColor Cyan

$arguments = @('--deny-tool=shell(git push)') + $extra
& copilot @arguments

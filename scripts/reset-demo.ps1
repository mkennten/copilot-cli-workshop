<#
.SYNOPSIS
  Puts the repository back into a clean state - between demos, between exercises, or to start over.
  WARNING: discards all uncommitted changes in the working folder.

.DESCRIPTION
  1. Discards uncommitted changes (also new, untracked files) - .venv and logs are kept
  2. Switches to the branch (default: main)
  3. Warns if that branch contains commits that are not in the published repository
     (e.g. a demo change committed on main by mistake); -Pristine removes them
  4. Runs the sample app's tests
  Work you committed on your own branches (e.g. feature/mark-command, fix/BOOK-17-...) is kept -
  those branches stay available with: git branch

.EXAMPLE
  ./scripts/reset-demo.ps1                                  # clean main
  ./scripts/reset-demo.ps1 -Branch exercise/reading-report  # clean start for exercise C
  ./scripts/reset-demo.ps1 -Pristine                        # main exactly as published
#>
[CmdletBinding()]
param(
    [string]$Branch = 'main',
    [switch]$Pristine
)
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$env:PYTHONUTF8 = '1'   # UTF-8 output from Python on Windows (the app prints a check mark)
Set-Location $root
Write-Host "Discarding uncommitted changes and switching to '$Branch' ..." -ForegroundColor Cyan
git restore --staged --worktree . 2>$null
git clean -fd -e .venv -e .copilot-logs | Out-Null
git switch $Branch
if ($LASTEXITCODE -ne 0) { Write-Error "Branch '$Branch' not found. List branches with: git branch -a"; exit 1 }
if (Test-Path .copilot-logs) { Get-ChildItem .copilot-logs -File | Remove-Item }

# Commits on this branch that are not in the published repository?
git rev-parse --verify --quiet "origin/$Branch" *> $null
if ($LASTEXITCODE -eq 0) {
    $extra = [int](git rev-list --count "origin/$Branch..$Branch")
    if ($extra -gt 0 -and $Pristine) {
        git reset --hard "origin/$Branch" | Out-Null
        Write-Host "Removed $extra local commit(s) - '$Branch' is now exactly as published." -ForegroundColor Cyan
    }
    elseif ($extra -gt 0) {
        Write-Warning "'$Branch' has $extra local commit(s) that are not in the published repository."
        Write-Host '  Keep them, or start from the published state with:  ./scripts/reset-demo.ps1 -Pristine' -ForegroundColor Yellow
    }
}

$venvPython = Join-Path $root '.venv\Scripts\python.exe'
$python = if (Test-Path $venvPython) { $venvPython } else { 'python' }
Push-Location (Join-Path $root 'samples\book-app-project')
& $python -m pytest tests -q -p no:cacheprovider
Pop-Location
git status --short
Write-Host "Clean state on '$Branch'. Start Copilot with ./scripts/start-copilot.ps1" -ForegroundColor Green

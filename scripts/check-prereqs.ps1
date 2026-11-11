<#
.SYNOPSIS
  Checks - and with -Install installs - the tools the GitHub Copilot CLI workshop needs.

.DESCRIPTION
  Without -Install the script is read-only: it reports OK / MISS per tool.
  With -Install it installs every missing tool with winget, refreshes PATH for this
  window and checks again.

  You normally do not call it directly:
    - learners:  ./scripts/setup.ps1                         (calls it with -Install)
    - trainers:  the trainer setup script                    (calls it with -Trainer -Install)
  Run it on its own to diagnose a machine.

  Learners and trainers need PowerShell 7, Git, GitHub CLI, Python and Copilot CLI.
  -Trainer additionally requires uv.

.EXAMPLE
  ./scripts/check-prereqs.ps1                 # check only
  ./scripts/check-prereqs.ps1 -Install        # install what is missing
  ./scripts/check-prereqs.ps1 -Trainer -Install
#>
[CmdletBinding()]
param(
    [switch]$Trainer,
    [switch]$Install,
    [switch]$NoNextStep   # used by setup.ps1 / trainer-setup.ps1
)

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')

# name, command, winget id, required for learners, required for trainers
$tools = @(
    @{ Name = 'Git';         Cmd = 'git';     Id = 'Git.Git';            Learner = $true;  Trainer = $true },
    @{ Name = 'Python 3.10+'; Cmd = 'python'; Id = 'Python.Python.3.12'; Learner = $true;  Trainer = $true },
    @{ Name = 'Copilot CLI'; Cmd = 'copilot'; Id = 'GitHub.Copilot';     Learner = $true;  Trainer = $true },
    @{ Name = 'GitHub CLI';  Cmd = 'gh';      Id = 'GitHub.cli';         Learner = $true;  Trainer = $true },
    @{ Name = 'uv';          Cmd = 'uv';      Id = 'astral-sh.uv';       Learner = $false; Trainer = $true }
)

function Write-Line([string]$status, [string]$name, [string]$detail, [string]$color) {
    Write-Host ("[{0,-4}] {1,-20} {2}" -f $status, $name, $detail) -ForegroundColor $color
}

function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

function Test-ToolPresent($tool) {
    if ($tool.Cmd -eq 'python') {
        # The Windows Store alias "python" does not count - it must report 3.10 or later.
        if (-not (Get-Command python -ErrorAction SilentlyContinue)) { return $null }
        $v = & python -c "import sys; print('%d.%d' % sys.version_info[:2])" 2>$null
        if ($LASTEXITCODE -eq 0 -and $v -and ([version]$v -ge [version]'3.10')) { return "Python $v" }
        return $null
    }
    if (-not (Get-Command $tool.Cmd -ErrorAction SilentlyContinue)) { return $null }
    $v = try { & $tool.Cmd --version 2>$null | Select-Object -First 1 } catch { '' }
    if (-not $v) { $v = 'installed' }
    return $v
}

function Invoke-Check {
    $result = @{ Missing = @(); PwshOk = $true }
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        Write-Line 'OK' 'PowerShell 7' $PSVersionTable.PSVersion 'Green'
    }
    else {
        Write-Line 'MISS' 'PowerShell 7' "this window runs PowerShell $($PSVersionTable.PSVersion)" 'Yellow'
        $result.PwshOk = $false
    }
    foreach ($tool in $tools) {
        $required = if ($Trainer) { $tool.Trainer } else { $tool.Learner }
        $found = Test-ToolPresent $tool
        if ($found) { Write-Line 'OK' $tool.Name $found 'Green' }
        elseif ($required) {
            Write-Line 'MISS' $tool.Name "winget install --id $($tool.Id) -e --silent --accept-source-agreements --accept-package-agreements" 'Yellow'
            $result.Missing += $tool
        }
        else { Write-Line 'INFO' $tool.Name 'optional, not installed' 'DarkGray' }
    }
    return $result
}

$role = if ($Trainer) { 'trainer' } else { 'learner' }
Write-Host "`nGitHub Copilot CLI workshop - prerequisite check ($role)`n"
$check = Invoke-Check

if ($Install -and ($check.Missing.Count -gt 0 -or -not $check.PwshOk)) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "`nwinget is not available on this machine. Install the tools marked MISS manually, then run this again." -ForegroundColor Yellow
        exit 1
    }
    $ids = @($check.Missing | ForEach-Object { $_.Id })
    if (-not $check.PwshOk) { $ids = @('Microsoft.PowerShell') + $ids }
    foreach ($id in $ids) {
        Write-Host "`nInstalling $id - winget shows its own progress; this can take a few minutes ..." -ForegroundColor Cyan
        winget install --id $id -e --silent --accept-source-agreements --accept-package-agreements
    }
    Update-SessionPath
    Write-Host "`nChecking again`n" -ForegroundColor Cyan
    $check = Invoke-Check
}

# Workshop Python environment (created by setup.ps1 - nothing to install by hand)
$venvPython = Join-Path $repoRoot '.venv\Scripts\python.exe'
$envReady = $false
if (Test-Path $venvPython) {
    & $venvPython -c "import pytest" 2>$null
    $envReady = ($LASTEXITCODE -eq 0)
}
if (-not $NoNextStep) {
    if ($envReady) { Write-Line 'OK' 'Workshop environment' '.venv with pytest' 'Green' }
    else { Write-Line 'TODO' 'Workshop environment' 'created by ./scripts/setup.ps1' 'Cyan' }
}

Write-Host ''
if (-not $check.PwshOk) {
    Write-Host 'This window is not PowerShell 7.' -ForegroundColor Yellow
    Write-Host 'Close Windows Terminal, open it again with the "PowerShell" profile (not "Windows PowerShell") and run the script again.' -ForegroundColor Yellow
    exit 1
}
if ($check.Missing.Count -gt 0) {
    $names = ($check.Missing | ForEach-Object { $_.Name }) -join ', '
    if ($Install) {
        Write-Host "Still missing: $names" -ForegroundColor Yellow
        Write-Host 'Close Windows Terminal completely, open it again and run the script again (new installs are sometimes only found in a new window).' -ForegroundColor Yellow
    }
    else {
        Write-Host "Missing: $names" -ForegroundColor Yellow
        Write-Host 'Install them with the commands shown, or let the setup script do it.' -ForegroundColor Yellow
    }
    exit 1
}

Write-Host 'All required tools are installed.' -ForegroundColor Green
if (-not $NoNextStep -and -not $Trainer) {
    if ($envReady) { Write-Host 'Next step (LEARNER-START.md, step 4):  ./scripts/start-copilot.ps1' -ForegroundColor Green }
    else { Write-Host 'Next step (LEARNER-START.md, step 3):  ./scripts/setup.ps1' -ForegroundColor Green }
}
exit 0

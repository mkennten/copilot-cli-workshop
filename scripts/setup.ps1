<#
.SYNOPSIS
  Learner setup in one run (LEARNER-START.md, step 3).

.DESCRIPTION
  1. Tools      - checks Git, GitHub CLI, Python, Copilot CLI and PowerShell 7; installs missing ones with winget
                  (scripts/check-prereqs.ps1 -Install)
  2. Python     - creates the workshop Python environment in .venv
  3. Packages   - installs pytest and the 'mcp' package (for the local book-catalog MCP server)
  4. Check      - runs the sample app's tests, starts the book-catalog MCP server once (self-test) and
                  sets a Git identity for this repository if none is configured (from your GitHub CLI sign-in)
  Safe to run again at any time: existing parts are reused.

.EXAMPLE
  ./scripts/setup.ps1
  ./scripts/setup.ps1 -NoInstall     # only check tools, do not install anything
  ./scripts/setup.ps1 -SkipMcp       # without the MCP package (e.g. if a proxy blocks it)
  ./scripts/setup.ps1 -IndexUrl https://pkgs.example.com/pypi/simple   # company package index

.PARAMETER IndexUrl
  Python package index to install from, if your network blocks the public one (pypi.org) - ask your
  IT for the URL. pip's own configuration (pip.ini, PIP_INDEX_URL) is used when this is not given.
#>
[CmdletBinding()]
param(
    [switch]$NoInstall,
    [switch]$SkipMcp,
    [string]$IndexUrl,        # company package index, if pypi.org is blocked
    [switch]$SkipToolCheck,   # used by trainer-setup.ps1, which checks the tools itself
    [switch]$NoNextStep       # used by trainer-setup.ps1
)
$ErrorActionPreference = 'Stop'
$env:PYTHONUTF8 = '1'   # UTF-8 output from Python on Windows (the app prints a check mark)
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$app = Join-Path $root 'samples\book-app-project'
$venvPython = Join-Path $root '.venv\Scripts\python.exe'
# Step labels: 4 parts on their own, 3 when trainer-setup.ps1 has already checked the tools
$offset = if ($SkipToolCheck) { 0 } else { 1 }
$total = 3 + $offset
function Step([int]$n, [string]$text) { Write-Host "`n[$($n + $offset)/$total] $text" -ForegroundColor Cyan }

function Invoke-WithProgress {
    <#
      Runs a program in the background and shows a spinner with the elapsed time,
      then [OK] or [FAIL]. On failure the last lines of the program's output are shown.
      Returns $true on success.
    #>
    param([string]$Label, [string]$FilePath, [string[]]$Arguments)
    $outLog = [IO.Path]::GetTempFileName()
    $errLog = [IO.Path]::GetTempFileName()
    $proc = Start-Process -FilePath $FilePath -ArgumentList $Arguments -NoNewWindow -PassThru `
        -RedirectStandardOutput $outLog -RedirectStandardError $errLog
    $null = $proc.Handle            # needed so ExitCode is available after the process ends
    $frames = @('|', '/', '-', '\')
    $timer = [Diagnostics.Stopwatch]::StartNew()
    $i = 0
    while (-not $proc.HasExited) {
        $line = "      {0} {1}  {2:mm\:ss}" -f $frames[$i % 4], $Label, $timer.Elapsed
        Write-Host -NoNewline ("`r" + $line.PadRight(78))
        Start-Sleep -Milliseconds 150
        $i++
    }
    $proc.WaitForExit()
    $elapsed = '{0:mm\:ss}' -f $timer.Elapsed
    $ok = ($proc.ExitCode -eq 0)
    if ($ok) {
        Write-Host ("`r" + ("      [OK]   $Label  ($elapsed)").PadRight(78)) -ForegroundColor Green
    }
    else {
        Write-Host ("`r" + ("      [FAIL] $Label  ($elapsed)").PadRight(78)) -ForegroundColor Red
        Get-Content $outLog, $errLog -ErrorAction SilentlyContinue | Select-Object -Last 15 |
            ForEach-Object { Write-Host "             $_" -ForegroundColor DarkGray }
    }
    Remove-Item $outLog, $errLog -ErrorAction SilentlyContinue
    return $ok
}

if (-not $SkipToolCheck) {
    Write-Host "`n[1/$total] Tools" -ForegroundColor Cyan
    $checkArgs = @{ NoNextStep = $true }
    if (-not $NoInstall) { $checkArgs.Install = $true }
    & (Join-Path $PSScriptRoot 'check-prereqs.ps1') @checkArgs
    if ($LASTEXITCODE -ne 0) { exit 1 }
}

Step 1 'Python environment (.venv)'
if (-not (Test-Path $venvPython)) {
    $python = (Get-Command python -ErrorAction Stop).Source
    $ok = Invoke-WithProgress 'Creating the Python environment' $python @('-m', 'venv', "`"$(Join-Path $root '.venv')`"")
    if (-not $ok) { throw 'Could not create .venv - run ./scripts/check-prereqs.ps1 to see what is missing.' }
}
else { Write-Host '      [OK]   already exists - reusing it' -ForegroundColor Green }

Step 2 'Installing packages  (the first run downloads them - this can take a minute or two)'
$pipArgs = @('--disable-pip-version-check', '--no-input')
if ($IndexUrl) {
    $pipArgs += @('--index-url', $IndexUrl)
    Write-Host "      package index: $($IndexUrl -replace '://[^/@\s]+@', '://***@')"
}
$ok = Invoke-WithProgress 'Updating pip' $venvPython (@('-m', 'pip', 'install', '--upgrade', 'pip') + $pipArgs)
if (-not $ok) { Write-Warning 'pip could not be updated - continuing with the installed version.' }
$ok = Invoke-WithProgress 'Installing pytest' $venvPython (@('-m', 'pip', 'install', '"pytest>=8.0"') + $pipArgs)
if (-not $ok) { throw 'pip could not install pytest - check network / proxy settings (see the lines above).' }
if (-not $SkipMcp) {
    # mcp 1.x on purpose: Copilot CLI cannot connect to stdio servers built with MCP SDK 2.x yet
    # (github/copilot-cli#4888). An installed 2.x is replaced by the newest 1.x.
    $ok = Invoke-WithProgress 'Installing mcp 1.x (for the local MCP server)' $venvPython (@('-m', 'pip', 'install', '"mcp>=1.2,<2"') + $pipArgs)
    if (-not $ok) { Write-Warning "The 'mcp' package could not be installed. Everything works except the local book-catalog MCP server." }
}

Step 3 'Checking the sample app, the MCP server and your Git identity'
# Commits in the exercises need a Git identity. If none is configured, set one for THIS repository
# only, from the GitHub account GitHub CLI is signed in with (LEARNER-START.md, step 2).
$gitName = git -C $root config user.name
$gitEmail = git -C $root config user.email
if ($gitName -and $gitEmail) {
    Write-Host "      [OK]   Git identity: $gitName <$gitEmail>" -ForegroundColor Green
} else {
    $ghUser = $null
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        $ghJson = gh api user 2>$null
        if ($LASTEXITCODE -eq 0 -and $ghJson) { $ghUser = ($ghJson | Out-String | ConvertFrom-Json) }
    }
    if ($ghUser) {
        if (-not $gitName) { $gitName = if ($ghUser.name) { $ghUser.name } else { $ghUser.login }; git -C $root config user.name $gitName }
        if (-not $gitEmail) { $gitEmail = "$($ghUser.id)+$($ghUser.login)@users.noreply.github.com"; git -C $root config user.email $gitEmail }
        Write-Host "      [OK]   Git identity set for this repository: $gitName <$gitEmail>" -ForegroundColor Green
    } else {
        Write-Host '      [WARN] No Git identity - commits in the exercises will fail. Sign in to GitHub CLI' -ForegroundColor Yellow
        Write-Host '             (LEARNER-START.md, step 2) and run this script again.' -ForegroundColor Yellow
    }
}
Push-Location $app
try {
    & $venvPython -m pytest tests -q -p no:cacheprovider
    $testsOk = ($LASTEXITCODE -eq 0)
    if (-not $SkipMcp) {
        # Builds the MCP server once with the installed SDK - catches problems before Copilot does
        $mcpCheck = & $venvPython 'mcp_server\book_catalog_server.py' --check 2>&1
        if ($LASTEXITCODE -eq 0) { Write-Host "      [OK]   $mcpCheck" -ForegroundColor Green }
        else {
            Write-Host '      [FAIL] book-catalog MCP server does not start:' -ForegroundColor Red
            $mcpCheck | Select-Object -Last 5 | ForEach-Object { Write-Host "             $_" -ForegroundColor DarkGray }
            Write-Warning 'Everything else works; only the local MCP server demo (session 2) is affected.'
        }
    }
}
finally { Pop-Location }
if (-not $testsOk) { throw 'Tests failed. Make sure you are on branch main (git switch main) and run setup again.' }

Write-Host "`nSetup complete." -ForegroundColor Green
if (-not $NoNextStep) {
    Write-Host 'Next step (LEARNER-START.md, step 4):  ./scripts/start-copilot.ps1' -ForegroundColor Green
}

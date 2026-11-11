# Learner: start here

Prepare your machine **before the workshop** – about 20 minutes. One script does most of the work;
the rest are short blocks to copy and paste into **Windows Terminal**.

When you are done, read the [agenda](AGENDA.md). On the workshop day you work with the
[Exercise Guide](workshop/EXERCISE-GUIDE.md).

| Step | What | How | Time |
|---|---|---|---|
| 1 | Install PowerShell 7, Git and GitHub CLI | copy-paste block | 5 min |
| 2 | Sign in to GitHub and get the workshop repository | copy-paste blocks | 3 min |
| 3 | Set up everything else | **`./scripts/setup.ps1`** | 5–10 min |
| 4 | Start Copilot for the first time | `./scripts/start-copilot.ps1` | 5 min |

You need: a Windows machine where you can install software, and a GitHub account with a
GitHub Copilot licence. Your trainer sends you the repository URL.

---

## Step 1 – Install PowerShell 7, Git and GitHub CLI

These three are needed before the repository exists; the setup script in step 3 installs everything
else. Open **Windows Terminal** and paste:

```powershell
winget install --id Microsoft.PowerShell -e --silent --accept-source-agreements --accept-package-agreements
winget install --id Git.Git -e --silent --accept-source-agreements --accept-package-agreements
winget install --id GitHub.cli -e --silent --accept-source-agreements --accept-package-agreements
```

All three installs run without questions. Only if Windows itself asks for permission to make changes
(administrator prompt), confirm it – no command can skip that.

Then **close Windows Terminal completely and open it again** with the **PowerShell** profile
(PowerShell 7 – not "Windows PowerShell"; click the arrow next to the tab → *PowerShell*).
Use this profile for all following steps.

## Step 2 – Sign in to GitHub and get the workshop repository

Sign in to GitHub CLI with the GitHub account that has your Copilot licence:

```powershell
gh auth login --hostname github.com --git-protocol https --web
```

GitHub CLI shows a one-time code: press **Enter**, paste the code in the browser window that opens
and confirm. If it asks *Authenticate Git with your GitHub credentials?*, answer **Y** – then
`git clone` uses the same sign-in. Check with:

```powershell
gh auth status
```

It must show `Logged in to github.com account <your-account>`.

Then get the repository – replace the URL with the one from your trainer:

```powershell
New-Item -ItemType Directory -Path C:\Labs -Force | Out-Null
git clone <repository-url-from-your-trainer> C:\Labs\copilot-cli-workshop
Set-Location C:\Labs\copilot-cli-workshop
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

If Git still asks you to sign in, a browser window opens – sign in with the same GitHub account.
The last line allows the workshop scripts to run for your user account.

## Step 3 – Set up everything else

```powershell
./scripts/setup.ps1
```

The script does the rest:

| Part | What it does |
|---|---|
| 1/4 Tools | Checks PowerShell 7, Git, GitHub CLI, Python and Copilot CLI and **installs missing ones** with winget |
| 2/4 Python environment | Creates a Python environment for the workshop in `.venv` |
| 3/4 Packages | Installs the test tool (pytest) and the MCP package |
| 4/4 Check | Runs the sample app's tests, starts the local MCP server once, and sets your Git identity for commits if none is configured (from your GitHub sign-in) |

Expected end: **5 passed**, **book-catalog MCP server OK**, **Setup complete.** and the next step.

If the script installed a tool and then says it cannot find it yet: close Windows Terminal, open it
again, `Set-Location C:\Labs\copilot-cli-workshop` and run `./scripts/setup.ps1` again.

## Step 4 – Start Copilot for the first time

```powershell
./scripts/start-copilot.ps1
```

The script switches to the sample app folder and starts Copilot CLI with `git push` blocked for the
session (`copilot --deny-tool='shell(git push)'` – you will learn why in session 1). You are now
**inside Copilot** – type or paste the following, one block at a time:

1. **Trust the folder** when asked.
2. Sign in if asked, and complete the sign-in in your browser:

```text
/login
```

3. Choose how Copilot asks for permissions (if your organisation does not allow it, use
   `/permissions manual`):

```text
/permissions assisted
```

4. Choose a model – the choice is saved and also used when you run Copilot from scripts later:

```text
/model
```

5. Ask a first question – you should get an answer about a book collection app:

```text
What does this application do? Answer in 3 bullet points.
```

6. Leave Copilot:

```text
/exit
```

**You are ready.** Nothing else to do before the workshop.

---

## On the workshop day

- The workshop is **online**. Join the meeting, and have **Windows Terminal** open next to it
  (PowerShell profile, in `C:\Labs\copilot-cli-workshop`).
- You work **on your own**, in your own copy. Questions go into the meeting chat at any time.
- **Follow the demos live – or wait.** In sessions 1–3 the trainer shows each demo on screen. You can
  type along in your copy, or just watch and do the same steps in the exercise that follows.
  Nothing later depends on it.
- Open the [Exercise Guide](workshop/EXERCISE-GUIDE.md) – every prompt and command there is in its
  own copy block.

---

## Commands you will use during the workshop

All commands run in Windows Terminal (PowerShell), not inside Copilot.

Start Copilot the workshop way:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\start-copilot.ps1
```

Discard your uncommitted changes and go back to a clean `main` (branches you committed to are kept):

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1
```

Clean start on another branch (example: exercise C):

```powershell
& C:\Labs\copilot-cli-workshop\scripts\reset-demo.ps1 -Branch exercise/reading-report
```

Check your machine again (read-only):

```powershell
& C:\Labs\copilot-cli-workshop\scripts\check-prereqs.ps1
```

## If something does not work

**"running scripts is disabled on this system"** – allow scripts for your user, then run the script again:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

**`UnicodeEncodeError ... '\u2713'` when Copilot runs the app** – start Copilot with
`start-copilot.ps1` (it sets `PYTHONUTF8=1`), or run this in the window first:

```powershell
$env:PYTHONUTF8 = '1'
```

**`Error: No supported model available`** (for example with `copilot -p`) – start Copilot, choose a
model, and try again:

```text
/model
```

If `/model` offers no models, ask your administrator to enable the Copilot CLI policy and the models
for your organisation.

**`winget` is not found** – install "App Installer" from the Microsoft Store, or ask your IT to
install PowerShell 7, Git, GitHub CLI, Python 3.12 and GitHub Copilot CLI.

**A tool is not found right after installing** – close **all** Windows Terminal windows and open a
new one.

**`python` opens the Microsoft Store** – Settings → Apps → Advanced app settings → App execution
aliases → turn off both `python` aliases; reopen Windows Terminal.

**`git clone` fails with "repository not found"** – the workshop repository is still private: send
your trainer your GitHub user name and wait for the access invitation (accept it in the e-mail or on
github.com), then run the `git clone` line again.

**`setup.ps1` fails at "Installing pytest" / "Installing mcp"** – your company network probably
blocks the public Python package index (errors such as `HandshakeFailure`, `Connect`, `403`). Ask
your IT for the company package index URL, then run the setup with it:

```powershell
& C:\Labs\copilot-cli-workshop\scripts\setup.ps1 -IndexUrl <package-index-url-from-your-IT>
```

Never put a password or token into that URL. If your network needs a web proxy instead, ask IT for
the value, set it in the same window and run the setup again:

```powershell
$env:HTTPS_PROXY = 'http://<proxy-host>:<port>'
```

**`setup.ps1` cannot download tools (winget)** – ask your IT to install PowerShell 7, Git,
GitHub CLI, Python 3.12 and GitHub Copilot CLI, or tell your trainer.

**Copilot says you have no access** – ask your administrator to assign a Copilot licence and enable
Copilot CLI for your organisation.

Still stuck? Tell your trainer before the workshop – or join the meeting 15 minutes early.

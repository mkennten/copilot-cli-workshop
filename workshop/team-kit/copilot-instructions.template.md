# Copilot instructions – <application name>

## Purpose
<One or two sentences: what the application does, who uses it, how critical it is.>

## Architecture
- `<path>` – <component, responsibility>
- `<path>` – <component, responsibility>
- External systems: <databases, queues, APIs> – never call production endpoints from tests.

## Build, run, test
- Build: `<dotnet build | mvn -q package | npm run build | ...>`
- Test: `<dotnet test | mvn test | npm test | python -m pytest>`
- Lint/format: `<command>` – run before proposing a commit.

## Conventions
- <Language version, framework, main libraries – and libraries we do NOT use.>
- <Error handling and logging conventions.>
- <Naming, folder structure, where tests live.>
- New behaviour needs automated tests in the same change.

## Way of working
- For changes touching more than one file: propose a plan with affected files and acceptance criteria first.
- Keep changes small and focused; do not reformat unrelated code.
- Finish with: files changed, how it was verified, open questions.

## Never
- Commit secrets, connection strings or personal data; use `<secret store>`.
- Change `<infrastructure / pipeline / migration>` files without saying so explicitly.
- Add dependencies without naming them and the reason.
- Run `git push`, deploy, or change shared environments.

---
name: run-tests
description: Detects the build tool of this repository and runs its automated tests, then summarises the result. Use when asked to run tests, verify a change, check acceptance criteria, or after any code change made by an agent.
---

# Run tests (any stack)

1. Detect the stack from the files in the repository root or the folder being changed:

   | Found | Test command |
   |---|---|
   | `*.sln` / `*.csproj` | `dotnet test` |
   | `pom.xml` | `mvn -q test` |
   | `build.gradle*` / `gradlew` | `./gradlew test` (Windows: `.\gradlew.bat test`) |
   | `package.json` with a `test` script | `npm test` (or `pnpm test` / `yarn test` if that lock file exists) |
   | `pyproject.toml` / `pytest.ini` / `tests/` with Python | `python -m pytest -q` |
   | `*.Tests.ps1` | `Invoke-Pester -Output Detailed` |

   If several match (monorepo), run only the one for the area that changed and say so.
2. Run `git diff --check` and `git status --short`.
3. Report:

```text
Stack/command: <command>
Tests:         <passed> passed, <failed> failed, <skipped> skipped
diff --check:  clean | <issues>
Changed files: <list>
Failures:
- <test>: <message> -> likely cause: <file/area>
```

Never change tests or production code to make tests pass unless explicitly asked. Never hide failures.

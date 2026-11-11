---
applyTo: "**/*.cs,**/*.csproj"
---

# .NET rules

- Target the framework in `Directory.Build.props` / the project file; do not change it.
- Enable and respect nullable reference types; no `!` suppression without a comment.
- Async all the way: no `.Result` / `.Wait()`; pass `CancellationToken` through public async APIs.
- Use dependency injection; no `new` for services that have an interface.
- Tests: xUnit (or the framework already used in the solution), one behaviour per test, `dotnet test` must pass.
- Logging via `ILogger<T>` with structured templates, never string concatenation.

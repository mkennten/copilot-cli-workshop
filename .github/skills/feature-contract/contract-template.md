# Feature: <Name>

## User story

As a <role>, I want <capability> so that <benefit>.

## Command

```text
python book_app.py <command> [arguments]
```

## Domain contract

<Module or class> provides:

```python
<exact signature> -> <return type>
```

<Exact return value / keys / error behavior.>

## Rules

- <Verifiable rule>
- Existing commands and behavior must remain compatible.
- data.json must not be modified by <reading operations / tests>.

## CLI output

```text
<exact output>
```

## Required tests

- <Scenario>

## File ownership (for /fleet)

| Track | Agent | Owned file(s) | Parallel? | Dependency |
|---|---|---|---|---|
| Domain | domain-engineer | | yes | contract |
| CLI | cli-engineer | | yes | contract |
| Tests | test-engineer | | yes | contract |
| Docs | documentation-writer | README.md | yes | contract |
| Integration | main agent | - | after all tracks | all tracks done |

## Out of scope

- <Explicit exclusions>

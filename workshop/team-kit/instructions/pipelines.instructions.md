---
applyTo: ".github/workflows/**,**/azure-pipelines*.yml,**/*.pipeline.yml"
---

# CI/CD pipeline rules

- Never weaken a pipeline to make it pass (no `continue-on-error`, skipped tests or removed steps).
- Least privilege: explicit `permissions:` in GitHub Actions; scoped service connections in Azure Pipelines.
- Pin third-party actions/tasks to a version (organisation policy may require a full commit SHA).
- Secrets only from the secret store / variable groups; never echo them.
- Explain every pipeline change in the pull request description.

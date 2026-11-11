---
applyTo: "**/*.ts,**/*.tsx,**/package.json"
---

# TypeScript rules

- `strict` mode stays on; no `any` without a comment explaining why.
- Use the package manager already in the repo (look for the lock file); never mix npm/yarn/pnpm.
- Prefer named exports; keep side effects out of module top level.
- Tests: the runner already configured (Jest/Vitest/Playwright); `npm test` must pass.
- Do not change `tsconfig*.json` or lint rules to make an error disappear.

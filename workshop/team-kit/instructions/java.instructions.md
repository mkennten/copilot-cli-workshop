---
applyTo: "**/*.java,**/pom.xml,**/build.gradle*"
---

# Java rules

- Use the Java version and build tool already configured (Maven or Gradle); do not add plugins silently.
- Prefer constructor injection; no field injection.
- Use `Optional` for absent return values, never for parameters or fields.
- Tests: JUnit 5 (+ the mocking library already used); `mvn test` / `gradle test` must pass.
- Log with SLF4J placeholders (`log.info("... {}", value)`), no `System.out`.

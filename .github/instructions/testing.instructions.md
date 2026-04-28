---
applyTo: "**/*Tests*.cs,**/*Test*.cs"
---

# Testing Conventions

## Strategy
- Integration tests first with `WebApplicationFactory` + Testcontainers.
- No in-memory database. Use the real database engine.

## Structure
- AAA pattern with blank lines between Arrange, Act, Assert.
- One assertion concept per test. Multiple properties of the same result are fine.

## Naming
- `MethodName_Scenario_ExpectedResult`
- Examples: `GetOrderAsync_OrderDoesNotExist_ReturnsNull`

## Fixtures
- Shared fixtures for expensive setup (database containers, HTTP servers).
- No mocking frameworks for things you own. Use real implementations.
- Test behavior, not implementation details.

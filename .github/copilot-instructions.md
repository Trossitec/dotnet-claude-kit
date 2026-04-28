# dotnet-claude-kit — .NET 10 / C# 14 Conventions

> This repository contains the dotnet-claude-kit: an opinionated knowledge base for .NET development. When generating or editing code in this repo, follow these conventions.

## Technology Stack

- **.NET 10** (`net10.0`) with **C# 14**
- **Minimal APIs** as the default for HTTP endpoints (not controllers)
- **EF Core** as the default ORM (no repository pattern wrapper)
- **xUnit v3** for testing with `WebApplicationFactory` + Testcontainers
- **Primary constructors** for DI, **records** for DTOs, **collection expressions** everywhere

## Universal Rules

1. **File-scoped namespaces always.** Never use block-scoped namespaces.
2. **`var` everywhere** when the type is obvious. Explicit types only when clarity demands it.
3. **Primary constructors for DI.** `public sealed class OrderService(IDbContext db, TimeProvider clock) { }`
4. **Records for DTOs and value objects.** Immutability and value equality are free.
5. **Collection expressions over constructors.** `List<int> ids = [1, 2, 3];`
6. **Pattern matching over if-else chains.** Switch expressions are more readable and exhaustiveness-checked.
7. **`TimeProvider` over `DateTime.Now`.** Always.
8. **`IHttpClientFactory` over `new HttpClient()`.** Always.
9. **Use latest stable NuGet versions.** Never rely on training data package versions.
10. **No Swashbuckle.** Use built-in .NET OpenAPI support.

## Architecture

- **No repository pattern over EF Core.** `DbContext` is already Unit of Work + Repository.
- **Feature folders over layer folders.** Group by feature, not by layer.
- **Dependency direction is inward.** Domain → Application → Infrastructure → Presentation.
- **Every endpoint group gets its own file implementing `IEndpointGroup`.** Never define endpoints inline in `Program.cs`.
- **Use `app.MapEndpoints()` for auto-discovery.** Program.cs never changes when adding new endpoints.
- **Shared kernel contains only contracts, never business logic.**

## Testing

- **Integration tests first.** Use `WebApplicationFactory` + Testcontainers.
- **No in-memory database for testing.** Spin up the real database engine.
- **Test naming: `MethodName_Scenario_ExpectedResult`.**
- **AAA pattern with clear separation.** Arrange, Act, Assert separated by blank lines.
- **No mocking frameworks for things you own.** Use real or test implementations.

## Security

- **No hardcoded secrets** in any code or examples.
- **Parameterized queries** required in all data-access code.
- **HTTPS-only** API examples.
- **Validate all inputs** at system boundaries.

## Performance

- **`sealed` on classes not designed for inheritance.** Enables JIT devirtualization.
- **`internal` by default, `public` only when needed.** Minimize API surface.
- **Async suffix on all async methods.** `GetOrderAsync`, not `GetOrder`.
- **Prefer `ValueTask` over `Task`** for hot paths where the result is often synchronous.

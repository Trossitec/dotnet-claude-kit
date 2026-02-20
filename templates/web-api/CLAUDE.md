# [Project Name] — Web API

> Copy this file into your project root and customize the sections below.

## Project Context

This is a .NET 10 REST API using Vertical Slice Architecture. Features are organized in self-contained vertical slices — each feature contains its endpoint, handler, request/response types, and validation in a single file or folder.

## Tech Stack

- **.NET 10** / C# 14
- **ASP.NET Core Minimal APIs** — endpoint routing with `MapGroup`
- **Entity Framework Core** — default ORM with PostgreSQL/SQL Server
- **MediatR** (or Wolverine or raw handlers) — command/query dispatch
- **FluentValidation** — request validation
- **Serilog** — structured logging
- **xUnit v3** + **Testcontainers** — testing

## Architecture

```
src/
  [ProjectName].Api/
    Features/
      [Feature]/
        [Operation].cs          # Command/Query + Handler + Response
    Common/
      Behaviors/                # MediatR pipeline behaviors
      Persistence/              # DbContext, configurations
      Extensions/               # Service registration helpers
    Program.cs
tests/
  [ProjectName].Api.Tests/
    Features/
      [Feature]/
        [Operation]Tests.cs
    Fixtures/
      ApiFixture.cs             # WebApplicationFactory + Testcontainers
```

### Feature File Convention

Each feature operation lives in a single file using a static class wrapper:

```csharp
public static class CreateOrder
{
    public record Command(...) : IRequest<Result<Response>>;
    public record Response(...);
    public class Validator : AbstractValidator<Command> { }
    internal class Handler : IRequestHandler<Command, Result<Response>> { }
}
```

## Coding Standards

- **C# 14 features** — Use primary constructors, collection expressions, `field` keyword, records, pattern matching
- **File-scoped namespaces** — Always
- **`var` for obvious types** — Use explicit types when the type isn't clear from context
- **Naming** — PascalCase for public members, `_camelCase` for private fields, suffix async methods with `Async`
- **No regions** — Ever
- **No comments for obvious code** — Only comment "why", never "what"

## Skills

Load these dotnet-claude-kit skills for context:

- `modern-csharp` — C# 14 language features and idioms
- `vertical-slice` — Feature folder structure and handler patterns
- `minimal-api` — Endpoint routing, TypedResults, OpenAPI metadata
- `ef-core` — DbContext patterns, query optimization, migrations
- `testing` — xUnit v3, WebApplicationFactory, Testcontainers
- `error-handling` — Result pattern, ProblemDetails
- `authentication` — JWT/OIDC if auth is needed
- `logging` — Serilog, OpenTelemetry
- `configuration` — Options pattern, secrets management
- `dependency-injection` — Service registration patterns

## MCP Tools

Use `cwm-roslyn-navigator` tools to minimize token consumption:

- **Before modifying a type** — Use `find_symbol` to locate it, `get_public_api` to understand its surface
- **Before adding a reference** — Use `find_references` to understand existing usage
- **To understand architecture** — Use `get_project_graph` to see project dependencies
- **To find implementations** — Use `find_implementations` instead of grep for interface/abstract class implementations
- **To check for errors** — Use `get_diagnostics` after changes

## Commands

```bash
# Build
dotnet build

# Run (development)
dotnet run --project src/[ProjectName].Api

# Run tests
dotnet test

# Add EF migration
dotnet ef migrations add [Name] --project src/[ProjectName].Api

# Apply migrations
dotnet ef database update --project src/[ProjectName].Api

# Format check
dotnet format --verify-no-changes
```

## Anti-patterns

Do NOT generate code that:

- Uses `DateTime.Now` — use `TimeProvider` injection instead
- Creates `new HttpClient()` — use `IHttpClientFactory`
- Uses `async void` — always return `Task`
- Blocks with `.Result` or `.Wait()` — await instead
- Uses `Results.Ok()` — use `TypedResults.Ok()` for OpenAPI
- Returns domain entities from endpoints — always map to response DTOs
- Creates repository abstractions over EF Core — use DbContext directly
- Uses in-memory database for tests — use Testcontainers
- Catches bare `Exception` — catch specific types, let the global handler catch the rest
- Uses string interpolation in log messages — use structured logging templates

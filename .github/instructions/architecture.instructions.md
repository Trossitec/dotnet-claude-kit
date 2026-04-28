---
applyTo: "**/*.cs,**/*.csproj"
---

# Architecture Conventions

## Data Access
- No repository pattern over EF Core. Inject `DbContext` directly.
- Good: `public sealed class OrderService(AppDbContext db)`
- Bad: Generic `IRepository<T>` wrappers.

## Endpoint Organization
- Every endpoint group implements `IEndpointGroup` in its own file.
- Use `app.MapEndpoints()` for auto-discovery.
- Never add `MapGroup` or manual endpoint wiring to `Program.cs`.

## Project Organization
- Feature folders over layer folders. Group related code by feature.
- Dependency direction: Domain → Application → Infrastructure → Presentation.
- Module boundaries enforced through project references.

## Shared Kernel
- Shared kernel contains only contracts, never business logic.
- Good: interfaces, DTOs, integration event definitions.
- Bad: domain logic, calculators, validators with rules.

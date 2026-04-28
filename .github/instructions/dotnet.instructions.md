---
applyTo: "**/*.cs,**/*.csproj"
---

# C# Coding Conventions

## File Organization
- File-scoped namespaces always. One type per file. Filename matches type name.
- Order members: constants, fields, constructors, properties, public methods, private methods.

## Type Declarations
- Primary constructors for DI injection: `public sealed class OrderService(IDbContext db, TimeProvider clock) { }`
- Records for DTOs and value objects: `public sealed record CreateOrderRequest(string ProductId, int Quantity);`
- `sealed` on classes not designed for inheritance.
- `internal` by default, `public` only when needed.

## Expressions
- Collection expressions: `List<int> ids = [1, 2, 3];`
- Pattern matching over if-else chains.
- Expression-bodied members for properties, indexers, accessors, lambdas.

## Naming
- `var` for obvious types, explicit types when clarity matters.
- Async suffix on all async methods: `GetOrderAsync`.
- PascalCase for public members, types, namespaces. camelCase for locals and parameters.
- No `_` prefix on private fields when using primary constructors.

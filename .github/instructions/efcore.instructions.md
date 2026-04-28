---
applyTo: "**/*DbContext*.cs,**/*Configuration*.cs,**/Migrations/**/*.cs"
---

# EF Core Conventions

## Configuration
- Use `IEntityTypeConfiguration<T>` to keep entity configs separate.
- Call `modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly)`.
- Use `.HasPrecision(18, 2)` for decimal properties.

## Queries
- Project into DTOs with `.Select()` instead of loading full entities.
- Use compiled queries for hot paths.
- Use `ExecuteUpdateAsync` / `ExecuteDeleteAsync` for bulk operations.

## Migrations
- Treat migrations like source code: review and test them.
- Never auto-apply migrations in production.
- Use meaningful migration names that describe the schema change.

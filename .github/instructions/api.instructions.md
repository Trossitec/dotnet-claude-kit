---
applyTo: "**/*Endpoint*.cs,**/*Controller*.cs"
---

# API Design Conventions

## Endpoints
- Group endpoints with `MapGroup`. Never scatter individual `MapGet`/`MapPost` in `Program.cs`.
- Use `TypedResults` for compile-time type safety and correct OpenAPI docs.
- Metadata over comments: `.WithName()`, `.WithTags()`, `.WithSummary()`.

## Responses
- Return `TypedResults.Ok(value)`, never `Results.Ok(value)`.
- Use `ProblemDetails` for errors.
- Version APIs with `Asp.Versioning` when needed.

## Validation
- Use FluentValidation or built-in data annotations.
- Return `ValidationProblem` for validation failures.

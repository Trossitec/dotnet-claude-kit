---
applyTo: "**/*.cs"
---

# Security Conventions

## Secrets
- No hardcoded secrets, API keys, or connection strings in code.
- Use `IConfiguration`, Key Vault, or environment variables.

## Data Access
- Parameterized queries always. Never string-concatenate SQL.
- Validate all inputs at system boundaries.

## APIs
- HTTPS-only. Redirect HTTP to HTTPS.
- Use `RequireAuthorization()` on sensitive endpoints.
- Rate-limit public endpoints.

## Dependencies
- Keep NuGet packages updated. Scan for known vulnerabilities.

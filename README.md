# dotnet-claude-kit

> The opinionated Claude Code companion for .NET developers.

Project-ready templates, intelligent agents, workflow automation, and a Roslyn MCP server for token-efficient codebase navigation.

---

## What This Is

dotnet-claude-kit is a curated set of instructions, skills, agents, and tools that make Claude Code dramatically more effective for .NET development. Instead of generic AI assistance, you get opinionated guidance grounded in modern .NET 10 / C# 14 best practices.

## Quick Start

### 1. Copy a template into your project

```bash
# Pick the template that matches your project type
cp templates/web-api/CLAUDE.md ./CLAUDE.md
```

### 2. Customize the CLAUDE.md

Edit the template to set your project name, tech stack, and conventions.

### 3. Start Claude Code

The CLAUDE.md references skills and agents automatically. The Roslyn MCP server starts via `.mcp.json` when Claude Code opens your project.

## Components

### Skills (17)

Opinionated, code-heavy reference files that teach Claude .NET best practices. Each skill is under 400 lines with concrete patterns and anti-patterns.

| Category | Skills |
|----------|--------|
| **Core Language** | [modern-csharp](skills/modern-csharp/SKILL.md) |
| **Architecture** | [vertical-slice](skills/vertical-slice/SKILL.md), [project-structure](skills/project-structure/SKILL.md) |
| **Web / API** | [minimal-api](skills/minimal-api/SKILL.md), [api-versioning](skills/api-versioning/SKILL.md), [authentication](skills/authentication/SKILL.md) |
| **Data** | [ef-core](skills/ef-core/SKILL.md) |
| **Resilience** | [error-handling](skills/error-handling/SKILL.md), [caching](skills/caching/SKILL.md), [messaging](skills/messaging/SKILL.md) |
| **Observability** | [logging](skills/logging/SKILL.md) |
| **Testing** | [testing](skills/testing/SKILL.md) |
| **DevOps** | [docker](skills/docker/SKILL.md), [ci-cd](skills/ci-cd/SKILL.md), [aspire](skills/aspire/SKILL.md) |
| **Cross-cutting** | [dependency-injection](skills/dependency-injection/SKILL.md), [configuration](skills/configuration/SKILL.md) |

### Agents (8)

Specialist agents that Claude can route queries to, each with defined skill dependencies and MCP tool usage.

| Agent | Domain | Key Skills |
|-------|--------|-----------|
| [dotnet-architect](agents/dotnet-architect.md) | Architecture, project structure | vertical-slice, project-structure |
| [api-designer](agents/api-designer.md) | Endpoints, OpenAPI, versioning | minimal-api, api-versioning, auth |
| [ef-core-specialist](agents/ef-core-specialist.md) | Database, queries, migrations | ef-core, configuration |
| [test-engineer](agents/test-engineer.md) | Testing strategy, infrastructure | testing |
| [security-auditor](agents/security-auditor.md) | Auth, OWASP, secrets | authentication, configuration |
| [performance-analyst](agents/performance-analyst.md) | Optimization, caching | modern-csharp, caching |
| [devops-engineer](agents/devops-engineer.md) | Docker, CI/CD, Aspire | docker, ci-cd, aspire |
| [code-reviewer](agents/code-reviewer.md) | Multi-dimensional review | All (contextual) |

### Templates (5)

Drop-in `CLAUDE.md` files for common project types:

| Template | Use Case |
|----------|----------|
| [web-api](templates/web-api/) | REST APIs with minimal APIs |
| [modular-monolith](templates/modular-monolith/) | Multi-module solutions with VSA per module |
| [blazor-app](templates/blazor-app/) | Blazor Server / WASM / Auto applications |
| [worker-service](templates/worker-service/) | Background workers and hosted services |
| [class-library](templates/class-library/) | NuGet packages and shared libraries |

### Knowledge

Living reference documents updated per .NET release:

| Document | Purpose |
|----------|---------|
| [dotnet-whats-new](knowledge/dotnet-whats-new.md) | .NET 10 / C# 14 features |
| [common-antipatterns](knowledge/common-antipatterns.md) | Patterns Claude should never generate |
| [package-recommendations](knowledge/package-recommendations.md) | Vetted NuGet packages |
| [breaking-changes](knowledge/breaking-changes.md) | .NET migration gotchas |
| [decisions/](knowledge/decisions/) | Architecture Decision Records |

### Roslyn MCP Server

Token-efficient codebase navigation via semantic analysis. Instead of reading full source files, Claude queries for specific information:

| Tool | What It Does | Token Savings |
|------|-------------|--------------|
| `find_symbol` | Locate type/method definitions | ~30-50 vs 500+ |
| `find_references` | Find all usages of a symbol | ~50-150 vs 2000+ |
| `find_implementations` | Find interface implementors | ~30-80 |
| `get_type_hierarchy` | Inheritance chain + interfaces | ~40-100 |
| `get_project_graph` | Solution dependency tree | ~50-200 |
| `get_public_api` | Public API without full file | ~100 vs 500+ |
| `get_diagnostics` | Compiler warnings/errors | ~50-300 |

See [mcp/CWM.RoslynNavigator/README.md](mcp/CWM.RoslynNavigator/README.md) for setup details.

### Hooks

Automated workflow integration:

- **Pre-commit** — `dotnet format --verify-no-changes` ensures consistent formatting
- **Post-scaffold** — `dotnet restore` after `.csproj` changes

## Architecture

```
dotnet-claude-kit/
├── CLAUDE.md                    # Instructions for developing THIS repo
├── AGENTS.md                    # Agent routing & orchestration
├── agents/                      # 8 specialist agents
├── skills/                      # 17 opinionated skills
├── templates/                   # 5 drop-in CLAUDE.md templates
├── knowledge/                   # Living reference documents + ADRs
├── mcp/CWM.RoslynNavigator/     # Roslyn MCP server
├── hooks/                       # Claude Code hooks
├── .mcp.json                    # MCP server registration
└── .github/workflows/           # CI validation
```

## Opinionated Defaults

| Decision | Default | Why |
|----------|---------|-----|
| Architecture | Vertical Slice | Feature cohesion over layer separation ([ADR-001](knowledge/decisions/001-vsa-default.md)) |
| Error handling | Result pattern | Exceptions are for exceptional cases ([ADR-002](knowledge/decisions/002-result-over-exceptions.md)) |
| ORM | EF Core | Best DX for most scenarios ([ADR-003](knowledge/decisions/003-ef-core-default-orm.md)) |
| Caching | HybridCache | Built-in stampede protection, L1+L2 ([ADR-004](knowledge/decisions/004-hybrid-cache-default.md)) |
| APIs | Minimal APIs | Lighter, composable, better with VSA |
| Testing | Integration-first | WebApplicationFactory + Testcontainers |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add skills, knowledge, templates, and MCP tools.

## License

[MIT](LICENSE)

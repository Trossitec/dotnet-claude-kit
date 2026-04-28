# dotnet-claude-kit — Agent Guide

> This file tells AI coding agents everything they need to know about THIS repository. For agent routing tables, see the bottom of this file.

## Project Overview

dotnet-claude-kit is an opinionated Claude Code plugin and knowledge layer that makes Claude an expert .NET developer. It is NOT a typical application — it is a curated collection of skills, agents, templates, rules, and hooks delivered as a Claude Code plugin, plus a .NET 10 Roslyn MCP server for token-efficient codebase navigation.

- **Repository**: https://github.com/trossitec/dotnet-claude-kit
- **Author**: Trossitec (https://trossitec.com)
- **License**: MIT
- **Plugin version**: 0.7.0
- **MCP server version**: 0.7.1

### What the repository contains

| Component | Count | Location | Description |
|-----------|-------|----------|-------------|
| Skills | 47 | `skills/<name>/SKILL.md` | Markdown reference files teaching Claude .NET best practices |
| Agents | 10 | `agents/<name>.md` | Specialist agent definitions with skill maps and boundaries |
| Commands | 16 | `commands/<name>.md` | Slash-command orchestrators that invoke skills and agents |
| Rules | 10 | `.claude/rules/<name>.md` | Always-loaded conventions for every interaction |
| Templates | 5 | `templates/<type>/` | Drop-in `CLAUDE.md` files for user projects |
| Hooks | 7 | `hooks/<name>.sh` + `hooks/hooks.json` | Automated quality guards triggered by Claude events |
| MCP Server | 1 | `mcp/CWM.RoslynNavigator/` | .NET 10 tool providing 15 read-only Roslyn semantic analysis tools |
| Knowledge | 9 | `knowledge/` + `knowledge/decisions/` | Living reference docs and Architecture Decision Records |

### Supported platforms

The kit targets multiple AI coding tools:

| Tool | Support | Install / Discovery |
|------|---------|---------------------|
| **Claude Code** (primary) | ✅ Full | `.claude-plugin/plugin.json` — `/plugin install dotnet-claude-kit` |
| **Cursor IDE** | ✅ Full | `.cursor/rules/dotnet-rules.md` |
| **Codex CLI** | ✅ Full | `.codex/AGENTS.md` |
| **GitHub Copilot** | ✅ Full | `.github/plugin.json` — `copilot plugin install trossitec/dotnet-claude-kit` |
| **GitHub Copilot (repo-level)** | ✅ Skills + Instructions | `.claude/skills/` + `.github/copilot-instructions.md` |
| **Kimi Code CLI** | ✅ Plugin + Skills | `plugin.json` — `kimi plugin install https://github.com/trossitec/dotnet-claude-kit` |
| **Kimi Code CLI (repo-level)** | ✅ Skills | `.claude/skills/` auto-discovered |
| **VS Code Copilot** | ✅ Full | `.github/plugin.json` + `.vscode/mcp.json` |

## Technology Stack

### Knowledge layer (majority of the repo)

- **Format**: Markdown with YAML frontmatter
- **Language**: English (all docs, comments, and identifiers)
- **No build step required** — skills, agents, commands, rules, and knowledge are consumed directly by the AI tool at runtime

### MCP server (`mcp/CWM.RoslynNavigator/`)

- **Runtime**: .NET 10 (`net10.0`)
- **Language**: C# 14
- **SDK**: `Microsoft.NET.Sdk`
- **Output**: `PackAsTool` global .NET tool (`cwm-roslyn-navigator`)
- **Key dependencies**:
  - `ModelContextProtocol` 0.2.0-preview.1
  - `Microsoft.CodeAnalysis.Workspaces.MSBuild` 5.0.0
  - `Microsoft.Build.Locator` 1.7.8
  - `Microsoft.Extensions.Hosting` 10.0.0
- **Test framework**: xUnit v3 (`xunit.v3` 1.0.0)

## Code Organization

```
dotnet-claude-kit/
├── AGENTS.md                    # This file — project context + agent routing
├── CLAUDE.md                    # Development conventions for THIS repo
├── README.md                    # User-facing documentation
├── CONTRIBUTING.md              # Contributor guide
├── CHANGELOG.md                 # Release history
├── .editorconfig                # C# / markdown / JSON formatting rules
├── .gitignore                   # Git ignore patterns
├── .mcp.json                    # MCP server registration manifest
│
├── agents/                      # 10 specialist agent definitions (*.md)
├── skills/                      # 47 skills, each in `<name>/SKILL.md`
├── commands/                    # 16 slash-command orchestrators (*.md)
├── .claude/rules/               # 10 always-loaded rules (*.md)
├── templates/                   # 5 drop-in CLAUDE.md templates for user projects
│   ├── web-api/
│   ├── modular-monolith/
│   ├── blazor-app/
│   ├── worker-service/
│   └── class-library/
├── knowledge/                   # Living reference docs (NOT skills)
│   ├── dotnet-whats-new.md
│   ├── common-antipatterns.md
│   ├── package-recommendations.md
│   ├── breaking-changes.md
│   ├── common-infrastructure.md
│   └── decisions/               # ADRs (Architecture Decision Records)
├── docs/                        # Shorthand and longform user guides
├── hooks/                       # 7 shell scripts + hooks.json manifest
├── mcp/                         # MCP server source
│   └── CWM.RoslynNavigator/
│       ├── CWM.RoslynNavigator.slnx
│       ├── src/
│       │   └── CWM.RoslynNavigator.csproj
│       └── tests/
│           └── CWM.RoslynNavigator.Tests.csproj
├── mcp-configs/                 # MCP configuration templates
├── .claude-plugin/              # Plugin marketplace manifests
│   ├── plugin.json
│   └── marketplace.json
├── .cursor/rules/               # Cursor IDE compatibility rules
└── .github/workflows/           # CI/CD pipelines
    ├── validate.yml
    └── publish-nuget.yml
```

## Build and Test Commands

### MCP server only (the only compiled artifact)

```bash
# Restore dependencies
dotnet restore mcp/CWM.RoslynNavigator/CWM.RoslynNavigator.slnx

# Build
dotnet build mcp/CWM.RoslynNavigator/CWM.RoslynNavigator.slnx

# Run tests
dotnet test mcp/CWM.RoslynNavigator/CWM.RoslynNavigator.slnx

# Format check (must pass in CI)
dotnet format mcp/CWM.RoslynNavigator/CWM.RoslynNavigator.slnx --verify-no-changes --no-restore
```

### Pack and publish (maintainers only)

```bash
# Pack the dotnet tool
dotnet pack mcp/CWM.RoslynNavigator/src/CWM.RoslynNavigator.csproj -c Release -o ./nupkg

# The NuGet publish workflow is triggered manually via GitHub Actions
# with a version input and optional dry-run flag.
```

### Validation scripts (CI runs these automatically)

The `validate.yml` workflow performs the following checks on every PR and push to `main`:

1. **Skill validation** — YAML frontmatter (`name`, `description`), max 400 lines, required sections (Core Principles, Patterns, Anti-patterns, Decision Guide)
2. **Command validation** — YAML frontmatter (`description`), max 200 lines, required sections (What, When, How)
3. **Rule validation** — YAML frontmatter (`alwaysApply: true`), max 100 lines
4. **Agent validation** — Required sections (Role Definition, Skill Dependencies, MCP Tool Usage, Boundaries), skill references resolve to real directories
5. **Cross-reference validation** — Commands and AGENTS.md reference only existing skills and agents
6. **Hook validation** — All scripts referenced in `hooks.json` exist and are syntactically valid
7. **Plugin manifest validation** — `plugin.json`, `marketplace.json`, `.mcp.json`, and `hooks.json` are valid JSON with required keys
8. **MCP build** — `dotnet build` of the RoslynNavigator solution
9. **MCP tests** — `dotnet test` with TRX logger
10. **Format check** — `dotnet format --verify-no-changes`

There is no local `package.json`, `Makefile`, or `justfile` — validation is handled by the GitHub Actions workflow above.

## Code Style Guidelines

### Markdown content (skills, agents, commands, rules, knowledge)

- **Line length budgets** (enforced in CI):
  - Skills: max 400 lines
  - Commands: max 200 lines
  - Rules: max 100 lines
  - All rules combined: ~600 lines total budget
- **YAML frontmatter is required** for skills, commands, and rules
- **Required sections** must be present (see CI validation above)
- **Every recommendation must have a "why"** — no bare rules without justification
- **Anti-patterns require BAD/GOOD code comparisons**
- **Code examples must use modern C# 14** — primary constructors, collection expressions, file-scoped namespaces, records, `field` keyword

### C# (MCP server only)

The `.editorconfig` enforces:

- File-scoped namespaces (`csharp_style_namespace_declarations = file_scoped:warning`)
- Primary constructors preferred
- Collection expressions preferred
- `var` everywhere (`true:suggestion` for built-in, apparent, and elsewhere)
- Expression-bodied members for properties, indexers, accessors, lambdas
- Pattern matching preferred
- Simple `using` statements preferred
- PascalCase for types and non-field members
- camelCase with `_` prefix for private fields
- System directives sorted first
- 4-space indentation for `.cs`, 2-space for `.csproj`/`.props`/`.targets`
- LF line endings, UTF-8, trim trailing whitespace

### Key architectural constraints

- **MCP tools are read-only** — no code generation, no file modifications
- **Responses are token-optimized** — return file paths, line numbers, and short snippets, never full file contents
- **No Swashbuckle** — use built-in .NET OpenAPI support in examples
- **No repository pattern over EF Core** — use `DbContext` directly in examples
- **`TimeProvider` over `DateTime.Now`** — always
- **`IHttpClientFactory` over `new HttpClient()`** — always
- **Use latest stable NuGet versions** — never rely on training data versions

## Testing Strategy

### MCP server tests

- Framework: xUnit v3
- Test project: `mcp/CWM.RoslynNavigator/tests/CWM.RoslynNavigator.Tests.csproj`
- Test data: `TestData/SampleSolution/` — a multi-project .NET solution loaded by Roslyn at runtime (excluded from compilation, copied to output)
- Tests cover all 15 MCP tools with real Roslyn workspace semantics
- CI uploads TRX results as artifacts on every run

### Knowledge content tests

There are no unit tests for markdown content. Quality is enforced by the `validate.yml` CI pipeline, which checks structure, frontmatter, line counts, and cross-references.

## Deployment and Release Process

### MCP server (NuGet)

The `publish-nuget.yml` workflow is triggered **manually** (`workflow_dispatch`) with inputs:

- `version` — semantic version string (e.g., `0.5.0`)
- `dry-run` — boolean, when true packs only and skips push

Pipeline stages:
1. **Test** — runs xUnit tests
2. **Pack** — creates NuGet package with `ContinuousIntegrationBuild=true`
3. **Publish** — pushes to NuGet.org using `secrets.NUGET_API_KEY`, then creates a GitHub release with auto-generated release notes

### Plugin (Claude Code marketplace)

The plugin is distributed via the Claude Code plugin marketplace (`/plugin install dotnet-claude-kit`). Version bumps are manual — update `.claude-plugin/plugin.json` and `mcp/CWM.RoslynNavigator/src/CWM.RoslynNavigator.csproj` together.

### Templates

Templates are not packaged — users copy `CLAUDE.md` files manually or use the `/dotnet-init` command.

## Security Considerations

- **No hardcoded secrets** in any markdown examples or C# code
- **Parameterized queries** required in all data-access examples
- **HTTPS-only** API examples
- **`pre-bash-guard.sh` hook** blocks destructive git operations (force push, `reset --hard`) and warns on risky shell commands
- **No sensitive file access** — MCP tools are read-only and do not modify source code
- **NUGET_API_KEY** is the only repository secret, stored as a GitHub encrypted secret and used only in the `publish-nuget.yml` environment `nuget`
- All shell hooks are validated for syntax in CI before merge

---

# Agent Routing & Orchestration

> This section defines how Claude Code routes queries to specialist agents and how agents coordinate.

## Agent Roster

| Agent | File | Primary Domain |
|-------|------|---------------|
| dotnet-architect | `agents/dotnet-architect.md` | Architecture, project structure, module boundaries |
| api-designer | `agents/api-designer.md` | Minimal APIs, OpenAPI, versioning, rate limiting |
| ef-core-specialist | `agents/ef-core-specialist.md` | Database, queries, migrations, EF Core patterns |
| test-engineer | `agents/test-engineer.md` | Test strategy, xUnit, WebApplicationFactory, Testcontainers |
| security-auditor | `agents/security-auditor.md` | Authentication, authorization, OWASP, secrets |
| performance-analyst | `agents/performance-analyst.md` | Benchmarks, memory, async patterns, caching |
| devops-engineer | `agents/devops-engineer.md` | Docker, CI/CD, Aspire, deployment |
| code-reviewer | `agents/code-reviewer.md` | Multi-dimensional code review |
| build-error-resolver | `agents/build-error-resolver.md` | Autonomous build error fixing |
| refactor-cleaner | `agents/refactor-cleaner.md` | Systematic dead code removal and cleanup |

## Routing Table

Match user intent to agent. When multiple agents could handle a query, the first match wins.

| User Intent Pattern | Primary Agent | Support Agent |
|---|---|---|
| "set up project", "folder structure", "architecture" | dotnet-architect | — |
| "add module", "split into modules", "bounded context" | dotnet-architect | — |
| "create endpoint", "API route", "OpenAPI", "swagger" | api-designer | — |
| "versioning", "rate limiting", "CORS" | api-designer | — |
| "database", "migration", "query", "DbContext", "EF" | ef-core-specialist | — |
| "write tests", "test strategy", "coverage" | test-engineer | — |
| "WebApplicationFactory", "Testcontainers", "xUnit" | test-engineer | — |
| "security", "authentication", "JWT", "OIDC", "authorize" | security-auditor | — |
| "performance", "benchmark", "memory", "profiling" | performance-analyst | — |
| "caching", "HybridCache", "output cache" | performance-analyst | — |
| "Docker", "container", "CI/CD", "pipeline", "deploy" | devops-engineer | — |
| "Aspire", "orchestration", "service discovery" | devops-engineer | — |
| "review this code", "PR review", "code quality" | code-reviewer | — |
| "choose architecture", "which architecture", "architecture decision" | dotnet-architect | — |
| "scaffold feature", "create feature", "add endpoint", "generate feature" | dotnet-architect | api-designer, ef-core-specialist |
| "init project", "setup project", "new project", "generate CLAUDE.md" | dotnet-architect | — |
| "health check", "analyze project", "project report" | code-reviewer | dotnet-architect |
| "review PR", "review changes", "code review", "PR review" | code-reviewer | — |
| "add migration", "ef migration", "update packages", "upgrade nuget" | ef-core-specialist | — |
| "conventions", "coding style", "detect patterns", "code consistency" | code-reviewer | — |
| "add feature" (architecture-appropriate) | dotnet-architect | api-designer, ef-core-specialist |
| "refactor" | code-reviewer | dotnet-architect |
| "build errors", "fix build", "won't compile" | build-error-resolver | — |
| "clean up", "dead code", "unused code", "de-sloppify" | refactor-cleaner | — |

## Skill Loading Order

Agents load skills in dependency order. Core skills load first.

### Default Load Order (All Agents)
1. `modern-csharp` — Always loaded, baseline C# knowledge
2. Agent-specific skills (see agent files)

### Per-Agent Skill Maps

| Agent | Skills |
|-------|--------|
| dotnet-architect | modern-csharp, architecture-advisor, project-structure, scaffolding, project-setup + conditional: vertical-slice, clean-architecture, ddd |
| api-designer | modern-csharp, minimal-api, api-versioning, authentication, error-handling |
| ef-core-specialist | modern-csharp, ef-core, configuration, migration-workflow |
| test-engineer | modern-csharp, testing |
| security-auditor | modern-csharp, authentication, configuration |
| performance-analyst | modern-csharp, caching |
| devops-engineer | modern-csharp, docker, ci-cd, aspire |
| code-reviewer | modern-csharp, code-review-workflow, convention-learner + contextual (loads relevant skills incl. clean-architecture, ddd based on files under review) |
| build-error-resolver | modern-csharp, autonomous-loops + contextual: ef-core, dependency-injection |
| refactor-cleaner | modern-csharp, de-sloppify + contextual: testing, ef-core |

## MCP Tool Preferences

Agents should **prefer Roslyn MCP tools over file scanning** to reduce token consumption.

| Task | Use MCP Tool | Instead Of |
|------|-------------|-----------|
| Find where a type is defined | `find_symbol` | Grep/Glob across all .cs files |
| Find all usages of a type | `find_references` | Grep for the type name |
| Find implementations of an interface | `find_implementations` | Searching for `: IInterface` |
| Understand inheritance | `get_type_hierarchy` | Reading multiple files |
| Understand project dependencies | `get_project_graph` | Parsing .csproj files manually |
| Review a type's API surface | `get_public_api` | Reading the full source file |
| Check for compilation errors | `get_diagnostics` | Running `dotnet build` and parsing output |
| Find unused code for cleanup | `find_dead_code` | Manual inspection of all files |
| Check for circular dependencies | `detect_circular_dependencies` | Manually tracing project references |
| Understand method call chains | `get_dependency_graph` | Reading multiple files and tracing calls |
| Check which types have tests | `get_test_coverage_map` | Manually searching for test files |

## Cross-Agent Meta Skills

These 10 meta and productivity skills are not tied to a specific agent — any agent can load them when the context calls for it:

| Skill | When to Load |
|-------|-------------|
| `self-correction-loop` | After ANY user correction — capture the rule in MEMORY.md |
| `wrap-up-ritual` | User signals end of session — write handoff to `.claude/handoff.md` |
| `context-discipline` | Context running low, large codebase navigation, planning exploration strategy |
| `model-selection` | Choosing between Opus/Sonnet/Haiku, assigning subagent models |
| `80-20-review` | Code review, PR review, deciding what to review in depth |
| `split-memory` | CLAUDE.md exceeds 300 lines, need to split instructions across files |
| `learning-log` | Non-obvious discovery during development — log the insight |
| `instinct-system` | Pattern detection across sessions — observe-hypothesize-confirm cycle for project conventions |
| `session-management` | Session start/end — load handoff, detect solution, write session summary |
| `autonomous-loops` | Iterative fix loops — build-fix, test-fix, refactor with bounded iterations |

### Meta Skill Routing

| User Intent Pattern | Skill |
|---|---|
| "learn from mistakes", "remember this", "don't do that again" | self-correction-loop |
| "wrap up", "done for today", "save progress", "handoff" | wrap-up-ritual |
| "context", "running out of tokens", "too many files" | context-discipline |
| "which model", "use Opus", "use Sonnet", "switch model" | model-selection |
| "review this", "what should I review", "blast radius" | 80-20-review |
| "split CLAUDE.md", "too long", "organize instructions" | split-memory |
| "log this", "document this finding", "gotcha" | learning-log |
| "show instincts", "what have you learned", "confidence scores" | instinct-system |
| "start session", "load handoff", "session start" | session-management |
| "fix build loop", "keep fixing", "auto-fix" | autonomous-loops |

## Slash Commands

Commands map to skills and agents. Use these as shortcuts for common workflows.

| Command | Primary Skill | Primary Agent | Purpose |
|---------|--------------|---------------|---------|
| `/dotnet-init` | project-setup | dotnet-architect | Interactive project initialization |
| `/plan` | architecture-advisor | dotnet-architect | Architecture-aware planning |
| `/verify` | verification-loop | — | 7-phase verification pipeline |
| `/tdd` | testing | test-engineer | Red-green-refactor workflow |
| `/scaffold` | scaffolding | dotnet-architect | Architecture-aware feature scaffolding |
| `/code-review` | code-review-workflow | code-reviewer | MCP-powered code review |
| `/build-fix` | autonomous-loops | build-error-resolver | Iterative build error fixing |
| `/checkpoint` | wrap-up-ritual | — | Save progress (commit + handoff) |
| `/security-scan` | security-scan | security-auditor | OWASP + secrets + dependency audit |
| `/migrate` | migration-workflow | ef-core-specialist | Safe EF Core migration workflow |
| `/health-check` | health-check | code-reviewer | Graded project health report |
| `/de-sloppify` | de-sloppify | refactor-cleaner | Systematic code cleanup |
| `/wrap-up` | wrap-up-ritual | — | Session ending ritual |
| `/instinct-status` | instinct-system | — | Show learned instincts |
| `/instinct-export` | instinct-system | — | Export instincts to shareable format |
| `/instinct-import` | instinct-system | — | Import instincts from another project |

## Conflict Resolution

When two agents could handle a query:

1. **Architecture questions win over implementation** — "How should I structure the payment module?" → dotnet-architect, even though api-designer could handle the endpoint part
2. **Specific beats general** — "How do I optimize this EF query?" → ef-core-specialist, not performance-analyst
3. **Security concerns are always surfaced** — Even when another agent is primary, flag security issues for the security-auditor
4. **Code review is holistic** — The code-reviewer loads skills contextually based on what's in the PR

## Token Budget Guidance

For detailed context management strategies, see the **`context-discipline`** skill.

- **Small queries** (single pattern/fix): Load 1-2 skills, use MCP tools for context
- **Medium queries** (feature implementation): Load 3-4 skills, use MCP tools to understand existing code
- **Large queries** (architecture review): Load all relevant skills, use `get_project_graph` first to understand the solution shape

## Response Patterns

All agents should:
1. **Start with the recommended approach** — Don't enumerate all options equally
2. **Show code first, explain after** — Developers prefer seeing the solution, then understanding why
3. **Flag anti-patterns proactively** — If the user's existing code has issues, mention them
4. **Reference skills** — Point to relevant skills for deeper reading
5. **Use MCP tools before reading files** — Reduce token consumption

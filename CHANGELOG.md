# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] — 2026-02-21

### Added
- **Multi-architecture support** — New skills: `architecture-advisor`, `clean-architecture`, `ddd`
- **Workflow mastery skill** — `workflow-mastery` skill covering parallel worktrees, plan mode strategy, verification loops, auto-format hooks, permission setup, and subagent patterns for .NET (inspired by Boris Cherny's tips)
- **Workflow Standards section** in root CLAUDE.md and all 5 templates — plan before building, verify before done, fix bugs autonomously, demand elegance, use subagents, learn from corrections
- **Architecture advisor questionnaire** — 15+ questions across 6 categories to recommend the best-fit architecture (VSA, Clean Architecture, DDD + CA, Modular Monolith)
- **ADR-005** — Multi-architecture decision record superseding ADR-001 (VSA-only default)
- **Plugin distribution** — `.claude-plugin/plugin.json` and `marketplace.json` for Claude Code plugin marketplace
- **Progressive skill loading** — All 20 skill descriptions enriched with trigger keywords for better contextual loading
- **Installation section** in README with plugin marketplace commands

### Changed
- Philosophy updated from "opinionated over encyclopedic" to "guided over prescriptive"
- Architecture default changed from VSA-only to advisor-driven (supports 4 architectures)
- `dotnet-architect` agent now loads `architecture-advisor` first, then conditionally loads architecture-specific skills
- `code-reviewer` agent contextually loads `clean-architecture` and `ddd` for project structure reviews
- All 5 templates updated to reference `architecture-advisor` skill
- `web-api` template now shows 3 architecture options (VSA, CA, DDD)
- `modular-monolith` template updated to support per-module architecture choice
- Skills count: 17 → 21
- Branding: "opinionated" → "definitive"
- ADR-001 marked as superseded by ADR-005
- MediatR description updated to mention architecture-agnostic compatibility

## [Unreleased]

### Added
- Initial repository structure
- Project spec in `docs/dotnet-claude-kit-SPEC.md`

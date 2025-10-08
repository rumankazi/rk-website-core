# Copilot Instructions for AI Coding Agents

## Project Overview

- **TypeScript/Next.js 14+ monorepo** for a personal website, with full-stack (SSR, API, DB) and DevOps automation.
- **Test-Driven Development (TDD):** Write tests first, then implement features. Red → Green → Refactor cycle.
- **Strict TypeScript, App Router, Prisma ORM, Tailwind CSS, Auth.js, PostgreSQL** (Cloud SQL), and containerized (Docker, Cloud Run).
- **CI/CD:** GitHub Actions, with quality checks, tests, security scans, and multi-stage deploys.
- **IaC:** Terraform for all cloud resources, with modular structure.

## Key Patterns & Conventions

- **Container-first:** All development, testing, and production workflows are run inside Docker containers or VS Code Dev Containers. Use `docker-compose` for local stack. This ensures dev = CI = prod, eliminates "works on my machine" issues, and enables fast onboarding/reset.
- **App Structure:**
  - `src/app/` (Next.js App Router: pages, API routes, (auth), (public))
  - `src/components/ui/` (reusable UI), `src/components/features/` (feature-specific)
  - `src/lib/` (db, auth, monitoring, utils), `src/types/` (global types)
  - `prisma/` (schema, migrations, seed)
  - `tests/` (unit: Vitest, integration, e2e: Playwright)
  - `docs/` (VitePress documentation site - auto-published)
- **Test-Driven Development:** Write failing tests first, implement to pass, then refactor. Every feature requires comprehensive test coverage.
- **Test Strategy:** Unit tests (Vitest), Integration tests (API testing), E2E tests (Playwright), Visual regression testing.
- **Strict Linting/Formatting:** ESLint, Prettier, Husky pre-commit hooks, enforced in CI.
- **Environment:** Use `.env.example` as template; secrets are never committed.
- **Documentation-First:** All design/infra/security decisions in `docs/`, auto-published as modern documentation site.

## Essential Workflows

- **Start local dev:**
  ```bash
  docker-compose up -d postgres
  pnpm prisma migrate dev
  pnpm dev
  ```
- **Documentation development:**
  ```bash
  cd docs && pnpm docs:dev    # Start VitePress dev server
  pnpm docs:build             # Build static documentation
  pnpm docs:preview           # Preview built documentation
  ```
- **TDD cycle:** `pnpm test:watch` (continuous testing during development)
- **Run tests:** `pnpm test` (unit/integration), `pnpm test:e2e` (Playwright), `pnpm test:coverage` (coverage reports)
- **Type check:** `pnpm type-check`
- **Lint:** `pnpm lint`
- **CI/CD:** See `.github/workflows/` (quality, build, test, deploy, security, docs)
- **Build container:** `docker build .` (multi-stage Dockerfile)
- **Clean slate:** `docker-compose down -v && docker-compose up`

## Integration Points

- **GCP:** Cloud Run, Cloud SQL, Artifact Registry, Secret Manager, Cloud Monitoring.
- **Monitoring:** Prometheus, Grafana, Sentry, Plausible (see `docs/website-roadmap.md`).
- **Security:** Dependabot, CodeQL, Snyk, Trivy, npm audit (all automated in CI).
- **Feature Flags:** Custom implementation with Redis backing for gradual rollouts and A/B testing.

## Documentation Automation & Publishing

### Documentation Stack

- **VitePress** - Modern, fast, Vue-powered static site generator for markdown
- **Auto-deployment** - GitHub Actions publishes docs to GitHub Pages on every commit
- **Modern Design** - Clean, professional, mobile-responsive with dark/light modes
- **Configurable** - Easy theming, custom components, full TypeScript support
- **Search** - Built-in search functionality across all documentation

### Documentation Structure

```
docs/
├── .vitepress/
│   ├── config.ts              # VitePress configuration
│   ├── theme/                 # Custom theme overrides
│   └── components/            # Custom Vue components
├── index.md                   # Landing page
├── guide/
│   ├── getting-started.md     # Quick start guide
│   ├── development.md         # Development workflow
│   └── deployment.md          # Deployment process
├── architecture/
│   ├── overview.md            # System architecture
│   ├── database.md            # Database design
│   ├── security.md            # Security implementation
│   └── monitoring.md          # Observability setup
├── api/
│   ├── routes.md              # API endpoints
│   └── authentication.md      # Auth implementation
├── infrastructure/
│   ├── terraform.md           # IaC documentation
│   ├── docker.md              # Container setup
│   └── ci-cd.md               # Pipeline configuration
└── changelog/
    └── README.md              # Version history & updates
```

### Documentation Workflows

- **Auto-update:** Documentation is updated with every feature increment
- **Version control:** All docs are versioned with the codebase
- **Auto-publish:** GitHub Actions builds and deploys to `https://username.github.io/project-docs`
- **Live reload:** Local development with hot module replacement

## Deployment Strategy

### Multi-Environment Pipeline

```
Development → Staging → Production
     ↓           ↓         ↓
  Local Dev   Auto-Deploy  Manual Gate
  Container   on PR merge  + Approval
```

### Database Changes

1. **Schema updates:** `prisma/schema.prisma` (forward-compatible only)
2. **Migration:** `pnpm prisma migrate dev --name descriptive-name`
3. **Testing:** Validate in development environment first
4. **Staging deploy:** Auto-deployed, run integration tests
5. **Production deploy:** Manual approval after staging validation

### Application Deployment

1. **Quality gates:** All checks must pass (lint, tests, security scans)
2. **Container build:** Multi-stage Dockerfile with optimization
3. **Staging:** Auto-deploy on merge, run E2E tests
4. **Production:** Manual approval → Canary → Full rollout
5. **Monitoring:** Health checks, error rates, performance metrics

### Rollback Procedures

- **Staging:** Keep previous image tag for 24h, instant rollback
- **Production:** Automatic rollback on health check failure
- **Database:** Point-in-time recovery, forward-compatible migrations only

## Test-Driven Development (TDD) Methodology

### TDD Cycle: Red → Green → Refactor

1. **RED**: Write a failing test that describes the desired functionality
2. **GREEN**: Write the minimal code to make the test pass
3. **REFACTOR**: Improve the code while keeping tests green

### TDD Requirements

- **MANDATORY: Write tests FIRST** - No implementation without tests
- **Comprehensive coverage:** Unit tests for all functions, integration tests for APIs, E2E tests for user flows
- **Test naming:** Descriptive test names that explain the expected behavior
- **Test organization:** Group related tests, use setup/teardown appropriately
- **Test isolation:** Each test should be independent and repeatable

### Testing Strategy by Layer

- **Unit Tests (Vitest):** Pure functions, utilities, components, business logic
- **Integration Tests:** API endpoints, database operations, external service integration
- **E2E Tests (Playwright):** User journeys, critical business flows, cross-browser compatibility
- **Visual Regression Tests:** UI component snapshots, layout consistency

## AI Agent Guidance

- **Follow project structure and naming conventions.**
- **Reference `docs/website-roadmap.md` for architecture, tech stack, and rationale.**
- **MANDATORY TDD: Write failing tests before any implementation.**
- **Test coverage:** Maintain >90% code coverage for all new features.\*\*
- **MANDATORY: Update documentation after every change - no exceptions.**
- **Document-driven development:** Create/update relevant docs BEFORE implementing features.
- **Never commit secrets or credentials - use Secret Manager only.**
- **Prefer containerized workflows and VS Code Dev Containers.**
- **All code must pass lint, type check, and tests before PR/merge.**
- **Include documentation updates in every PR - link to updated docs in PR description.**
- **Database migrations must be forward-compatible (additive changes first).**
- **Include health check endpoints for all new services.**
- **Consider deployment impact - staging first, then production approval.**

## Examples

### TDD Workflow Examples

- **API Route (TDD):** Write `tests/integration/api/users.test.ts` → implement `src/app/api/users/route.ts`
- **Component (TDD):** Write `tests/unit/Button.test.tsx` → implement `src/components/ui/Button.tsx`
- **Utility (TDD):** Write `tests/unit/validators.test.ts` → implement `src/lib/validators.ts`
- **E2E Flow (TDD):** Write `tests/e2e/auth.spec.ts` → implement auth pages and flows

### Implementation Examples

- Add a new API route: First write test in `tests/integration/api/` then `src/app/api/your-route/route.ts`
- Add a DB model: `prisma/schema.prisma` + write migration tests + `pnpm prisma migrate dev`
- Add a UI component: Write component tests first, then `src/components/ui/YourComponent.tsx`
- Feature flag usage: `src/lib/feature-flags.ts` + conditional rendering + comprehensive tests
- Health check: `src/app/api/health/route.ts` with database/service validation + monitoring tests

For more, see `docs/website-roadmap.md` and `.github/workflows/`.

# Website Development Roadmap & Tech Stack

**Status:** Phase 4 Ready  
**Last Updated:** October 8, 2025  
**DevOps Engineer Learning Web Development**

---

::: tip Documentation Site
This documentation is automatically published at [https://rumankazi.github.io/rk-website-core/](https://rumankazi.github.io/rk-website-core/) using VitePress and GitHub Actions.
:::

---

## Project Goals

- Build a personal website with full control over infrastructure
- Learn modern web development best practices through **Test-Driven Development (TDD)**
- Implement security, testing, and architecture principles with comprehensive test coverage
- Document incremental progress with every feature thoroughly tested
- Maximize automation (deployments, testing, quality checks) with test-first mentality
- Monitor both infrastructure and application/user behavior

---

## Complete Tech Stack

### Core Technologies

| Layer              | Technology               | Rationale                                                                                            |
| ------------------ | ------------------------ | ---------------------------------------------------------------------------------------------------- |
| **Language**       | TypeScript (strict mode) | Type safety catches 15-20% of bugs at compile time, better IDE support, self-documenting code        |
| **Framework**      | Next.js 14+ (App Router) | Production-ready patterns, SSR, API routes, automatic optimization, excellent TypeScript integration |
| **Database**       | PostgreSQL on Cloud SQL  | Industry standard, ACID compliance, superior JSON support, better for learning relational concepts   |
| **ORM**            | Prisma                   | Type-safe queries, schema as source of truth, excellent migration system, generated TypeScript types |
| **Styling**        | Tailwind CSS             | Utility-first for rapid development, zero runtime cost, built-in design system, tree-shaking         |
| **Authentication** | Auth.js (NextAuth v5)    | Next.js native, secure by default, supports multiple providers, database session management          |

### Testing & Quality (Test-Driven Development)

| Tool                    | Purpose                  | TDD Application                                                                  |
| ----------------------- | ------------------------ | -------------------------------------------------------------------------------- |
| **Vitest**              | Unit & Integration Tests | Red-Green-Refactor cycle, 5-10x faster than Jest, native ESM, TypeScript support |
| **Playwright**          | E2E Testing              | User story validation, multi-browser testing, reliable auto-waits                |
| **ESLint**              | Code Linting             | Code quality enforcement, catches bugs before tests                              |
| **Prettier**            | Code Formatting          | Consistent formatting for readable tests and implementation                      |
| **TypeScript Compiler** | Type Checking            | Compile-time safety, reduces runtime errors caught by tests                      |
| **Husky + lint-staged** | Pre-commit Hooks         | Ensure all tests pass before commit, prevent broken test suites                  |
| **@testing-library**    | Component Testing        | User-centric testing approach, test behavior not implementation                  |
| **MSW (Mock Service)**  | API Mocking              | Mock external APIs for reliable, fast integration tests                          |

### Infrastructure & DevOps

| Component              | Technology              | Purpose                                                                                |
| ---------------------- | ----------------------- | -------------------------------------------------------------------------------------- |
| **Cloud Provider**     | GCP                     | Cloud Run (serverless containers), Cloud SQL (managed PostgreSQL), Cloud Build (CI/CD) |
| **IaC**                | Terraform               | Multi-cloud support, mature ecosystem, industry standard, better for career growth     |
| **CI/CD**              | GitHub Actions          | Native GitHub integration, flexible workflows, matrix builds for testing               |
| **Container Registry** | Artifact Registry       | GCP native, vulnerability scanning, artifact management                                |
| **Load Balancer**      | Cloud Load Balancer     | HTTPS/SSL termination, global routing, DDoS protection                                 |
| **Static Assets**      | Cloud Storage           | CDN integration, cost-effective, automatic versioning                                  |
| **Secrets**            | Secret Manager          | Encrypted secret storage, automatic rotation, audit logging                            |
| **Feature Flags**      | Custom + Redis (future) | Gradual rollouts, A/B testing, emergency toggles, progressive deployment               |

### Monitoring & Observability

| Tool                     | Purpose                                           | Cost Model                            |
| ------------------------ | ------------------------------------------------- | ------------------------------------- |
| **GCP Cloud Monitoring** | Infrastructure metrics, logs, traces              | Pay-per-use, generous free tier       |
| **Prometheus + Grafana** | Custom metrics, business KPIs, user behavior      | Self-hosted (free), Cloud SQL storage |
| **Sentry**               | Application errors, performance monitoring        | Free tier: 5k errors/month            |
| **Plausible Analytics**  | Privacy-focused web analytics                     | Self-hosted (free) or $9/month cloud  |
| **OpenTelemetry**        | Distributed tracing, standardized instrumentation | Free (just costs of storage)          |

### Security Tools

| Tool           | Type                       | Integration                            |
| -------------- | -------------------------- | -------------------------------------- |
| **Dependabot** | Dependency updates         | GitHub native (free)                   |
| **CodeQL**     | Static analysis            | GitHub Actions (free for public repos) |
| **Snyk**       | Vulnerability scanning     | GitHub Action, free tier available     |
| **Trivy**      | Container & IaC scanning   | GitHub Action (free)                   |
| **npm audit**  | Dependency vulnerabilities | Local & CI, built into npm             |

---

## Architecture Overview

```
┌─────────────────────────────────────────┐
│         Cloud Load Balancer             │
│         (HTTPS/SSL, CDN)                │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          Cloud Run                       │
│    (Next.js Application)                │
│  - Auto-scaling 0-N                      │
│  - Containerized                         │
│  - Request-based billing                 │
└──────┬────────────┬──────────┬──────────┘
       │            │          │
┌──────▼────────┐ ┌─▼────────┐ ┌▼──────────┐
│   Cloud SQL   │ │  Secret  │ │  Storage  │
│ (PostgreSQL)  │ │ Manager  │ │ (Static)  │
└───────┬───────┘ └──────────┘ └───────────┘
        │
┌───────▼──────────────────────────────────┐
│         Monitoring Stack                  │
│  - GCP Monitoring (infra)                │
│  - Prometheus (app metrics)              │
│  - Grafana (dashboards)                  │
│  - Sentry (errors)                       │
│  - Plausible (user analytics)            │
└──────────────────────────────────────────┘
```

---

## Project Structure

```
my-website/
├── .github/
│   └── workflows/
│       ├── ci.yml              # Quality checks, tests
│       ├── deploy-staging.yml  # Auto-deploy to staging
│       └── deploy-prod.yml     # Manual deploy to prod
│
├── docs/
│   ├── PROGRESS.md            # Daily learning log
│   ├── ARCHITECTURE.md        # Design decisions
│   ├── SECURITY.md            # Security implementations
│   └── MONITORING.md          # Observability setup
│
├── infrastructure/
│   ├── terraform/
│   │   ├── environments/
│   │   │   ├── dev/
│   │   │   ├── staging/
│   │   │   └── production/
│   │   └── modules/
│   │       ├── networking/
│   │       ├── database/
│   │       ├── monitoring/
│   │       └── cloud-run/
│   └── monitoring/
│       ├── grafana/           # Dashboard configs
│       └── prometheus/        # Scrape configs
│
├── src/
│   ├── app/                   # Next.js App Router
│   │   ├── api/              # API routes
│   │   ├── (auth)/           # Auth pages group
│   │   └── (public)/         # Public pages group
│   ├── components/
│   │   ├── ui/               # Reusable UI components
│   │   └── features/         # Feature-specific components
│   ├── lib/
│   │   ├── db/               # Database client, utilities
│   │   ├── auth/             # Auth configuration
│   │   ├── monitoring/       # Instrumentation
│   │   └── utils/            # Helper functions
│   ├── types/                # TypeScript type definitions
│   └── middleware.ts         # Next.js middleware
│
├── tests/
│   ├── unit/                 # Vitest unit tests
│   ├── integration/          # API integration tests
│   └── e2e/                  # Playwright E2E tests
│
├── prisma/
│   ├── schema.prisma         # Database schema
│   ├── migrations/           # Migration history
│   └── seed.ts              # Seed data
│
├── .husky/                   # Git hooks
├── .vscode/                  # VS Code settings
├── Dockerfile                # Container definition
├── docker-compose.yml        # Local development
├── .env.example             # Environment variables template
├── .eslintrc.json           # ESLint configuration
├── .prettierrc              # Prettier configuration
├── tsconfig.json            # TypeScript configuration
├── vitest.config.ts         # Vitest configuration
├── playwright.config.ts     # Playwright configuration
└── tailwind.config.ts       # Tailwind configuration
```

---

## CI/CD Pipeline

### GitHub Actions Workflow

```
┌─────────────────────────────────────────┐
│  Push / Pull Request                    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Job 1: Quality Checks (Parallel)       │
├─────────────────────────────────────────┤
│  - ESLint (code quality)                │
│  - Prettier (format check)              │
│  - TypeScript (type check)              │
│  - npm audit (dependency vulnerabilities)│
│  - Snyk scan (security issues)          │
│  - Trivy scan (IaC misconfigurations)   │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Job 2: Build & Test                    │
├─────────────────────────────────────────┤
│  - Unit tests (Vitest)                  │
│  - Integration tests                    │
│  - Build Next.js app                    │
│  - Build Docker image                   │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Job 3: E2E Tests                       │
├─────────────────────────────────────────┤
│  - Playwright (Chromium, Firefox)       │
│  - Screenshot on failure                │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Job 4: Deploy to Staging (auto)        │
├─────────────────────────────────────────┤
│  - Push to Artifact Registry            │
│  - Deploy to Cloud Run (staging)        │
│  - Run smoke tests                      │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Job 5: Deploy to Production (manual)   │
├─────────────────────────────────────────┤
│  - Require approval                     │
│  - Deploy to Cloud Run (prod)           │
│  - Health checks                        │
│  - Rollback on failure                  │
└─────────────────────────────────────────┘
```

---

## Deployment Strategy

### Multi-Environment Pipeline

```
Development → Staging → Production
     ↓           ↓         ↓
  Local Dev   Auto-Deploy  Manual Gate
  Container   on PR merge  + Approval
     $0         ~$20/mo    ~$100/mo
```

### Environment Configuration

**Development Environment**

- **Location**: VS Code Dev Containers + Docker Compose
- **Purpose**: Feature development, debugging, rapid iteration
- **Database**: Local PostgreSQL in Docker
- **Monitoring**: Local Prometheus + Grafana stack
- **Cost**: $0 (local containers)

**Staging Environment**

- **Location**: Google Cloud Run (separate project/namespace)
- **Trigger**: Automatic on every merge to `main` branch
- **Purpose**: Integration testing, stakeholder preview, final validation
- **Database**: Cloud SQL db-f1-micro (shared-core)
- **Domain**: `staging.your-domain.com`
- **Cost**: ~$20-30/month

**Production Environment**

- **Location**: Google Cloud Run (production project)
- **Trigger**: Manual approval after staging validation
- **Purpose**: Real users, performance monitoring, business metrics
- **Database**: Cloud SQL db-n1-standard-2 (dedicated cores)
- **Domain**: `your-domain.com`
- **Cost**: ~$100-200/month (scales with usage)

### Deployment Patterns

- **Database:** Forward-compatible migrations, blue-green for production
- **Application:** Blue-green (staging), Canary with health monitoring (production)
- **Rollback:** Automatic on health check failures or error rate > 1%
- **Zero Downtime:** Production deployments with traffic shifting

### Feature Flag System (Future Enhancement)

```typescript
// Gradual feature rollouts and A/B testing
const useNewDashboard = await featureFlag("new-dashboard", {
  user: session.user,
  rolloutPercentage: 25, // Start with 25% of users
  rules: {
    beta_users: true, // Always enabled for beta users
    admin: true, // Always enabled for admins
  },
});

if (useNewDashboard) {
  return <NewDashboard />;
} else {
  return <LegacyDashboard />;
}
```

**Feature Flag Benefits:**

- **Gradual Rollouts**: Release to small percentage, monitor, expand
- **Emergency Toggles**: Instant feature disable without deployment
- **A/B Testing**: Compare feature performance and user engagement
- **Canary Releases**: Test with specific user segments first

---

## Security Best Practices

### Code Level

- ✅ Input validation on all user inputs
- ✅ Parameterized queries (Prisma prevents SQL injection)
- ✅ CSRF protection (Next.js middleware)
- ✅ Rate limiting on API routes
- ✅ Content Security Policy headers
- ✅ XSS prevention (React escapes by default)

### Infrastructure Level

- ✅ Secrets in Secret Manager (never in code)
- ✅ Principle of least privilege (IAM roles)
- ✅ VPC for database (not public)
- ✅ HTTPS everywhere (Cloud Load Balancer)
- ✅ Automatic SSL certificate management
- ✅ DDoS protection (Cloud Armor)

### Pipeline Level

- ✅ Dependency scanning (Dependabot)
- ✅ SAST analysis (CodeQL)
- ✅ Container vulnerability scanning (Trivy)
- ✅ IaC security scanning (Trivy)
- ✅ Pre-commit hooks (prevent bad commits)

---

## VS Code Extensions (Required)

Install these immediately:

- **ESLint** (dbaeumer.vscode-eslint)
- **Prettier** (esbenp.prettier-vscode)
- **Tailwind CSS IntelliSense** (bradlc.vscode-tailwindcss)
- **Prisma** (Prisma.prisma)
- **GitHub Actions** (github.vscode-github-actions)
- **Error Lens** (usernamehw.errorlens)
- **GitLens** (eamodio.gitlens)
- **Docker** (ms-azuretools.vscode-docker)

---

## Development Workflow

### Test-Driven Development (TDD) Methodology

#### TDD Cycle: Red → Green → Refactor

1. **RED**: Write a failing test that describes the desired functionality
2. **GREEN**: Write the minimal code to make the test pass
3. **REFACTOR**: Improve the code while keeping tests green

#### TDD Requirements

- **MANDATORY: Write tests FIRST** - No implementation without tests
- **Comprehensive coverage:** Unit tests for all functions, integration tests for APIs, E2E tests for user flows
- **Test naming:** Descriptive test names that explain the expected behavior
- **Test organization:** Group related tests, use setup/teardown appropriately
- **Test isolation:** Each test should be independent and repeatable

#### Testing Strategy by Layer

- **Unit Tests (Vitest):** Pure functions, utilities, components, business logic
- **Integration Tests:** API endpoints, database operations, external service integration
- **E2E Tests (Playwright):** User journeys, critical business flows, cross-browser compatibility
- **Visual Regression Tests:** UI component snapshots, layout consistency

### Daily Workflow

1. Pull latest from main: `git pull origin main`
2. Create feature branch: `git checkout -b feature/your-feature`
3. **TDD Cycle**: Write failing tests → implement code → refactor
4. Pre-commit hooks run automatically
5. Push branch: `git push origin feature/your-feature`
6. Create PR on GitHub
7. CI runs automatically
8. Review and merge

### Local Development

```bash
# Start database
docker-compose up -d postgres

# Run migrations
pnpm prisma migrate dev

# Start dev server
pnpm dev

# TDD Development Workflow
pnpm test:watch        # Continuous testing during development
pnpm test              # Run all tests
pnpm test:coverage     # Generate coverage reports
pnpm test:e2e          # Run E2E tests

# Type check
pnpm type-check

# Lint
pnpm lint
```

---

## Documentation Strategy

### After Each Feature

1. **PROGRESS.md**: What you built, learned, problems solved
2. **ARCHITECTURE.md**: Design decisions made
3. **SECURITY.md**: Security measures implemented
4. **Code comments**: Explain "why," not "what"

### Weekly Review

- What patterns emerged?
- What would you do differently?
- What questions do you have?

---

## Leveraging AI (Claude) Throughout Development

### Architecture & Design

- "Review this database schema for a blog system"
- "What security considerations for user authentication?"
- "Should this be a server or client component in Next.js?"

### Code Review

- "Review this React component for performance issues"
- "Is this API route vulnerable to attacks?"
- "How can I make this more testable?"

### Debugging

- Paste error + context
- Ask for debugging strategies
- Request explanation of error messages

### Documentation

- "Generate JSDoc comments for this function"
- "Create API documentation from these endpoints"
- "Explain this TypeScript type to a beginner"

### Learning Accelerator

- "Explain React Server Components with examples"
- "What's the difference between SSR and SSG?"
- "How does Prisma prevent SQL injection?"

### Security Analysis

- "Analyze this auth flow for vulnerabilities"
- "What OWASP Top 10 risks apply here?"
- "Review this Terraform for security misconfigurations"

**AI Usage Principles:**

- Verify all AI suggestions
- Ask "why" to understand reasoning
- Use AI for starting points, then refine
- Document AI-assisted decisions
- Test AI-generated code thoroughly

---

## Cost Optimization

### Development Phase (Learning)

- Cloud Run: ~$0 (free tier: 2M requests/month)
- Cloud SQL: ~$7-10/month (db-f1-micro)
- Monitoring: ~$0 (self-hosted Grafana)
- Total: ~$10/month

### Production Phase (Light Traffic)

- Cloud Run: $10-20/month
- Cloud SQL: $30-50/month
- Monitoring: $5/month
- Total: $45-75/month

### Optimization Tips

- Use Cloud Run min instances = 0 (scale to zero)
- Cloud SQL: Use db-f1-micro initially
- Self-host Grafana on Cloud Run
- Use Plausible Community Edition (self-hosted)
- Free tier Sentry (5k errors/month)

---

## Next Steps

### Phase 4 Implementation (Current)

1. ✅ Understand tech stack rationale
2. ✅ Set up local VS Code Dev Container environment
3. ✅ Configure comprehensive development tooling
4. ✅ Set up documentation framework with VitePress
5. ⏳ Create Next.js project structure
6. ⏳ Configure ESLint, Prettier, TypeScript, Husky
7. ⏳ Create initial GitHub Actions workflow
8. ⏳ Initialize Terraform project structure

### Phase 5: Database & API Foundation

- Prisma setup and first schema
- Database migrations system
- First API endpoints with validation
- Integration tests and API testing
- Health check endpoints
- Basic error handling patterns

### Phase 6: Deployment Pipeline

- **GitHub Actions CI/CD:** Quality gates, testing, security scans
- **Staging Environment:** Auto-deployment on main branch
- **Production Environment:** Manual approval workflow
- **Database Migrations:** Forward-compatible migration strategy
- **Container Registry:** Artifact Registry with vulnerability scanning
- **Monitoring Setup:** Basic health checks and error tracking

### Phase 7: Authentication & Authorization

- Auth.js configuration with multiple providers
- Login/signup flows with validation
- Protected routes and middleware
- Session management and security
- User roles and permissions
- Security testing and validation

### Phase 8: Advanced Features & Monitoring

- **Feature Flag System:** Gradual rollouts and A/B testing
- **Comprehensive Monitoring:** Prometheus + Grafana + Sentry
- **Performance Optimization:** Bundle analysis and optimization
- **Advanced Security:** Security headers, rate limiting, audit logging
- **User Analytics:** Privacy-focused analytics with Plausible
- **Advanced Deployments:** Canary deployments and blue-green strategies

---

## Container-Based Development Strategy

### Why Containers for This Project

**Development Benefits:**

- ✅ Identical environments (dev = CI = prod)
- ✅ Fast setup (one command to start everything)
- ✅ Easy cleanup (destroy and recreate in seconds)
- ✅ Monitoring stack included from day one
- ✅ No "works on my machine" issues
- ✅ Database changes are isolated and safe

**VS Code Dev Containers:**

- Run VS Code inside container
- Auto-install extensions
- Terminal runs in container context
- Hot reload works perfectly
- Port forwarding automatic

### Container Architecture

```
┌─────────────────────────────────────────┐
│       VS Code Dev Container             │
│  - All extensions installed             │
│  - Terminal in container                │
│  - Hot reload enabled                   │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│       Docker Compose Stack              │
├─────────────────────────────────────────┤
│  app (Next.js)          :3000           │
│  postgres (DB)          :5432           │
│  prometheus (Metrics)   :9090           │
│  grafana (Dashboards)   :3001           │
└─────────────────────────────────────────┘
```

### Multi-Stage Dockerfile Strategy

```dockerfile
# Stage 1: Dependencies (cached layer)
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# Stage 2: Builder (development & build)
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN pnpm prisma generate
RUN pnpm build

# Stage 3: Runner (production-ready)
FROM node:20-alpine AS runner
WORKDIR /app
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
```

### Development Workflow

**Morning startup:**

```bash
docker-compose up -d  # Start all services
code .                # Open VS Code
# Click "Reopen in Container"
```

**During development:**

- Code changes → Hot reload automatic
- Database changes → `pnpm prisma migrate dev`
- View metrics → http://localhost:9090
- Grafana → http://localhost:3001

**Testing:**

```bash
docker-compose exec app pnpm test        # Unit tests
docker-compose exec app pnpm test:e2e    # E2E tests
```

**Clean slate:**

```bash
docker-compose down -v  # Destroy everything
docker-compose up       # Fresh start (30 seconds)
```

## User Input & Project Decisions

**Status:** ✅ Ready to Start

**GCP Account:** ✅ Yes, billing enabled  
**Domain Name:** ❌ Not yet (will acquire later)  
**Initial Build:** 🎯 Public-facing site (no auth initially)  
**Monitoring:** 🎯 Early phase implementation (Prometheus + Grafana from start)  
**Container Development:** ✅ Yes, full Docker/Dev Container setup

---

## Resources

### Official Documentation

- Next.js: https://nextjs.org/docs
- TypeScript: https://www.typescriptlang.org/docs
- Prisma: https://www.prisma.io/docs
- Tailwind: https://tailwindcss.com/docs
- Terraform: https://developer.hashicorp.com/terraform/docs

### Learning Resources

- Next.js Learn: https://nextjs.org/learn
- TypeScript Handbook: https://www.typescriptlang.org/docs/handbook
- Web.dev (Performance): https://web.dev
- OWASP Top 10: https://owasp.org/www-project-top-ten

### Community

- Next.js Discord
- r/nextjs
- Stack Overflow
- GitHub Discussions

---

**Last Updated:** October 8, 2025  
**Version:** 1.0  
**Status:** Ready to Start Phase 4

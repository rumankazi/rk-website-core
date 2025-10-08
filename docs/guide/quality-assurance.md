# Quality Assurance Guide

This document outlines the comprehensive quality assurance processes and workflows implemented in the RK Website Core project.

## 🔍 Overview

Our QA strategy follows a **multi-layered approach** with automated checks at every stage of development:

1. **Pre-commit hooks** - Immediate feedback during development
2. **GitHub Actions workflows** - Comprehensive CI/CD pipeline
3. **Security scanning** - Continuous vulnerability monitoring
4. **Performance monitoring** - Lighthouse CI and bundle analysis

## 🛠️ Local Development Quality Checks

### Quick Commands

```bash
# Run all quality checks locally
pnpm test:all                 # Lint + Type Check + Unit Tests + E2E Tests

# Individual checks
pnpm lint                     # ESLint code quality
pnpm type-check              # TypeScript validation
pnpm test                    # Unit tests
pnpm test:e2e                # End-to-end tests
pnpm format:check            # Prettier formatting check
pnpm security:check          # Dependency vulnerability scan
```

### Git Hooks (Husky)

#### Pre-commit Hook

Automatically runs before each commit:

- ✅ **Lint staged files** - ESLint with auto-fix
- ✅ **Format staged files** - Prettier formatting
- ✅ **Type checking** - Full TypeScript validation
- ✅ **Unit tests** - Quick test suite execution

#### Pre-push Hook

Automatically runs before pushing:

- ✅ **Build verification** - Ensures production build works
- ✅ **Security audit** - Dependency vulnerability check

#### Commit Message Hook

Validates commit message format:

- ✅ **Conventional Commits** - Enforces standardized format
- ✅ **Format**: `type(scope): description`
- ✅ **Types**: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert

## 🚀 Continuous Integration (GitHub Actions)

### Quality Workflow (`.github/workflows/quality.yml`)

Comprehensive quality pipeline that runs on every push and PR:

#### 1. Security & Dependency Scan

- **Dependency audit** - `pnpm audit` for vulnerabilities
- **Snyk scanning** - Advanced security analysis
- **CodeQL analysis** - Static code security scanning

#### 2. Code Quality

- **ESLint** - Code quality and style enforcement
- **TypeScript** - Type safety validation
- **Prettier** - Code formatting verification
- **Super Linter** - Multi-language linting

#### 3. Unit & Integration Tests

- **PostgreSQL service** - Real database for testing
- **Vitest** - Modern test runner with coverage
- **Coverage reports** - Codecov integration
- **Prisma migrations** - Database schema validation

#### 4. End-to-End Tests

- **Playwright** - Cross-browser testing
- **Multi-device testing** - Desktop and mobile viewports
- **Visual regression** - Screenshot comparisons
- **API testing** - Health check validation

#### 5. Build Verification

- **Multi-Node.js versions** - Compatibility testing (Node 20, 21)
- **Production build** - Ensures deployment readiness
- **Start command test** - Application startup validation

#### 6. Docker Build Test

- **Multi-stage build** - Production-ready container
- **Security scanning** - Container vulnerability checks
- **Build optimization** - Layer caching strategies

#### 7. Performance Analysis

- **Bundle analysis** - Size optimization tracking
- **Lighthouse CI** - Performance, accessibility, SEO scores
- **Core Web Vitals** - LCP, FID, CLS monitoring

#### 8. Documentation Quality

- **Link checking** - Broken link detection
- **VitePress build** - Documentation compilation
- **Markdown validation** - Format consistency

### CodeQL Security Analysis (`.github/workflows/codeql.yml`)

- **Weekly scheduled scans** - Every Sunday at 2 AM UTC
- **JavaScript/TypeScript analysis** - Language-specific scanning
- **Security and quality queries** - Comprehensive rule set
- **SARIF upload** - GitHub Security tab integration

## 📊 Quality Metrics & Thresholds

### Test Coverage

- **Minimum**: 80% overall coverage
- **Target**: 90%+ for new features
- **Critical paths**: 95%+ coverage required

### Performance Thresholds (Lighthouse CI)

- **Performance**: ≥80 (warn), ≥90 (target)
- **Accessibility**: ≥90 (error threshold)
- **Best Practices**: ≥85 (warn)
- **SEO**: ≥80 (warn)

### Core Web Vitals

- **First Contentful Paint**: <2s (warn), <1.5s (target)
- **Largest Contentful Paint**: <4s (error), <2.5s (target)
- **Cumulative Layout Shift**: <0.1 (error), <0.05 (target)
- **Total Blocking Time**: <500ms (warn), <200ms (target)

### Security Standards

- **Dependency vulnerabilities**: Block moderate+ severity
- **CodeQL alerts**: Zero high/critical issues
- **Container security**: Regular base image updates

## 🔧 VS Code Integration

### Available Tasks (Ctrl+Shift+P → "Tasks: Run Task")

| Task               | Command               | Description              |
| ------------------ | --------------------- | ------------------------ |
| **dev**            | `pnpm dev`            | Start development server |
| **build**          | `pnpm build`          | Production build         |
| **test**           | `pnpm test`           | Run unit tests           |
| **test:watch**     | `pnpm test --watch`   | Continuous testing       |
| **test:e2e**       | `pnpm test:e2e`       | End-to-end tests         |
| **lint**           | `pnpm lint`           | Code quality check       |
| **lint:fix**       | `pnpm lint --fix`     | Auto-fix issues          |
| **type-check**     | `pnpm type-check`     | TypeScript validation    |
| **format**         | `pnpm format`         | Format all files         |
| **security:check** | `pnpm security:check` | Security audit           |

### Problem Matchers

- **TypeScript** - Integrated error reporting
- **ESLint** - Inline code quality feedback
- **Prettier** - Format-on-save support

## 🛡️ Security Measures

### Automated Security

- **Dependabot** - Automatic dependency updates
- **Snyk integration** - Continuous vulnerability monitoring
- **CodeQL scanning** - Static analysis security testing
- **Container scanning** - Docker image vulnerability checks

### Security Configuration

- **OWASP compliance** - Top 10 security practices
- **CSP headers** - Content Security Policy
- **Secure authentication** - NextAuth.js integration
- **Input validation** - Zod schemas for API endpoints

### Security Monitoring

- **GitHub Security Advisories** - Automatic vulnerability alerts
- **Regular audits** - Weekly security reviews
- **Incident response** - Documented procedures in `SECURITY.md`

## 📈 Performance Monitoring

### Build Optimization

- **Bundle analysis** - Webpack Bundle Analyzer
- **Tree shaking** - Dead code elimination
- **Code splitting** - Dynamic imports
- **Asset optimization** - Image and font optimization

### Runtime Performance

- **Core Web Vitals** - Real user monitoring
- **Lighthouse CI** - Automated performance testing
- **Error tracking** - Sentry integration (planned)

## 🚨 Quality Gates

### Merge Requirements

All PRs must pass:

- ✅ **All CI checks** - No failures allowed
- ✅ **Code review** - At least one approval
- ✅ **Security scan** - No high/critical vulnerabilities
- ✅ **Test coverage** - Maintain or improve coverage
- ✅ **Documentation** - Updated for new features

### Deployment Gates

- ✅ **Staging validation** - Full test suite in staging environment
- ✅ **Performance benchmarks** - Lighthouse scores within thresholds
- ✅ **Security clearance** - No outstanding vulnerabilities
- ✅ **Manual approval** - Final human review for production

## 📋 Quality Checklist for Developers

### Before Committing

- [ ] Code follows project style guidelines
- [ ] All tests pass locally (`pnpm test:all`)
- [ ] TypeScript has no errors (`pnpm type-check`)
- [ ] Code is properly formatted (`pnpm format`)
- [ ] Security audit passes (`pnpm security:check`)
- [ ] Commit message follows Conventional Commits format

### Before Creating PR

- [ ] Feature is fully tested (unit + integration + E2E)
- [ ] Documentation is updated
- [ ] Performance impact assessed
- [ ] Security implications reviewed
- [ ] Breaking changes documented

### Before Merging PR

- [ ] All CI checks pass
- [ ] Code review completed
- [ ] QA testing completed
- [ ] Performance regression check
- [ ] Security review completed

## 🔄 Continuous Improvement

### Regular Reviews

- **Weekly**: Review CI/CD metrics and failures
- **Monthly**: Update dependencies and security policies
- **Quarterly**: Review and update quality standards

### Metrics Tracking

- **Build success rate** - Target: >95%
- **Test execution time** - Target: <5 minutes
- **Security scan results** - Target: Zero critical issues
- **Performance scores** - Track trends over time

### Tool Updates

- **Dependencies** - Keep all tools at latest stable versions
- **GitHub Actions** - Regular workflow optimization
- **Quality thresholds** - Adjust based on project maturity

---

This comprehensive QA setup ensures that every code change meets our high standards for quality, security, and performance. The automated workflows provide fast feedback and prevent issues from reaching production.

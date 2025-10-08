# Security Configuration for rk-website-core

## Dependency Security

### Audit Configuration

- **Level**: moderate (blocks moderate and high severity vulnerabilities)
- **Auto-fix**: enabled for patches and minor updates
- **Check frequency**: daily in CI, on every commit locally

### Known Acceptable Risks

# Document any accepted vulnerabilities with justification

# Format: vulnerability-id: justification

# Example:

# GHSA-xxxx-xxxx-xxxx: Dev dependency, not used in production

## Code Security

### ESLint Security Rules

- `security/detect-object-injection`: error
- `security/detect-non-literal-regexp`: warn
- `security/detect-unsafe-regex`: error
- `security/detect-buffer-noassert`: error
- `security/detect-eval-with-expression`: error
- `security/detect-no-csrf-before-method-override`: error

### Environment Variables

- Never commit secrets to repository
- Use `.env.example` for documentation
- All production secrets managed via Secret Manager
- Local development uses non-sensitive defaults

## Docker Security

### Base Image

- Use official Node.js Alpine images (minimal attack surface)
- Pin specific versions (no `latest` tag)
- Regular updates to patch security vulnerabilities

### Container Security

- Run as non-root user (nextjs:1001)
- Read-only root filesystem where possible
- Minimal set of installed packages
- Health checks for monitoring

## API Security

### Authentication

- NextAuth.js for secure authentication
- Secure session management
- CSRF protection enabled
- Rate limiting on sensitive endpoints

### Headers

- Security headers via Next.js configuration
- Content Security Policy (CSP)
- X-Frame-Options: DENY
- X-Content-Type-Options: nosniff
- Referrer-Policy: strict-origin-when-cross-origin

## Database Security

### Prisma Configuration

- Connection pooling for DoS protection
- Input validation with Zod schemas
- Parameterized queries (automatic with Prisma)
- Row-level security where applicable

### Data Protection

- Encryption at rest (managed by Cloud SQL)
- Encryption in transit (TLS/SSL)
- Regular backups with encryption
- Access logging enabled

## Monitoring & Alerting

### Security Monitoring

- Dependabot for dependency updates
- CodeQL for static analysis
- Snyk for vulnerability scanning
- Regular penetration testing

### Incident Response

- Security incidents tracked in GitHub Issues
- Automated alerting for critical vulnerabilities
- Response team: @rumankazi
- Escalation path documented in runbooks

## Compliance

### Data Privacy

- GDPR compliance for EU users
- User data minimization
- Right to deletion implemented
- Privacy policy maintained

### Industry Standards

- OWASP Top 10 compliance
- Secure development lifecycle
- Regular security training
- Third-party security audits

## Regular Security Tasks

### Weekly

- [ ] Review Dependabot PRs
- [ ] Check security scan results
- [ ] Update dependencies

### Monthly

- [ ] Security audit of new features
- [ ] Review access logs
- [ ] Update security documentation

### Quarterly

- [ ] Penetration testing
- [ ] Security training
- [ ] Incident response drills
- [ ] Review and update security policies

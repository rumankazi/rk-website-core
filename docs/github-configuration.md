# GitHub Repository Configuration

This document outlines the recommended GitHub repository settings for optimal security, quality assurance, and automated workflows.

## Branch Protection Rules

### Main Branch Protection

Configure the following settings for the `main` branch:

```yaml
# Recommended settings for main branch protection
Require a pull request before merging: ✅
  Require approvals: 1
  Dismiss stale PR approvals when new commits are pushed: ✅
  Require review from code owners: ✅

Require status checks to pass before merging: ✅
  Require branches to be up to date before merging: ✅
  Status checks that are required:
    - Quality Gate
    - build
    - test
    - lint
    - type-check
    - security-audit
    - e2e-tests
    - performance-check

Require conversation resolution before merging: ✅
Require signed commits: ✅ (recommended)
Require linear history: ✅
Allow force pushes: ❌
Allow deletions: ❌

Restrict pushes that create files: ✅
  Restrict pushes that create files matching a path: package-lock.json, yarn.lock
```

### Development Branch Protection

For `develop` or feature branches:

```yaml
Require a pull request before merging: ✅
  Require approvals: 1
  Allow specified actors to bypass required pull requests: ✅
    - dependabot[bot]
    - github-actions[bot]

Require status checks to pass before merging: ✅
  Status checks that are required:
    - Quality Gate
    - build
    - test
    - lint

Allow force pushes: ✅ (for rebasing)
Allow deletions: ✅
```

## Repository Settings

### General Settings

```yaml
# Features
Issues: ✅
Projects: ✅
Wiki: ❌ (use docs/ instead)
Discussions: ✅ (optional)
Sponsorships: ❌

# Pull Requests
Allow merge commits: ❌
Allow squash merging: ✅
Allow rebase merging: ✅
Always suggest updating pull request branches: ✅
Allow auto-merge: ✅
Automatically delete head branches: ✅

# Archives
Include Git LFS objects in archives: ✅
```

### Security Settings

```yaml
# Security & Analysis
Dependency graph: ✅
Dependabot alerts: ✅
Dependabot security updates: ✅
Dependabot version updates: ✅

Code scanning: ✅
  CodeQL analysis: ✅
  Third-party tools: ✅

Secret scanning: ✅
  Push protection: ✅

Private vulnerability reporting: ✅
```

### Actions Settings

```yaml
# Actions permissions
Allow all actions and reusable workflows: ✅
Allow actions created by GitHub: ✅
Allow actions by Marketplace verified creators: ✅
Allow specified actions and reusable workflows: ✅

# Workflow permissions
Read repository contents and packages permissions: ✅
Write permissions: ✅ (for auto-merge and releases)

# Fork pull request workflows
Run workflows from fork pull requests: ✅
Send write tokens to workflows from fork pull requests: ❌
Send secrets to workflows from fork pull requests: ❌
```

## Environment Protection Rules

### Production Environment

```yaml
Environment name: production

Environment protection rules:
Required reviewers: ✅
  - @rumankazi
  - @senior-dev-team (if applicable)

Wait timer: 0 minutes
Prevent administrators from bypassing configured protection rules: ✅

Environment secrets:
  DATABASE_URL: [Production database connection]
  NEXTAUTH_SECRET: [Production auth secret]
  GOOGLE_CLIENT_ID: [Production OAuth client]
  GOOGLE_CLIENT_SECRET: [Production OAuth secret]
  SENTRY_DSN: [Production error tracking]
```

### Staging Environment

```yaml
Environment name: staging

Environment protection rules:
Required reviewers: ❌ (auto-deploy)
Wait timer: 0 minutes

Environment secrets:
  DATABASE_URL: [Staging database connection]
  NEXTAUTH_SECRET: [Staging auth secret]
  # ... other staging secrets
```

## Secrets and Variables

### Repository Secrets

Required secrets for CI/CD workflows:

```yaml
# Authentication
NEXTAUTH_SECRET: Random string for NextAuth.js
GOOGLE_CLIENT_ID: Google OAuth client ID
GOOGLE_CLIENT_SECRET: Google OAuth client secret

# Database
DATABASE_URL: PostgreSQL connection string
DIRECT_URL: Direct database connection (for migrations)

# Monitoring & Analytics
SENTRY_DSN: Sentry error tracking DSN
SENTRY_AUTH_TOKEN: Sentry authentication token
PLAUSIBLE_API_KEY: Plausible analytics API key

# Deployment
GCP_SERVICE_ACCOUNT_KEY: Google Cloud service account JSON
DOCKER_REGISTRY_URL: Container registry URL
DOCKER_USERNAME: Registry username
DOCKER_PASSWORD: Registry password

# Notifications
SLACK_WEBHOOK_URL: Slack notifications webhook
DISCORD_WEBHOOK_URL: Discord notifications webhook
```

### Repository Variables

Environment-agnostic configuration:

```yaml
# Application
NODE_VERSION: '20'
PNPM_VERSION: 'latest'
POSTGRES_VERSION: '15'

# Build
DOCKER_BUILDKIT: '1'
COMPOSE_DOCKER_CLI_BUILD: '1'

# Testing
PLAYWRIGHT_BROWSERS: 'chromium,firefox,webkit'
E2E_BASE_URL: 'http://localhost:3000'

# Quality
COVERAGE_THRESHOLD: '90'
BUNDLE_SIZE_LIMIT: '500kb'
```

## Labels Configuration

Create these labels for better issue and PR management:

```yaml
# Type labels
- name: 'bug 🐛'
  color: 'd73a4a'
  description: "Something isn't working"

- name: 'feature ✨'
  color: 'a2eeef'
  description: 'New feature or request'

- name: 'enhancement 🚀'
  color: '84b6eb'
  description: 'Improvement to existing feature'

- name: 'documentation 📚'
  color: '0075ca'
  description: 'Improvements or additions to documentation'

- name: 'security 🔒'
  color: 'b60205'
  description: 'Security-related issue or update'

# Priority labels
- name: 'priority-critical ‼️'
  color: 'b60205'
  description: 'Critical priority - immediate attention required'

- name: 'priority-high 📈'
  color: 'd93f0b'
  description: 'High priority'

- name: 'priority-medium ➡️'
  color: 'fbca04'
  description: 'Medium priority'

- name: 'priority-low 📉'
  color: '0e8a16'
  description: 'Low priority'

# Status labels
- name: 'needs-review 👀'
  color: 'fbca04'
  description: 'Awaiting review'

- name: 'needs-testing 🧪'
  color: '1d76db'
  description: 'Requires testing'

- name: 'ready-to-merge ✅'
  color: '0e8a16'
  description: 'Approved and ready for merge'

- name: 'blocked 🚫'
  color: 'b60205'
  description: 'Blocked by external dependency'

# Automation labels
- name: 'auto-mergeable 🤖'
  color: '006b75'
  description: 'Can be automatically merged'

- name: 'major-update ⬆️'
  color: 'd93f0b'
  description: 'Major version update'

- name: 'minor-update ⬆️'
  color: 'fbca04'
  description: 'Minor version update'

- name: 'patch-update ⬆️'
  color: '0e8a16'
  description: 'Patch version update'

# Dependencies
- name: 'dependencies 📦'
  color: '0366d6'
  description: 'Pull request that updates a dependency file'

- name: 'react 🔵'
  color: '61dafb'
  description: 'React-related changes'

- name: 'nextjs ⚫'
  color: '000000'
  description: 'Next.js-related changes'

- name: 'typescript 🔷'
  color: '3178c6'
  description: 'TypeScript-related changes'

- name: 'prisma 🗃️'
  color: '2d3748'
  description: 'Database/Prisma-related changes'
```

## Webhooks Configuration

### Slack Integration

```yaml
Payload URL: https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
Content type: application/json
SSL verification: Enable SSL verification

Events:
  - Push
  - Pull request (opened, closed, reopened)
  - Issues (opened, closed)
  - Release (published)
  - Deployment status
  - Check run (completed)
```

### Discord Integration

```yaml
Payload URL: https://discord.com/api/webhooks/YOUR/DISCORD/WEBHOOK
Content type: application/json

Events:
  - Push
  - Pull request (opened, closed)
  - Release (published)
  - Deployment status
```

## Code Owners

Create a `.github/CODEOWNERS` file:

```
# Global owners
* @rumankazi

# Frontend components
/src/components/ @rumankazi @frontend-team

# API routes
/src/app/api/ @rumankazi @backend-team

# Database
/prisma/ @rumankazi @database-team

# Infrastructure
/docker* @rumankazi @devops-team
/.github/workflows/ @rumankazi @devops-team
/terraform/ @rumankazi @devops-team

# Documentation
/docs/ @rumankazi @documentation-team
*.md @rumankazi @documentation-team

# Configuration
package.json @rumankazi
tsconfig.json @rumankazi
next.config.js @rumankazi
tailwind.config.js @rumankazi
```

## Issue Templates

The repository should have issue templates for:

1. **Bug Report** (`bug_report.yml`)
2. **Feature Request** (`feature_request.yml`)
3. **Security Issue** (`security_report.yml`)
4. **Documentation** (`documentation.yml`)
5. **Performance Issue** (`performance.yml`)

## Pull Request Templates

Create `.github/pull_request_template.md`:

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Testing

- [ ] Unit tests pass locally
- [ ] Integration tests pass locally
- [ ] E2E tests pass locally
- [ ] Manual testing completed
- [ ] Performance impact assessed

## Quality Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No console.log or debug code
- [ ] TypeScript types are properly defined

## Screenshots (if applicable)

Add screenshots or GIFs for UI changes

## Additional Notes

Any additional information that reviewers should know
```

## Automation Scripts

For repository setup automation, consider creating scripts:

1. **Setup script** (`scripts/setup-repo.sh`)
2. **Label creation** (`scripts/create-labels.js`)
3. **Branch protection** (`scripts/setup-branch-protection.js`)

This configuration ensures maximum security, quality assurance, and automated workflows while maintaining developer productivity.

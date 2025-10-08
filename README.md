# RK Website Core

Modern TypeScript/Next.js full-stack development with comprehensive DevOps automation and documentation.

[![Documentation](https://img.shields.io/badge/docs-VitePress-blue)](https://rumankazi.github.io/rk-website-core/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🚀 Quick Start

```bash
# Clone and open in VS Code Dev Container
git clone https://github.com/rumankazi/rk-website-core.git
cd rk-website-core
code .
# Click "Reopen in Container" when prompted

# Install dependencies and start development
pnpm install
pnpm dev
```

## 📚 Documentation

Complete documentation is automatically published at:
**[https://rumankazi.github.io/rk-website-core/](https://rumankazi.github.io/rk-website-core/)**

### Local Documentation Development

```bash
cd docs
npm install
npm run docs:dev    # Start VitePress dev server on :5173
npm run docs:build  # Build static documentation
```

## 🛠️ Tech Stack

- **Framework**: Next.js 14+ with App Router
- **Language**: TypeScript (strict mode)
- **Database**: PostgreSQL with Prisma ORM
- **Styling**: Tailwind CSS
- **Authentication**: Auth.js (NextAuth v5)
- **Testing**: Vitest (unit) + Playwright (E2E)
- **Infrastructure**: Docker, Terraform, Google Cloud Platform
- **CI/CD**: GitHub Actions with quality gates
- **Documentation**: VitePress with auto-publishing

## 🏗️ Architecture

Container-first development with production-ready patterns:

- **Dev Environment**: VS Code Dev Containers with all tools pre-configured
- **Local Stack**: docker-compose with PostgreSQL, Prometheus, Grafana
- **Production**: Google Cloud Run with Cloud SQL and comprehensive monitoring
- **Security**: Built-in security measures, automated vulnerability scanning
- **Observability**: Prometheus + Grafana + Sentry + Plausible analytics

## 📁 Project Structure

```
├── src/app/              # Next.js App Router (pages, API routes)
├── src/components/       # React components (UI + features)
├── src/lib/              # Database, auth, utilities
├── prisma/               # Database schema and migrations
├── tests/                # Unit, integration, and E2E tests
├── docs/                 # VitePress documentation (auto-published)
├── infrastructure/       # Terraform IaC configurations
├── .devcontainer/        # VS Code Dev Container setup
├── .vscode/              # VS Code settings and extensions
└── .github/workflows/    # CI/CD automation
```

## 🔧 Development Workflow

### Essential Commands

```bash
# Development
pnpm dev              # Start Next.js dev server
pnpm test             # Run unit tests
pnpm test:e2e         # Run E2E tests
pnpm lint             # Run ESLint
pnpm type-check       # TypeScript checking

# Database
pnpm prisma migrate dev    # Run migrations
pnpm prisma studio         # Open Prisma Studio
pnpm prisma generate       # Generate client

# Infrastructure
docker-compose up -d       # Start local services
docker-compose down        # Stop services
```

### VS Code Integration

Pre-configured with 16 essential extensions:

- ESLint, Prettier, TypeScript support
- Tailwind CSS IntelliSense
- Prisma, Playwright, Docker support
- GitLens, GitHub Actions, Copilot
- Error Lens, Path Intellisense

All available via Tasks (Ctrl+Shift+P → "Tasks: Run Task")

## 🚢 Deployment

### Automatic Deployments

- **Staging**: Auto-deploy on every push to `main`
- **Production**: Manual approval required
- **Documentation**: Auto-published to GitHub Pages

### Infrastructure as Code

All cloud resources managed with Terraform:

- Cloud Run (serverless containers)
- Cloud SQL (managed PostgreSQL)
- Load balancers, storage, monitoring
- Security and networking configuration

## 📊 Monitoring & Observability

Comprehensive monitoring from day one:

- **Infrastructure**: GCP Cloud Monitoring
- **Application**: Prometheus + Grafana dashboards
- **Errors**: Sentry error tracking
- **Analytics**: Plausible (privacy-focused)
- **Performance**: Lighthouse CI in GitHub Actions

## 🔒 Security

Security built into every layer:

- Automated dependency vulnerability scanning
- Container and infrastructure security scanning
- Input validation with Zod schemas
- Secrets managed with Google Secret Manager
- HTTPS everywhere with automatic SSL certificates

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make changes with tests and documentation updates
4. Commit changes (`git commit -m 'Add amazing feature'`)
5. Push to branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

All contributions automatically trigger quality checks, tests, and security scans.

## 📖 Learning Resources

This project is designed for learning modern web development:

- Complete documentation with rationale for every decision
- Step-by-step guides for all development tasks
- Architecture patterns and best practices
- DevOps automation examples
- Security implementation guidelines

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Built with modern tools and inspired by production-ready patterns:

- Next.js team for the excellent framework
- Prisma for type-safe database access
- Vercel for deployment inspiration
- Google Cloud Platform for reliable infrastructure

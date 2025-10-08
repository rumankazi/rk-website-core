---
layout: home

hero:
  name: 'RK Website Core'
  text: 'Modern TypeScript/Next.js Development'
  tagline: 'Complete full-stack development documentation with DevOps automation'
  image:
    src: /hero-image.png
    alt: RK Website Core
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: View on GitHub
      link: https://github.com/rumankazi/rk-website-core

features:
  - icon: ⚡
    title: Modern Tech Stack
    details: TypeScript, Next.js 14+, Prisma ORM, Tailwind CSS, and PostgreSQL with complete type safety.

  - icon: 🐳
    title: Container-First Development
    details: Docker containers, VS Code Dev Containers, and docker-compose for consistent development environments.

  - icon: 🔒
    title: Security by Default
    details: Built-in security measures, automated vulnerability scanning, and best practices enforcement.

  - icon: 🚀
    title: DevOps Automation
    details: GitHub Actions CI/CD, Infrastructure as Code with Terraform, and multi-environment deployments.

  - icon: 📊
    title: Comprehensive Monitoring
    details: Prometheus, Grafana, Sentry, and Plausible for complete observability and user analytics.

  - icon: 📚
    title: Documentation-Driven
    details: Auto-generated, version-controlled documentation with VitePress and automated publishing.
---

## Quick Start

Get up and running in minutes with the container-first development environment:

```bash
# Clone the repository
git clone https://github.com/rumankazi/rk-website-core.git
cd rk-website-core

# Open in VS Code Dev Container
code .
# Click "Reopen in Container" when prompted

# Install dependencies
pnpm install

# Start development server
pnpm dev
```

## Architecture Overview

This project follows a **container-first development strategy** with:

- **Next.js 14+** with App Router for modern React development
- **TypeScript** in strict mode for type safety
- **Prisma ORM** for type-safe database operations
- **Tailwind CSS** for utility-first styling
- **Cloud Run** deployment on Google Cloud Platform
- **Terraform** for Infrastructure as Code
- **GitHub Actions** for comprehensive CI/CD

## Project Structure

```
├── src/app/              # Next.js App Router
├── src/components/       # Reusable UI components
├── src/lib/             # Database, auth, and utilities
├── prisma/              # Database schema and migrations
├── tests/               # Unit, integration, and E2E tests
├── docs/                # VitePress documentation
├── infrastructure/      # Terraform IaC configurations
├── .devcontainer/       # VS Code Dev Container setup
└── .github/workflows/   # CI/CD automation
```

## Key Features

- **🔧 Complete Development Environment**: VS Code Dev Containers with all tools pre-configured
- **📦 Monorepo Structure**: Organized codebase with clear separation of concerns
- **🧪 Comprehensive Testing**: Unit tests (Vitest), E2E tests (Playwright), and integration testing
- **📈 Quality Automation**: ESLint, Prettier, TypeScript, and security scanning in CI/CD
- **🌍 Multi-Environment Deployment**: Separate staging and production environments
- **📖 Living Documentation**: Auto-updated documentation with every code change

---

::: tip Development Philosophy
This project emphasizes **learning through building** - documenting every decision, implementing best practices, and automating everything possible for a production-ready development experience.
:::

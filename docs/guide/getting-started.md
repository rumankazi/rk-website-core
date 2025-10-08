# Getting Started

Welcome to the RK Website Core development environment! This guide will get you up and running quickly.

## Prerequisites

- **Git** - Version control
- **Docker** - Container runtime
- **VS Code** - Code editor with Dev Containers extension
- **Node.js 20+** (if developing without containers)

## Quick Setup

### 1. Clone the Repository

```bash
git clone https://github.com/rumankazi/rk-website-core.git
cd rk-website-core
```

### 2. Open in Dev Container

The easiest way to get started is using VS Code Dev Containers:

1. Open the project in VS Code: `code .`
2. VS Code will prompt: **"Reopen in Container"** - click it
3. Wait for the container to build (first time takes ~5 minutes)
4. All extensions and tools will be automatically installed

### 3. Install Dependencies

Once inside the container:

```bash
pnpm install
```

### 4. Set Up Environment

Copy the environment template:

```bash
cp .env.example .env.local
```

Edit `.env.local` with your configuration (database URLs, API keys, etc.)

### 5. Database Setup

Start the PostgreSQL database:

```bash
# Start database in background
docker-compose up -d postgres

# Run initial migrations
pnpm prisma migrate dev

# Generate Prisma client
pnpm prisma generate
```

### 6. Start Development

```bash
pnpm dev
```

Your application will be available at:

- **Next.js App**: http://localhost:3000
- **Prisma Studio**: http://localhost:5555 (run `pnpm prisma studio`)

## Alternative: Local Development

If you prefer developing without containers:

### Requirements

- Node.js 20+
- PostgreSQL 14+
- pnpm

### Setup Steps

```bash
# Install pnpm globally
npm install -g pnpm

# Install dependencies
pnpm install

# Set up database (adjust connection string in .env.local)
pnpm prisma migrate dev

# Start development
pnpm dev
```

## Verify Installation

Run these commands to ensure everything works:

```bash
# Type checking
pnpm type-check

# Linting
pnpm lint

# Unit tests
pnpm test

# Build production bundle
pnpm build
```

## Development Tools Available

### VS Code Tasks

Access via **Ctrl+Shift+P → "Tasks: Run Task"**:

- `dev` - Start development server
- `test` / `test:watch` - Run tests
- `lint` / `lint:fix` - Code quality
- `type-check` - TypeScript validation
- `prisma:migrate` - Database migrations
- `docker:up` / `docker:down` - Container management

### Debugging

- **F5** - Start debugging (Next.js full-stack)
- **Ctrl+Shift+D** - Open debug panel
- Breakpoints work in both server and client code

### Database Management

```bash
# Open Prisma Studio
pnpm prisma studio

# Reset database (development only!)
pnpm prisma migrate reset

# Generate client after schema changes
pnpm prisma generate
```

## Project Structure Overview

```
rk-website-core/
├── src/
│   ├── app/              # Next.js App Router pages
│   ├── components/       # React components
│   └── lib/             # Utilities, database, auth
├── prisma/
│   ├── schema.prisma    # Database schema
│   └── migrations/      # Migration history
├── tests/
│   ├── unit/           # Vitest unit tests
│   └── e2e/            # Playwright E2E tests
├── docs/               # VitePress documentation
├── .devcontainer/      # Dev container configuration
└── .vscode/           # VS Code settings
```

## Next Steps

1. **Read the [Development Workflow](./development.md)** for daily development practices
2. **Explore [Architecture Overview](../architecture/overview.md)** to understand the system design
3. **Check [VS Code Setup](./vscode-setup.md)** for productivity tips
4. **Review [Deployment Process](./deployment.md)** for release management

## Getting Help

- **Architecture Questions**: Check `docs/architecture/`
- **API Documentation**: See `docs/api/`
- **Infrastructure**: Review `docs/infrastructure/`
- **Issues**: Create GitHub issues for bugs or feature requests

---

::: tip Container Benefits
The Dev Container approach ensures everyone has the exact same development environment, eliminating "works on my machine" issues and enabling instant onboarding.
:::

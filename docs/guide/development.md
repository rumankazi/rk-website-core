# Development Workflow

This guide outlines the daily development practices and workflows for contributing to the project.

## Daily Development Cycle

### 1. Morning Startup

```bash
# Pull latest changes
git pull origin main

# Ensure containers are running
docker-compose up -d

# Start development server
pnpm dev

# In another terminal: start test watch mode
pnpm test:watch
```

### 2. Feature Development

#### Creating a New Feature

```bash
# Create feature branch from main
git checkout -b feature/user-authentication

# Work on your feature...
# Code, test, commit frequently

# Run quality checks before pushing
pnpm lint
pnpm type-check
pnpm test
```

#### Branch Naming Convention

- **Features**: `feature/description-of-feature`
- **Bug fixes**: `fix/description-of-bug`
- **Documentation**: `docs/description-of-update`
- **Infrastructure**: `infra/description-of-change`
- **Refactoring**: `refactor/description-of-refactor`

### 3. Code Quality Standards

#### Pre-commit Checklist

Before every commit, ensure:

- [ ] Code is formatted with Prettier
- [ ] ESLint passes with no errors
- [ ] TypeScript compiles without errors
- [ ] Unit tests pass
- [ ] Documentation is updated if needed

#### Automated Quality Checks

The project has pre-commit hooks that automatically run:

```bash
# These run automatically on git commit
- prettier --write
- eslint --fix
- type checking
```

### 4. Testing Strategy

#### Unit Tests (Vitest)

```bash
# Run all tests
pnpm test

# Watch mode during development
pnpm test:watch

# Coverage report
pnpm test:coverage
```

#### Integration Tests

```bash
# Test API endpoints
pnpm test:integration

# Test database operations
pnpm test:db
```

#### E2E Tests (Playwright)

```bash
# Run E2E tests
pnpm test:e2e

# Run in headed mode (see browser)
pnpm test:e2e --headed

# Run specific test
pnpm test:e2e tests/e2e/auth.spec.ts
```

## Database Development Workflow

### Schema Changes

1. **Update Prisma Schema**:

   ```typescript
   // prisma/schema.prisma
   model User {
     id    String @id @default(cuid())
     email String @unique
     name  String?
     // Add your new fields here
   }
   ```

2. **Create and Apply Migration**:

   ```bash
   pnpm prisma migrate dev --name add-user-profile
   ```

3. **Generate Updated Client**:

   ```bash
   pnpm prisma generate
   ```

4. **Update TypeScript Types** (if needed):
   ```bash
   # Types are automatically generated from Prisma schema
   # Import them in your code:
   import type { User, Prisma } from '@prisma/client'
   ```

### Database Reset (Development Only)

```bash
# ⚠️ This will delete all data!
pnpm prisma migrate reset
```

## Component Development

### Creating UI Components

```bash
# Create in appropriate directory
mkdir src/components/ui/Button
touch src/components/ui/Button/Button.tsx
touch src/components/ui/Button/Button.test.tsx
touch src/components/ui/Button/index.ts
```

### Component Structure

```typescript
// src/components/ui/Button/Button.tsx
import { cn } from "@/lib/utils";

interface ButtonProps {
  variant?: "primary" | "secondary" | "ghost";
  size?: "sm" | "md" | "lg";
  children: React.ReactNode;
}

export function Button({
  variant = "primary",
  size = "md",
  children,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(
        "rounded-md font-medium transition-colors",
        {
          "bg-blue-600 text-white hover:bg-blue-700": variant === "primary",
          "bg-gray-200 text-gray-900 hover:bg-gray-300":
            variant === "secondary",
        },
        {
          "px-3 py-1.5 text-sm": size === "sm",
          "px-4 py-2": size === "md",
          "px-6 py-3 text-lg": size === "lg",
        }
      )}
      {...props}
    >
      {children}
    </button>
  );
}
```

### Component Testing

```typescript
// src/components/ui/Button/Button.test.tsx
import { render, screen } from "@testing-library/react";
import { Button } from "./Button";

describe("Button", () => {
  it("renders with correct text", () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole("button")).toHaveTextContent("Click me");
  });

  it("applies primary variant styles", () => {
    render(<Button variant="primary">Primary</Button>);
    const button = screen.getByRole("button");
    expect(button).toHaveClass("bg-blue-600");
  });
});
```

## API Development

### Creating API Routes

```typescript
// src/app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'
import { db } from '@/lib/db'

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
})

export async function GET() {
  try {
    const users = await db.user.findMany()
    return NextResponse.json(users)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch users' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { email, name } = CreateUserSchema.parse(body)

    const user = await db.user.create({
      data: { email, name },
    })

    return NextResponse.json(user, { status: 201 })
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid input', details: error.errors },
        { status: 400 }
      )
    }

    return NextResponse.json(
      { error: 'Failed to create user' },
      { status: 500 }
    )
  }
}
```

### API Testing

```typescript
// tests/integration/api/users.test.ts
import { describe, it, expect } from 'vitest'
import { testClient } from '@/tests/helpers/api-client'

describe('/api/users', () => {
  it('creates a new user', async () => {
    const userData = {
      email: 'test@example.com',
      name: 'Test User',
    }

    const response = await testClient.post('/api/users', userData)

    expect(response.status).toBe(201)
    expect(response.body).toMatchObject(userData)
  })
})
```

## Documentation Workflow

### Updating Documentation

Documentation is automatically published, so keep it current:

1. **Update relevant docs** when making changes:

   ```bash
   # Architecture changes
   docs/architecture/

   # New API endpoints
   docs/api/

   # Infrastructure changes
   docs/infrastructure/
   ```

2. **Preview documentation** locally:

   ```bash
   cd docs
   pnpm docs:dev
   # Visit http://localhost:5173
   ```

3. **Build documentation**:
   ```bash
   pnpm docs:build
   ```

### Documentation Standards

- Use **clear headings** and structure
- Include **code examples** for all features
- Add **diagrams** for complex architecture
- Keep **API documentation** current with OpenAPI specs
- Update **changelog** for user-facing changes

## Git Workflow

### Commit Message Format

```
type(scope): description

[optional body]

[optional footer]
```

**Types**: feat, fix, docs, style, refactor, test, chore

**Examples**:

```bash
feat(auth): add user login functionality
fix(api): handle validation errors in user creation
docs(readme): update development setup instructions
```

### Pull Request Process

1. **Create feature branch**
2. **Make changes** with tests and documentation
3. **Push branch** to GitHub
4. **Create Pull Request** with:
   - Clear title and description
   - Link to related issues
   - Screenshots for UI changes
   - Updated documentation links
5. **Address review feedback**
6. **Squash and merge** when approved

### CI/CD Pipeline

Every PR triggers:

- **Quality checks**: ESLint, Prettier, TypeScript
- **Security scans**: Snyk, npm audit, Trivy
- **Tests**: Unit, integration, E2E
- **Build verification**: Next.js build, Docker image
- **Documentation**: Build and deploy preview

## Environment Management

### Development Environment

```bash
# Local development with hot reload
pnpm dev

# Database: PostgreSQL in Docker
# Monitoring: Grafana on :3001, Prometheus on :9090
```

### Staging Environment

```bash
# Deployed automatically on main branch push
# URL: https://staging.your-domain.com
# Uses staging database and external services
```

### Production Environment

```bash
# Manual deployment from main branch
# URL: https://your-domain.com
# Full monitoring and alerting enabled
```

## Performance Optimization

### Bundle Analysis

```bash
# Analyze bundle size
pnpm build:analyze

# View bundle analyzer report
open .next/analyze/client.html
```

### Database Performance

```bash
# View slow queries
pnpm prisma studio
# Monitor query performance in Grafana dashboard
```

### Monitoring

- **Application**: Sentry for error tracking
- **Performance**: Lighthouse CI in GitHub Actions
- **Infrastructure**: Prometheus + Grafana
- **User Analytics**: Plausible (privacy-focused)

---

::: tip Development Philosophy
Focus on **incremental improvements**, **comprehensive testing**, and **thorough documentation**. Every change should make the codebase more maintainable and the development experience better.
:::

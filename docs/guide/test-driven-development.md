# Test-Driven Development (TDD) Guide

This guide covers the Test-Driven Development methodology used throughout the RK Website Core project.

## TDD Philosophy

> **"Red, Green, Refactor"** - The fundamental cycle of TDD

Test-Driven Development is not just about testing; it's a design methodology that helps create:

- **Better code architecture** through test-first thinking
- **Higher confidence** in code changes and refactoring
- **Living documentation** through descriptive tests
- **Reduced debugging time** by catching issues early
- **Simplified code** by writing only what's needed to pass tests

## The TDD Cycle

### 1. RED Phase - Write a Failing Test

Write the **smallest possible test** that describes the desired behavior:

```typescript
// tests/unit/utils/formatCurrency.test.ts
import { describe, it, expect } from 'vitest'
import { formatCurrency } from '@/lib/utils/formatCurrency'

describe('formatCurrency', () => {
  it('should format a number as USD currency', () => {
    // This test will fail because formatCurrency doesn't exist yet
    const result = formatCurrency(1234.56)
    expect(result).toBe('$1,234.56')
  })
})
```

**Key Principles for RED Phase:**

- Test should **fail for the right reason** (not because of syntax errors)
- Write **one test at a time**
- Focus on **behavior, not implementation**
- Use **descriptive test names** that explain the expected behavior

### 2. GREEN Phase - Make the Test Pass

Write the **minimal code** to make the test pass:

```typescript
// src/lib/utils/formatCurrency.ts
export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  }).format(amount)
}
```

**Key Principles for GREEN Phase:**

- Write the **simplest code** that makes the test pass
- Don't worry about perfect design yet
- **Avoid premature optimization**
- Focus on making the test green, not beautiful code

### 3. REFACTOR Phase - Improve the Code

Improve the code while keeping tests green:

```typescript
// src/lib/utils/formatCurrency.ts (refactored)
export interface CurrencyOptions {
  currency?: string
  locale?: string
}

export function formatCurrency(
  amount: number,
  options: CurrencyOptions = {}
): string {
  const { currency = 'USD', locale = 'en-US' } = options

  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency,
  }).format(amount)
}
```

**Key Principles for REFACTOR Phase:**

- **Run tests frequently** to ensure nothing breaks
- Improve **code structure, naming, and design**
- **Extract common patterns** and eliminate duplication
- **Add more test cases** to cover edge cases

## TDD by Layer

### Unit Tests - Pure Functions and Utilities

**Test pure functions, utilities, and business logic:**

```typescript
// tests/unit/lib/validators.test.ts
import { describe, it, expect } from 'vitest'
import { validateEmail, validatePassword } from '@/lib/validators'

describe('validateEmail', () => {
  it('should return true for valid email addresses', () => {
    expect(validateEmail('user@example.com')).toBe(true)
    expect(validateEmail('test.email+tag@example.co.uk')).toBe(true)
  })

  it('should return false for invalid email addresses', () => {
    expect(validateEmail('invalid-email')).toBe(false)
    expect(validateEmail('')).toBe(false)
    expect(validateEmail('user@')).toBe(false)
  })

  it('should handle edge cases', () => {
    expect(validateEmail(null as any)).toBe(false)
    expect(validateEmail(undefined as any)).toBe(false)
  })
})

describe('validatePassword', () => {
  it('should require minimum 8 characters', () => {
    expect(validatePassword('short')).toBe(false)
    expect(validatePassword('longenough123')).toBe(true)
  })

  it('should require at least one number', () => {
    expect(validatePassword('noNumbersHere')).toBe(false)
    expect(validatePassword('hasNumber1')).toBe(true)
  })
})
```

### Component Tests - React Components

**Test component behavior, not implementation details:**

```typescript
// tests/unit/components/Button.test.tsx
import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import { Button } from "@/components/ui/Button";

describe("Button", () => {
  it("should render with correct text", () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole("button")).toHaveTextContent("Click me");
  });

  it("should call onClick handler when clicked", () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByRole("button"));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it("should be disabled when disabled prop is true", () => {
    render(<Button disabled>Cannot click</Button>);
    expect(screen.getByRole("button")).toBeDisabled();
  });

  it("should apply correct variant styles", () => {
    render(<Button variant="primary">Primary</Button>);
    const button = screen.getByRole("button");
    expect(button).toHaveClass("bg-blue-600"); // Adjust based on your styles
  });
});
```

### Integration Tests - API Routes

**Test API endpoints with database interactions:**

```typescript
// tests/integration/api/users.test.ts
import { describe, it, expect, beforeEach, afterEach } from 'vitest'
import { testClient } from '@/tests/helpers/api-client'
import { cleanupDatabase, seedTestData } from '@/tests/helpers/database'

describe('/api/users', () => {
  beforeEach(async () => {
    await cleanupDatabase()
    await seedTestData()
  })

  afterEach(async () => {
    await cleanupDatabase()
  })

  describe('POST /api/users', () => {
    it('should create a new user with valid data', async () => {
      const userData = {
        email: 'test@example.com',
        name: 'Test User',
      }

      const response = await testClient.post('/api/users', userData)

      expect(response.status).toBe(201)
      expect(response.body).toMatchObject({
        email: userData.email,
        name: userData.name,
        id: expect.any(String),
      })
    })

    it('should return 400 for invalid email', async () => {
      const userData = {
        email: 'invalid-email',
        name: 'Test User',
      }

      const response = await testClient.post('/api/users', userData)

      expect(response.status).toBe(400)
      expect(response.body.error).toContain('Invalid email')
    })

    it('should return 409 for duplicate email', async () => {
      const userData = {
        email: 'existing@example.com',
        name: 'Test User',
      }

      // First request should succeed
      await testClient.post('/api/users', userData)

      // Second request should fail
      const response = await testClient.post('/api/users', userData)
      expect(response.status).toBe(409)
    })
  })

  describe('GET /api/users', () => {
    it('should return list of users', async () => {
      const response = await testClient.get('/api/users')

      expect(response.status).toBe(200)
      expect(Array.isArray(response.body)).toBe(true)
      expect(response.body.length).toBeGreaterThan(0)
    })

    it('should support pagination', async () => {
      const response = await testClient.get('/api/users?page=1&limit=5')

      expect(response.status).toBe(200)
      expect(response.body.users).toHaveLength(5)
      expect(response.body.pagination).toMatchObject({
        page: 1,
        limit: 5,
        total: expect.any(Number),
      })
    })
  })
})
```

### E2E Tests - User Journeys

**Test complete user workflows:**

```typescript
// tests/e2e/auth.spec.ts
import { test, expect } from '@playwright/test'

test.describe('User Authentication', () => {
  test('should allow user to sign up and log in', async ({ page }) => {
    // Navigate to sign up page
    await page.goto('/auth/signup')

    // Fill out signup form
    await page.fill('[data-testid=email-input]', 'test@example.com')
    await page.fill('[data-testid=password-input]', 'securePassword123')
    await page.fill('[data-testid=name-input]', 'Test User')

    // Submit form
    await page.click('[data-testid=signup-button]')

    // Should redirect to dashboard
    await expect(page).toHaveURL('/dashboard')
    await expect(page.locator('[data-testid=welcome-message]')).toContainText(
      'Welcome, Test User'
    )
  })

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/auth/login')

    await page.fill('[data-testid=email-input]', 'wrong@example.com')
    await page.fill('[data-testid=password-input]', 'wrongpassword')
    await page.click('[data-testid=login-button]')

    await expect(page.locator('[data-testid=error-message]')).toContainText(
      'Invalid credentials'
    )
  })

  test('should allow user to log out', async ({ page }) => {
    // Login first (could use a helper function)
    await page.goto('/auth/login')
    await page.fill('[data-testid=email-input]', 'existing@example.com')
    await page.fill('[data-testid=password-input]', 'password123')
    await page.click('[data-testid=login-button]')

    // Logout
    await page.click('[data-testid=user-menu]')
    await page.click('[data-testid=logout-button]')

    // Should redirect to home page
    await expect(page).toHaveURL('/')
  })
})
```

## TDD Best Practices

### Test Naming Conventions

Use descriptive test names that explain the behavior:

```typescript
// ❌ Poor test names
it('should work')
it('test user creation')
it('validates input')

// ✅ Good test names
it('should format positive numbers with dollar sign and commas')
it('should create user with valid email and return user object')
it('should return validation error when email is missing @ symbol')
```

### Test Organization

**Group related tests and use consistent structure:**

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    describe('when given valid input', () => {
      it('should create user in database')
      it('should return user object with id')
      it('should hash password before storing')
    })

    describe('when given invalid input', () => {
      it('should throw error for missing email')
      it('should throw error for weak password')
      it('should throw error for duplicate email')
    })
  })

  describe('updateUser', () => {
    // Similar structure...
  })
})
```

### Test Data Management

**Use factories and fixtures for consistent test data:**

```typescript
// tests/helpers/factories.ts
import { faker } from '@faker-js/faker'

export const userFactory = {
  build: (overrides = {}) => ({
    email: faker.internet.email(),
    name: faker.person.fullName(),
    password: 'SecurePassword123!',
    ...overrides,
  }),

  buildMany: (count: number, overrides = {}) =>
    Array.from({ length: count }, () => userFactory.build(overrides)),
}

// Usage in tests
const testUser = userFactory.build({ email: 'specific@test.com' })
const testUsers = userFactory.buildMany(5)
```

### Mocking External Dependencies

**Mock external services for reliable, fast tests:**

```typescript
// tests/unit/services/EmailService.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { EmailService } from '@/lib/services/EmailService'

// Mock the external email provider
vi.mock('@/lib/providers/sendgrid', () => ({
  sendEmail: vi.fn(),
}))

describe('EmailService', () => {
  let emailService: EmailService

  beforeEach(() => {
    vi.clearAllMocks()
    emailService = new EmailService()
  })

  it('should send welcome email to new users', async () => {
    const mockSendEmail = vi.mocked(sendEmail)
    mockSendEmail.mockResolvedValue({ success: true })

    const result = await emailService.sendWelcomeEmail({
      email: 'user@example.com',
      name: 'Test User',
    })

    expect(mockSendEmail).toHaveBeenCalledWith({
      to: 'user@example.com',
      subject: 'Welcome to our platform!',
      template: 'welcome',
      data: { name: 'Test User' },
    })
    expect(result.success).toBe(true)
  })
})
```

## Testing Configuration

### Vitest Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import path from 'path'

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./tests/setup.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'tests/',
        'dist/',
        '**/*.d.ts',
        '**/*.config.*',
        'coverage/',
      ],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80,
        },
      },
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
```

### Playwright Configuration

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
})
```

## TDD Workflow Integration

### VS Code Integration

Add these tasks to `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "test:watch",
      "type": "shell",
      "command": "pnpm",
      "args": ["test", "--watch"],
      "group": "test",
      "isBackground": true,
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    },
    {
      "label": "test:coverage",
      "type": "shell",
      "command": "pnpm",
      "args": ["test", "--coverage"],
      "group": "test"
    }
  ]
}
```

### Git Hooks for TDD

Ensure tests pass before commits:

```bash
# .husky/pre-commit
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Run tests before allowing commit
pnpm test
pnpm test:e2e
pnpm lint
pnpm type-check
```

### CI/CD Integration

Ensure comprehensive testing in CI:

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'

      - run: pnpm install
      - run: pnpm test:coverage
      - run: pnpm test:e2e

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
```

## Common TDD Patterns

### Testing API Error Handling

```typescript
describe('API Error Handling', () => {
  it('should handle database connection errors', async () => {
    // Mock database to throw error
    vi.mocked(db.user.create).mockRejectedValue(new Error('Connection failed'))

    const response = await testClient.post('/api/users', validUserData)

    expect(response.status).toBe(500)
    expect(response.body.error).toBe('Internal server error')
  })
})
```

### Testing Async Operations

```typescript
describe('Async Operations', () => {
  it('should handle promise rejections', async () => {
    const asyncFunction = vi.fn().mockRejectedValue(new Error('Async error'))

    await expect(myService.processAsync(asyncFunction)).rejects.toThrow(
      'Async error'
    )
  })
})
```

### Testing React Hooks

```typescript
// Custom hook testing
import { renderHook, act } from '@testing-library/react'
import { useCounter } from '@/hooks/useCounter'

describe('useCounter', () => {
  it('should increment counter', () => {
    const { result } = renderHook(() => useCounter(0))

    act(() => {
      result.current.increment()
    })

    expect(result.current.count).toBe(1)
  })
})
```

## Measuring TDD Success

### Code Coverage Metrics

- **Line Coverage**: >90% for new code
- **Branch Coverage**: >85% for critical paths
- **Function Coverage**: 100% for public APIs

### Quality Metrics

- **Bug Rate**: Lower bug reports in production
- **Development Speed**: Faster feature delivery after initial learning curve
- **Refactoring Confidence**: Ability to refactor without fear
- **Documentation**: Tests serve as living documentation

---

::: tip TDD Mindset
Remember: TDD is not about testing, it's about **design**. The tests drive better architecture, cleaner interfaces, and more maintainable code. Embrace the Red-Green-Refactor cycle as a design tool, not just a testing practice.
:::

::: warning Common TDD Pitfalls

- Writing tests after implementation (Test-After Development)
- Testing implementation details instead of behavior
- Not refactoring because tests are passing
- Writing too many tests at once instead of one at a time
- Mocking everything instead of testing real integrations where appropriate
  :::

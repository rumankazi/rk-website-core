import { expect, test } from '@playwright/test'

test.describe('Homepage', () => {
  test('should load and display main content', async ({ page }) => {
    await page.goto('/')

    // Check if the main heading is visible
    await expect(page.locator('h1')).toContainText('RK Website Core')

    // Check if the description is visible
    await expect(page.locator('span')).toContainText(
      'Modern TypeScript/Next.js full-stack development'
    )

    // Check if the documentation link is present
    await expect(page.locator('a[href*="github.io"]')).toBeVisible()

    // Check if the GitHub link is present
    await expect(page.locator('a[href*="github.com"]')).toBeVisible()
  })

  test('should have proper meta tags', async ({ page }) => {
    await page.goto('/')

    // Check page title
    await expect(page).toHaveTitle(/RK Website Core/)

    // Check meta description
    const metaDescription = page.locator('meta[name="description"]')
    await expect(metaDescription).toHaveAttribute(
      'content',
      /Modern TypeScript\/Next\.js full-stack development/
    )
  })

  test('should be responsive', async ({ page }) => {
    await page.goto('/')

    // Test mobile viewport
    await page.setViewportSize({ width: 375, height: 667 })
    await expect(page.locator('h1')).toBeVisible()

    // Test tablet viewport
    await page.setViewportSize({ width: 768, height: 1024 })
    await expect(page.locator('h1')).toBeVisible()

    // Test desktop viewport
    await page.setViewportSize({ width: 1920, height: 1080 })
    await expect(page.locator('h1')).toBeVisible()
  })
})

test.describe('API Health Check', () => {
  test('should return healthy status', async ({ request }) => {
    const response = await request.get('/api/health')

    expect(response.status()).toBe(200)

    const data = await response.json()
    expect(data.status).toBe('healthy')
    expect(data.services.api).toBe('operational')
  })
})

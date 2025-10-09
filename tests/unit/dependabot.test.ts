import { readFileSync } from 'fs'
import { join } from 'path'
import { describe, expect, test } from 'vitest'

describe('Dependabot Configuration', () => {
  test('should have valid dependabot.yml with proper timezone settings', () => {
    const dependabotPath = join(process.cwd(), '.github', 'dependabot.yml')
    const dependabotContent = readFileSync(dependabotPath, 'utf-8')

    // Check that all timezone references use Etc/UTC instead of UTC
    expect(dependabotContent).toContain("timezone: 'Etc/UTC'")
    expect(dependabotContent).not.toContain("timezone: 'UTC'")
  })

  test('should not have reviewers property (deprecated)', () => {
    const dependabotPath = join(process.cwd(), '.github', 'dependabot.yml')
    const dependabotContent = readFileSync(dependabotPath, 'utf-8')

    // Check that reviewers property is not present
    expect(dependabotContent).not.toContain('reviewers:')
  })

  test('should have proper package ecosystems configured', () => {
    const dependabotPath = join(process.cwd(), '.github', 'dependabot.yml')
    const dependabotContent = readFileSync(dependabotPath, 'utf-8')

    expect(dependabotContent).toContain("package-ecosystem: 'npm'")
    expect(dependabotContent).toContain("package-ecosystem: 'github-actions'")
    expect(dependabotContent).toContain("package-ecosystem: 'docker'")
  })

  test('should have version 2 specified', () => {
    const dependabotPath = join(process.cwd(), '.github', 'dependabot.yml')
    const dependabotContent = readFileSync(dependabotPath, 'utf-8')

    expect(dependabotContent).toContain('version: 2')
  })
})

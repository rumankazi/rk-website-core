import { readFileSync } from 'fs'
import { join } from 'path'
import { describe, expect, test } from 'vitest'

describe('GitHub Workflows Configuration', () => {
  test('should have dependabot workflow with correct metadata reference', () => {
    const workflowPath = join(
      process.cwd(),
      '.github',
      'workflows',
      'dependabot.yml'
    )
    const workflowContent = readFileSync(workflowPath, 'utf-8')

    // Check that old-version is replaced with previous-version
    expect(workflowContent).not.toContain('old-version')
    expect(workflowContent).toContain('previous-version')
  })

  test('should have quality workflow without invalid codecov token', () => {
    const workflowPath = join(
      process.cwd(),
      '.github',
      'workflows',
      'quality.yml'
    )
    const workflowContent = readFileSync(workflowPath, 'utf-8')

    // Check that CODECOV_TOKEN is not hardcoded as a secret
    const codecovTokenMatch = workflowContent.match(
      /token: \$\{\{ secrets\.CODECOV_TOKEN \}\}/
    )
    expect(codecovTokenMatch).toBeNull()
  })

  test('should have proper workflow permissions', () => {
    const workflowPath = join(
      process.cwd(),
      '.github',
      'workflows',
      'dependabot.yml'
    )
    const workflowContent = readFileSync(workflowPath, 'utf-8')

    expect(workflowContent).toContain('permissions:')
    expect(workflowContent).toContain('contents: write')
    expect(workflowContent).toContain('pull-requests: write')
  })

  test('should have quality assurance workflow', () => {
    const workflowPath = join(
      process.cwd(),
      '.github',
      'workflows',
      'quality.yml'
    )
    const workflowContent = readFileSync(workflowPath, 'utf-8')

    expect(workflowContent).toContain('name: Quality Assurance')
    expect(workflowContent).toContain('security-scan:')
    expect(workflowContent).toContain('code-quality:')
    expect(workflowContent).toContain('test-unit:')
    expect(workflowContent).toContain('test-e2e:')
  })
})

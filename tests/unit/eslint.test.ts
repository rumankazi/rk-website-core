import { readFileSync } from 'fs'
import { join } from 'path'
import { describe, expect, test } from 'vitest'

describe('ESLint Configuration', () => {
  test('should have valid eslint.config.js with Next.js plugin', () => {
    const eslintConfigPath = join(process.cwd(), 'eslint.config.js')
    const eslintConfigContent = readFileSync(eslintConfigPath, 'utf-8')

    // Check for Next.js configuration
    expect(eslintConfigContent).toContain('next/core-web-vitals')
    expect(eslintConfigContent).toContain('next/typescript')
    expect(eslintConfigContent).toContain('@eslint/eslintrc')
  })

  test('should use flat config format', () => {
    const eslintConfigPath = join(process.cwd(), 'eslint.config.js')
    const eslintConfigContent = readFileSync(eslintConfigPath, 'utf-8')

    // Should use ES modules and export default
    expect(eslintConfigContent).toContain('export default')
    expect(eslintConfigContent).toContain('import')
  })

  test('should have proper ignore patterns', () => {
    const eslintConfigPath = join(process.cwd(), 'eslint.config.js')
    const eslintConfigContent = readFileSync(eslintConfigPath, 'utf-8')

    expect(eslintConfigContent).toContain('ignores:')
    expect(eslintConfigContent).toContain('node_modules/')
    expect(eslintConfigContent).toContain('.next/')
  })

  test('should have TypeScript rules configured', () => {
    const eslintConfigPath = join(process.cwd(), 'eslint.config.js')
    const eslintConfigContent = readFileSync(eslintConfigPath, 'utf-8')

    expect(eslintConfigContent).toContain('@typescript-eslint/no-unused-vars')
    expect(eslintConfigContent).toContain('@typescript-eslint/no-explicit-any')
  })

  test('should have proper file patterns configured', () => {
    const eslintConfigPath = join(process.cwd(), 'eslint.config.js')
    const eslintConfigContent = readFileSync(eslintConfigPath, 'utf-8')

    expect(eslintConfigContent).toContain("files: ['**/*.{js,jsx,ts,tsx}']")
  })

  test('should separate Next.js configs for better plugin detection', () => {
    const eslintConfigPath = join(process.cwd(), 'eslint.config.js')
    const eslintConfigContent = readFileSync(eslintConfigPath, 'utf-8')

    // Should extend configs separately for better plugin detection
    expect(eslintConfigContent).toContain(
      "...compat.extends('next/core-web-vitals')"
    )
    expect(eslintConfigContent).toContain(
      "...compat.extends('next/typescript')"
    )
  })
})

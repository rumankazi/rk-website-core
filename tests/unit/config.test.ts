import { readFileSync } from 'fs'
import { join } from 'path'
import { describe, expect, test } from 'vitest'

describe('TypeScript Configuration', () => {
  test('should have valid tsconfig.json with path mappings', () => {
    const tsconfigPath = join(process.cwd(), 'tsconfig.json')
    const tsconfig = JSON.parse(readFileSync(tsconfigPath, 'utf-8'))

    expect(tsconfig.compilerOptions).toBeDefined()
    expect(tsconfig.compilerOptions.baseUrl).toBe('.')
    expect(tsconfig.compilerOptions.paths).toBeDefined()
    expect(tsconfig.compilerOptions.paths['@/*']).toEqual(['./src/*'])
    expect(tsconfig.compilerOptions.ignoreDeprecations).toBe('5.0')
  })

  test('should have proper module resolution configuration', () => {
    const tsconfigPath = join(process.cwd(), 'tsconfig.json')
    const tsconfig = JSON.parse(readFileSync(tsconfigPath, 'utf-8'))

    expect(tsconfig.compilerOptions.moduleResolution).toBe('bundler')
    expect(tsconfig.compilerOptions.strict).toBe(true)
    expect(tsconfig.compilerOptions.noUncheckedIndexedAccess).toBe(true)
  })
})

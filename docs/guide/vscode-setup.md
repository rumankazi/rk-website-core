# VS Code Development Setup

This document explains the VS Code configuration for optimal development experience with this TypeScript/Next.js project.

## DevContainer Configuration

The project uses VS Code Dev Containers for consistent development environments:

- **Node.js 20** (latest LTS)
- **Auto-installed extensions** for the tech stack
- **Port forwarding** for Next.js (3000), PostgreSQL (5432), Prometheus (9090), Grafana (3001)
- **Post-create commands** to set up pnpm

## Essential Extensions Installed

### Core Development

- **ESLint** - Code linting and error detection
- **Prettier** - Code formatting
- **TypeScript** - Enhanced TypeScript support

### Framework Specific

- **Tailwind CSS IntelliSense** - Tailwind class autocomplete
- **Prisma** - Database schema management
- **Playwright** - E2E testing support

### Git & GitHub

- **GitLens** - Enhanced Git capabilities
- **GitHub Actions** - Workflow management
- **GitHub Copilot** - AI-powered coding assistance

### DevOps

- **Docker** - Container management
- **Terraform** - Infrastructure as Code
- **YAML** - YAML file support

### Productivity

- **Error Lens** - Inline error display
- **Path Intellisense** - File path autocomplete
- **Auto Rename Tag** - Automatic HTML/JSX tag renaming

## Key Settings Configured

### Code Formatting

- **Format on Save** enabled
- **ESLint auto-fix** on save
- **Import organization** on save
- **Prettier as default formatter**

### TypeScript Enhancement

- **Auto imports** enabled
- **Single quotes** preference
- **File move updates** imports automatically

### Tailwind CSS

- **IntelliSense** for TypeScript/React files
- **Class regex** for `cva`, `cx`, `clsx` functions

### File Management

- **Excluded folders** from search and file watcher
- **Associated file types** for better syntax highlighting

## Development Workflow

### Starting Development

1. **Open in Dev Container**: Click "Reopen in Container" when prompted
2. **Install dependencies**: `pnpm install`
3. **Start dev server**: `pnpm dev` or use Tasks panel

### Available Tasks (Ctrl+Shift+P → "Tasks: Run Task")

- **dev** - Start Next.js development server
- **build** - Build production bundle
- **test** - Run unit tests
- **test:watch** - Run tests in watch mode
- **test:e2e** - Run Playwright E2E tests
- **lint** - Run ESLint
- **lint:fix** - Fix ESLint issues automatically
- **type-check** - TypeScript type checking
- **prisma:migrate** - Run database migrations
- **prisma:generate** - Generate Prisma client
- **docker:up** - Start Docker services
- **docker:down** - Stop Docker services

### Debugging Configuration

- **Next.js Server-side** debugging
- **Client-side** debugging in Chrome
- **Full-stack** debugging (both server and client)

### Useful Keybindings

- **Ctrl+Shift+P** - Command palette
- **Ctrl+P** - Quick file open
- **F12** - Go to definition
- **Shift+F12** - Show references
- **F2** - Rename symbol
- **Ctrl+Shift+F** - Search in files
- **Ctrl+`** - Toggle terminal
- **Shift+Alt+F** - Format document

## File Structure Integration

The VS Code settings are optimized for the project structure:

```
.vscode/
├── settings.json          # Workspace settings
├── extensions.json        # Recommended extensions
├── tasks.json            # Development tasks
├── launch.json           # Debug configurations
└── keybindings.json      # Custom keybindings
```

## Tips for Maximum Productivity

1. **Use the Command Palette** (Ctrl+Shift+P) for quick actions
2. **Install GitHub Copilot** for AI-powered code suggestions
3. **Use Error Lens** to see errors inline without opening Problems panel
4. **Configure GitLens** for enhanced Git integration
5. **Use Playwright extension** for visual E2E test development
6. **Use Tasks** instead of terminal commands for consistency

## Customization

You can further customize the setup by:

- Adding more extensions to `.vscode/extensions.json`
- Modifying settings in `.vscode/settings.json`
- Adding custom tasks in `.vscode/tasks.json`
- Creating custom keybindings in `.vscode/keybindings.json`

All settings are automatically synchronized when using the devcontainer, ensuring consistency across different development environments.

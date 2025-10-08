import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'RK Website Core',
  description:
    'Complete TypeScript/Next.js development documentation with DevOps automation',

  // Base URL for deployment
  base: '/rk-website-core/',

  // Theme configuration
  themeConfig: {
    // Logo and site title
    logo: '/logo.svg',
    siteTitle: 'RK Website Core',

    // Navigation
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Architecture', link: '/architecture/overview' },
      { text: 'API', link: '/api/routes' },
      { text: 'Infrastructure', link: '/infrastructure/terraform' },
      { text: 'Changelog', link: '/changelog/' },
    ],

    // Sidebar navigation
    sidebar: {
      '/guide/': [
        {
          text: 'Getting Started',
          items: [
            { text: 'Quick Start', link: '/guide/getting-started' },
            { text: 'Development Workflow', link: '/guide/development' },
            { text: 'Deployment Process', link: '/guide/deployment' },
            { text: 'VS Code Setup', link: '/guide/vscode-setup' },
          ],
        },
      ],
      '/architecture/': [
        {
          text: 'System Design',
          items: [
            { text: 'Overview', link: '/architecture/overview' },
            { text: 'Database Design', link: '/architecture/database' },
            { text: 'Security Implementation', link: '/architecture/security' },
            {
              text: 'Monitoring & Observability',
              link: '/architecture/monitoring',
            },
          ],
        },
      ],
      '/api/': [
        {
          text: 'API Documentation',
          items: [
            { text: 'Routes & Endpoints', link: '/api/routes' },
            { text: 'Authentication', link: '/api/authentication' },
            { text: 'Error Handling', link: '/api/error-handling' },
          ],
        },
      ],
      '/infrastructure/': [
        {
          text: 'DevOps & Infrastructure',
          items: [
            { text: 'Terraform Setup', link: '/infrastructure/terraform' },
            { text: 'Docker Configuration', link: '/infrastructure/docker' },
            { text: 'CI/CD Pipeline', link: '/infrastructure/ci-cd' },
            {
              text: 'Cloud Resources',
              link: '/infrastructure/cloud-resources',
            },
          ],
        },
      ],
    },

    // Social links
    socialLinks: [
      { icon: 'github', link: 'https://github.com/rumankazi/rk-website-core' },
    ],

    // Footer
    footer: {
      message: 'Built with ❤️ using TypeScript, Next.js, and VitePress',
      copyright: 'Copyright © 2025 Ruman Kazi',
    },

    // Search
    search: {
      provider: 'local',
    },

    // Edit link
    editLink: {
      pattern:
        'https://github.com/rumankazi/rk-website-core/edit/main/docs/:path',
      text: 'Edit this page on GitHub',
    },

    // Last updated
    lastUpdated: {
      text: 'Updated at',
      formatOptions: {
        dateStyle: 'full',
        timeStyle: 'medium',
      },
    },
  },

  // Markdown configuration
  markdown: {
    theme: 'github-dark',
    lineNumbers: true,

    // Code highlighting
    codeTransformers: [
      // Add copy button to code blocks
    ],
  },

  // Head tags
  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }],
    [
      'meta',
      { name: 'viewport', content: 'width=device-width, initial-scale=1.0' },
    ],
    [
      'meta',
      {
        name: 'description',
        content:
          'Complete TypeScript/Next.js development documentation with DevOps automation',
      },
    ],
  ],

  // Build configuration
  outDir: '../dist/docs',
  cacheDir: '.vitepress/cache',

  // Development server
  server: {
    port: 5173,
    host: true,
  },

  // Ignore dead links for localhost URLs during build
  ignoreDeadLinks: [/^http:\/\/localhost/],
})

import Link from 'next/link'

export default function HomePage() {
  return (
    <div className="container relative">
      <section className="mx-auto flex max-w-[980px] flex-col items-center gap-2 py-8 md:py-12 md:pb-8 lg:py-24 lg:pb-20">
        <h1 className="text-center text-3xl font-bold leading-tight tracking-tighter md:text-6xl lg:leading-[1.1]">
          RK Website Core
        </h1>
        <span className="max-w-[750px] text-center text-lg text-muted-foreground sm:text-xl">
          Modern TypeScript/Next.js full-stack development with comprehensive
          DevOps automation and documentation.
        </span>
        <div className="flex w-full items-center justify-center space-x-4 py-4 md:pb-10">
          <Link
            href="https://rumankazi.github.io/rk-website-core/"
            target="_blank"
            rel="noreferrer"
            className="inline-flex h-9 items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow transition-colors hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50"
          >
            Documentation
          </Link>
          <Link
            href="https://github.com/rumankazi/rk-website-core"
            target="_blank"
            rel="noreferrer"
            className="inline-flex h-9 items-center justify-center rounded-md border border-input bg-background px-4 py-2 text-sm font-medium shadow-sm transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50"
          >
            GitHub
          </Link>
        </div>
      </section>

      <section className="mx-auto max-w-[980px] py-8 md:py-12">
        <div className="mx-auto grid justify-center gap-4 sm:grid-cols-2 md:max-w-[64rem] md:grid-cols-3">
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <div className="space-y-2">
                <h3 className="font-bold">Modern Tech Stack</h3>
                <p className="text-sm text-muted-foreground">
                  TypeScript, Next.js 14+, Prisma ORM, Tailwind CSS, and
                  PostgreSQL with complete type safety.
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <div className="space-y-2">
                <h3 className="font-bold">Container-First Development</h3>
                <p className="text-sm text-muted-foreground">
                  Docker containers, VS Code Dev Containers, and docker-compose
                  for consistent development environments.
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <div className="space-y-2">
                <h3 className="font-bold">DevOps Automation</h3>
                <p className="text-sm text-muted-foreground">
                  GitHub Actions CI/CD, Infrastructure as Code with Terraform,
                  and multi-environment deployments.
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <div className="space-y-2">
                <h3 className="font-bold">Security by Default</h3>
                <p className="text-sm text-muted-foreground">
                  Built-in security measures, automated vulnerability scanning,
                  and best practices enforcement.
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <div className="space-y-2">
                <h3 className="font-bold">Comprehensive Monitoring</h3>
                <p className="text-sm text-muted-foreground">
                  Prometheus, Grafana, Sentry, and Plausible for complete
                  observability and user analytics.
                </p>
              </div>
            </div>
          </div>
          <div className="relative overflow-hidden rounded-lg border bg-background p-2">
            <div className="flex h-[180px] flex-col justify-between rounded-md p-6">
              <div className="space-y-2">
                <h3 className="font-bold">Documentation-Driven</h3>
                <p className="text-sm text-muted-foreground">
                  Auto-generated, version-controlled documentation with
                  VitePress and automated publishing.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}

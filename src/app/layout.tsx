import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: {
    default: 'RK Website Core',
    template: '%s | RK Website Core',
  },
  description:
    'Modern TypeScript/Next.js full-stack development with comprehensive DevOps automation',
  keywords: [
    'Next.js',
    'TypeScript',
    'Prisma',
    'Tailwind CSS',
    'Full Stack',
    'DevOps',
  ],
  authors: [
    {
      name: 'Ruman Kazi',
      url: 'https://github.com/rumankazi',
    },
  ],
  creator: 'Ruman Kazi',
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: 'https://rumankazi.github.io/rk-website-core/',
    title: 'RK Website Core',
    description:
      'Modern TypeScript/Next.js full-stack development with comprehensive DevOps automation',
    siteName: 'RK Website Core',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'RK Website Core',
    description:
      'Modern TypeScript/Next.js full-stack development with comprehensive DevOps automation',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <div className="relative flex min-h-screen flex-col">
          <main className="flex-1">{children}</main>
        </div>
      </body>
    </html>
  )
}

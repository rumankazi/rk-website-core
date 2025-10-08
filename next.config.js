/** @type {import('next').NextConfig} */
const nextConfig = {
  typedRoutes: true,
  images: {
    remotePatterns: [
      {
        protocol: 'http',
        hostname: 'localhost',
        port: '',
        pathname: '**',
      },
    ],
  },
  // Enable strict mode for better development experience
  reactStrictMode: true,
  // Enable standalone output for Docker
  output: 'standalone',
}

export default nextConfig

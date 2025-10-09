# Multi-stage Dockerfile for production deployment
FROM node:20-alpine AS deps
WORKDIR /app

# Install system dependencies and pnpm
RUN apk add --no-cache libc6-compat curl
RUN npm install -g pnpm@latest

# Copy package files
COPY package.json pnpm-lock.yaml* ./
COPY prisma ./prisma/

# Install dependencies
RUN pnpm install --frozen-lockfile

# Generate Prisma client
RUN pnpm prisma generate

# ===============================================
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app

# Install system dependencies and pnpm
RUN apk add --no-cache libc6-compat
RUN npm install -g pnpm@latest

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/prisma ./prisma/

# Copy source code (dockerignore excludes unnecessary files)
COPY . .

# Ensure required directories exist
RUN mkdir -p public

# Set environment to production for build
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Build the application
RUN pnpm build

# Ensure .prisma client directory exists and is accessible
RUN mkdir -p node_modules/.prisma && \
    if [ -d "node_modules/.pnpm" ]; then \
    find node_modules/.pnpm -name ".prisma" -type d -exec cp -r {} node_modules/ \; 2>/dev/null || true; \
    fi

# ===============================================
# Production stage
FROM node:20-alpine AS runner
WORKDIR /app

# Install system dependencies including curl for health checks
RUN apk add --no-cache curl

# Create non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built application files
COPY --from=builder /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Copy public directory
COPY --from=builder /app/public ./public

# Copy Prisma schema and generated client
COPY --from=builder --chown=nextjs:nodejs /app/prisma ./prisma
COPY --from=builder --chown=nextjs:nodejs /app/node_modules/@prisma ./node_modules/@prisma
COPY --from=builder --chown=nextjs:nodejs /app/node_modules/.prisma ./node_modules/.prisma

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"
ENV NEXT_TELEMETRY_DISABLED=1

# Switch to non-root user
USER nextjs

# Expose port
EXPOSE 3000

# Health check using curl
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:3000/api/health || exit 1

# Start the application
CMD ["node", "server.js"]
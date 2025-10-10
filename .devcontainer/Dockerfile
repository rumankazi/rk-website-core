# [Choice] Node.js version (use -bullseye variants on local arm64/Apple Silicon): 20, 18, 16, 20-bullseye, 18-bullseye, 16-bullseye
ARG VARIANT=24-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:${VARIANT}

# Install performance optimization packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    # Performance monitoring tools
    htop \
    # Fast file operations
    rsync \
    # Better terminal experience
    zsh \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install latest pnpm with performance optimizations
RUN su node -c "npm install -g pnpm@latest" \
    && su node -c "pnpm config set store-dir /workspaces/.pnpm-store" \
    && su node -c "pnpm config set package-import-method hardlink" \
    && su node -c "pnpm config set side-effects-cache true" \
    && su node -c "pnpm config set prefer-offline true"

# Configure git for better performance
RUN su node -c "git config --global core.preloadindex true" \
    && su node -c "git config --global core.fscache true" \
    && su node -c "git config --global gc.auto 256"

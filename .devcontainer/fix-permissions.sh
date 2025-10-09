#!/bin/bash

# Fix permissions for pnpm store and node_modules
echo "Fixing permissions for development environment..."

# Fix pnpm store permissions
if [ -d "/workspaces/.pnpm-store" ]; then
    sudo chown -R node:node /workspaces/.pnpm-store
    echo "Fixed pnpm store permissions"
fi

# Fix node_modules permissions if it exists
if [ -d "/workspaces/rk-website-core/node_modules" ]; then
    sudo chown -R node:node /workspaces/rk-website-core/node_modules
    echo "Fixed node_modules permissions"
fi

# Ensure the workspace itself has correct permissions
sudo chown -R node:node /workspaces/rk-website-core

echo "Permission fixes completed!"
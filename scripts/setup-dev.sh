#!/bin/bash

# Development Environment Setup Script
# This script sets up the development environment and handles common issues

set -e  # Exit on any error

echo "🚀 Setting up development environment..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to fix permissions
fix_permissions() {
    echo "🔧 Fixing permissions..."
    
    # Fix pnpm store permissions
    if [ -d "/workspaces/.pnpm-store" ]; then
        sudo chown -R node:node "/workspaces/.pnpm-store" 2>/dev/null || true
        echo "  ✅ Fixed pnpm store permissions"
    fi
    
    # Fix node_modules permissions
    if [ -d "./node_modules" ]; then
        sudo chown -R node:node "./node_modules" 2>/dev/null || true
        echo "  ✅ Fixed node_modules permissions"
    fi
    
    # Fix workspace permissions
    sudo chown -R node:node "/workspaces/rk-website-core" 2>/dev/null || true
    echo "  ✅ Fixed workspace permissions"
}

# Function to install dependencies
install_dependencies() {
    echo "📦 Installing dependencies..."
    
    # Check if pnpm is available
    if ! command_exists pnpm; then
        echo "  Installing pnpm..."
        npm install -g pnpm@latest
    fi
    
    # Configure pnpm
    pnpm config set store-dir /workspaces/.pnpm-store
    
    # Install dependencies with retry logic
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "  📥 Installing dependencies (attempt $attempt/$max_attempts)..."
        
        if pnpm install; then
            echo "  ✅ Dependencies installed successfully"
            break
        else
            if [ $attempt -eq $max_attempts ]; then
                echo "  ❌ Failed to install dependencies after $max_attempts attempts"
                echo "  💡 Trying with --force flag..."
                pnpm install --force
                break
            else
                echo "  ⚠️  Installation failed, retrying..."
                fix_permissions
                sleep 2
            fi
        fi
        
        ((attempt++))
    done
    
    # Approve build scripts if needed
    if pnpm list | grep -q "build scripts"; then
        echo "  🔓 Approving build scripts..."
        echo "y" | pnpm approve-builds 2>/dev/null || true
    fi
}

# Function to run setup checks
run_checks() {
    echo "🔍 Running setup checks..."
    
    # Check Node.js version
    if command_exists node; then
        echo "  ✅ Node.js: $(node --version)"
    else
        echo "  ❌ Node.js not found"
        exit 1
    fi
    
    # Check pnpm version
    if command_exists pnpm; then
        echo "  ✅ pnpm: $(pnpm --version)"
    else
        echo "  ❌ pnpm not found"
        exit 1
    fi
    
    # Check if dependencies are installed
    if [ -d "./node_modules" ]; then
        echo "  ✅ Dependencies installed"
    else
        echo "  ⚠️  Dependencies not found"
    fi
    
    # Check Prisma
    if pnpm prisma --version >/dev/null 2>&1; then
        echo "  ✅ Prisma available"
    else
        echo "  ⚠️  Prisma not available"
    fi
}

# Main execution
main() {
    echo "🎯 Development Environment Setup"
    echo "================================"
    
    # Fix permissions first
    fix_permissions
    
    # Install dependencies
    install_dependencies
    
    # Run checks
    run_checks
    
    echo ""
    echo "🎉 Development environment is ready!"
    echo ""
    echo "Next steps:"
    echo "  1. Start PostgreSQL: pnpm docker:up"
    echo "  2. Run migrations: pnpm prisma:migrate"
    echo "  3. Start development: pnpm dev"
    echo ""
    echo "Available commands:"
    echo "  - pnpm dev          # Start development server"
    echo "  - pnpm test:watch   # Run tests in watch mode"
    echo "  - pnpm lint         # Run linter"
    echo "  - pnpm type-check   # Run TypeScript checks"
    echo ""
}

# Run main function
main "$@"
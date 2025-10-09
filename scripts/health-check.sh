#!/bin/bash

# System health check for performance optimizations
# Usage: ./scripts/health-check.sh

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🏥 Performance Health Check${NC}"
echo -e "${BLUE}===========================${NC}"
echo ""

# Function to check status
check_status() {
    local description="$1"
    local command="$2"
    local expected="$3"
    
    echo -n "Checking $description... "
    
    if result=$(eval "$command" 2>/dev/null); then
        if [[ -z "$expected" ]] || [[ "$result" == *"$expected"* ]] || [[ "$result" =~ $expected ]]; then
            echo -e "${GREEN}✅ OK${NC}"
            [[ -n "$result" ]] && echo "  → $result"
        else
            echo -e "${YELLOW}⚠️  Warning${NC}"
            echo "  → Expected: $expected"
            echo "  → Got: $result"
        fi
    else
        echo -e "${RED}❌ Failed${NC}"
    fi
    echo ""
}

# System Resources
echo -e "${BLUE}📊 System Resources${NC}"
check_status "CPU cores" "nproc" ""
check_status "Available memory" "free -h | grep '^Mem:' | awk '{print \$2}'" ""
check_status "Disk space" "df -h . | tail -1 | awk '{print \$4}'" ""

# Development Tools
echo -e "${BLUE}🛠️  Development Tools${NC}"
check_status "Node.js version" "node --version" "v20"
check_status "pnpm version" "pnpm --version" ""
check_status "TypeScript version" "pnpm tsc --version" ""

# pnpm Configuration
echo -e "${BLUE}📦 pnpm Configuration${NC}"
check_status "pnpm store directory" "pnpm config get store-dir" "/workspaces/.pnpm-store"
check_status "Package import method" "pnpm config get package-import-method" "hardlink"
check_status "Side effects cache" "pnpm config get side-effects-cache" "true"
check_status "Prefer offline" "pnpm config get prefer-offline" "true"

# Cache Directories
echo -e "${BLUE}💾 Cache Status${NC}"
check_status "ESLint cache exists" "[ -d node_modules/.cache/eslint ] && echo 'exists' || echo 'missing'" "exists"
check_status "TypeScript cache exists" "[ -f node_modules/.cache/tsc/tsbuildinfo ] && echo 'exists' || echo 'missing'" ""
check_status "Next.js cache exists" "[ -d .next/cache ] && echo 'exists' || echo 'missing'" ""

# Volume Mounts (if in container)
if [ -f /.dockerenv ]; then
    echo -e "${BLUE}🐳 Container Optimizations${NC}"
    check_status "pnpm store volume" "[ -d /workspaces/.pnpm-store ] && echo 'mounted' || echo 'not mounted'" "mounted"
    check_status "Docker in Docker" "docker --version" "Docker version"
else
    echo -e "${YELLOW}ℹ️  Not running in container${NC}"
fi

# Performance Recommendations
echo -e "${BLUE}💡 Performance Recommendations${NC}"

# Check if pnpm store has content
if [ -d "/workspaces/.pnpm-store" ] && [ "$(ls -A /workspaces/.pnpm-store 2>/dev/null)" ]; then
    echo -e "${GREEN}✅ pnpm store is populated and ready${NC}"
else
    echo -e "${YELLOW}⚠️  pnpm store is empty - run 'pnpm install' to populate${NC}"
fi

# Check Node.js version
node_version=$(node --version | sed 's/v//' | cut -d. -f1)
if [ "$node_version" -ge 20 ]; then
    echo -e "${GREEN}✅ Node.js version is optimal (v$node_version)${NC}"
else
    echo -e "${YELLOW}⚠️  Consider upgrading to Node.js v20+ for better performance${NC}"
fi

# Check available memory
mem_gb=$(free -g | grep '^Mem:' | awk '{print $2}')
if [ "$mem_gb" -ge 6 ]; then
    echo -e "${GREEN}✅ Sufficient memory available (${mem_gb}GB)${NC}"
else
    echo -e "${YELLOW}⚠️  Low memory (${mem_gb}GB) - consider increasing container memory${NC}"
fi

echo ""
echo -e "${BLUE}🎯 Quick Performance Tests${NC}"
echo "Run these commands to test performance:"
echo "  • Full benchmark: ./scripts/benchmark.sh"
echo "  • Quick test: ./scripts/perf-test.sh"
echo "  • Clean caches: pnpm clean:cache"
echo "  • Fast install: pnpm install:fast"
echo ""
echo -e "${GREEN}✨ Health check completed!${NC}"
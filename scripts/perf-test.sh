#!/bin/bash

# Performance measurement script for development tasks
# Usage: ./scripts/perf-test.sh

echo "🚀 Performance Test - Development Tasks"
echo "========================================"

# Function to measure time
measure_time() {
    local cmd="$1"
    local description="$2"
    
    echo "📊 Testing: $description"
    echo "Command: $cmd"
    
    start_time=$(date +%s.%3N)
    eval "$cmd" > /dev/null 2>&1
    end_time=$(date +%s.%3N)
    
    duration=$(echo "$end_time - $start_time" | bc)
    echo "⏱️  Duration: ${duration}s"
    echo "---"
}

# Test various commands
measure_time "pnpm lint" "ESLint (with cache)"
measure_time "pnpm type-check:fast" "TypeScript check (fast)"
measure_time "pnpm test --run" "Unit tests"
measure_time "pnpm prisma generate" "Prisma generate"

echo "✅ Performance test completed!"
echo "💡 Tips for faster development:"
echo "   - Use 'pnpm dev:fast' for quick validation"
echo "   - Use 'pnpm install:fast' for faster installs" 
echo "   - Run 'pnpm clean:cache' if things feel slow"
#!/bin/bash

# Comprehensive benchmark script for development performance
# Usage: ./scripts/benchmark.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BENCHMARK_DIR="./benchmark-results"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="$BENCHMARK_DIR/benchmark_$TIMESTAMP.json"

# Create benchmark directory
mkdir -p "$BENCHMARK_DIR"

echo -e "${BLUE}🚀 Development Performance Benchmark${NC}"
echo -e "${BLUE}====================================${NC}"
echo "Results will be saved to: $RESULTS_FILE"
echo ""

# Function to measure command execution time
measure_command() {
    local cmd="$1"
    local description="$2"
    local cleanup_cmd="$3"
    
    echo -e "${YELLOW}📊 Benchmarking: $description${NC}"
    echo "Command: $cmd"
    
    # Cleanup before test if specified
    if [ -n "$cleanup_cmd" ]; then
        eval "$cleanup_cmd" > /dev/null 2>&1 || true
    fi
    
    # Warm up (run once to populate caches)
    echo "  🔥 Warming up..."
    eval "$cmd" > /dev/null 2>&1 || true
    
    # Actual measurement (3 runs for average)
    local total_time=0
    local runs=3
    
    echo "  ⏱️  Running $runs test iterations..."
    
    for i in $(seq 1 $runs); do
        # Clear caches for consistent measurement
        if [ -n "$cleanup_cmd" ]; then
            eval "$cleanup_cmd" > /dev/null 2>&1 || true
        fi
        
        local start_time=$(date +%s.%3N)
        eval "$cmd" > /dev/null 2>&1
        local end_time=$(date +%s.%3N)
        
        local duration=$(echo "$end_time - $start_time" | bc -l)
        total_time=$(echo "$total_time + $duration" | bc -l)
        
        echo "    Run $i: ${duration}s"
    done
    
    local avg_time=$(echo "scale=3; $total_time / $runs" | bc -l)
    
    echo -e "  ${GREEN}✅ Average time: ${avg_time}s${NC}"
    echo ""
    
    # Store result in JSON format
    echo "  \"$description\": {" >> "$RESULTS_FILE.tmp"
    echo "    \"command\": \"$cmd\"," >> "$RESULTS_FILE.tmp"
    echo "    \"average_time\": $avg_time," >> "$RESULTS_FILE.tmp"
    echo "    \"total_runs\": $runs" >> "$RESULTS_FILE.tmp"
    echo "  }," >> "$RESULTS_FILE.tmp"
    
    return 0
}

# System information
echo -e "${BLUE}📋 System Information${NC}"
echo "Date: $(date)"
echo "Node version: $(node --version)"
echo "pnpm version: $(pnpm --version)"
echo "Available memory: $(free -h | grep '^Mem:' | awk '{print $2}')"
echo "CPU cores: $(nproc)"
echo "Disk space: $(df -h . | tail -1 | awk '{print $4}' | sed 's/[^0-9.]*//g')GB free"
echo ""

# Initialize results file
echo "{" > "$RESULTS_FILE.tmp"
echo "  \"benchmark_info\": {" >> "$RESULTS_FILE.tmp"
echo "    \"timestamp\": \"$TIMESTAMP\"," >> "$RESULTS_FILE.tmp"
echo "    \"node_version\": \"$(node --version)\"," >> "$RESULTS_FILE.tmp"
echo "    \"pnpm_version\": \"$(pnpm --version)\"," >> "$RESULTS_FILE.tmp"
echo "    \"cpu_cores\": $(nproc)," >> "$RESULTS_FILE.tmp"
echo "    \"memory_gb\": \"$(free -h | grep '^Mem:' | awk '{print $2}')\"" >> "$RESULTS_FILE.tmp"
echo "  }," >> "$RESULTS_FILE.tmp"

# Benchmark tests
echo -e "${BLUE}🧪 Running Benchmark Tests${NC}"
echo ""

# 1. Package installation
measure_command "pnpm install --prefer-offline" "Package Installation (with optimizations)" "rm -rf node_modules pnpm-lock.yaml"

# 2. TypeScript compilation
measure_command "pnpm type-check" "TypeScript Type Checking" "rm -rf node_modules/.cache/tsc"

# 3. Fast TypeScript compilation
measure_command "pnpm type-check:fast" "TypeScript Type Checking (Fast Mode)" "rm -rf node_modules/.cache/tsc"

# 4. ESLint
measure_command "pnpm lint" "ESLint Code Linting" "rm -rf node_modules/.cache/eslint"

# 5. Test execution
measure_command "pnpm test --run" "Unit Test Execution" ""

# 6. Prisma generation
measure_command "pnpm prisma generate" "Prisma Client Generation" "rm -rf node_modules/.prisma"

# 7. Next.js build (this might take a while)
echo -e "${YELLOW}🏗️  Building Next.js application (this may take a few minutes)...${NC}"
measure_command "pnpm build" "Next.js Production Build" "rm -rf .next"

# 8. Development server startup (quick test)
echo -e "${YELLOW}🚦 Testing dev server startup time...${NC}"
timeout 30s bash -c 'pnpm dev > /dev/null 2>&1 &
DEV_PID=$!
sleep 25  # Give it time to start
kill $DEV_PID 2>/dev/null || true
wait $DEV_PID 2>/dev/null || true' || true

# Finalize JSON file
sed -i '$ s/,$//' "$RESULTS_FILE.tmp"  # Remove last comma
echo "}" >> "$RESULTS_FILE.tmp"
mv "$RESULTS_FILE.tmp" "$RESULTS_FILE"

# Summary
echo -e "${GREEN}🎉 Benchmark Complete!${NC}"
echo ""
echo -e "${BLUE}📊 Performance Summary${NC}"
echo "Results saved to: $RESULTS_FILE"
echo ""

# Display results in a nice format
if command -v jq &> /dev/null; then
    echo -e "${YELLOW}📈 Quick Results Overview:${NC}"
    jq -r '.benchmark_info.timestamp as $time | 
           "Benchmark Time: " + $time + "\n" +
           (to_entries | 
            map(select(.key != "benchmark_info")) | 
            map("• " + .key + ": " + (.value.average_time | tostring) + "s") | 
            join("\n"))' "$RESULTS_FILE"
else
    echo "Install 'jq' for prettier result display: apt-get install jq"
fi

echo ""
echo -e "${BLUE}💡 Performance Tips:${NC}"
echo "• Use 'pnpm install:fast' for quicker installs without scripts"
echo "• Use 'pnpm type-check:fast' for faster TypeScript checking"
echo "• Use 'pnpm dev:fast' for quick development validation"
echo "• Run 'pnpm clean:cache' if performance degrades over time"
echo "• Use 'pnpm dev --turbo' for faster development server"
echo ""
echo -e "${GREEN}✨ Benchmark completed successfully!${NC}"
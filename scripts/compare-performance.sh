#!/bin/bash

# Performance comparison tool
# Usage: ./scripts/compare-performance.sh [baseline_file] [current_file]

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: $0 <baseline_file> <current_file>${NC}"
    echo "Example: $0 benchmark-results/benchmark_20241009_100000.json benchmark-results/benchmark_20241009_110000.json"
    exit 1
fi

BASELINE_FILE="$1"
CURRENT_FILE="$2"

if [ ! -f "$BASELINE_FILE" ] || [ ! -f "$CURRENT_FILE" ]; then
    echo -e "${RED}Error: One or both benchmark files not found${NC}"
    exit 1
fi

echo -e "${BLUE}📊 Performance Comparison Report${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: 'jq' is required for comparison. Install with: apt-get install jq${NC}"
    exit 1
fi

# Extract benchmark info
baseline_time=$(jq -r '.benchmark_info.timestamp' "$BASELINE_FILE")
current_time=$(jq -r '.benchmark_info.timestamp' "$CURRENT_FILE")

echo -e "${YELLOW}Baseline:${NC} $baseline_time"
echo -e "${YELLOW}Current:${NC}  $current_time"
echo ""

# Compare each benchmark
echo -e "${BLUE}📈 Performance Changes:${NC}"
echo ""

# Get all benchmark keys (excluding benchmark_info)
jq -r 'keys[] | select(. != "benchmark_info")' "$BASELINE_FILE" | while read -r key; do
    baseline_time=$(jq -r --arg key "$key" '.[$key].average_time' "$BASELINE_FILE" 2>/dev/null)
    current_time=$(jq -r --arg key "$key" '.[$key].average_time' "$CURRENT_FILE" 2>/dev/null)
    
    if [ "$baseline_time" != "null" ] && [ "$current_time" != "null" ]; then
        # Calculate percentage change
        percentage=$(echo "scale=2; (($current_time - $baseline_time) / $baseline_time) * 100" | bc -l)
        absolute_change=$(echo "scale=3; $current_time - $baseline_time" | bc -l)
        
        # Determine if it's an improvement or regression
        if (( $(echo "$percentage < -5" | bc -l) )); then
            # Significant improvement (>5% faster)
            echo -e "${GREEN}✅ $key${NC}"
            echo -e "   ${GREEN}${percentage}% faster${NC} (${absolute_change}s change)"
            echo -e "   Baseline: ${baseline_time}s → Current: ${current_time}s"
        elif (( $(echo "$percentage > 5" | bc -l) )); then
            # Significant regression (>5% slower)
            echo -e "${RED}❌ $key${NC}"
            echo -e "   ${RED}${percentage}% slower${NC} (+${absolute_change}s change)"
            echo -e "   Baseline: ${baseline_time}s → Current: ${current_time}s"
        else
            # Minor change (<5%)
            echo -e "${YELLOW}➖ $key${NC}"
            echo -e "   ${YELLOW}${percentage}% change${NC} (${absolute_change}s change)"
            echo -e "   Baseline: ${baseline_time}s → Current: ${current_time}s"
        fi
        echo ""
    fi
done

# Overall summary
echo -e "${BLUE}📋 Summary:${NC}"

# Count improvements and regressions
improvements=$(jq -r 'keys[] | select(. != "benchmark_info")' "$BASELINE_FILE" | while read -r key; do
    baseline_time=$(jq -r --arg key "$key" '.[$key].average_time' "$BASELINE_FILE" 2>/dev/null)
    current_time=$(jq -r --arg key "$key" '.[$key].average_time' "$CURRENT_FILE" 2>/dev/null)
    
    if [ "$baseline_time" != "null" ] && [ "$current_time" != "null" ]; then
        percentage=$(echo "scale=2; (($current_time - $baseline_time) / $baseline_time) * 100" | bc -l)
        if (( $(echo "$percentage < -5" | bc -l) )); then
            echo "improvement"
        fi
    fi
done | wc -l)

regressions=$(jq -r 'keys[] | select(. != "benchmark_info")' "$BASELINE_FILE" | while read -r key; do
    baseline_time=$(jq -r --arg key "$key" '.[$key].average_time' "$BASELINE_FILE" 2>/dev/null)
    current_time=$(jq -r --arg key "$key" '.[$key].average_time' "$CURRENT_FILE" 2>/dev/null)
    
    if [ "$baseline_time" != "null" ] && [ "$current_time" != "null" ]; then
        percentage=$(echo "scale=2; (($current_time - $baseline_time) / $baseline_time) * 100" | bc -l)
        if (( $(echo "$percentage > 5" | bc -l) )); then
            echo "regression"
        fi
    fi
done | wc -l)

echo -e "${GREEN}Improvements:${NC} $improvements tests faster"
echo -e "${RED}Regressions:${NC} $regressions tests slower"

if [ "$improvements" -gt "$regressions" ]; then
    echo -e "${GREEN}🎉 Overall: Performance improved!${NC}"
elif [ "$regressions" -gt "$improvements" ]; then
    echo -e "${RED}⚠️  Overall: Performance regressed${NC}"
else
    echo -e "${YELLOW}➖ Overall: Performance unchanged${NC}"
fi
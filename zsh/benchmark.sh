#!/usr/bin/env bash
# Benchmark zsh startup time

echo "🏃 Benchmarking zsh startup time..."
echo "=================================="
echo ""

# Function to measure startup time
benchmark_shell() {
    local config=$1
    local name=$2
    local times=10
    local total=0
    
    echo "Testing: $name"
    echo "Running $times iterations..."
    
    for i in $(seq 1 $times); do
        # Measure time in milliseconds
        local start=$(gdate +%s%3N 2>/dev/null || date +%s)
        ZDOTDIR=$config zsh -i -c exit 2>/dev/null
        local end=$(gdate +%s%3N 2>/dev/null || date +%s)
        local duration=$((end - start))
        total=$((total + duration))
        echo -n "."
    done
    echo ""
    
    local average=$((total / times))
    echo "Average: ${average}ms"
    echo ""
    
    return $average
}

# Test current configuration
if [ -f ~/.zshrc ]; then
    echo "📊 Current configuration:"
    benchmark_shell "$HOME" "Current .zshrc"
    current_time=$?
fi

# Test optimized configuration
echo "📊 Optimized configuration:"
export ZDOTDIR=/Users/vbsec/dotfiles/zsh
benchmark_shell "/Users/vbsec/dotfiles/zsh" "Optimized .zshrc"
optimized_time=$?

# Show comparison
if [ ! -z "$current_time" ]; then
    echo "=================================="
    echo "📈 Results:"
    echo "Current:   ${current_time}ms"
    echo "Optimized: ${optimized_time}ms"
    
    if [ $optimized_time -lt $current_time ]; then
        improvement=$((100 * (current_time - optimized_time) / current_time))
        echo "🎉 Improvement: ${improvement}% faster!"
    fi
fi

echo ""
echo "💡 Tips for further optimization:"
echo "- Disable unused lazy-loaded functions"
echo "- Remove unnecessary PATH entries"
echo "- Use 'zprof' to identify remaining bottlenecks"
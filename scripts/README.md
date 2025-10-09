# Performance Benchmarking Tools

This directory contains tools to measure and optimize development performance in the containerized environment.

## 🚀 Quick Start

### Run a Full Benchmark

```bash
./scripts/benchmark.sh
```

### Run a Quick Performance Test

```bash
./scripts/perf-test.sh
```

### Compare Two Benchmark Results

```bash
./scripts/compare-performance.sh benchmark-results/old.json benchmark-results/new.json
```

## 📊 Understanding Results

### Benchmark Metrics

- **Package Installation**: Time to install all dependencies
- **TypeScript Type Checking**: Full type validation
- **TypeScript (Fast Mode)**: Quick type check with skipLibCheck
- **ESLint**: Code linting with caching
- **Unit Tests**: Test suite execution
- **Prisma Generation**: Database client generation
- **Next.js Build**: Production build compilation

### Performance Targets

- **Package Install**: < 60s (optimized with pnpm store)
- **TypeScript**: < 15s (with incremental compilation)
- **ESLint**: < 10s (with caching)
- **Unit Tests**: < 30s
- **Next.js Build**: < 120s

## 🔧 Performance Optimizations Applied

### Container Level

- 4 CPU cores allocated
- 8GB RAM allocated
- Persistent volumes for caches
- Optimized Docker layers

### Package Manager (pnpm)

- Hardlink strategy for faster installs
- Persistent store directory
- Offline-first approach
- Side effects caching

### Development Tools

- ESLint caching enabled
- TypeScript incremental compilation
- Next.js Turbo mode
- Prisma client caching

### VSCode Optimizations

- File watcher exclusions
- TypeScript performance settings
- Search optimizations

## 📈 Tracking Performance

### Before Container Rebuild

1. Run baseline benchmark: `./scripts/benchmark.sh`
2. Note the results file location

### After Container Rebuild

1. Run new benchmark: `./scripts/benchmark.sh`
2. Compare results: `./scripts/compare-performance.sh old_file.json new_file.json`

### Expected Improvements

- **50-70%** faster package installs
- **30-50%** faster TypeScript compilation
- **60-80%** faster ESLint runs
- **20-40%** faster dev server startup

## 🛠️ Troubleshooting Slow Performance

### Clear Caches

```bash
pnpm clean:cache
```

### Reinstall with Optimizations

```bash
pnpm clean
pnpm install:fast
```

### Check System Resources

```bash
htop  # Available in optimized container
df -h # Check disk space
```

### Dev Container Issues

1. Rebuild container: `Ctrl+Shift+P` → "Rebuild Container"
2. Check Docker resources in Docker Desktop
3. Ensure volumes are properly mounted

## 📝 Performance Tips

### Daily Development

- Use `pnpm dev:fast` for quick validation
- Use `pnpm type-check:fast` for rapid type checking
- Use `pnpm install:fast` for dependency updates

### When Things Feel Slow

- Run `pnpm clean:cache` to clear tool caches
- Check if any background processes are running
- Restart dev container if necessary

### Container Optimization

- Ensure Docker has adequate resources allocated
- Use volume mounts for persistent caches
- Keep dev container image updated

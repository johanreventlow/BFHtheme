# Performance benchmarks for issue #15 and #16
library(BFHtheme)
library(microbenchmark)

cat("=== Performance Benchmarks ===\n\n")

# Benchmark #16: Palette caching
cat("Issue #16: Palette caching (bfh_pal)\n")
cat("Testing repeated palette lookups...\n\n")

# Clear cache first
suppressMessages(clear_bfh_pal_cache())

# First call (cache miss)
first_call <- microbenchmark(
  bfh_pal("main"),
  times = 100
)

# Repeated calls (cache hits)
repeated_calls <- microbenchmark(
  bfh_pal("main"),
  bfh_pal("blues"),
  bfh_pal("main", reverse = TRUE),
  times = 1000
)

cat("First call (cache miss):\n")
print(summary(first_call)[, c("expr", "mean", "median")])

cat("\nRepeated calls (cache hits):\n")
print(summary(repeated_calls)[, c("expr", "mean", "median")])

speedup <- mean(first_call$time) / mean(repeated_calls$time)
cat(sprintf("\nSpeedup: %.1fx faster with caching\n", speedup))

cat("\n" , strrep("=", 50), "\n\n")

# Benchmark #15: bfh_labs() optimization
cat("Issue #15: bfh_labs() string operations\n")
cat("Testing label transformation...\n\n")

test_labs <- microbenchmark(
  bfh_labs(
    title = "Test plot",
    subtitle = "test subtitle",
    x = "x axis label",
    y = "y axis label",
    color = "group"
  ),
  times = 1000
)

cat("bfh_labs() performance:\n")
print(summary(test_labs)[, c("expr", "mean", "median")])

cat("\n=== Benchmark Complete ===\n")

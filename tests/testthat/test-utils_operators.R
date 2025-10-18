# Tests for utility operators

# === Tests for %||% (NULL coalescing) operator ===

test_that("%||% returns left operand when not NULL", {
  # Basic cases
  expect_equal(1 %||% 2, 1)
  expect_equal("value" %||% "default", "value")
  expect_equal(TRUE %||% FALSE, TRUE)

  # Edge cases that might be falsy but are not NULL
  expect_equal(0 %||% 1, 0)
  expect_equal("" %||% "default", "")
  expect_equal(FALSE %||% TRUE, FALSE)
  expect_equal(NA %||% "default", NA)
  expect_equal(NaN %||% 1, NaN)
})

test_that("%||% returns right operand when left is NULL", {
  # Basic cases
  expect_equal(NULL %||% 2, 2)
  expect_equal(NULL %||% "default", "default")
  expect_equal(NULL %||% FALSE, FALSE)
  expect_equal(NULL %||% 0, 0)
  expect_equal(NULL %||% "", "")
  expect_equal(NULL %||% NA, NA)
})

test_that("%||% works with various data types", {
  # Vectors
  expect_equal(c(1, 2) %||% c(3, 4), c(1, 2))
  expect_equal(NULL %||% c(1, 2), c(1, 2))

  # Lists
  expect_equal(list(a = 1) %||% list(b = 2), list(a = 1))
  expect_equal(NULL %||% list(a = 1), list(a = 1))

  # Functions
  f <- function() {}
  expect_equal(f %||% function() {}, f)
  expect_equal(NULL %||% function() {}, (NULL %||% function() {}))
})

test_that("%||% handles chaining correctly", {
  # Multiple chained NULL coalescing
  expect_equal(NULL %||% NULL %||% 42, 42)
  expect_equal(NULL %||% NULL %||% NULL %||% "final", "final")

  # Chaining with non-NULL values
  expect_equal(1 %||% 2 %||% 3, 1)
  expect_equal(NULL %||% 2 %||% 3, 2)
})

test_that("%||% respects operator precedence", {
  # Test with arithmetic operations
  expect_equal((NULL %||% 5) + 3, 8)
  expect_equal(2 * (NULL %||% 4), 8)

  # Test with function calls
  result <- paste0("prefix_", NULL %||% "suffix")
  expect_equal(result, "prefix_suffix")
})

test_that("%||% works with complex expressions", {
  # Test with conditional expressions
  x <- NULL
  result <- if (x %||% FALSE) "yes" else "no"
  expect_equal(result, "no")

  # Test in function body
  func <- function(param = NULL) {
    param %||% "default"
  }
  expect_equal(func(NULL), "default")
  expect_equal(func("custom"), "custom")
  expect_equal(func(), "default")  # Default param is NULL, coalesced to "default"
})

test_that("%||% is left-associative (standard R operator precedence)", {
  # The operator should evaluate left-to-right
  # a %||% b %||% c is (a %||% b) %||% c
  expect_equal(NULL %||% NULL %||% 1, 1)
  expect_equal(1 %||% NULL %||% 2, 1)
  expect_equal(NULL %||% 1 %||% 2, 1)
})

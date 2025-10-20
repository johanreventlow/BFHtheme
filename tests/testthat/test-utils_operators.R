test_that("%||% returns left operand if not NULL", {
  # Regular values
  expect_equal(1 %||% 2, 1)
  expect_equal("value" %||% "default", "value")
  expect_equal(TRUE %||% FALSE, TRUE)

  # Edge cases: FALSE, 0, empty string are NOT NULL
  expect_equal(FALSE %||% TRUE, FALSE)
  expect_equal(0 %||% 1, 0)
  expect_equal("" %||% "default", "")

  # NA and NaN are NOT NULL
  expect_equal(NA %||% 42, NA)
  expect_equal(NaN %||% 42, NaN)

  # Empty vectors are NOT NULL
  expect_equal(character(0) %||% "default", character(0))
  expect_equal(numeric(0) %||% 1, numeric(0))
})

test_that("%||% returns right operand if left is NULL", {
  # Basic NULL coalescing
  expect_equal(NULL %||% 2, 2)
  expect_equal(NULL %||% "default", "default")
  expect_equal(NULL %||% FALSE, FALSE)
  expect_equal(NULL %||% TRUE, TRUE)

  # Right operand can be any value
  expect_equal(NULL %||% 0, 0)
  expect_equal(NULL %||% "", "")
  expect_equal(NULL %||% NA, NA)
  expect_equal(NULL %||% NaN, NaN)

  # Right operand can be empty vector
  expect_equal(NULL %||% character(0), character(0))
  expect_equal(NULL %||% numeric(0), numeric(0))
})

test_that("%||% handles chaining", {
  # Multiple NULL values cascade to final non-NULL
  expect_equal(NULL %||% NULL %||% 42, 42)
  expect_equal(NULL %||% NULL %||% NULL %||% "default", "default")

  # First non-NULL value is returned
  expect_equal(NULL %||% "first" %||% "second", "first")
  expect_equal(1 %||% 2 %||% 3, 1)
})

test_that("%||% works with complex data types", {
  # Lists
  expect_equal(NULL %||% list(a = 1), list(a = 1))
  expect_equal(list(x = 2) %||% list(y = 3), list(x = 2))

  # Data frames
  df <- data.frame(a = 1:3, b = 4:6)
  expect_equal(NULL %||% df, df)
  expect_equal(df %||% data.frame(), df)

  # Functions
  f <- function() "test"
  expect_equal(NULL %||% f, f)
  expect_equal(f %||% function() "other", f)
})

test_that("%||% handles expressions", {
  # Right side is evaluated only if needed
  counter <- 0
  increment <- function() {
    counter <<- counter + 1
    "value"
  }

  # Left is not NULL, right should not be evaluated
  result <- "existing" %||% increment()
  expect_equal(result, "existing")
  expect_equal(counter, 0)  # increment() was not called

  # Left is NULL, right should be evaluated
  result <- NULL %||% increment()
  expect_equal(result, "value")
  expect_equal(counter, 1)  # increment() was called once
})

test_that("%||% preserves attributes", {
  # Vector with attributes
  x <- 1:3
  attr(x, "custom") <- "attribute"

  result <- x %||% 4:6
  expect_equal(result, x)
  expect_equal(attr(result, "custom"), "attribute")

  # NULL case
  result <- NULL %||% x
  expect_equal(result, x)
  expect_equal(attr(result, "custom"), "attribute")
})

test_that("%||% works in typical BFHtheme use cases", {
  # Font fallback pattern (from themes.R)
  base_family <- NULL
  result <- base_family %||% "Arial"
  expect_equal(result, "Arial")

  base_family <- "Mari"
  result <- base_family %||% "Arial"
  expect_equal(result, "Mari")

  # Default value pattern (common in package)
  user_value <- NULL
  default_value <- 12
  expect_equal(user_value %||% default_value, 12)

  user_value <- 14
  expect_equal(user_value %||% default_value, 14)
})

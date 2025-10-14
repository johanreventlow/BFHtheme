# Tests for validation helper functions

# === Tests for validate_palette_argument() ===

test_that("validate_palette_argument accepts valid single character strings", {
  # Valid inputs should pass through unchanged
  expect_equal(validate_palette_argument("main"), "main")
  expect_equal(validate_palette_argument("blues"), "blues")
  expect_equal(validate_palette_argument("primary"), "primary")
})

test_that("validate_palette_argument rejects empty strings", {
  expect_error(
    validate_palette_argument(""),
    "palette must be a single character string"
  )
})

test_that("validate_palette_argument rejects character vectors with multiple elements", {
  expect_error(
    validate_palette_argument(c("main", "blues")),
    "palette must be a single character string"
  )
})

test_that("validate_palette_argument rejects non-character inputs", {
  expect_error(
    validate_palette_argument(123),
    "palette must be a single character string"
  )

  expect_error(
    validate_palette_argument(TRUE),
    "palette must be a single character string"
  )

  expect_error(
    validate_palette_argument(NULL),
    "palette must be a single character string"
  )
})

test_that("validate_palette_argument rejects NA", {
  expect_error(
    validate_palette_argument(NA_character_),
    "palette must be a single character string"
  )
})

# === Tests for validate_logical_argument() ===

test_that("validate_logical_argument accepts valid single logical values", {
  # Valid inputs should pass through unchanged
  expect_equal(validate_logical_argument(TRUE, "reverse"), TRUE)
  expect_equal(validate_logical_argument(FALSE, "discrete"), FALSE)
})

test_that("validate_logical_argument rejects NA", {
  expect_error(
    validate_logical_argument(NA, "reverse"),
    "reverse must be a single logical value"
  )
})

test_that("validate_logical_argument rejects logical vectors with multiple elements", {
  expect_error(
    validate_logical_argument(c(TRUE, FALSE), "reverse"),
    "reverse must be a single logical value"
  )
})

test_that("validate_logical_argument rejects non-logical inputs", {
  expect_error(
    validate_logical_argument("TRUE", "reverse"),
    "reverse must be a single logical value"
  )

  expect_error(
    validate_logical_argument(1, "discrete"),
    "discrete must be a single logical value"
  )

  expect_error(
    validate_logical_argument(NULL, "reverse"),
    "reverse must be a single logical value"
  )
})

test_that("validate_logical_argument uses custom argument name in error messages", {
  expect_error(
    validate_logical_argument(NA, "custom_arg"),
    "custom_arg must be a single logical value"
  )

  expect_error(
    validate_logical_argument("invalid", "another_param"),
    "another_param must be a single logical value"
  )
})

# === Integration tests ===

test_that("validation helpers work together in typical scale function pattern", {
  # Simulate typical usage in scale functions
  palette <- "main"
  discrete <- TRUE
  reverse <- FALSE

  # Should not throw errors
  expect_silent({
    palette <- validate_palette_argument(palette)
    discrete <- validate_logical_argument(discrete, "discrete")
    reverse <- validate_logical_argument(reverse, "reverse")
  })

  expect_equal(palette, "main")
  expect_equal(discrete, TRUE)
  expect_equal(reverse, FALSE)
})

test_that("validation helpers catch multiple invalid arguments correctly", {
  # First invalid argument should be caught
  expect_error(
    {
      palette <- validate_palette_argument(c("a", "b"))
      discrete <- validate_logical_argument(NA, "discrete")
    },
    "palette must be a single character string"
  )

  # If palette is valid, logical validation should be caught
  expect_error(
    {
      palette <- validate_palette_argument("main")
      discrete <- validate_logical_argument(NA, "discrete")
    },
    "discrete must be a single logical value"
  )
})

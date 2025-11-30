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

# === Tests for validate_numeric_range() ===

test_that("validate_numeric_range accepts valid numeric values within range", {
  # Valid inputs should pass through unchanged
  expect_equal(validate_numeric_range(0.5, "size", 0, 1), 0.5)
  expect_equal(validate_numeric_range(0, "alpha", 0, 1), 0)
  expect_equal(validate_numeric_range(1, "padding", 0, 1), 1)
  expect_equal(validate_numeric_range(12, "base_size", 6, 24), 12)
})

test_that("validate_numeric_range accepts NULL when allow_null = TRUE", {
  expect_null(validate_numeric_range(NULL, "size", 0, 1, allow_null = TRUE))
})

test_that("validate_numeric_range rejects values below minimum", {
  expect_error(
    validate_numeric_range(-0.1, "size", 0, 1),
    "size must be between 0 and 1"
  )
  expect_error(
    validate_numeric_range(5, "base_size", 6, 24),
    "base_size must be between 6 and 24"
  )
})

test_that("validate_numeric_range rejects values above maximum", {
  expect_error(
    validate_numeric_range(1.5, "alpha", 0, 1),
    "alpha must be between 0 and 1"
  )
  expect_error(
    validate_numeric_range(30, "base_size", 6, 24),
    "base_size must be between 6 and 24"
  )
})

test_that("validate_numeric_range rejects non-numeric inputs", {
  expect_error(
    validate_numeric_range("0.5", "size", 0, 1),
    "size must be a single numeric value"
  )
  expect_error(
    validate_numeric_range(TRUE, "alpha", 0, 1),
    "alpha must be a single numeric value"
  )
})

test_that("validate_numeric_range rejects NULL when allow_null = FALSE", {
  expect_error(
    validate_numeric_range(NULL, "size", 0, 1, allow_null = FALSE),
    "size cannot be NULL"
  )
})

test_that("validate_numeric_range rejects NA", {
  expect_error(
    validate_numeric_range(NA_real_, "size", 0, 1),
    "size must be a single numeric value"
  )
})

test_that("validate_numeric_range rejects vectors with multiple elements", {
  expect_error(
    validate_numeric_range(c(0.5, 0.6), "size", 0, 1),
    "size must be a single numeric value"
  )
})

# === Tests for validate_choice() ===

test_that("validate_choice accepts valid choices", {
  expect_equal(validate_choice("topleft", "position", c("topleft", "topright", "bottomleft", "bottomright")), "topleft")
  expect_equal(validate_choice("web", "size", c("web", "print", "presentation")), "web")
})

test_that("validate_choice accepts NULL when allow_null = TRUE", {
  expect_null(validate_choice(NULL, "position", c("top", "bottom"), allow_null = TRUE))
})

test_that("validate_choice rejects invalid choices", {
  expect_error(
    validate_choice("middle", "position", c("top", "bottom")),
    "position must be one of"
  )
  expect_error(
    validate_choice("large", "size", c("small", "medium")),
    "size must be one of"
  )
})

test_that("validate_choice rejects NULL when allow_null = FALSE", {
  expect_error(
    validate_choice(NULL, "position", c("top", "bottom"), allow_null = FALSE),
    "position cannot be NULL"
  )
})

test_that("validate_choice rejects non-character inputs", {
  expect_error(
    validate_choice(1, "position", c("top", "bottom")),
    "position must be a single character value"
  )
})

test_that("validate_choice rejects vectors with multiple elements", {
  expect_error(
    validate_choice(c("top", "bottom"), "position", c("top", "bottom", "middle")),
    "position must be a single character value"
  )
})

test_that("validate_choice handles case sensitivity", {
  # Default is case-sensitive
  expect_error(
    validate_choice("TopLeft", "position", c("topleft", "topright")),
    "position must be one of"
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

# === Tests for validate_numeric_range() ===

test_that("validate_numeric_range accepts values within range", {
  expect_equal(BFHtheme:::validate_numeric_range(0.5, "size", 0, 1), 0.5)
  expect_equal(BFHtheme:::validate_numeric_range(0, "size", 0, 1), 0)
  expect_equal(BFHtheme:::validate_numeric_range(1, "size", 0, 1), 1)
  expect_equal(BFHtheme:::validate_numeric_range(-5, "value", -10, 0), -5)
})

test_that("validate_numeric_range rejects values outside range", {
  expect_error(
    BFHtheme:::validate_numeric_range(1.5, "size", 0, 1),
    "size must be between"
  )

  expect_error(
    BFHtheme:::validate_numeric_range(-0.1, "alpha", 0, 1),
    "alpha must be between"
  )
})

test_that("validate_numeric_range rejects non-numeric inputs", {
  expect_error(
    BFHtheme:::validate_numeric_range("0.5", "size", 0, 1),
    "size must be a single numeric value"
  )

  expect_error(
    BFHtheme:::validate_numeric_range(c(0.5, 0.6), "size", 0, 1),
    "size must be a single numeric value"
  )
})

test_that("validate_numeric_range handles NULL based on allow_null parameter", {
  expect_equal(BFHtheme:::validate_numeric_range(NULL, "size", 0, 1, allow_null = TRUE), NULL)

  expect_error(
    BFHtheme:::validate_numeric_range(NULL, "size", 0, 1, allow_null = FALSE),
    "size cannot be NULL"
  )
})

# === Tests for validate_choice() ===

test_that("validate_choice accepts valid choices", {
  expect_equal(
    BFHtheme:::validate_choice("topleft", "position", c("topleft", "topright", "bottomleft")),
    "topleft"
  )

  expect_equal(
    BFHtheme:::validate_choice("color", "variant", c("color", "grey", "mark")),
    "color"
  )
})

test_that("validate_choice rejects invalid choices", {
  expect_error(
    BFHtheme:::validate_choice("invalid", "position", c("topleft", "topright")),
    "position must be one of"
  )

  expect_error(
    BFHtheme:::validate_choice("blue", "color", c("red", "green")),
    "color must be one of"
  )
})

test_that("validate_choice rejects non-character inputs", {
  expect_error(
    BFHtheme:::validate_choice(1, "position", c("topleft", "topright")),
    "position must be a single character value"
  )

  expect_error(
    BFHtheme:::validate_choice(c("a", "b"), "choice", c("a", "b", "c")),
    "choice must be a single character value"
  )
})

test_that("validate_choice handles NULL based on allow_null parameter", {
  expect_equal(
    BFHtheme:::validate_choice(NULL, "position", c("topleft", "topright"), allow_null = TRUE),
    NULL
  )

  expect_error(
    BFHtheme:::validate_choice(NULL, "position", c("topleft", "topright"), allow_null = FALSE),
    "position cannot be NULL"
  )
})

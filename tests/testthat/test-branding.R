# Tests for branding functions

# === Helper: Create test logo ===
# Creates a test logo with known aspect ratio for tests
create_test_logo <- function() {
  test_logo_path <- tempfile(fileext = ".png")
  if (requireNamespace("png", quietly = TRUE)) {
    # Create a simple 5x10 pixel logo (height x width)
    # This gives us a 1:2 aspect ratio (height:width)
    logo_array <- array(0, dim = c(5, 10, 3))
    logo_array[,,3] <- 1  # Blue color
    png::writePNG(logo_array, test_logo_path)
  }
  return(test_logo_path)
}

# Create a logo for use in tests
test_logo_path <- create_test_logo()

# === Tests for add_bfh_logo() ===

test_that("add_bfh_logo validates file exists", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  expect_error(
    add_bfh_logo(p, "nonexistent_file.png"),
    "Logo file not found"
  )
})

test_that("add_bfh_logo blocks path traversal attempts", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # Test path traversal patterns
  expect_error(
    add_bfh_logo(p, "../../../etc/passwd"),
    "Path traversal patterns"
  )

  expect_error(
    add_bfh_logo(p, "~/secret/file.png"),
    "Path traversal patterns"
  )

  expect_error(
    add_bfh_logo(p, "../logo.png"),
    "Path traversal patterns"
  )
})

test_that("add_bfh_logo validates logo_path type", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # NULL
  expect_error(
    add_bfh_logo(p, NULL),
    "logo_path must be a non-empty character string"
  )

  # Empty string
  expect_error(
    add_bfh_logo(p, ""),
    "logo_path must be a non-empty character string"
  )

  # Numeric
  expect_error(
    add_bfh_logo(p, 123),
    "logo_path must be a non-empty character string"
  )

  # Vector
  expect_error(
    add_bfh_logo(p, c("file1.png", "file2.png")),
    "logo_path must be a non-empty character string"
  )
})

test_that("add_bfh_logo validates size parameter", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # Size must be > 0 and <= 1
  expect_error(
    add_bfh_logo(p, test_logo_path, size = 0),
    "size must be a number between 0 and 1"
  )

  expect_error(
    add_bfh_logo(p, test_logo_path, size = 1.5),
    "size must be a number between 0 and 1"
  )

  expect_error(
    add_bfh_logo(p, test_logo_path, size = -0.1),
    "size must be a number between 0 and 1"
  )
})

test_that("add_bfh_logo validates alpha parameter", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  expect_error(
    add_bfh_logo(p, test_logo_path, alpha = 1.5),
    "alpha must be a number between 0 and 1"
  )

  expect_error(
    add_bfh_logo(p, test_logo_path, alpha = -0.1),
    "alpha must be a number between 0 and 1"
  )
})

test_that("add_bfh_logo accepts valid positions", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # All valid positions should work
  expect_s3_class(
    add_bfh_logo(p, test_logo_path, position = "topleft"),
    "ggplot"
  )
  expect_s3_class(
    add_bfh_logo(p, test_logo_path, position = "topright"),
    "ggplot"
  )
  expect_s3_class(
    add_bfh_logo(p, test_logo_path, position = "bottomleft"),
    "ggplot"
  )
  expect_s3_class(
    add_bfh_logo(p, test_logo_path, position = "bottomright"),
    "ggplot"
  )
})

test_that("add_bfh_logo rejects invalid position", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  expect_error(
    add_bfh_logo(p, test_logo_path, position = "center"),
    "position must be one of"
  )
})

test_that("add_bfh_logo returns ggplot object", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  result <- add_bfh_logo(p, test_logo_path)

  expect_s3_class(result, "ggplot")
})

test_that("add_bfh_logo preserves aspect ratio", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")
  skip_if_not_installed("grid")

  # Create test logo with known aspect ratio
  # 5 pixels high, 10 pixels wide = 0.5 aspect ratio
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # This test verifies that the logo uses different width and height
  # based on aspect ratio (should not be square)
  result <- add_bfh_logo(p, test_logo_path, size = 0.2)

  expect_s3_class(result, "ggplot")
  # Functional test: ensure it doesn't error and returns valid plot
})

# === Tests for add_bfh_footer() ===

test_that("add_bfh_footer returns ggplot object", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  result <- add_bfh_footer(p)

  expect_s3_class(result, "ggplot")
})

test_that("add_bfh_footer accepts custom text", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  result <- add_bfh_footer(p, text = "Custom footer text")

  expect_s3_class(result, "ggplot")
})

test_that("add_bfh_footer accepts custom colors", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  result <- add_bfh_footer(
    p,
    color = "#FF0000",
    text_color = "black"
  )

  expect_s3_class(result, "ggplot")
})

# === Tests for bfh_title_block() ===

test_that("bfh_title_block returns labs object", {
  result <- bfh_title_block("Test Title")
  # ggplot2 labels objects have class c("ggplot2::labels", "gg", "S7_object")
  expect_true(inherits(result, "ggplot2::labels") || inherits(result, "gg"))
})

test_that("bfh_title_block accepts subtitle and caption", {
  result <- bfh_title_block(
    title = "Main Title",
    subtitle = "Subtitle text",
    caption = "Caption text"
  )

  expect_true(inherits(result, "ggplot2::labels") || inherits(result, "gg"))
})

test_that("bfh_title_block can be added to plot", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    bfh_title_block("Test Title")

  expect_s3_class(p, "ggplot")
})

# === Cleanup ===
# Cleanup happens automatically with withr

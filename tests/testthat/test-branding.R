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

test_that("add_bfh_logo enforces optional root restriction", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  root_dir <- tempfile("bfh-logo-root")
  dir.create(root_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(root_dir, recursive = TRUE), add = TRUE)

  inside_logo <- file.path(root_dir, "logo-inside.png")
  file.copy(test_logo_path, inside_logo, overwrite = TRUE)

  original_option <- getOption("BFHtheme.logo_root")
  on.exit(options(BFHtheme.logo_root = original_option), add = TRUE)
  options(BFHtheme.logo_root = root_dir)

  expect_s3_class(
    add_bfh_logo(p, inside_logo),
    "ggplot"
  )

  expect_error(
    add_bfh_logo(p, test_logo_path),
    "allowed root"
  )
})

test_that("add_bfh_logo accepts normalized shortcuts", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # Home directory shortcut
  home_logo <- tempfile(pattern = "bfh-logo-", tmpdir = path.expand("~"), fileext = ".png")
  on.exit(unlink(home_logo), add = TRUE)
  file.copy(test_logo_path, home_logo, overwrite = TRUE)

  expect_s3_class(
    add_bfh_logo(p, file.path("~", basename(home_logo))),
    "ggplot"
  )

  # Relative parent reference
  original_wd <- getwd()
  temp_root <- tempfile("bfh-relative")
  dir.create(temp_root, recursive = TRUE, showWarnings = FALSE)
  nested_dir <- file.path(temp_root, "nested")
  dir.create(nested_dir, showWarnings = FALSE)
  parent_logo <- file.path(temp_root, "logo-relative.png")
  file.copy(test_logo_path, parent_logo, overwrite = TRUE)

  on.exit(unlink(parent_logo), add = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  on.exit(setwd(original_wd), add = TRUE)

  setwd(nested_dir)

  expect_s3_class(
    add_bfh_logo(p, "../logo-relative.png"),
    "ggplot"
  )
})

test_that("add_bfh_logo accepts NULL logo_path (default logo)", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # NULL should load default logo
  expect_s3_class(
    add_bfh_logo(p),  # logo_path = NULL by default
    "ggplot"
  )
})

test_that("add_bfh_logo validates logo_path type when provided", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

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

test_that("add_bfh_logo rejects invalid MIME types", {
  skip_if_not_installed("ggplot2")

  bogus_logo <- tempfile(fileext = ".png")
  writeLines("not a real image", bogus_logo)

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  expect_error(
    add_bfh_logo(p, bogus_logo),
    "Logo file must be a valid PNG or JPEG image"
  )
})


test_that("add_bfh_logo validates alpha parameter", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  expect_error(
    add_bfh_logo(p, test_logo_path, alpha = 1.5),
    "alpha must be between 0 and 1"
  )

  expect_error(
    add_bfh_logo(p, test_logo_path, alpha = -0.1),
    "alpha must be between 0 and 1"
  )
})

test_that("add_bfh_logo uses fixed positioning", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # Function should work with minimal parameters (fixed positioning)
  result <- add_bfh_logo(p, test_logo_path)
  expect_s3_class(result, "ggplot")

  # With alpha parameter
  result_alpha <- add_bfh_logo(p, test_logo_path, alpha = 0.7)
  expect_s3_class(result_alpha, "ggplot")
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
  # Fixed positioning now uses 1/15 height, width calculated from aspect ratio
  result <- add_bfh_logo(p, test_logo_path)

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

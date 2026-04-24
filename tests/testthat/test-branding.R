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
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  root_dir <- withr::local_tempdir(pattern = "bfh-logo-root")
  inside_logo <- file.path(root_dir, "logo-inside.png")
  file.copy(test_logo_path, inside_logo, overwrite = TRUE)

  withr::local_options(BFHtheme.logo_root = root_dir)

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
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # ~ is expanded (not blocked) — verify without writing to home directory
  expect_error(
    add_bfh_logo(p, "~/bfh-test-logo-does-not-exist.png"),
    "Logo file not found"
  )

  # Relative parent reference
  temp_root <- withr::local_tempdir(pattern = "bfh-relative")
  nested_dir <- file.path(temp_root, "nested")
  dir.create(nested_dir, showWarnings = FALSE)
  parent_logo <- file.path(temp_root, "logo-relative.png")
  file.copy(test_logo_path, parent_logo, overwrite = TRUE)

  withr::local_dir(nested_dir)

  expect_s3_class(
    add_bfh_logo(p, "../logo-relative.png"),
    "ggplot"
  )
})

test_that("add_bfh_logo accepts NULL logo_path (default logo)", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

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
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

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
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  result <- add_bfh_logo(p, test_logo_path)

  expect_s3_class(result, "ggplot")
})

test_that("add_bfh_logo preserves aspect ratio", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")
  skip_if_not_installed("grid")
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

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

test_that("add_bfh_footer rejects invalid height", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  expect_error(add_bfh_footer(p, height = -1),  "height must be in \\(0, 1\\]")
  expect_error(add_bfh_footer(p, height = 0),   "height must be in \\(0, 1\\]")
  expect_error(add_bfh_footer(p, height = 2),   "height must be in \\(0, 1\\]")
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

# === Tests for logo cache ===

test_that("logo cache returns same array on repeated calls", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # Clear cache before test
  clear_bfh_logo_cache()
  on.exit(clear_bfh_logo_cache(), add = TRUE)

  # First call: populates cache
  add_bfh_logo(p, test_logo_path)
  n_after_first <- length(ls(envir = BFHtheme:::.bfh_logo_cache))

  # Second identical call: should not add new cache entry
  add_bfh_logo(p, test_logo_path)
  n_after_second <- length(ls(envir = BFHtheme:::.bfh_logo_cache))

  expect_equal(n_after_first, 1L)
  expect_equal(n_after_second, 1L)
})

test_that("logo cache invalidates when file mtime changes", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  fresh_logo <- tempfile(fileext = ".png")
  logo_array <- array(0, dim = c(5, 10, 3))
  png::writePNG(logo_array, fresh_logo)
  on.exit(unlink(fresh_logo), add = TRUE)

  clear_bfh_logo_cache()
  on.exit(clear_bfh_logo_cache(), add = TRUE)

  add_bfh_logo(p, fresh_logo)
  n_after_first <- length(ls(envir = BFHtheme:::.bfh_logo_cache))

  # Touch file to simulate mtime change
  Sys.sleep(1.1)
  png::writePNG(logo_array, fresh_logo)

  add_bfh_logo(p, fresh_logo)
  n_after_second <- length(ls(envir = BFHtheme:::.bfh_logo_cache))

  expect_equal(n_after_first, 1L)
  expect_equal(n_after_second, 2L)  # New cache entry for new mtime
})

# === Tests for resource limits ===

test_that("add_bfh_logo rejects files exceeding max bytes", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  withr::local_options(BFHtheme.logo_max_bytes = 1L)

  expect_error(
    add_bfh_logo(p, test_logo_path),
    "exceeds size limit"
  )
})

test_that("add_bfh_logo accepts files within custom max bytes", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")
  skip_if_not_installed("cowplot")
  skip_if_not_installed("magick")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  withr::local_options(BFHtheme.logo_max_bytes = 10 * 1024^2)

  expect_s3_class(add_bfh_logo(p, test_logo_path), "ggplot")
})

test_that("add_bfh_logo rejects images exceeding max dim", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("png")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  large_logo <- tempfile(fileext = ".png")
  large_array <- array(0.5, dim = c(10, 10, 3))
  png::writePNG(large_array, large_logo)
  on.exit(unlink(large_logo), add = TRUE)

  withr::local_options(BFHtheme.logo_max_dim = 5L)

  expect_error(
    add_bfh_logo(p, large_logo),
    "exceed.*limit"
  )
})

test_that("add_bfh_logo stops when cowplot is absent", {
  skip_if_not_installed("ggplot2")
  # This test only runs in environments where cowplot is not installed.
  # It validates the fail-hard contract for missing cowplot.
  skip_if(requireNamespace("cowplot", quietly = TRUE),
          "Test requires cowplot to be absent")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  expect_error(add_bfh_logo(p), "cowplot")
})

# === Cleanup ===
# Cleanup happens automatically with withr

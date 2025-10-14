# Tests for logo helper functions

# === Tests for get_bfh_logo() ===

test_that("get_bfh_logo accepts valid size values", {
  # All valid sizes should not error
  expect_no_error(get_bfh_logo(size = "full"))
  expect_no_error(get_bfh_logo(size = "web"))
  expect_no_error(get_bfh_logo(size = "small"))
})

test_that("get_bfh_logo accepts valid variant values", {
  # All valid variants should not error
  expect_no_error(get_bfh_logo(variant = "color"))
  expect_no_error(get_bfh_logo(variant = "grey"))
  expect_no_error(get_bfh_logo(variant = "mark"))
})

test_that("get_bfh_logo rejects invalid size values", {
  expect_error(
    get_bfh_logo(size = "invalid"),
    "'arg' should be one of"
  )

  expect_error(
    get_bfh_logo(size = "large"),
    "'arg' should be one of"
  )
})

test_that("get_bfh_logo rejects invalid variant values", {
  expect_error(
    get_bfh_logo(variant = "invalid"),
    "'arg' should be one of"
  )

  expect_error(
    get_bfh_logo(variant = "blue"),
    "'arg' should be one of"
  )
})

test_that("get_bfh_logo returns character path or NULL", {
  result <- get_bfh_logo()

  # Should return either character path or NULL (if files not installed)
  expect_true(is.character(result) || is.null(result))

  # If character, should not be empty
  if (is.character(result)) {
    expect_true(nchar(result) > 0)
  }
})

test_that("get_bfh_logo returns different paths for different sizes", {
  skip_if(is.null(get_bfh_logo("full")), "Logo files not installed")

  full <- get_bfh_logo("full", "color")
  web <- get_bfh_logo("web", "color")
  small <- get_bfh_logo("small", "color")

  # All should be character
  expect_type(full, "character")
  expect_type(web, "character")
  expect_type(small, "character")

  # Full and web should be different
  expect_false(identical(full, web))
})

test_that("get_bfh_logo returns different paths for different variants", {
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  color <- get_bfh_logo(variant = "color")
  grey <- get_bfh_logo(variant = "grey")
  mark <- get_bfh_logo(variant = "mark")

  # All should be character
  expect_type(color, "character")
  expect_type(grey, "character")
  expect_type(mark, "character")

  # All should be different
  expect_false(identical(color, grey))
  expect_false(identical(color, mark))
  expect_false(identical(grey, mark))
})

test_that("get_bfh_logo warns when files not found", {
  # This test assumes logo files are not installed in test environment
  # If files are installed, the test will be skipped
  skip_if_not(is.null(get_bfh_logo()), "Logo files are installed")

  expect_warning(
    get_bfh_logo(),
    "BFH logo file not found"
  )
})

test_that("get_bfh_logo paths exist when returned", {
  path <- get_bfh_logo()

  # If path is returned (not NULL), it should exist
  if (!is.null(path)) {
    expect_true(file.exists(path))
  }
})

# === Tests for add_logo() ===

test_that("add_logo returns plot when logo files available", {
  skip_if_not_installed("ggplot2")
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    theme_bfh()

  result <- add_logo(p)
  expect_s3_class(result, "ggplot")
})

test_that("add_logo returns plot without logo when files unavailable", {
  skip_if_not_installed("ggplot2")
  skip_if_not(is.null(get_bfh_logo()), "Logo files are installed")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  expect_warning(
    result <- add_logo(p),
    "Could not find BFH logo"
  )

  expect_s3_class(result, "ggplot")
})

test_that("add_logo accepts all position values", {
  skip_if_not_installed("ggplot2")
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  expect_s3_class(add_logo(p, position = "topleft"), "ggplot")
  expect_s3_class(add_logo(p, position = "topright"), "ggplot")
  expect_s3_class(add_logo(p, position = "bottomleft"), "ggplot")
  expect_s3_class(add_logo(p, position = "bottomright"), "ggplot")
})

test_that("add_logo accepts size parameter", {
  skip_if_not_installed("ggplot2")
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  expect_s3_class(add_logo(p, size = 0.1), "ggplot")
  expect_s3_class(add_logo(p, size = 0.2), "ggplot")
})

test_that("add_logo accepts alpha parameter", {
  skip_if_not_installed("ggplot2")
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  expect_s3_class(add_logo(p, alpha = 0.5), "ggplot")
  expect_s3_class(add_logo(p, alpha = 1.0), "ggplot")
})

test_that("add_logo accepts logo_size parameter", {
  skip_if_not_installed("ggplot2")
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  expect_s3_class(add_logo(p, logo_size = "full"), "ggplot")
  expect_s3_class(add_logo(p, logo_size = "web"), "ggplot")
  expect_s3_class(add_logo(p, logo_size = "small"), "ggplot")
})

test_that("add_logo accepts variant parameter", {
  skip_if_not_installed("ggplot2")
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  expect_s3_class(add_logo(p, variant = "color"), "ggplot")
  expect_s3_class(add_logo(p, variant = "grey"), "ggplot")
  expect_s3_class(add_logo(p, variant = "mark"), "ggplot")
})

test_that("add_logo combines multiple parameters correctly", {
  skip_if_not_installed("ggplot2")
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  result <- add_logo(
    p,
    position = "topright",
    size = 0.12,
    alpha = 0.8,
    logo_size = "small",
    variant = "grey"
  )

  expect_s3_class(result, "ggplot")
})

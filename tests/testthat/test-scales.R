# Tests for scale functions

test_that("scale_color_bfh creates ggplot scale", {
  scale <- scale_color_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleDiscrete")
})

test_that("scale_fill_bfh creates ggplot scale", {
  scale <- scale_fill_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleDiscrete")
})

test_that("scale_colour_bfh is alias for scale_color_bfh", {
  scale1 <- scale_color_bfh()
  scale2 <- scale_colour_bfh()

  expect_s3_class(scale1, "Scale")
  expect_s3_class(scale2, "Scale")
})

test_that("scale_color_bfh_continuous creates continuous scale", {
  scale <- scale_color_bfh_continuous()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuous")
})

test_that("scale_fill_bfh_continuous creates continuous scale", {
  scale <- scale_fill_bfh_continuous()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuous")
})

test_that("scale_color_bfh_discrete creates discrete scale", {
  scale <- scale_color_bfh_discrete()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleDiscrete")
})

test_that("scale_fill_bfh_discrete creates discrete scale", {
  scale <- scale_fill_bfh_discrete()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleDiscrete")
})

test_that("scale_color_bfh accepts palette parameter", {
  scale_main <- scale_color_bfh(palette = "main")
  scale_blues <- scale_color_bfh(palette = "blues")

  expect_s3_class(scale_main, "Scale")
  expect_s3_class(scale_blues, "Scale")
})

test_that("scale_fill_bfh accepts palette parameter", {
  scale_main <- scale_fill_bfh(palette = "main")
  scale_blues <- scale_fill_bfh(palette = "blues")

  expect_s3_class(scale_main, "Scale")
  expect_s3_class(scale_blues, "Scale")
})

test_that("scale_color_bfh works with ggplot2", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, color = factor(cyl))) +
    ggplot2::geom_point() +
    scale_color_bfh()

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})

test_that("scale_fill_bfh works with ggplot2", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(factor(cyl))) +
    ggplot2::geom_bar(ggplot2::aes(fill = factor(cyl))) +
    scale_fill_bfh()

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})

test_that("continuous scales work with ggplot2", {
  skip_if_not_installed("ggplot2")

  p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, color = hp)) +
    ggplot2::geom_point() +
    scale_color_bfh_continuous()

  p2 <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_hex() +
    scale_fill_bfh_continuous()

  expect_s3_class(p1, "gg")
  expect_s3_class(p2, "gg")
})

# === Input Validation Tests ===

test_that("scale_color_bfh validates palette parameter", {
  # Non-character palette
  expect_error(
    scale_color_bfh(palette = 123),
    "palette must be a single character string"
  )

  # NULL palette
  expect_error(
    scale_color_bfh(palette = NULL),
    "palette must be a single character string"
  )

  # Vector palette
  expect_error(
    scale_color_bfh(palette = c("main", "blues")),
    "palette must be a single character string"
  )

  # Empty string palette
  expect_error(
    scale_color_bfh(palette = ""),
    "palette must be a single character string"
  )
})

test_that("scale_color_bfh validates discrete parameter", {
  # Non-logical discrete
  expect_error(
    scale_color_bfh(discrete = "TRUE"),
    "discrete must be a single logical value"
  )

  # Numeric discrete
  expect_error(
    scale_color_bfh(discrete = 1),
    "discrete must be a single logical value"
  )

  # NA discrete
  expect_error(
    scale_color_bfh(discrete = NA),
    "discrete must be a single logical value"
  )

  # Vector discrete
  expect_error(
    scale_color_bfh(discrete = c(TRUE, FALSE)),
    "discrete must be a single logical value"
  )
})

test_that("scale_color_bfh validates reverse parameter", {
  # Non-logical reverse
  expect_error(
    scale_color_bfh(reverse = "TRUE"),
    "reverse must be a single logical value"
  )

  # Numeric reverse
  expect_error(
    scale_color_bfh(reverse = 1),
    "reverse must be a single logical value"
  )

  # NA reverse
  expect_error(
    scale_color_bfh(reverse = NA),
    "reverse must be a single logical value"
  )

  # Vector reverse
  expect_error(
    scale_color_bfh(reverse = c(TRUE, FALSE)),
    "reverse must be a single logical value"
  )
})

test_that("scale_fill_bfh validates palette parameter", {
  expect_error(
    scale_fill_bfh(palette = 123),
    "palette must be a single character string"
  )

  expect_error(
    scale_fill_bfh(palette = NULL),
    "palette must be a single character string"
  )

  expect_error(
    scale_fill_bfh(palette = c("main", "blues")),
    "palette must be a single character string"
  )
})

test_that("scale_fill_bfh validates discrete and reverse parameters", {
  expect_error(
    scale_fill_bfh(discrete = "TRUE"),
    "discrete must be a single logical value"
  )

  expect_error(
    scale_fill_bfh(reverse = 1),
    "reverse must be a single logical value"
  )

  expect_error(
    scale_fill_bfh(discrete = NA),
    "discrete must be a single logical value"
  )
})

test_that("scale_color_bfh_continuous validates palette parameter", {
  expect_error(
    scale_color_bfh_continuous(palette = 123),
    "palette must be a single character string"
  )

  expect_error(
    scale_color_bfh_continuous(palette = NULL),
    "palette must be a single character string"
  )

  expect_error(
    scale_color_bfh_continuous(palette = c("blues", "greys")),
    "palette must be a single character string"
  )
})

test_that("scale_color_bfh_continuous validates reverse parameter", {
  expect_error(
    scale_color_bfh_continuous(reverse = "FALSE"),
    "reverse must be a single logical value"
  )

  expect_error(
    scale_color_bfh_continuous(reverse = 0),
    "reverse must be a single logical value"
  )

  expect_error(
    scale_color_bfh_continuous(reverse = NA),
    "reverse must be a single logical value"
  )
})

test_that("scale_fill_bfh_continuous validates parameters", {
  expect_error(
    scale_fill_bfh_continuous(palette = 123),
    "palette must be a single character string"
  )

  expect_error(
    scale_fill_bfh_continuous(reverse = "TRUE"),
    "reverse must be a single logical value"
  )
})

test_that("scale_color_bfh_discrete validates parameters", {
  expect_error(
    scale_color_bfh_discrete(palette = 123),
    "palette must be a single character string"
  )

  expect_error(
    scale_color_bfh_discrete(reverse = NA),
    "reverse must be a single logical value"
  )
})

test_that("scale_fill_bfh_discrete validates parameters", {
  expect_error(
    scale_fill_bfh_discrete(palette = NULL),
    "palette must be a single character string"
  )

  expect_error(
    scale_fill_bfh_discrete(reverse = c(TRUE, FALSE)),
    "reverse must be a single logical value"
  )
})

test_that("all scale functions accept valid parameter values", {
  # These should all work without errors
  expect_s3_class(scale_color_bfh(palette = "main", discrete = TRUE, reverse = FALSE), "Scale")
  expect_s3_class(scale_fill_bfh(palette = "blues", discrete = FALSE, reverse = TRUE), "Scale")
  expect_s3_class(scale_color_bfh_continuous(palette = "blues", reverse = TRUE), "Scale")
  expect_s3_class(scale_fill_bfh_continuous(palette = "greys", reverse = FALSE), "Scale")
  expect_s3_class(scale_color_bfh_discrete(palette = "primary", reverse = TRUE), "Scale")
  expect_s3_class(scale_fill_bfh_discrete(palette = "contrast", reverse = FALSE), "Scale")
})

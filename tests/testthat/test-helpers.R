# Tests for helper functions

test_that("get_bfh_dimensions returns valid dimensions", {
  dims <- get_bfh_dimensions("report", "standard")

  expect_type(dims, "list")
  expect_named(dims, c("width", "height"))
  expect_true(dims$width > 0)
  expect_true(dims$height > 0)
  expect_type(dims$width, "double")
  expect_type(dims$height, "double")
})

test_that("get_bfh_dimensions supports all types", {
  types <- c("report", "presentation", "poster", "web", "print")

  for (type in types) {
    dims <- get_bfh_dimensions(type, "standard")
    expect_type(dims, "list")
    expect_true(dims$width > 0)
    expect_true(dims$height > 0)
  }
})

test_that("get_bfh_dimensions supports all formats", {
  formats <- c("standard", "wide", "square")

  for (format in formats) {
    dims <- get_bfh_dimensions("report", format)
    expect_type(dims, "list")
    expect_true(dims$width > 0)
    expect_true(dims$height > 0)
  }
})

test_that("get_bfh_dimensions handles invalid type gracefully", {
  expect_warning(dims <- get_bfh_dimensions("invalid_type", "standard"))
  expect_type(dims, "list")
  expect_true(dims$width > 0)
})

test_that("get_bfh_dimensions handles invalid format gracefully", {
  expect_warning(dims <- get_bfh_dimensions("report", "invalid_format"))
  expect_type(dims, "list")
  expect_true(dims$width > 0)
})

test_that("bfh_save validates inputs", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # Should work with valid inputs
  temp_file <- tempfile(fileext = ".png")
  expect_no_error(bfh_save(temp_file, p))
  unlink(temp_file)
})

test_that("bfh_save uses preset dimensions", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  temp_file <- tempfile(fileext = ".png")
  result <- suppressMessages(bfh_save(temp_file, p, preset = "report_full"))

  expect_equal(result, temp_file)
  expect_true(file.exists(temp_file))
  unlink(temp_file)
})

test_that("bfh_save accepts custom dimensions", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  temp_file <- tempfile(fileext = ".png")
  result <- suppressMessages(bfh_save(temp_file, p, width = 10, height = 8))

  expect_equal(result, temp_file)
  expect_true(file.exists(temp_file))
  unlink(temp_file)
})

test_that("bfh_labs converts to uppercase except title", {
  skip_if_not_installed("ggplot2")

  labs <- bfh_labs(
    title = "My Title",
    subtitle = "my subtitle",
    x = "x axis",
    y = "y axis"
  )

  # Check it's a ggplot2 labs object (class changed in newer ggplot2)
  expect_true(inherits(labs, "labels") || inherits(labs, "ggplot2::labels"))

  # Extract the labels
  expect_equal(labs$title, "My Title")  # Title unchanged
  expect_equal(labs$subtitle, "MY SUBTITLE")  # Uppercase
  expect_equal(labs$x, "X AXIS")  # Uppercase
  expect_equal(labs$y, "Y AXIS")  # Uppercase
})

test_that("bfh_labs works with ggplot2", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    bfh_labs(title = "Test", x = "weight", y = "mpg")

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})

test_that("add_bfh_color_bar validates plot input", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # Should work with valid plot
  expect_no_error(add_bfh_color_bar(p))

  # Should fail with non-plot
  expect_error(add_bfh_color_bar("not a plot"))
})

test_that("add_bfh_color_bar adds bar to plot", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  p_with_bar <- add_bfh_color_bar(p, position = "top")

  expect_s3_class(p_with_bar, "gg")
  expect_s3_class(p_with_bar, "ggplot")
})

test_that("add_bfh_color_bar accepts all positions", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  positions <- c("top", "bottom", "left", "right")
  for (pos in positions) {
    p_with_bar <- add_bfh_color_bar(p, position = pos)
    expect_s3_class(p_with_bar, "gg")
  }
})

test_that("bfh_combine_plots requires patchwork", {
  skip_if_not_installed("ggplot2")

  p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  p2 <- ggplot2::ggplot(mtcars, ggplot2::aes(hp, mpg)) + ggplot2::geom_point()

  if (requireNamespace("patchwork", quietly = TRUE)) {
    combined <- bfh_combine_plots(list(p1, p2), ncol = 2)
    expect_s3_class(combined, "gg")
  } else {
    expect_error(bfh_combine_plots(list(p1, p2), ncol = 2))
  }
})

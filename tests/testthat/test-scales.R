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

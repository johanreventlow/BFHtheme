# Tests for theme functions

test_that("theme_bfh returns ggplot2 theme", {
  theme <- theme_bfh()
  expect_s3_class(theme, "theme")
  expect_s3_class(theme, "gg")
})

test_that("theme_bfh accepts base_size parameter", {
  theme_small <- theme_bfh(base_size = 10)
  theme_large <- theme_bfh(base_size = 16)

  expect_s3_class(theme_small, "theme")
  expect_s3_class(theme_large, "theme")
})

test_that("theme_bfh accepts base_family parameter", {
  theme_arial <- theme_bfh(base_family = "Arial")
  theme_sans <- theme_bfh(base_family = "sans")

  expect_s3_class(theme_arial, "theme")
  expect_s3_class(theme_sans, "theme")
})


test_that("theme_bfh works with ggplot2", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    theme_bfh()

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})


test_that("theme_bfh y-axis labels are left-aligned", {
  theme <- theme_bfh()

  # Verificer at axis.text.y har hjust = 0 (venstrestillet)
  expect_equal(theme$axis.text.y$hjust, 0)
})

test_that("theme_bfh rejects invalid base_size", {
  expect_error(theme_bfh(base_size = -1),   "base_size must be positive numeric")
  expect_error(theme_bfh(base_size = 0),    "base_size must be positive numeric")
  expect_error(theme_bfh(base_size = NULL), "base_size must be positive numeric")
})

test_that("theme_bfh accepts valid base_size", {
  expect_s3_class(theme_bfh(base_size = 14), "theme")
})

test_that("theme_bfh rejects invalid base_family", {
  expect_error(theme_bfh(base_family = 123),              "base_family must be a character scalar or NULL")
  expect_error(theme_bfh(base_family = c("Arial", "sans")), "base_family must be a character scalar or NULL")
})


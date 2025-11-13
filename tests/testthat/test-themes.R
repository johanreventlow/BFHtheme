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


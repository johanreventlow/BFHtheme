# Visual regression tests using vdiffr
# These tests create SVG snapshots of theme outputs to detect visual changes
# Skip on CRAN and during R CMD check as font availability varies

test_that("theme_bfh produces consistent visual output", {
  skip_on_cran()
  skip_if(identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), "BFHtheme"),
          "Skipping visual tests during R CMD check")
  skip_if_not_installed("vdiffr")
  skip_if_not_installed("ggplot2")

  # Create a simple test plot
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(
      title = "Test Plot",
      subtitle = "Subtitle text",
      x = "Weight",
      y = "MPG"
    ) +
    theme_bfh()

  vdiffr::expect_doppelganger("theme_bfh_basic", p)
})


test_that("theme_bfh with color scales produces consistent output", {
  skip_on_cran()
  skip_if(identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), "BFHtheme"),
          "Skipping visual tests during R CMD check")
  skip_if_not_installed("vdiffr")
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, color = factor(cyl))) +
    ggplot2::geom_point(size = 3) +
    ggplot2::labs(
      title = "BFH Theme with Colors",
      color = "Cylinders"
    ) +
    scale_color_bfh() +
    theme_bfh()

  vdiffr::expect_doppelganger("theme_bfh_with_colors", p)
})

test_that("theme_bfh with facets produces consistent output", {
  skip_on_cran()
  skip_if(identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), "BFHtheme"),
          "Skipping visual tests during R CMD check")
  skip_if_not_installed("vdiffr")
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~cyl) +
    ggplot2::labs(title = "Faceted Plot") +
    theme_bfh()

  vdiffr::expect_doppelganger("theme_bfh_faceted", p)
})

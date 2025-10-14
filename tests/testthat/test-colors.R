# Tests for color functions

test_that("bfh_cols returns correct colors", {
  # Test single color
  expect_equal(bfh_cols("hospital_primary"), c(hospital_primary = "#007dbb"))

  # Test multiple colors
  result <- bfh_cols("hospital_primary", "blue")
  expect_length(result, 2)
  expect_named(result, c("hospital_primary", "blue"))

  # Test all colors when no arguments
  all_colors <- bfh_cols()
  expect_type(all_colors, "character")
  expect_true(length(all_colors) > 0)
  expect_true(all(grepl("^#[0-9a-fA-F]{6}$", all_colors)))
})

test_that("bfh_cols validates input", {
  # Test invalid color name
  expect_error(bfh_cols("nonexistent_color"))

  # Test non-character input
  expect_error(bfh_cols(123))
})

test_that("bfh_pal returns function", {
  # Test that bfh_pal returns a function
  pal_fn <- bfh_pal("main")
  expect_type(pal_fn, "closure")

  # Test that the function returns colors
  colors <- pal_fn(5)
  expect_length(colors, 5)
  expect_true(all(grepl("^#[0-9a-fA-F]{6}$", colors)))
})

test_that("bfh_pal validates palette name", {
  expect_error(bfh_pal("nonexistent_palette"))
})

test_that("bfh_pal supports reverse parameter", {
  pal_normal <- bfh_pal("main", reverse = FALSE)
  pal_reversed <- bfh_pal("main", reverse = TRUE)

  colors_normal <- pal_normal(4)
  colors_reversed <- pal_reversed(4)

  # Check that reversed palette has colors in opposite order
  # (allowing for minor interpolation differences)
  expect_equal(colors_normal[1], colors_reversed[4])
  expect_equal(colors_normal[4], colors_reversed[1])
})

test_that("bfh_palettes object exists and is correct structure", {
  expect_true(exists("bfh_palettes"))
  expect_type(bfh_palettes, "list")
  expect_true(length(bfh_palettes) > 0)

  # Check that each palette contains hex colors
  for (palette in bfh_palettes) {
    expect_true(all(grepl("^#[0-9a-fA-F]{6}$", palette)))
  }
})

test_that("show_bfh_palettes runs without error", {
  # This function creates a plot, so we just check it doesn't error
  expect_no_error(show_bfh_palettes())
})

test_that("check_colorblind_safe returns structured diagnostics", {
  palette <- c(primary = "#007dbb", accent = "#e30613", highlight = "#ffed00")
  result <- check_colorblind_safe(palette, threshold = 8)

  expect_type(result, "list")
  expect_true(result$passes)
  expect_equal(result$threshold, 8)
  expect_true(all(c("summary", "pairwise") %in% names(result)))
  expect_s3_class(result$summary, "data.frame")
  expect_named(result$pairwise)
  expect_true(all(result$summary$min_delta_e >= 0))
})

test_that("check_colorblind_safe flags low-contrast palettes", {
  palette <- c(shade1 = "#002244", shade2 = "#012345")
  result <- check_colorblind_safe(palette, threshold = 2)

  expect_false(result$passes)
  expect_true(any(!result$summary$passes))
  normal_pairs <- result$pairwise$normal
  expect_true(any(normal_pairs$below_threshold))
})

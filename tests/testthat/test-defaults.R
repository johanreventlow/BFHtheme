# Tests for defaults functions

# === Tests for set_bfh_defaults() ===

test_that("set_bfh_defaults sets theme successfully", {
  skip_if_not_installed("ggplot2")

  # Store original theme
  original_theme <- ggplot2::theme_get()

  # Set BFH defaults
  result <- suppressMessages(set_bfh_defaults())

  # Check return value
  expect_true(result)

  # Check that theme was changed
  new_theme <- ggplot2::theme_get()
  expect_false(identical(original_theme, new_theme))

  # Restore original theme
  ggplot2::theme_set(original_theme)
})

test_that("set_bfh_defaults accepts different themes", {
  skip_if_not_installed("ggplot2")

  original_theme <- ggplot2::theme_get()

  # Test all theme variants
  themes <- c("bfh", "bfh_minimal", "bfh_print", "bfh_presentation", "bfh_dark")

  for (theme_name in themes) {
    result <- suppressMessages(
      set_bfh_defaults(theme = theme_name)
    )
    expect_true(result)
  }

  # Restore
  ggplot2::theme_set(original_theme)
})

test_that("set_bfh_defaults accepts different palettes", {
  skip_if_not_installed("ggplot2")

  original_theme <- ggplot2::theme_get()

  # Test valid palettes
  palettes <- c("main", "blues", "hospital", "regionh")

  for (palette_name in palettes) {
    result <- suppressMessages(
      set_bfh_defaults(palette = palette_name)
    )
    expect_true(result)
  }

  # Restore
  ggplot2::theme_set(original_theme)
})

test_that("set_bfh_defaults handles invalid palette gracefully", {
  skip_if_not_installed("ggplot2")

  original_theme <- ggplot2::theme_get()

  # Should warn and fall back to main
  expect_warning(
    result <- set_bfh_defaults(palette = "nonexistent_palette"),
    "Palette .* not found"
  )

  # Should still succeed
  expect_true(result)

  # Restore
  ggplot2::theme_set(original_theme)
})

test_that("set_bfh_defaults uses auto-detected font when base_family is NULL", {
  skip_if_not_installed("ggplot2")

  original_theme <- ggplot2::theme_get()

  # With NULL (default), should auto-detect
  result <- suppressMessages(
    set_bfh_defaults(base_family = NULL)
  )
  expect_true(result)

  # Theme should be set
  new_theme <- ggplot2::theme_get()
  expect_false(identical(original_theme, new_theme))

  # Restore
  ggplot2::theme_set(original_theme)
})

test_that("set_bfh_defaults accepts custom base_family", {
  skip_if_not_installed("ggplot2")

  original_theme <- ggplot2::theme_get()

  # With explicit font
  result <- suppressMessages(
    set_bfh_defaults(base_family = "sans")
  )
  expect_true(result)

  # Restore
  ggplot2::theme_set(original_theme)
})

test_that("set_bfh_defaults updates geom defaults", {
  skip_if_not_installed("ggplot2")

  original_theme <- ggplot2::theme_get()

  # Set defaults with a known palette
  suppressMessages(set_bfh_defaults(palette = "main"))

  # Create a simple plot - point should use BFH color
  p <- ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x, y)) +
    ggplot2::geom_point()

  expect_s3_class(p, "ggplot")

  # Restore
  ggplot2::theme_set(original_theme)
  reset_bfh_defaults()
})

test_that("set_bfh_defaults prints messages", {
  skip_if_not_installed("ggplot2")

  original_theme <- ggplot2::theme_get()

  expect_message(
    set_bfh_defaults(),
    "BFH defaults set successfully"
  )

  expect_message(
    set_bfh_defaults(theme = "bfh_minimal"),
    "Theme: bfh_minimal"
  )

  expect_message(
    set_bfh_defaults(palette = "blues"),
    "Palette: blues"
  )

  # Restore
  ggplot2::theme_set(original_theme)
})

# === Tests for reset_bfh_defaults() ===

test_that("reset_bfh_defaults resets to ggplot2 defaults", {
  skip_if_not_installed("ggplot2")

  # Set BFH defaults
  suppressMessages(set_bfh_defaults())

  # Reset
  result <- suppressMessages(reset_bfh_defaults())
  expect_true(result)

  # Theme should be ggplot2 default (theme_gray)
  current_theme <- ggplot2::theme_get()
  default_theme <- ggplot2::theme_gray()

  # Check class (should both be theme_gray)
  expect_equal(class(current_theme), class(default_theme))
})

test_that("reset_bfh_defaults emits fallback message when no state saved", {
  skip_if_not_installed("ggplot2")

  # Ensure no saved state
  .bfh_state$previous_theme <- NULL
  .bfh_state$previous_geoms <- NULL
  on.exit({
    .bfh_state$previous_theme <- NULL
    .bfh_state$previous_geoms <- NULL
  }, add = TRUE)

  expect_message(
    reset_bfh_defaults(),
    "No saved state found"
  )
})

# === Integration tests ===

test_that("workflow: set -> plot -> reset works correctly", {
  skip_if_not_installed("ggplot2")

  # Store original
  original_theme <- ggplot2::theme_get()

  # Set BFH defaults
  suppressMessages(set_bfh_defaults())

  # Create plot
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  expect_s3_class(p, "ggplot")

  # Reset
  suppressMessages(reset_bfh_defaults())

  # Should be back to original
  current_theme <- ggplot2::theme_get()
  expect_equal(class(current_theme), class(original_theme))
})

# === Tests for reversible defaults (make-global-state-explicit) ===

test_that("set->reset cycle restores previous theme exactly", {
  skip_if_not_installed("ggplot2")

  ggplot2::theme_set(ggplot2::theme_classic())
  original_theme <- ggplot2::theme_get()
  on.exit(ggplot2::theme_set(ggplot2::theme_gray()), add = TRUE)

  suppressMessages(set_bfh_defaults())
  suppressMessages(reset_bfh_defaults())

  restored_theme <- ggplot2::theme_get()
  # panel.background differs: classic=white, gray=grey92
  expect_equal(
    restored_theme$panel.background$fill,
    original_theme$panel.background$fill
  )
  # Verify it is NOT theme_gray (which uses grey92 background)
  expect_false(identical(
    restored_theme$panel.background$fill,
    ggplot2::theme_gray()$panel.background$fill
  ))
})

test_that("set->reset cycle restores previous geom defaults", {
  skip_if_not_installed("ggplot2")

  # Set a distinctive custom colour
  ggplot2::update_geom_defaults("point", list(colour = "red"))
  on.exit(
    ggplot2::update_geom_defaults("point", list(colour = "black")),
    add = TRUE
  )

  suppressMessages(set_bfh_defaults())

  # BFH palette colour should now be active (not red)
  bfh_colour <- ggplot2::GeomPoint$default_aes$colour
  expect_false(identical(bfh_colour, "red"))

  suppressMessages(reset_bfh_defaults())

  restored_colour <- ggplot2::GeomPoint$default_aes$colour
  expect_equal(restored_colour, "red")
})

test_that("reset_bfh_defaults without prior set falls back gracefully", {
  skip_if_not_installed("ggplot2")

  .bfh_state$previous_theme <- NULL
  .bfh_state$previous_geoms <- NULL
  on.exit({
    .bfh_state$previous_theme <- NULL
    .bfh_state$previous_geoms <- NULL
  }, add = TRUE)

  expect_message(reset_bfh_defaults(), "No saved state found")
  result <- suppressMessages(reset_bfh_defaults())
  expect_true(result)
  expect_equal(class(ggplot2::theme_get()), class(ggplot2::theme_gray()))
})

test_that("library(BFHtheme) does not modify knitr chunk options", {
  skip_if_not_installed("knitr")

  # knitr is loaded; check that BFHtheme did not touch dev option
  # BFHtheme is already loaded in test session, so we verify the current state
  dev_option <- knitr::opts_chunk$get("dev")
  # dev should NOT be "ragg_png" unless the user explicitly called
  # use_bfh_knitr_defaults() — which tests do not do
  expect_false(identical(dev_option, "ragg_png"))
})

test_that("use_bfh_knitr_defaults sets dev to ragg_png", {
  skip_if_not_installed("knitr")
  skip_if_not_installed("ragg")

  original_dev <- knitr::opts_chunk$get("dev")
  on.exit(knitr::opts_chunk$set(dev = original_dev), add = TRUE)

  use_bfh_knitr_defaults()
  expect_equal(knitr::opts_chunk$get("dev"), "ragg_png")
})

test_that("use_bfh_knitr_defaults respects dpi argument", {
  skip_if_not_installed("knitr")
  skip_if_not_installed("ragg")

  original_dpi <- knitr::opts_chunk$get("dpi")
  on.exit(knitr::opts_chunk$set(dpi = original_dpi), add = TRUE)

  use_bfh_knitr_defaults(dpi = 150)
  expect_equal(knitr::opts_chunk$get("dpi"), 150)
})

test_that("palette fallback updates palette variable correctly", {
  skip_if_not_installed("ggplot2")

  original_theme <- ggplot2::theme_get()

  # Use invalid palette
  expect_warning(
    suppressMessages(set_bfh_defaults(palette = "invalid_palette")),
    "not found"
  )

  # The message should mention "main" palette after fallback
  expect_message(
    suppressWarnings(set_bfh_defaults(palette = "invalid_palette")),
    "Palette: main"
  )

  # Restore
  ggplot2::theme_set(original_theme)
})

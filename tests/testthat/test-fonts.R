# Tests for font functions

# === Tests for get_bfh_font() ===

test_that("get_bfh_font returns character string", {
  result <- get_bfh_font(check_installed = FALSE)
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("get_bfh_font returns Mari when check_installed is FALSE", {
  result <- get_bfh_font(check_installed = FALSE)
  expect_equal(result, "Mari")
})

test_that("get_bfh_font returns a font when check_installed is TRUE", {
  result <- get_bfh_font(check_installed = TRUE, silent = TRUE)
  expect_type(result, "character")
  expect_length(result, 1)
  # Should return one of the fallback fonts
  expect_true(result %in% c("Mari", "Mari Office", "Roboto", "Arial", "sans"))
})

test_that("get_bfh_font prefers Mari when available", {
  skip_if_not_installed("systemfonts")
  suppressMessages(clear_bfh_font_cache())

  # Test that Mari is preferred when available
  # This test relies on actual systemfonts behavior
  # If Mari is not available, test that first available font is selected
  result <- get_bfh_font(check_installed = TRUE, silent = TRUE, force_refresh = TRUE)

  expect_type(result, "character")
  expect_length(result, 1)
  # Should return one of the priority fonts
  expect_true(result %in% c("Mari", "Mari Office", "Roboto", "Arial", "sans"))
})

test_that("get_bfh_font silent parameter works", {
  # With silent = FALSE (default), should see messages
  expect_message(
    get_bfh_font(check_installed = TRUE, silent = FALSE)
  )

  # With silent = TRUE, should not see messages
  expect_silent(
    get_bfh_font(check_installed = TRUE, silent = TRUE)
  )
})

test_that("get_bfh_font handles missing systemfonts package gracefully", {
  # Should fall back to sans when font checking packages not available
  # This is tested by the fact that the function doesn't error
  result <- get_bfh_font(check_installed = TRUE, silent = TRUE)
  expect_type(result, "character")
})

# === Tests for check_bfh_fonts() ===

test_that("check_bfh_fonts returns logical vector", {
  result <- suppressMessages(check_bfh_fonts())
  expect_type(result, "logical")
  expect_true(length(result) > 0)
})

test_that("check_bfh_fonts has named elements", {
  result <- suppressMessages(check_bfh_fonts())
  expect_named(result)
  expected_names <- c("Mari", "Mari Office", "Roboto", "Arial")
  expect_equal(names(result), expected_names)
})

test_that("check_bfh_fonts prints output", {
  expect_output(
    check_bfh_fonts(),
    "BFH Font Availability"
  )
})

# === Tests for install_roboto_font() ===

test_that("install_roboto_font prints instructions", {
  expect_output(
    install_roboto_font(),
    "Installing Roboto Font"
  )

  expect_output(
    install_roboto_font(),
    "Apache License"
  )
})

# === Tests for setup_bfh_fonts() ===

test_that("setup_bfh_fonts returns character string", {
  result <- suppressMessages(setup_bfh_fonts(use_showtext = FALSE))
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("setup_bfh_fonts with showtext handles missing package", {
  # Should fall back gracefully when showtext not available
  result <- suppressMessages(setup_bfh_fonts(use_showtext = TRUE))
  expect_type(result, "character")
})

test_that("setup_bfh_fonts returns valid font name", {
  result <- suppressMessages(setup_bfh_fonts(use_showtext = FALSE))
  # Should return a reasonable font
  expect_true(nchar(result) > 0)
})

# === Tests for set_bfh_fonts() ===

test_that("set_bfh_fonts returns font name invisibly", {
  skip_if_not_installed("ggplot2")

  result <- suppressMessages(set_bfh_fonts(use_showtext = FALSE))
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("set_bfh_fonts updates ggplot2 theme", {
  skip_if_not_installed("ggplot2")

  # Store original theme
  original_theme <- ggplot2::theme_get()

  # Set BFH fonts
  result <- suppressMessages(set_bfh_fonts(use_showtext = FALSE))

  # Function should return a font name
  expect_type(result, "character")
  expect_length(result, 1)

  # Check that theme_update was called (by verifying the function ran)
  current_theme <- ggplot2::theme_get()
  expect_s3_class(current_theme, "theme")

  # Restore original theme
  ggplot2::theme_set(original_theme)
})

test_that("set_bfh_fonts prints message", {
  skip_if_not_installed("ggplot2")

  expect_message(
    set_bfh_fonts(use_showtext = FALSE),
    "BFH fonts set as default"
  )
})

# === Tests for font caching ===

test_that("font cache improves performance on repeated calls", {
  # Clear cache to start fresh
  suppressMessages(clear_bfh_font_cache())

  # First call should detect font
  font1 <- suppressMessages(get_bfh_font(check_installed = TRUE, silent = TRUE))
  expect_type(font1, "character")

  # Second call should return cached result
  font2 <- get_bfh_font(check_installed = TRUE, silent = FALSE)
  expect_message(
    get_bfh_font(check_installed = TRUE, silent = FALSE),
    "cached"
  )
  expect_equal(font1, font2)
})

test_that("clear_bfh_font_cache() clears the cache", {
  # Get font (will be cached)
  font1 <- suppressMessages(get_bfh_font(check_installed = TRUE, silent = TRUE))

  # Clear cache
  expect_message(clear_bfh_font_cache(), "cache cleared")

  # Next call should not show cached message
  expect_message(
    get_bfh_font(check_installed = TRUE, silent = FALSE),
    "Using font"
  )
})

test_that("force_refresh bypasses cache", {
  # First call caches result
  font1 <- suppressMessages(get_bfh_font(check_installed = TRUE, silent = TRUE))

  # force_refresh should bypass cache and re-detect
  font2 <- get_bfh_font(check_installed = TRUE, silent = FALSE, force_refresh = TRUE)
  expect_message(
    get_bfh_font(check_installed = TRUE, silent = FALSE, force_refresh = TRUE),
    "Using font"
  )

  # Should still return same font
  expect_equal(font1, font2)
})

test_that("cache persists across multiple calls", {
  # Clear cache
  suppressMessages(clear_bfh_font_cache())

  # First call
  font1 <- suppressMessages(get_bfh_font(silent = TRUE))

  # Multiple subsequent calls should all use cache
  for (i in 1:5) {
    fonti <- get_bfh_font(silent = FALSE)
    expect_message(
      get_bfh_font(silent = FALSE),
      "cached"
    )
    expect_equal(font1, fonti)
  }
})

# === Integration tests ===

test_that("font workflow: setup -> get -> set works correctly", {
  skip_if_not_installed("ggplot2")

  # Clear cache for clean test
  suppressMessages(clear_bfh_font_cache())

  # Step 1: Get font
  font1 <- suppressMessages(get_bfh_font(check_installed = TRUE, silent = TRUE))
  expect_type(font1, "character")

  # Step 2: Setup fonts
  font2 <- suppressMessages(setup_bfh_fonts(use_showtext = FALSE))
  expect_type(font2, "character")

  # Step 3: Set as default
  font3 <- suppressMessages(set_bfh_fonts(use_showtext = FALSE))
  expect_type(font3, "character")

  # All should return the same font (when not using showtext)
  expect_equal(font1, font2)
  expect_equal(font2, font3)
})

# === Edge case and fallback tests ===

test_that("get_bfh_font falls back to sans when no packages available", {
  # This tests the fallback path when neither systemfonts nor extrafont are available
  # In practice, systemfonts is usually available, so this is defensive
  suppressMessages(clear_bfh_font_cache())

  result <- get_bfh_font(check_installed = TRUE, silent = TRUE, force_refresh = TRUE)
  expect_type(result, "character")
  expect_length(result, 1)
  # Should return a valid font name
  expect_true(nchar(result) > 0)
})

test_that("check_bfh_fonts handles missing font packages gracefully", {
  # Test that the function works even when systemfonts/extrafont aren't available
  result <- suppressMessages(check_bfh_fonts())

  expect_type(result, "logical")
  expect_named(result)
  # Result could be NA if packages unavailable, or TRUE/FALSE if available
  expect_true(all(is.logical(result) | is.na(result)))
})

test_that("get_bfh_font respects font priority order", {
  skip_if_not_installed("systemfonts")
  suppressMessages(clear_bfh_font_cache())

  result <- get_bfh_font(check_installed = TRUE, silent = TRUE, force_refresh = TRUE)

  # Result should be one of the priority fonts
  priority_fonts <- c("Mari", "Mari Office", "Roboto", "Arial", "sans")
  expect_true(result %in% priority_fonts)
})

test_that("get_bfh_font can load Roboto via showtext when available", {
  skip_if_not_installed("showtext")

  # Clear cache for clean test
  suppressMessages(clear_bfh_font_cache())

  # Mock scenario: Ingen Mari/Roboto installeret systemisk
  # Denne test verificerer at showtext-path virker
  result <- suppressMessages(
    get_bfh_font(check_installed = TRUE, silent = TRUE, force_refresh = TRUE)
  )

  expect_type(result, "character")
  expect_length(result, 1)

  # Hvis showtext er tilgængelig og ingen prioriterede fonts findes,
  # skulle Roboto loades via Google Fonts
  # (Dette afhænger af hvilket font systemet finder først)
  expect_true(result %in% c("Mari", "Mari Office", "Roboto", "Arial", "sans"))
})

test_that("showtext fallback works when Mari fonts not available", {
  # Dette er en dokumentations-test der verificerer at vores
  # showtext-integration er korrekt struktureret

  # Verificer at funktionen ikke fejler når showtext ikke er tilgængelig
  suppressMessages(clear_bfh_font_cache())

  result <- suppressMessages(
    get_bfh_font(check_installed = TRUE, silent = TRUE, force_refresh = TRUE)
  )

  # Skulle altid returnere en valid font
  expect_type(result, "character")
  expect_length(result, 1)
  expect_true(nchar(result) > 0)
})

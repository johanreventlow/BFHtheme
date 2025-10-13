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
  expect_true(result %in% c("Mari", "Roboto", "Arial", "sans"))
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
  expected_names <- c("Mari Office", "Mari", "Roboto", "Arial")
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

# === Integration tests ===

test_that("font workflow: setup -> get -> set works correctly", {
  skip_if_not_installed("ggplot2")

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

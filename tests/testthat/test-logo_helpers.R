# Tests for logo helper functions

# === Tests for get_bfh_logo() ===

test_that("get_bfh_logo accepts valid size values", {
  # All valid sizes should not error
  expect_no_error(get_bfh_logo(size = "full"))
  expect_no_error(get_bfh_logo(size = "web"))
  expect_no_error(get_bfh_logo(size = "small"))
})

test_that("get_bfh_logo accepts valid variant values", {
  # All valid variants should not error
  expect_no_error(get_bfh_logo(variant = "color"))
  expect_no_error(get_bfh_logo(variant = "grey"))
  expect_no_error(get_bfh_logo(variant = "mark"))
})

test_that("get_bfh_logo rejects invalid size values", {
  expect_error(
    get_bfh_logo(size = "invalid"),
    "'arg' should be one of"
  )

  expect_error(
    get_bfh_logo(size = "large"),
    "'arg' should be one of"
  )
})

test_that("get_bfh_logo rejects invalid variant values", {
  expect_error(
    get_bfh_logo(variant = "invalid"),
    "'arg' should be one of"
  )

  expect_error(
    get_bfh_logo(variant = "blue"),
    "'arg' should be one of"
  )
})

test_that("get_bfh_logo returns character path or NULL", {
  result <- get_bfh_logo()

  # Should return either character path or NULL (if files not installed)
  expect_true(is.character(result) || is.null(result))

  # If character, should not be empty
  if (is.character(result)) {
    expect_true(nchar(result) > 0)
  }
})

test_that("get_bfh_logo returns different paths for different sizes", {
  skip_if(is.null(get_bfh_logo("full")), "Logo files not installed")

  full <- get_bfh_logo("full", "color")
  web <- get_bfh_logo("web", "color")
  small <- get_bfh_logo("small", "color")

  # All should be character
  expect_type(full, "character")
  expect_type(web, "character")
  expect_type(small, "character")

  # Full and web should be different
  expect_false(identical(full, web))
})

test_that("get_bfh_logo returns different paths for different variants", {
  skip_if(is.null(get_bfh_logo()), "Logo files not installed")

  color <- get_bfh_logo(variant = "color")
  grey <- get_bfh_logo(variant = "grey")
  mark <- get_bfh_logo(variant = "mark")

  # All should be character
  expect_type(color, "character")
  expect_type(grey, "character")
  expect_type(mark, "character")

  # All should be different
  expect_false(identical(color, grey))
  expect_false(identical(color, mark))
  expect_false(identical(grey, mark))
})

test_that("get_bfh_logo warns when files not found", {
  # This test assumes logo files are not installed in test environment
  # If files are installed, the test will be skipped
  skip_if_not(is.null(get_bfh_logo()), "Logo files are installed")

  expect_warning(
    get_bfh_logo(),
    "BFH logo file not found"
  )
})

test_that("get_bfh_logo paths exist when returned", {
  path <- get_bfh_logo()

  # If path is returned (not NULL), it should exist
  if (!is.null(path)) {
    expect_true(file.exists(path))
  }
})

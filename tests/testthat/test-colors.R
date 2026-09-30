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

# Statusfarver ---------------------------------------------------------------

test_that("bfh_status_cols giver kraftigst foerst i hver gruppe", {
  expect_equal(
    bfh_status_cols("overholdt", 5),
    c("#002555", "#0067a1", "#4caad8", "#a8ddf6", "#d8eef9")
  )
  expect_equal(bfh_status_cols("overholdt", 2), c("#007dbb", "#99d8f6"))
  expect_equal(
    bfh_status_cols("ikke_afgjort", 4),
    c("#333333", "#646c6f", "#8f8f8f", "#b8b8b8")
  )
  expect_equal(bfh_status_cols("overskredet", 1), "#c0392b")
  expect_equal(bfh_status_cols("overholdt", 1), "#007dbb")
  expect_length(bfh_status_cols("overskredet", 0), 0)
})

test_that("bfh_status_cols giver gyldige, forskellige hex-farver", {
  for (g in c("overholdt", "ikke_afgjort", "overskredet")) {
    farver <- bfh_status_cols(g, 6)
    expect_length(farver, 6)
    expect_true(all(grepl("^#[0-9a-f]{6}$", farver)))
    expect_equal(anyDuplicated(farver), 0L)
  }
})

test_that("bfh_status_cols validerer input", {
  expect_error(bfh_status_cols("groen", 2), "Gyldige grupper")
  expect_error(bfh_status_cols(c("overholdt", "overskredet"), 2), "Gyldige grupper")
  expect_error(bfh_status_cols("overholdt", -1))
  expect_error(bfh_status_cols("overholdt", 1.5))
  expect_error(bfh_status_cols("overholdt", NA))
})

test_that("bfh_status_values fordeler nuancer pr. gruppe", {
  grupper <- c("ikke_afgjort", "ikke_afgjort", "overskredet", "overholdt", "overholdt")
  farver <- bfh_status_values(grupper)
  expect_length(farver, 5)
  expect_equal(farver[1:2], bfh_status_cols("ikke_afgjort", 2))
  expect_equal(farver[3], "#c0392b")
  expect_equal(farver[4:5], bfh_status_cols("overholdt", 2))
})

test_that("bfh_status_values respekterer rang inden for gruppen", {
  farver <- bfh_status_values(c("overholdt", "overholdt", "overholdt"), rang = c(2, 3, 1))
  expect_equal(farver[3], bfh_status_cols("overholdt", 3)[1])
  expect_equal(farver[1:2], bfh_status_cols("overholdt", 3)[2:3])
})

test_that("bfh_status_values validerer input", {
  expect_error(bfh_status_values(1:2))
  expect_error(bfh_status_values(c("overholdt", "lilla")), "Gyldige grupper")
  expect_error(bfh_status_values(c("overholdt", "overholdt"), rang = 1))
  expect_error(bfh_status_values("overholdt", rang = NA_real_))
})

test_that("status-paletten findes og er gyldig", {
  expect_equal(
    unname(bfh_palettes$status),
    c("#007dbb", "#646c6f", "#c0392b")
  )
  expect_equal(bfh_cols("status_overskredet"), c(status_overskredet = "#c0392b"))
})

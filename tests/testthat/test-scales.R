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

# === Input Validation Tests ===

test_that("scale_color_bfh validates palette parameter", {
  # Non-character palette
  expect_error(
    scale_color_bfh(palette = 123),
    "palette must be a single character string"
  )

  # NULL palette
  expect_error(
    scale_color_bfh(palette = NULL),
    "palette must be a single character string"
  )

  # Vector palette
  expect_error(
    scale_color_bfh(palette = c("main", "blues")),
    "palette must be a single character string"
  )

  # Empty string palette
  expect_error(
    scale_color_bfh(palette = ""),
    "palette must be a single character string"
  )
})

test_that("scale_color_bfh validates discrete parameter", {
  # Non-logical discrete
  expect_error(
    scale_color_bfh(discrete = "TRUE"),
    "discrete must be a single logical value"
  )

  # Numeric discrete
  expect_error(
    scale_color_bfh(discrete = 1),
    "discrete must be a single logical value"
  )

  # NA discrete
  expect_error(
    scale_color_bfh(discrete = NA),
    "discrete must be a single logical value"
  )

  # Vector discrete
  expect_error(
    scale_color_bfh(discrete = c(TRUE, FALSE)),
    "discrete must be a single logical value"
  )
})

test_that("scale_color_bfh validates reverse parameter", {
  # Non-logical reverse
  expect_error(
    scale_color_bfh(reverse = "TRUE"),
    "reverse must be a single logical value"
  )

  # Numeric reverse
  expect_error(
    scale_color_bfh(reverse = 1),
    "reverse must be a single logical value"
  )

  # NA reverse
  expect_error(
    scale_color_bfh(reverse = NA),
    "reverse must be a single logical value"
  )

  # Vector reverse
  expect_error(
    scale_color_bfh(reverse = c(TRUE, FALSE)),
    "reverse must be a single logical value"
  )
})

test_that("scale_fill_bfh validates palette parameter", {
  expect_error(
    scale_fill_bfh(palette = 123),
    "palette must be a single character string"
  )

  expect_error(
    scale_fill_bfh(palette = NULL),
    "palette must be a single character string"
  )

  expect_error(
    scale_fill_bfh(palette = c("main", "blues")),
    "palette must be a single character string"
  )
})

test_that("scale_fill_bfh validates discrete and reverse parameters", {
  expect_error(
    scale_fill_bfh(discrete = "TRUE"),
    "discrete must be a single logical value"
  )

  expect_error(
    scale_fill_bfh(reverse = 1),
    "reverse must be a single logical value"
  )

  expect_error(
    scale_fill_bfh(discrete = NA),
    "discrete must be a single logical value"
  )
})

test_that("scale_color_bfh_continuous validates palette parameter", {
  expect_error(
    scale_color_bfh_continuous(palette = 123),
    "palette must be a single character string"
  )

  expect_error(
    scale_color_bfh_continuous(palette = NULL),
    "palette must be a single character string"
  )

  expect_error(
    scale_color_bfh_continuous(palette = c("blues", "greys")),
    "palette must be a single character string"
  )
})

test_that("scale_color_bfh_continuous validates reverse parameter", {
  expect_error(
    scale_color_bfh_continuous(reverse = "FALSE"),
    "reverse must be a single logical value"
  )

  expect_error(
    scale_color_bfh_continuous(reverse = 0),
    "reverse must be a single logical value"
  )

  expect_error(
    scale_color_bfh_continuous(reverse = NA),
    "reverse must be a single logical value"
  )
})

test_that("scale_fill_bfh_continuous validates parameters", {
  expect_error(
    scale_fill_bfh_continuous(palette = 123),
    "palette must be a single character string"
  )

  expect_error(
    scale_fill_bfh_continuous(reverse = "TRUE"),
    "reverse must be a single logical value"
  )
})

test_that("scale_color_bfh_discrete validates parameters", {
  expect_error(
    scale_color_bfh_discrete(palette = 123),
    "palette must be a single character string"
  )

  expect_error(
    scale_color_bfh_discrete(reverse = NA),
    "reverse must be a single logical value"
  )
})

test_that("scale_fill_bfh_discrete validates parameters", {
  expect_error(
    scale_fill_bfh_discrete(palette = NULL),
    "palette must be a single character string"
  )

  expect_error(
    scale_fill_bfh_discrete(reverse = c(TRUE, FALSE)),
    "reverse must be a single logical value"
  )
})

test_that("all scale functions accept valid parameter values", {
  # These should all work without errors
  expect_s3_class(scale_color_bfh(palette = "main", discrete = TRUE, reverse = FALSE), "Scale")
  expect_s3_class(scale_fill_bfh(palette = "blues", discrete = FALSE, reverse = TRUE), "Scale")
  expect_s3_class(scale_color_bfh_continuous(palette = "blues", reverse = TRUE), "Scale")
  expect_s3_class(scale_fill_bfh_continuous(palette = "greys", reverse = FALSE), "Scale")
  expect_s3_class(scale_color_bfh_discrete(palette = "primary", reverse = TRUE), "Scale")
  expect_s3_class(scale_fill_bfh_discrete(palette = "contrast", reverse = FALSE), "Scale")
})

# === Position Scale Tests (Uppercase Labels) ===

test_that("scale_x_continuous_bfh creates continuous position scale", {
  skip_if_not_installed("ggplot2")

  scale <- scale_x_continuous_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuousPosition")
})

test_that("scale_y_continuous_bfh creates continuous position scale", {
  skip_if_not_installed("ggplot2")

  scale <- scale_y_continuous_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuousPosition")
})

test_that("scale_x_discrete_bfh creates discrete position scale", {
  skip_if_not_installed("ggplot2")

  scale <- scale_x_discrete_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleDiscretePosition")
})

test_that("scale_y_discrete_bfh creates discrete position scale", {
  skip_if_not_installed("ggplot2")

  scale <- scale_y_discrete_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleDiscretePosition")
})

test_that("scale_x_date_bfh creates date position scale", {
  skip_if_not_installed("ggplot2")

  scale <- scale_x_date_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuousDate")
})

test_that("scale_y_date_bfh creates date position scale", {
  skip_if_not_installed("ggplot2")

  scale <- scale_y_date_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuousDate")
})

test_that("scale_x_datetime_bfh creates datetime position scale", {
  skip_if_not_installed("ggplot2")

  scale <- scale_x_datetime_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuousDatetime")
})

test_that("scale_y_datetime_bfh creates datetime position scale", {
  skip_if_not_installed("ggplot2")

  scale <- scale_y_datetime_bfh()
  expect_s3_class(scale, "Scale")
  expect_s3_class(scale, "ScaleContinuousDatetime")
})

test_that("continuous position scales work with ggplot2", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    scale_x_continuous_bfh() +
    scale_y_continuous_bfh()

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})

test_that("discrete position scales work with ggplot2", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(x = factor(cyl), y = mpg)) +
    ggplot2::geom_boxplot() +
    scale_x_discrete_bfh()

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})

test_that("date position scales work with ggplot2", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    date = seq.Date(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "month"),
    value = rnorm(12)
  )

  p <- ggplot2::ggplot(df, ggplot2::aes(date, value)) +
    ggplot2::geom_line() +
    scale_x_date_bfh()

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})

test_that("datetime position scales work with ggplot2", {
  skip_if_not_installed("ggplot2")

  df <- data.frame(
    datetime = seq.POSIXt(as.POSIXct("2023-01-01"), as.POSIXct("2023-12-31"), by = "month"),
    value = rnorm(12)
  )

  p <- ggplot2::ggplot(df, ggplot2::aes(datetime, value)) +
    ggplot2::geom_line() +
    scale_x_datetime_bfh()

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})

test_that("position scales uppercase labels correctly", {
  skip_if_not_installed("ggplot2")

  # Test continuous scale with toupper
  scale_cont <- scale_x_continuous_bfh()
  expect_true(!is.null(scale_cont$labels))

  # Test discrete scale with toupper
  scale_disc <- scale_x_discrete_bfh()
  expect_true(!is.null(scale_disc$labels))

  # Test that toupper is the default labels function for continuous
  test_labels_cont <- c("1", "2", "3")
  result_cont <- scale_cont$labels(test_labels_cont)
  expect_equal(result_cont, c("1", "2", "3"))  # Numbers remain unchanged

  # Test that toupper works for discrete labels
  test_labels_disc <- c("low", "medium", "high")
  result_disc <- scale_disc$labels(test_labels_disc)
  expect_equal(result_disc, c("LOW", "MEDIUM", "HIGH"))
})

test_that("date scales format and uppercase correctly with default label_date_short", {
  skip_if_not_installed("ggplot2")

  # Create date scale with default (label_date_short)
  scale <- scale_x_date_bfh()

  # Test with actual dates
  test_dates <- as.Date(c("2023-01-01", "2023-02-01", "2023-03-01"))
  result <- scale$labels(test_dates)

  # Should be uppercase (label_date_short produces hierarchical output)
  expect_true(all(result == toupper(result)))

  # Should contain month abbreviations
  all_labels <- paste(result, collapse = " ")
  expect_true(grepl("JAN", all_labels))
  expect_true(grepl("FEB", all_labels))
  expect_true(grepl("MAR", all_labels))
  expect_true(grepl("2023", all_labels))
})

test_that("date scales can override with custom label format", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("scales")

  # Override with custom format
  scale <- scale_x_date_bfh(labels = scales::label_date("%b %Y"))

  test_dates <- as.Date(c("2023-01-01", "2023-02-01", "2023-03-01"))
  result <- scale$labels(test_dates)

  # Should be uppercase month abbreviations with year
  expect_true(all(grepl("^[A-Z]{3}", result)))
  expect_true(all(grepl("2023", result)))

  # Verify months are correct
  expect_true(grepl("^JAN", result[1]))
  expect_true(grepl("^FEB", result[2]))
  expect_true(grepl("^MAR", result[3]))
})

test_that("datetime scales format and uppercase correctly with default label_date_short", {
  skip_if_not_installed("ggplot2")

  # Create datetime scale with default (label_date_short)
  scale <- scale_x_datetime_bfh()

  # Test with actual datetimes (specify UTC to avoid timezone issues)
  test_datetimes <- as.POSIXct(c("2023-01-01", "2023-02-01", "2023-03-01"), tz = "UTC")
  result <- scale$labels(test_datetimes)

  # Should be uppercase
  expect_true(all(result == toupper(result)))

  # Verify months are present
  all_labels <- paste(result, collapse = " ")
  expect_true(grepl("JAN", all_labels))
  expect_true(grepl("FEB", all_labels))
  expect_true(grepl("MAR", all_labels))
  expect_true(grepl("2023", all_labels))
})

test_that("position scales accept custom labels argument", {
  skip_if_not_installed("ggplot2")

  # Custom labeling function
  custom_label <- function(x) paste0("Custom: ", x)

  scale <- scale_x_continuous_bfh(labels = custom_label)
  expect_true(!is.null(scale$labels))

  # Test custom function
  result <- scale$labels(c(1, 2, 3))
  expect_equal(result, c("Custom: 1", "Custom: 2", "Custom: 3"))
})

test_that("date scales accept custom labels override", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("scales")

  # Override with custom format using label_date
  scale <- scale_x_date_bfh(labels = scales::label_date("%Y-%m"))

  test_dates <- as.Date(c("2023-01-01", "2023-02-01"))
  result <- scale$labels(test_dates)

  # Should be uppercase with custom format
  expect_equal(result[1], "2023-01")
  expect_equal(result[2], "2023-02")
})

test_that("position scales can be combined with theme_bfh", {
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    scale_x_continuous_bfh() +
    scale_y_continuous_bfh() +
    theme_bfh()

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")

  # Check that both scales are present
  scales_list <- p$scales$scales
  expect_true(length(scales_list) >= 2)
})

# === scales Package Integration Tests ===

test_that("date scales work with scales::label_date_short()", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("scales")

  scale <- scale_x_date_bfh(labels = scales::label_date_short())

  test_dates <- as.Date(c("2023-01-01", "2023-02-01", "2023-03-01"))
  result <- scale$labels(test_dates)

  # Should be uppercase
  expect_true(all(result == toupper(result)))

  # Should contain month abbreviations
  expect_true(any(grepl("JAN", result)))
})

test_that("date scales work with scales::label_date()", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("scales")

  scale <- scale_x_date_bfh(labels = scales::label_date("%B %Y"))

  test_dates <- as.Date(c("2023-01-01", "2023-02-01"))
  result <- scale$labels(test_dates)

  # Should be uppercase full month names
  expect_true(grepl("JANUAR|JANUARY", result[1]))  # Locale-dependent
  expect_true(grepl("FEBRUAR|FEBRUARY", result[2]))
})

test_that("date scales work with breaks_pretty()", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("scales")

  df <- data.frame(
    date = seq.Date(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "month"),
    value = rnorm(12)
  )

  p <- ggplot2::ggplot(df, ggplot2::aes(date, value)) +
    ggplot2::geom_line() +
    scale_x_date_bfh(breaks = scales::breaks_pretty(n = 6))

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")
})

test_that("date scales combine breaks_pretty() and label_date_short()", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("scales")

  df <- data.frame(
    date = seq.Date(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "month"),
    value = rnorm(12)
  )

  p <- ggplot2::ggplot(df, ggplot2::aes(date, value)) +
    ggplot2::geom_line() +
    scale_x_date_bfh(
      breaks = scales::breaks_pretty(n = 8),
      labels = scales::label_date_short()
    )

  expect_s3_class(p, "gg")
  expect_s3_class(p, "ggplot")

  # Labels should be uppercase
  scale <- p$scales$scales[[1]]
  test_dates <- as.Date(c("2023-01-01", "2023-06-01"))
  result <- scale$labels(test_dates)
  expect_true(all(result == toupper(result)))
})

test_that(".uppercase_label_wrapper handles NULL and waiver()", {
  skip_if_not_installed("ggplot2")

  # NULL should pass through
  result_null <- .uppercase_label_wrapper(NULL)
  expect_null(result_null)

  # waiver() should pass through
  result_waiver <- .uppercase_label_wrapper(ggplot2::waiver())
  expect_s3_class(result_waiver, "waiver")
})

test_that(".uppercase_label_wrapper correctly wraps functions", {
  skip_if_not_installed("scales")

  # Wrap a simple function
  lower_fn <- function(x) c("hello", "world")
  upper_fn <- .uppercase_label_wrapper(lower_fn)

  result <- upper_fn(NULL)  # Input doesn't matter for this test
  expect_equal(result, c("HELLO", "WORLD"))
})

test_that("datetime scales work with scales::label_time()", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("scales")

  scale <- scale_x_datetime_bfh(labels = scales::label_time())

  test_times <- as.POSIXct(c("2023-01-01 10:30:00", "2023-01-01 14:45:00"))
  result <- scale$labels(test_times)

  # Should be uppercase time format
  expect_true(all(result == toupper(result)))
  expect_true(all(grepl("\\d{2}:\\d{2}:\\d{2}", result)))
})

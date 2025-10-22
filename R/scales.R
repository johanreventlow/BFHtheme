# Internal factory function for creating BFH scales
# Reduces code duplication across scale_* functions
.create_bfh_scale <- function(aesthetic, palette, discrete = NULL, reverse = FALSE, ...) {
  # Validate inputs
  palette <- validate_palette_argument(palette)
  reverse <- validate_logical_argument(reverse, "reverse")

  # Validate discrete only if provided (NULL for *_continuous/*_discrete variants)
  if (!is.null(discrete)) {
    discrete <- validate_logical_argument(discrete, "discrete")
  }

  # Create palette function
  pal <- bfh_pal(palette = palette, reverse = reverse)

  # Return appropriate scale based on discrete/continuous
  if (isTRUE(discrete)) {
    ggplot2::discrete_scale(aesthetic, palette = pal, ...)
  } else {
    # Map aesthetic to corresponding gradientn function
    scale_fn <- switch(aesthetic,
      colour = ggplot2::scale_color_gradientn,
      fill = ggplot2::scale_fill_gradientn,
      stop("aesthetic must be 'colour' or 'fill'", call. = FALSE)
    )
    scale_fn(colours = pal(256), ...)
  }
}

#' BFH Colour Scales for ggplot2
#'
#' @description
#' Convenient wrappers around ggplot2 scales that apply BFH brand palettes to
#' colour or fill aesthetics.
#'
#' @details
#' When `discrete = TRUE` the functions delegate to [ggplot2::discrete_scale()].
#' For continuous aesthetics they build a gradient using [bfh_pal()] and
#' [ggplot2::scale_color_gradientn()] / [ggplot2::scale_fill_gradientn()]. Set
#' `reverse = TRUE` to invert palette order, and pass additional arguments via
#' `...` to fine-tune scale behaviour.
#'
#' @param palette Character name of a palette in [bfh_palettes()]. Defaults to `"main"`.
#' @param discrete Logical; treat the mapped variable as discrete? Defaults to `TRUE`.
#' @param reverse Logical; reverse the palette order? Defaults to `FALSE`.
#' @param ... Additional arguments passed to the underlying ggplot2 scale
#'   functions.
#' @name scale_bfh
#' @return A ggplot2 scale object.
#' @export
#'
#' @importFrom ggplot2 discrete_scale scale_color_gradientn scale_fill_gradientn
#' @seealso [bfh_pal()], [bfh_palettes], [scale_fill_bfh_continuous()]
#' @family BFH scales
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
#'   geom_point() +
#'   scale_color_bfh()
#' }
scale_color_bfh <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  .create_bfh_scale("colour", palette, discrete, reverse, ...)
}

#' @rdname scale_bfh
#' @export
scale_colour_bfh <- scale_color_bfh

#' @rdname scale_bfh
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +
#'   geom_bar() +
#'   scale_fill_bfh()
#' }
scale_fill_bfh <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  .create_bfh_scale("fill", palette, discrete, reverse, ...)
}

#' Continuous colour scales using specific BFH palettes
#'
#' @param palette Character name of a palette in [bfh_palettes()].
#' @param reverse Logical; reverse palette direction? Defaults to `FALSE`.
#' @param ... Additional arguments passed to [ggplot2::scale_color_gradientn()].
#' @export
#' @seealso [scale_color_bfh()], [bfh_pal()]
#' @family BFH scales
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_tile() +
#'   scale_fill_bfh_continuous(palette = "blues")
#' }
scale_fill_bfh_continuous <- function(palette = "blues", reverse = FALSE, ...) {
  .create_bfh_scale("fill", palette, discrete = FALSE, reverse, ...)
}

#' @rdname scale_fill_bfh_continuous
#' @export
scale_color_bfh_continuous <- function(palette = "blues", reverse = FALSE, ...) {
  .create_bfh_scale("colour", palette, discrete = FALSE, reverse, ...)
}

#' @rdname scale_fill_bfh_continuous
#' @export
scale_colour_bfh_continuous <- scale_color_bfh_continuous

#' Discrete colour scales using specific BFH palettes
#'
#' @param palette Character name of a palette in [bfh_palettes()].
#' @param reverse Logical; reverse palette direction? Defaults to `FALSE`.
#' @param ... Additional arguments passed to [ggplot2::discrete_scale()].
#' @export
#' @seealso [scale_color_bfh()], [bfh_pal()], [bfh_palettes]
#' @family BFH scales
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'   geom_point() +
#'   scale_color_bfh_discrete(palette = "primary")
#' }
scale_fill_bfh_discrete <- function(palette = "main", reverse = FALSE, ...) {
  .create_bfh_scale("fill", palette, discrete = TRUE, reverse, ...)
}

#' @rdname scale_fill_bfh_discrete
#' @export
scale_color_bfh_discrete <- function(palette = "main", reverse = FALSE, ...) {
  .create_bfh_scale("colour", palette, discrete = TRUE, reverse, ...)
}

#' @rdname scale_fill_bfh_discrete
#' @export
scale_colour_bfh_discrete <- scale_color_bfh_discrete

# Position scale functions with uppercase labels --------------------------------

#' BFH Position Scales with Uppercase Labels
#'
#' @description
#' Position scale functions that automatically convert axis tick labels to
#' uppercase, following BFH typography guidelines. These functions wrap
#' ggplot2's standard position scales and apply uppercase transformation
#' to all axis labels.
#'
#' @details
#' These functions are particularly useful for maintaining consistent
#' typographic style across plots. The uppercase transformation is applied
#' via the `labels` argument, which accepts a function that formats the
#' axis breaks.
#'
#' For date and datetime scales, **the default is [scales::label_date_short()]**
#' which creates compact, hierarchical labels that only show what has changed
#' (e.g., year only appears when it changes). This minimizes horizontal space
#' on the x-axis. All output is automatically converted to uppercase.
#'
#' ## Default Behavior (label_date_short)
#'
#' By default, date/datetime scales use `label_date_short()` which produces:
#' ```
#' JAN. | FEB. | MAR. | ... | DEC. | JAN. | FEB. | ...
#' 2023                              2024
#' ```
#' Instead of the repetitive:
#' ```
#' JAN. 2023 | FEB. 2023 | MAR. 2023 | ... | JAN. 2024 | FEB. 2024 | ...
#' ```
#'
#' ## Integration with scales package
#'
#' The date/datetime scales integrate seamlessly with the `scales` package.
#' You can override the default or use `breaks_pretty()` for intelligent
#' break positioning:
#'
#' ```r
#' # Use default (label_date_short with smart breaks)
#' scale_x_date_bfh()
#'
#' # Add custom breaks
#' scale_x_date_bfh(breaks = scales::breaks_pretty(n = 6))
#'
#' # Override with custom label format
#' scale_x_date_bfh(labels = scales::label_date("%B %Y"))  # Full month names
#'
#' # Combine custom breaks and labels
#' scale_x_date_bfh(
#'   breaks = scales::breaks_pretty(n = 8),
#'   labels = scales::label_date("%b %d")
#' )
#' ```
#'
#' @param ... Additional arguments passed to the underlying ggplot2 scale
#'   function. Common arguments include `breaks`, `limits`, `expand`, etc.
#' @param labels Label formatting function. For date/datetime scales, defaults
#'   to `scales::label_date_short()` which creates compact, hierarchical labels.
#'   For other scales, defaults to `toupper`. You can pass any `scales::label_*()`
#'   function (e.g., `label_date("%B %Y")`, `label_time()`) and output will be
#'   uppercased automatically. Set to `NULL` or `waiver()` to use ggplot2 defaults.
#' @param date_labels Date format string using standard strftime format codes.
#'   Only applicable to date/datetime scales when using custom label functions.
#'   Defaults to `"%b %Y"`. **Note:** This parameter is ignored when using the
#'   default `label_date_short()`. To use custom formats, override the `labels`
#'   parameter: `labels = scales::label_date(format = "your_format")`.
#' @return A ggplot2 scale object.
#' @name scale_position_bfh
#' @family BFH scales
#' @seealso [ggplot2::scale_x_continuous()], [ggplot2::scale_x_discrete()],
#'   [ggplot2::scale_x_date()], [bfh_labs()], [scales::label_date()],
#'   [scales::label_date_short()], [scales::breaks_pretty()]
#' @export
#'
#' @importFrom ggplot2 scale_x_continuous scale_y_continuous scale_x_discrete scale_y_discrete scale_x_date scale_y_date scale_x_datetime scale_y_datetime
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # Continuous scale with uppercase labels
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   scale_x_continuous_bfh() +
#'   theme_bfh()
#'
#' # Discrete scale with uppercase labels
#' ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
#'   geom_boxplot() +
#'   scale_x_discrete_bfh() +
#'   theme_bfh()
#'
#' # Date scale with default label_date_short() (compact hierarchical labels)
#' df <- data.frame(
#'   date = seq.Date(as.Date("2023-01-01"), as.Date("2024-12-31"), by = "month"),
#'   value = rnorm(24)
#' )
#' ggplot(df, aes(date, value)) +
#'   geom_line() +
#'   scale_x_date_bfh() +  # Uses label_date_short() by default!
#'   theme_bfh()
#'
#' # Add custom breaks for better positioning
#' ggplot(df, aes(date, value)) +
#'   geom_line() +
#'   scale_x_date_bfh(breaks = scales::breaks_pretty(n = 8)) +
#'   theme_bfh()
#'
#' # Override with custom label format
#' ggplot(df, aes(date, value)) +
#'   geom_line() +
#'   scale_x_date_bfh(labels = scales::label_date("%B %Y")) +  # Full month names
#'   theme_bfh()
#' }
scale_x_continuous_bfh <- function(..., labels = toupper) {
  ggplot2::scale_x_continuous(labels = labels, ...)
}

#' @rdname scale_position_bfh
#' @export
scale_y_continuous_bfh <- function(..., labels = toupper) {
  ggplot2::scale_y_continuous(labels = labels, ...)
}

#' @rdname scale_position_bfh
#' @export
scale_x_discrete_bfh <- function(..., labels = toupper) {
  ggplot2::scale_x_discrete(labels = labels, ...)
}

#' @rdname scale_position_bfh
#' @export
scale_y_discrete_bfh <- function(..., labels = toupper) {
  ggplot2::scale_y_discrete(labels = labels, ...)
}

#' @rdname scale_position_bfh
#' @export
scale_x_date_bfh <- function(...,
                              date_labels = "%b %Y",
                              labels = scales::label_date_short()) {
  # Wrap labels function with uppercase converter
  labels_upper <- .uppercase_label_wrapper(labels)
  ggplot2::scale_x_date(labels = labels_upper, ...)
}

#' @rdname scale_position_bfh
#' @export
scale_y_date_bfh <- function(...,
                              date_labels = "%b %Y",
                              labels = scales::label_date_short()) {
  # Wrap labels function with uppercase converter
  labels_upper <- .uppercase_label_wrapper(labels)
  ggplot2::scale_y_date(labels = labels_upper, ...)
}

#' @rdname scale_position_bfh
#' @export
scale_x_datetime_bfh <- function(...,
                                  date_labels = "%b %Y",
                                  labels = scales::label_date_short()) {
  # Wrap labels function with uppercase converter
  labels_upper <- .uppercase_label_wrapper(labels)
  ggplot2::scale_x_datetime(labels = labels_upper, ...)
}

#' @rdname scale_position_bfh
#' @export
scale_y_datetime_bfh <- function(...,
                                  date_labels = "%b %Y",
                                  labels = scales::label_date_short()) {
  # Wrap labels function with uppercase converter
  labels_upper <- .uppercase_label_wrapper(labels)
  ggplot2::scale_y_datetime(labels = labels_upper, ...)
}

# Internal helper: Wrap scales package label functions with uppercase
# This allows us to use scales::label_date(), label_date_short(), etc.
# and automatically uppercase the output
#
# @param label_fn A labeling function (e.g., from scales package)
# @return A wrapped function that uppercases the output
.uppercase_label_wrapper <- function(label_fn) {
  # Handle NULL and waiver() - pass through unchanged
  if (is.null(label_fn) || inherits(label_fn, "waiver")) {
    return(label_fn)
  }

  # Wrap the function with toupper
  function(x) {
    toupper(label_fn(x))
  }
}

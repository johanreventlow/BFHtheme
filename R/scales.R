#' BFH Color Scales for ggplot2
#'
#' @description
#' Color and fill scales using BFH color palettes for ggplot2.
#'
#' @param palette Character name of palette in bfh_palettes. Default is "main".
#' @param discrete Boolean indicating whether color aesthetic is discrete or not
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale() or
#'   scale_color_gradientn(), used respectively when discrete is TRUE or FALSE
#' @name scale_bfh
#' @return A ggplot2 scale object
#' @export
#'
#' @importFrom ggplot2 discrete_scale scale_color_gradientn scale_fill_gradientn
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
#'   geom_point() +
#'   scale_color_bfh()
#' }
scale_color_bfh <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  # Input validation
  if (!is.character(palette) || length(palette) != 1 || nchar(palette) == 0) {
    stop("palette must be a single character string", call. = FALSE)
  }

  if (!is.logical(discrete) || length(discrete) != 1 || is.na(discrete)) {
    stop("discrete must be a single logical value (TRUE or FALSE)", call. = FALSE)
  }

  if (!is.logical(reverse) || length(reverse) != 1 || is.na(reverse)) {
    stop("reverse must be a single logical value (TRUE or FALSE)", call. = FALSE)
  }

  pal <- bfh_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("colour", palette = pal, ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
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
  # Input validation
  if (!is.character(palette) || length(palette) != 1 || nchar(palette) == 0) {
    stop("palette must be a single character string", call. = FALSE)
  }

  if (!is.logical(discrete) || length(discrete) != 1 || is.na(discrete)) {
    stop("discrete must be a single logical value (TRUE or FALSE)", call. = FALSE)
  }

  if (!is.logical(reverse) || length(reverse) != 1 || is.na(reverse)) {
    stop("reverse must be a single logical value (TRUE or FALSE)", call. = FALSE)
  }

  pal <- bfh_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("fill", palette = pal, ...)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}

#' Continuous color scales using specific BFH palettes
#'
#' @param palette Character name of palette in bfh_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_color_gradientn()
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_tile() +
#'   scale_fill_bfh_continuous(palette = "blues")
#' }
scale_fill_bfh_continuous <- function(palette = "blues", reverse = FALSE, ...) {
  # Input validation
  if (!is.character(palette) || length(palette) != 1 || nchar(palette) == 0) {
    stop("palette must be a single character string", call. = FALSE)
  }

  if (!is.logical(reverse) || length(reverse) != 1 || is.na(reverse)) {
    stop("reverse must be a single logical value (TRUE or FALSE)", call. = FALSE)
  }

  pal <- bfh_pal(palette = palette, reverse = reverse)
  ggplot2::scale_fill_gradientn(colours = pal(256), ...)
}

#' @rdname scale_fill_bfh_continuous
#' @export
scale_color_bfh_continuous <- function(palette = "blues", reverse = FALSE, ...) {
  # Input validation
  if (!is.character(palette) || length(palette) != 1 || nchar(palette) == 0) {
    stop("palette must be a single character string", call. = FALSE)
  }

  if (!is.logical(reverse) || length(reverse) != 1 || is.na(reverse)) {
    stop("reverse must be a single logical value (TRUE or FALSE)", call. = FALSE)
  }

  pal <- bfh_pal(palette = palette, reverse = reverse)
  ggplot2::scale_color_gradientn(colours = pal(256), ...)
}

#' @rdname scale_fill_bfh_continuous
#' @export
scale_colour_bfh_continuous <- scale_color_bfh_continuous

#' Discrete color scales using specific BFH palettes
#'
#' @param palette Character name of palette in bfh_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'   geom_point() +
#'   scale_color_bfh_discrete(palette = "primary")
#' }
scale_fill_bfh_discrete <- function(palette = "main", reverse = FALSE, ...) {
  # Input validation
  if (!is.character(palette) || length(palette) != 1 || nchar(palette) == 0) {
    stop("palette must be a single character string", call. = FALSE)
  }

  if (!is.logical(reverse) || length(reverse) != 1 || is.na(reverse)) {
    stop("reverse must be a single logical value (TRUE or FALSE)", call. = FALSE)
  }

  pal <- bfh_pal(palette = palette, reverse = reverse)
  ggplot2::discrete_scale("fill", palette = pal, ...)
}

#' @rdname scale_fill_bfh_discrete
#' @export
scale_color_bfh_discrete <- function(palette = "main", reverse = FALSE, ...) {
  # Input validation
  if (!is.character(palette) || length(palette) != 1 || nchar(palette) == 0) {
    stop("palette must be a single character string", call. = FALSE)
  }

  if (!is.logical(reverse) || length(reverse) != 1 || is.na(reverse)) {
    stop("reverse must be a single logical value (TRUE or FALSE)", call. = FALSE)
  }

  pal <- bfh_pal(palette = palette, reverse = reverse)
  ggplot2::discrete_scale("colour", palette = pal, ...)
}

#' @rdname scale_fill_bfh_discrete
#' @export
scale_colour_bfh_discrete <- scale_color_bfh_discrete

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

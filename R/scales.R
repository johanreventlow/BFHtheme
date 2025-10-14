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
  palette <- validate_palette_argument(palette)
  discrete <- validate_logical_argument(discrete, "discrete")
  reverse <- validate_logical_argument(reverse, "reverse")

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
  palette <- validate_palette_argument(palette)
  discrete <- validate_logical_argument(discrete, "discrete")
  reverse <- validate_logical_argument(reverse, "reverse")

  pal <- bfh_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("fill", palette = pal, ...)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
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
  palette <- validate_palette_argument(palette)
  reverse <- validate_logical_argument(reverse, "reverse")

  pal <- bfh_pal(palette = palette, reverse = reverse)
  ggplot2::scale_fill_gradientn(colours = pal(256), ...)
}

#' @rdname scale_fill_bfh_continuous
#' @export
scale_color_bfh_continuous <- function(palette = "blues", reverse = FALSE, ...) {
  palette <- validate_palette_argument(palette)
  reverse <- validate_logical_argument(reverse, "reverse")

  pal <- bfh_pal(palette = palette, reverse = reverse)
  ggplot2::scale_color_gradientn(colours = pal(256), ...)
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
  palette <- validate_palette_argument(palette)
  reverse <- validate_logical_argument(reverse, "reverse")

  pal <- bfh_pal(palette = palette, reverse = reverse)
  ggplot2::discrete_scale("fill", palette = pal, ...)
}

#' @rdname scale_fill_bfh_discrete
#' @export
scale_color_bfh_discrete <- function(palette = "main", reverse = FALSE, ...) {
  palette <- validate_palette_argument(palette)
  reverse <- validate_logical_argument(reverse, "reverse")

  pal <- bfh_pal(palette = palette, reverse = reverse)
  ggplot2::discrete_scale("colour", palette = pal, ...)
}

#' @rdname scale_fill_bfh_discrete
#' @export
scale_colour_bfh_discrete <- scale_color_bfh_discrete

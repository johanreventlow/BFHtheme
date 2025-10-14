#' Get Path to the Packaged BFH Logo
#'
#' @description
#' Retrieves the file path to BFH logo assets bundled with the package.
#' Variants include full colour, greyscale, and symbol-only marks across
#' multiple resolutions.
#'
#' @param size Logo size: `"full"` (print resolution), `"web"` (800 px), or
#'   `"small"` (400 px). Defaults to `"web"`.
#' @param variant Logo variant: `"color"` (default), `"grey"` (greyscale), or
#'   `"mark"` (symbol only).
#' @return Character string containing the absolute path, or `NULL` if the asset
#'   is unavailable.
#' @export
#' @seealso [add_logo()], [add_bfh_logo()]
#' @family BFH branding
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' # Add BFH logo to plot
#' add_bfh_logo(p, get_bfh_logo())
#'
#' # Use high-resolution version for print
#' add_bfh_logo(p, get_bfh_logo("full"))
#'
#' # Use greyscale logo
#' add_bfh_logo(p, get_bfh_logo(variant = "grey"))
#'
#' # Use mark (symbol only)
#' add_bfh_logo(p, get_bfh_logo(variant = "mark"))
#' }
get_bfh_logo <- function(size = "web", variant = "color") {
  size <- match.arg(size, c("full", "web", "small"))
  variant <- match.arg(variant, c("color", "grey", "mark"))

  logo_file <- if (variant == "color") {
    switch(size,
      "full" = "logo/bfh_logo.png",
      "web" = "logo/bfh_logo_web.png",
      "small" = "logo/bfh_logo_small.png"
    )
  } else if (variant == "grey") {
    switch(size,
      "full" = "logo/bfh_logo_grey.png",
      "web" = "logo/bfh_logo_grey_web.png",
      "small" = "logo/bfh_logo_grey_web.png"  # Use web for small
    )
  } else {  # mark
    switch(size,
      "full" = "logo/bfh_mark.png",
      "web" = "logo/bfh_mark_web.png",
      "small" = "logo/bfh_mark_web.png"  # Use web for small
    )
  }

  logo_path <- system.file(logo_file, package = "BFHtheme")

  if (logo_path == "") {
    warning("BFH logo file not found in package. Logo may not have been installed correctly.")
    return(NULL)
  }

  return(logo_path)
}

#' Add Packaged BFH Logo to a Plot
#'
#' @description
#' Convenience wrapper around [add_bfh_logo()] that automatically pulls logo
#' assets from the package via [get_bfh_logo()].
#'
#' @param plot A ggplot2 object.
#' @param position Logo location: `"topleft"`, `"topright"`, `"bottomleft"`, or `"bottomright"`.
#'   Defaults to `"bottomright"`.
#' @param size Relative size of the logo (0–1). Defaults to `0.15`.
#' @param alpha Transparency of the logo (0–1). Defaults to `0.9`.
#' @param logo_size Logo file size: `"full"`, `"web"`, or `"small"`. Defaults to `"web"`.
#' @param variant Logo variant: `"color"` (default), `"grey"`, or `"mark"`.
#' @return Modified ggplot2 object with the logo applied.
#' @export
#' @seealso [get_bfh_logo()], [add_bfh_logo()]
#' @family BFH branding
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' # Add color logo in bottom right corner (default)
#' add_logo(p)
#'
#' # Add logo in top right corner
#' add_logo(p, position = "topright")
#'
#' # Add greyscale logo
#' add_logo(p, variant = "grey")
#'
#' # Add mark (symbol only, no text)
#' add_logo(p, variant = "mark", size = 0.08)
#' }
add_logo <- function(plot,
                     position = "bottomright",
                     size = 0.15,
                     alpha = 0.9,
                     logo_size = "web",
                     variant = "color") {

  logo_path <- get_bfh_logo(logo_size, variant)

  if (is.null(logo_path)) {
    warning("Could not find BFH logo. Plot returned without logo.")
    return(plot)
  }

  add_bfh_logo(plot, logo_path, position, size, alpha)
}

#' Get path to BFH logo
#'
#' @description
#' Returns the file path to the BFH logo included with the package.
#' Multiple variants are available: full color, greyscale, and mark (symbol only).
#'
#' @param size Character string specifying logo size: "full" (300 DPI), "web" (800px), or "small" (400px).
#'   Default is "web".
#' @param variant Character string specifying logo variant: "color" (default), "grey" (greyscale), or
#'   "mark" (hospital symbol only, without text).
#' @return Character string with the full path to the logo file
#' @export
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

#' Add BFH logo to plot (convenience wrapper)
#'
#' @description
#' Convenience function that adds the BFH logo from the package to a plot.
#' This is a wrapper around add_bfh_logo() that automatically uses the
#' packaged logo. Multiple logo variants are available.
#'
#' @param plot A ggplot2 object
#' @param position Position of logo: "topleft", "topright", "bottomleft", "bottomright"
#' @param size Relative size of the logo (0-1). Default is 0.15 (15% of plot width).
#' @param alpha Transparency of the logo (0-1). Default is 0.9.
#' @param logo_size Logo file size: "full", "web", or "small". Default is "web".
#' @param variant Logo variant: "color" (default), "grey" (greyscale), or "mark" (symbol only).
#' @return A modified ggplot2 object with the logo
#' @export
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

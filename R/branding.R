#' Add BFH logo to plot
#'
#' @description
#' Adds the Bispebjerg og Frederiksberg Hospital logo to a ggplot2 plot.
#' The logo file must be provided by the user.
#'
#' @param plot A ggplot2 object
#' @param logo_path Path to the logo image file (PNG, JPG, or SVG)
#' @param position Position of logo: "topleft", "topright", "bottomleft", "bottomright"
#' @param size Relative width of the logo (0-1). Default is 0.1 (10% of plot width).
#'   Height is automatically calculated to preserve aspect ratio.
#' @param alpha Transparency of the logo (0-1). Default is 1 (fully opaque).
#' @param padding Padding from the plot edge as a fraction of plot size. Default is 0.02.
#' @return A modified ggplot2 object with the logo
#' @export
#'
#' @importFrom ggplot2 annotation_custom coord_cartesian theme margin annotate labs
#' @importFrom grid rectGrob textGrob grobTree gpar unit rasterGrob
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' # Add logo (you need to provide the path to your logo file)
#' add_bfh_logo(p, "path/to/bfh_logo.png", position = "topright")
#' }
add_bfh_logo <- function(plot,
                         logo_path,
                         position = "bottomright",
                         size = 0.1,
                         alpha = 1,
                         padding = 0.02) {

  # Input validation
  if (!file.exists(logo_path)) {
    stop("Logo file not found: ", logo_path, call. = FALSE)
  }

  if (!is.numeric(size) || size <= 0 || size > 1) {
    stop("size must be a number between 0 and 1 (exclusive of 0)", call. = FALSE)
  }

  if (!is.numeric(alpha) || alpha < 0 || alpha > 1) {
    stop("alpha must be a number between 0 and 1", call. = FALSE)
  }

  if (!requireNamespace("png", quietly = TRUE) &&
      !requireNamespace("jpeg", quietly = TRUE)) {
    warning("Packages 'png' and/or 'jpeg' recommended for image support.")
  }

  # Read the image
  if (grepl("\\.png$", logo_path, ignore.case = TRUE)) {
    if (!requireNamespace("png", quietly = TRUE)) {
      stop("Package 'png' is required to read PNG files. Install with: install.packages('png')", call. = FALSE)
    }
    logo <- png::readPNG(logo_path)
  } else if (grepl("\\.(jpg|jpeg)$", logo_path, ignore.case = TRUE)) {
    if (!requireNamespace("jpeg", quietly = TRUE)) {
      stop("Package 'jpeg' is required to read JPEG files. Install with: install.packages('jpeg')", call. = FALSE)
    }
    logo <- jpeg::readJPEG(logo_path)
  } else {
    stop("Logo must be a PNG or JPEG file", call. = FALSE)
  }

  # Beregn aspect ratio for at bevare logoets proportioner
  # Logo array har dimensioner [height, width, channels] eller [height, width]
  logo_dims <- dim(logo)
  logo_height <- logo_dims[1]
  logo_width <- logo_dims[2]
  aspect_ratio <- logo_height / logo_width

  # Beregn faktisk højde baseret på bredde og aspect ratio
  logo_width_npc <- size
  logo_height_npc <- size * aspect_ratio

  # Determine position parameters med korrekte dimensioner
  pos <- switch(position,
    topleft = list(
      x = grid::unit(padding + logo_width_npc/2, "npc"),
      y = grid::unit(1 - padding - logo_height_npc/2, "npc")
    ),
    topright = list(
      x = grid::unit(1 - padding - logo_width_npc/2, "npc"),
      y = grid::unit(1 - padding - logo_height_npc/2, "npc")
    ),
    bottomleft = list(
      x = grid::unit(padding + logo_width_npc/2, "npc"),
      y = grid::unit(padding + logo_height_npc/2, "npc")
    ),
    bottomright = list(
      x = grid::unit(1 - padding - logo_width_npc/2, "npc"),
      y = grid::unit(padding + logo_height_npc/2, "npc")
    ),
    stop("position must be one of: topleft, topright, bottomleft, bottomright", call. = FALSE)
  )

  # Convert to raster with position applied og korrekt aspect ratio
  logo_raster <- grid::rasterGrob(
    logo,
    x = pos$x,
    y = pos$y,
    interpolate = TRUE,
    width = grid::unit(logo_width_npc, "npc"),
    height = grid::unit(logo_height_npc, "npc"),
    gp = grid::gpar(alpha = alpha)
  )

  # Add logo to plot
  plot +
    ggplot2::annotation_custom(
      logo_raster,
      xmin = -Inf, xmax = Inf,
      ymin = -Inf, ymax = Inf
    ) +
    ggplot2::coord_cartesian(clip = "off")
}

#' Add BFH footer to plot
#'
#' @description
#' Adds a footer with BFH branding information to the plot.
#' Useful for adding contact information or copyright notices.
#'
#' @param plot A ggplot2 object
#' @param text Footer text. If NULL, uses default BFH text.
#' @param color Color of the footer bar. Default is BFH primary blue.
#' @param text_color Color of the footer text. Default is white.
#' @param height Height of the footer as fraction of plot. Default is 0.05.
#' @return A modified ggplot2 object with footer
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' add_bfh_footer(p, text = "Bispebjerg og Frederiksberg Hospital - 2024")
#' }
add_bfh_footer <- function(plot,
                           text = NULL,
                           color = bfh_cols("hospital_primary"),
                           text_color = "white",
                           height = 0.05) {

  if (is.null(text)) {
    text <- "Bispebjerg og Frederiksberg Hospital"
  }

  # Create footer rectangle positioned at bottom with specified height
  footer_rect <- grid::rectGrob(
    x = grid::unit(0.5, "npc"),
    y = grid::unit(height/2, "npc"),
    width = grid::unit(1, "npc"),
    height = grid::unit(height, "npc"),
    gp = grid::gpar(fill = color, col = NA)
  )

  # Create footer text centered in footer area
  footer_text <- grid::textGrob(
    text,
    x = grid::unit(0.5, "npc"),
    y = grid::unit(height/2, "npc"),
    gp = grid::gpar(col = text_color, fontsize = 10)
  )

  # Combine rectangle and text
  footer_grob <- grid::grobTree(footer_rect, footer_text)

  # Add footer to plot
  # annotation_custom() kræver numeriske koordinater, ikke unit objekter
  # Vi bruger -Inf/Inf og lader grob'en selv håndtere positioning
  plot +
    ggplot2::annotation_custom(
      footer_grob,
      xmin = -Inf, xmax = Inf,
      ymin = -Inf, ymax = Inf
    ) +
    ggplot2::coord_cartesian(clip = "off") +
    ggplot2::theme(plot.margin = ggplot2::margin(b = height * 100, unit = "pt"))
}

#' Create a branded title block
#'
#' @description
#' Creates a formatted title block with BFH branding colors.
#' Returns a list of ggplot2 labs() elements.
#'
#' @param title Main title text
#' @param subtitle Subtitle text (optional)
#' @param caption Caption text (optional)
#' @return A ggplot2 labs() object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   bfh_title_block(
#'     title = "Vehicle Weight vs Fuel Efficiency",
#'     subtitle = "Analysis of mtcars dataset",
#'     caption = "Source: Motor Trend, 1974"
#'   ) +
#'   theme_bfh()
#' }
bfh_title_block <- function(title, subtitle = NULL, caption = NULL) {
  ggplot2::labs(
    title = title,
    subtitle = subtitle,
    caption = caption
  )
}

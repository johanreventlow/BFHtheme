#' Set BFH defaults for ggplot2
#'
#' @description
#' Sets default BFH theme and geom colors for all plots in the current session.
#' This function modifies the global ggplot2 theme and updates default colors
#' for common geoms (point, line, bar, etc.).
#'
#' **Note:** This function does NOT set default color/fill scales for aesthetic
#' mappings. If you use `aes(color = ...)` or `aes(fill = ...)`, you must
#' manually add `scale_color_bfh()` or `scale_fill_bfh()` to your plots.
#'
#' @param theme Character name of the BFH theme to use as default.
#'   Options: "bfh", "bfh_minimal", "bfh_print", "bfh_presentation", "bfh_dark".
#'   Default is "bfh".
#' @param palette Character name of the default color palette used for geom defaults.
#'   Default is "main".
#' @param base_size Base font size for the theme. Default is 12.
#' @param base_family Base font family for the theme. If NULL (default),
#'   automatically detects best available BFH font (Mari, Roboto, Arial, or sans).
#' @return Invisibly returns TRUE after setting defaults
#' @export
#'
#' @importFrom ggplot2 theme_set theme_gray update_geom_defaults
#' @examples
#' \dontrun{
#' # Set BFH defaults at the start of your script
#' set_bfh_defaults()
#'
#' # Plots without color mapping use BFH colors automatically
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point()  # Uses BFH primary color
#'
#' # For color mappings, add scale manually
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   scale_color_bfh()  # Required for BFH colors
#'
#' # Use a different theme
#' set_bfh_defaults(theme = "bfh_minimal", palette = "blues")
#' }
set_bfh_defaults <- function(theme = "bfh",
                             palette = "main",
                             base_size = 12,
                             base_family = NULL) {

  # Set the theme
  theme_func <- switch(theme,
    "bfh" = theme_bfh,
    "bfh_minimal" = theme_bfh_minimal,
    "bfh_print" = theme_bfh_print,
    "bfh_presentation" = theme_bfh_presentation,
    "bfh_dark" = theme_bfh_dark,
    theme_bfh  # default fallback
  )

  ggplot2::theme_set(theme_func(base_size = base_size, base_family = base_family))

  # Get the palette colors
  pal_colors <- bfh_palettes[[palette]]
  if (is.null(pal_colors)) {
    warning("Palette '", palette, "' not found. Using 'main' palette.", call. = FALSE)
    palette <- "main"  # Opdater palette-variablen
    pal_colors <- bfh_palettes[["main"]]
  }

  # Set default colors for common geoms
  ggplot2::update_geom_defaults("point", list(colour = pal_colors[1]))
  ggplot2::update_geom_defaults("line", list(colour = pal_colors[1]))
  ggplot2::update_geom_defaults("area", list(fill = pal_colors[1]))
  ggplot2::update_geom_defaults("rect", list(fill = pal_colors[1]))
  ggplot2::update_geom_defaults("density", list(fill = pal_colors[1]))
  ggplot2::update_geom_defaults("bar", list(fill = pal_colors[1]))
  ggplot2::update_geom_defaults("col", list(fill = pal_colors[1]))
  ggplot2::update_geom_defaults("boxplot", list(fill = pal_colors[1]))
  ggplot2::update_geom_defaults("violin", list(fill = pal_colors[1]))
  ggplot2::update_geom_defaults("dotplot", list(fill = pal_colors[1]))

  message("BFH defaults set successfully!")
  message("Theme: ", theme)
  message("Palette: ", palette)

  invisible(TRUE)
}

#' Reset ggplot2 defaults
#'
#' @description
#' Resets ggplot2 to its default theme and geom colors.
#' Use this to undo the effects of set_bfh_defaults().
#'
#' @return Invisibly returns TRUE after resetting defaults
#' @export
#' @examples
#' \dontrun{
#' # Set BFH defaults
#' set_bfh_defaults()
#'
#' # ... create some plots ...
#'
#' # Reset to ggplot2 defaults
#' reset_bfh_defaults()
#' }
reset_bfh_defaults <- function() {
  # Reset to ggplot2 default theme
  ggplot2::theme_set(ggplot2::theme_gray())

  # Reset geom defaults to original ggplot2 colors
  ggplot2::update_geom_defaults("point", list(colour = "black"))
  ggplot2::update_geom_defaults("line", list(colour = "black"))
  ggplot2::update_geom_defaults("area", list(fill = "grey20"))
  ggplot2::update_geom_defaults("rect", list(fill = "grey35"))
  ggplot2::update_geom_defaults("density", list(fill = "grey20"))
  ggplot2::update_geom_defaults("bar", list(fill = "grey35"))
  ggplot2::update_geom_defaults("col", list(fill = "grey35"))
  ggplot2::update_geom_defaults("boxplot", list(fill = "white"))
  ggplot2::update_geom_defaults("violin", list(fill = "white"))
  ggplot2::update_geom_defaults("dotplot", list(fill = "black"))

  message("ggplot2 defaults have been reset.")

  invisible(TRUE)
}

#' Apply BFH theme to the current plot
#'
#' @description
#' A convenience function that applies the BFH theme to the current plot.
#' Optionally adds BFH color scales for discrete mappings.
#'
#' @param theme Character name of the BFH theme. Default is "bfh".
#' @param palette Character name of the color palette. Default is "main".
#' @param base_size Base font size. Default is 12.
#' @param add_color_scale Logical. If TRUE, adds discrete color scale. Default is FALSE.
#' @param add_fill_scale Logical. If TRUE, adds discrete fill scale. Default is FALSE.
#' @return A list of ggplot2 theme and scale components
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' # Just theme, no scales
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   apply_bfh_theme()
#'
#' # With discrete color scale
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   apply_bfh_theme(add_color_scale = TRUE)
#'
#' # For continuous mappings, add scale manually
#' ggplot(mtcars, aes(wt, mpg, color = hp)) +
#'   geom_point() +
#'   apply_bfh_theme() +
#'   scale_color_bfh_continuous()
#' }
apply_bfh_theme <- function(theme = "bfh",
                            palette = "main",
                            base_size = 12,
                            add_color_scale = FALSE,
                            add_fill_scale = FALSE) {
  theme_func <- switch(theme,
    "bfh" = theme_bfh,
    "bfh_minimal" = theme_bfh_minimal,
    "bfh_print" = theme_bfh_print,
    "bfh_presentation" = theme_bfh_presentation,
    "bfh_dark" = theme_bfh_dark,
    theme_bfh
  )

  # Start with theme
  components <- list(theme_func(base_size = base_size))

  # Add scales if requested
  if (add_color_scale) {
    components <- c(components, list(scale_color_bfh(palette = palette)))
  }
  if (add_fill_scale) {
    components <- c(components, list(scale_fill_bfh(palette = palette)))
  }

  components
}

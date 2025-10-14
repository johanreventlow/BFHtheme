#' Set BFH Defaults for ggplot2
#'
#' @description
#' Applies a BFH theme globally and updates default geom colours for the current
#' R session. Ideal for scripts or reports where every plot should inherit BFH
#' styling without repeated boilerplate.
#'
#' @details
#' The function calls [ggplot2::theme_set()] with the selected BFH theme and
#' updates default aesthetics for commonly used geoms (points, lines, bars, and
#' more). Colour/fill scales are not altered automatically—continue to add
#' `scale_*_bfh()` when mapping aesthetics.
#'
#' @param theme Character name of the BFH theme to adopt. Valid choices are
#'   `"bfh"`, `"bfh_minimal"`, `"bfh_print"`, `"bfh_presentation"`, and
#'   `"bfh_dark"`. Defaults to `"bfh"`.
#' @param palette Character name of the palette from [bfh_palettes] used to seed
#'   geom defaults. Defaults to `"main"`.
#' @param base_size Base font size for the theme. Defaults to 12.
#' @param base_family Base font family. Use `NULL` (default) to auto-detect with
#'   [get_bfh_font()].
#' @return Invisibly returns `TRUE` after the defaults have been applied.
#' @export
#'
#' @importFrom ggplot2 theme_set theme_gray update_geom_defaults
#' @seealso [reset_bfh_defaults()], [apply_bfh_theme()], [set_bfh_fonts()]
#' @family BFH defaults
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

#' Reset ggplot2 Defaults
#'
#' @description
#' Restores ggplot2's original theme and geom defaults, undoing the effect of
#' [set_bfh_defaults()].
#'
#' @return Invisibly returns `TRUE` once defaults are reset.
#' @export
#' @seealso [set_bfh_defaults()]
#' @family BFH defaults
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

#' Apply BFH Theme to a Plot
#'
#' @description
#' Lightweight helper that returns a list containing the requested BFH theme and
#' optional discrete colour/fill scales. Designed for piping directly into a
#' ggplot call.
#'
#' @param theme Character name of the BFH theme variant. Defaults to `"bfh"`.
#' @param palette Character name of the palette (from [bfh_palettes]) used when
#'   adding scales. Defaults to `"main"`.
#' @param base_size Base font size supplied to the chosen theme. Defaults to 12.
#' @param add_color_scale Logical; add [scale_color_bfh()] if `TRUE`.
#'   Defaults to `FALSE`.
#' @param add_fill_scale Logical; add [scale_fill_bfh()] if `TRUE`.
#'   Defaults to `FALSE`.
#' @return A list of ggplot2 components that can be added to a plot.
#' @export
#' @seealso [set_bfh_defaults()], [theme_bfh()], [scale_color_bfh()]
#' @family BFH defaults
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

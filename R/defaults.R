# Geom classes modified by set_bfh_defaults() — used for save/restore
.bfh_managed_geoms <- c(
  "point", "line", "area", "rect", "density",
  "bar", "col", "boxplot", "violin", "dotplot"
)

# Map geom names to exported ggplot2 Geom ggproto objects for default_aes access
.bfh_geom_class <- function(geom_name) {
  switch(
    geom_name,
    point   = ggplot2::GeomPoint,
    line    = ggplot2::GeomLine,
    area    = ggplot2::GeomArea,
    rect    = ggplot2::GeomRect,
    density = ggplot2::GeomDensity,
    bar     = ggplot2::GeomBar,
    col     = ggplot2::GeomCol,
    boxplot = ggplot2::GeomBoxplot,
    violin  = ggplot2::GeomViolin,
    dotplot = ggplot2::GeomDotplot,
    stop("Unknown geom: ", geom_name, call. = FALSE)
  )
}

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
#' Previous global state (active theme and geom defaults) is saved automatically
#' and can be restored with [reset_bfh_defaults()].
#'
#' @param theme Character name of the BFH theme to adopt. Only `"bfh"` is
#'   supported (other theme variants removed in v0.2.0). Defaults to `"bfh"`.
#' @param palette Character name of the palette from [bfh_palettes] used to seed
#'   geom defaults. Defaults to `"main"`.
#' @param base_size Base font size for the theme. Defaults to 12.
#' @param base_family Base font family. Use `NULL` (default) to auto-detect with
#'   [get_bfh_font()].
#' @return Invisibly returns `TRUE` after the defaults have been applied.
#' @export
#'
#' @importFrom ggplot2 theme_set theme_gray update_geom_defaults
#' @seealso [reset_bfh_defaults()], [set_bfh_fonts()]
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
#' # Use a different palette
#' set_bfh_defaults(palette = "blues")
#' }
set_bfh_defaults <- function(theme = "bfh",
                             palette = "main",
                             base_size = 12,
                             base_family = NULL) {

  # Save current state before mutation
  .bfh_state$previous_theme <- ggplot2::theme_get()
  .bfh_state$previous_geoms <- lapply(
    stats::setNames(.bfh_managed_geoms, .bfh_managed_geoms),
    function(nm) as.list(.bfh_geom_class(nm)$default_aes)
  )

  theme_func <- switch(theme,
    "bfh" = theme_bfh,
    theme_bfh
  )

  ggplot2::theme_set(theme_func(base_size = base_size, base_family = base_family))

  pal_colors <- bfh_palettes[[palette]]
  if (is.null(pal_colors)) {
    warning("Palette '", palette, "' not found. Using 'main' palette.", call. = FALSE)
    palette <- "main"
    pal_colors <- bfh_palettes[["main"]]
  }

  ggplot2::update_geom_defaults("point",   list(colour = pal_colors[1]))
  ggplot2::update_geom_defaults("line",    list(colour = pal_colors[1]))
  ggplot2::update_geom_defaults("area",    list(fill   = pal_colors[1]))
  ggplot2::update_geom_defaults("rect",    list(fill   = pal_colors[1]))
  ggplot2::update_geom_defaults("density", list(fill   = pal_colors[1]))
  ggplot2::update_geom_defaults("bar",     list(fill   = pal_colors[1]))
  ggplot2::update_geom_defaults("col",     list(fill   = pal_colors[1]))
  ggplot2::update_geom_defaults("boxplot", list(fill   = pal_colors[1]))
  ggplot2::update_geom_defaults("violin",  list(fill   = pal_colors[1]))
  ggplot2::update_geom_defaults("dotplot", list(fill   = pal_colors[1]))

  message("BFH defaults set successfully!")
  message("Theme: ", theme)
  message("Palette: ", palette)

  invisible(TRUE)
}

#' Reset ggplot2 Defaults
#'
#' @description
#' Restores the theme and geom defaults that were active before [set_bfh_defaults()]
#' was last called.
#'
#' @details
#' If [set_bfh_defaults()] has not been called in the current session, falls
#' back to `theme_gray()` and ggplot2's hardcoded geom defaults, and emits a
#' message indicating no saved state was found.
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
#' # Reset to previous state
#' reset_bfh_defaults()
#' }
reset_bfh_defaults <- function() {
  if (is.null(.bfh_state$previous_theme)) {
    message("No saved state found. Resetting to ggplot2 defaults.")
    ggplot2::theme_set(ggplot2::theme_gray())

    ggplot2::update_geom_defaults("point",   list(colour = "black"))
    ggplot2::update_geom_defaults("line",    list(colour = "black"))
    ggplot2::update_geom_defaults("area",    list(fill   = "grey20"))
    ggplot2::update_geom_defaults("rect",    list(fill   = "grey35"))
    ggplot2::update_geom_defaults("density", list(fill   = "grey20"))
    ggplot2::update_geom_defaults("bar",     list(fill   = "grey35"))
    ggplot2::update_geom_defaults("col",     list(fill   = "grey35"))
    ggplot2::update_geom_defaults("boxplot", list(fill   = "white"))
    ggplot2::update_geom_defaults("violin",  list(fill   = "white"))
    ggplot2::update_geom_defaults("dotplot", list(fill   = "black"))
  } else {
    ggplot2::theme_set(.bfh_state$previous_theme)

    for (nm in names(.bfh_state$previous_geoms)) {
      ggplot2::update_geom_defaults(nm, .bfh_state$previous_geoms[[nm]])
    }

    .bfh_state$previous_theme <- NULL
    .bfh_state$previous_geoms <- NULL

    message("BFH defaults reset.")
  }

  invisible(TRUE)
}

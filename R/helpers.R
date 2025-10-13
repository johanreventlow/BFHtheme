#' Save a plot with BFH specifications
#'
#' @description
#' Convenience function to save ggplot2 plots with recommended dimensions and
#' settings for BFH reports and presentations. Wraps ggplot2::ggsave() with
#' sensible defaults.
#'
#' @param filename File name to save the plot. Should include extension
#'   (e.g., "plot.png", "figure.pdf").
#' @param plot Plot to save. Defaults to last plot displayed.
#' @param preset Character string specifying a size preset:
#'   - "report_full": Full-width figure for reports (7x5 inches)
#'   - "report_half": Half-width figure for reports (3.5x3 inches)
#'   - "presentation": Standard presentation slide (10x6 inches)
#'   - "presentation_wide": Widescreen presentation (12x6.75 inches)
#'   - "square": Square format (6x6 inches)
#'   - "poster": Large format for posters (12x9 inches)
#' @param width Plot width in units. If specified, overrides preset.
#' @param height Plot height in units. If specified, overrides preset.
#' @param units Units for width and height ("in", "cm", "mm", "px"). Default is "in".
#' @param dpi Resolution in dots per inch. Default is 300 for high quality.
#' @param ... Additional arguments passed to ggplot2::ggsave()
#' @return Invisibly returns the filename
#' @export
#'
#' @importFrom ggplot2 ggsave last_plot labs annotation_custom coord_cartesian annotate theme
#' @importFrom grid rectGrob unit gpar
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' # Save with preset
#' bfh_save("my_plot.png", p, preset = "report_full")
#'
#' # Save with custom dimensions
#' bfh_save("my_plot.pdf", p, width = 8, height = 6, dpi = 600)
#' }
bfh_save <- function(filename,
                     plot = ggplot2::last_plot(),
                     preset = "report_full",
                     width = NULL,
                     height = NULL,
                     units = "in",
                     dpi = 300,
                     ...) {

  # Define presets (dimensions in inches)
  presets <- list(
    report_full = list(width = 7, height = 5),
    report_half = list(width = 3.5, height = 3),
    presentation = list(width = 10, height = 6),
    presentation_wide = list(width = 12, height = 6.75),
    square = list(width = 6, height = 6),
    poster = list(width = 12, height = 9)
  )

  # Use preset dimensions if width/height not specified
  if (is.null(width) || is.null(height)) {
    if (!preset %in% names(presets)) {
      warning("Unknown preset '", preset, "'. Using report_full dimensions.")
      preset <- "report_full"
    }

    dims <- presets[[preset]]
    if (is.null(width)) width <- dims$width
    if (is.null(height)) height <- dims$height
  }

  # Save the plot
  ggplot2::ggsave(
    filename = filename,
    plot = plot,
    width = width,
    height = height,
    units = units,
    dpi = dpi,
    ...
  )

  message("Plot saved: ", filename)
  message(sprintf("Dimensions: %.1f x %.1f %s at %d dpi", width, height, units, dpi))

  invisible(filename)
}

#' Get recommended plot dimensions
#'
#' @description
#' Returns recommended plot dimensions for different output types.
#'
#' @param type Character string specifying the output type:
#'   "report", "presentation", "poster", "web", "print"
#' @param format Character string for aspect ratio: "standard", "wide", "square"
#' @return Named list with width and height in inches
#' @export
#' @examples
#' get_bfh_dimensions("report", "standard")
#' get_bfh_dimensions("presentation", "wide")
get_bfh_dimensions <- function(type = "report", format = "standard") {
  dimensions <- list(
    report = list(
      standard = list(width = 7, height = 5),
      wide = list(width = 8, height = 4.5),
      square = list(width = 5, height = 5)
    ),
    presentation = list(
      standard = list(width = 10, height = 6),
      wide = list(width = 12, height = 6.75),
      square = list(width = 8, height = 8)
    ),
    poster = list(
      standard = list(width = 12, height = 9),
      wide = list(width = 16, height = 9),
      square = list(width = 12, height = 12)
    ),
    web = list(
      standard = list(width = 8, height = 6),
      wide = list(width = 10, height = 5.625),
      square = list(width = 6, height = 6)
    ),
    print = list(
      standard = list(width = 8, height = 6),
      wide = list(width = 10, height = 6),
      square = list(width = 6, height = 6)
    )
  )

  if (!type %in% names(dimensions)) {
    warning("Unknown type '", type, "'. Using 'report'.")
    type <- "report"
  }

  if (!format %in% names(dimensions[[type]])) {
    warning("Unknown format '", format, "'. Using 'standard'.")
    format <- "standard"
  }

  dimensions[[type]][[format]]
}

#' Create a multi-panel figure with shared legend
#'
#' @description
#' Arranges multiple ggplot2 plots into a single figure with a shared legend.
#' Useful for creating multi-panel figures for reports.
#'
#' @param plots List of ggplot2 plot objects
#' @param ncol Number of columns in the layout
#' @param nrow Number of rows in the layout
#' @param legend_position Position of shared legend: "bottom", "top", "left", "right", "none"
#' @return A combined plot object (requires patchwork or cowplot)
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p1 <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) + geom_point()
#' p2 <- ggplot(mtcars, aes(hp, mpg, color = factor(cyl))) + geom_point()
#' p3 <- ggplot(mtcars, aes(disp, mpg, color = factor(cyl))) + geom_point()
#'
#' # Combine with shared legend
#' bfh_combine_plots(list(p1, p2, p3), ncol = 3)
#' }
bfh_combine_plots <- function(plots,
                              ncol = NULL,
                              nrow = NULL,
                              legend_position = "bottom") {

  # Check if patchwork is available (preferred)
  if (requireNamespace("patchwork", quietly = TRUE)) {
    # Combine plots
    if (!is.null(ncol)) {
      combined <- patchwork::wrap_plots(plots, ncol = ncol)
    } else if (!is.null(nrow)) {
      combined <- patchwork::wrap_plots(plots, nrow = nrow)
    } else {
      combined <- patchwork::wrap_plots(plots)
    }

    # Add shared legend if requested
    if (legend_position != "none") {
      combined <- combined + patchwork::plot_layout(guides = "collect") &
        ggplot2::theme(legend.position = legend_position)
    } else {
      combined <- combined & ggplot2::theme(legend.position = "none")
    }

    return(combined)

  } else {
    stop("This function requires the 'patchwork' package. Install it with: install.packages('patchwork')")
  }
}

#' Add BFH color bar annotation to plot
#'
#' @description
#' Adds a colored bar to the plot, useful for adding a visual BFH brand element.
#'
#' @param plot A ggplot2 object
#' @param position Position of the bar: "top", "bottom", "left", "right"
#' @param color Color of the bar. Default is BFH primary blue.
#' @param size Size of the bar (height for horizontal, width for vertical)
#' @return A ggplot2 object with the color bar annotation
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' add_bfh_color_bar(p, position = "top")
#' }
add_bfh_color_bar <- function(plot,
                              position = "top",
                              color = bfh_cols("hospital_primary"),
                              size = 0.02) {

  if (!inherits(plot, "gg")) {
    stop("plot must be a ggplot2 object")
  }

  # Create rectangle grob with position-specific viewport
  # annotation_custom() kræver numeriske koordinater, ikke unit objekter
  # Vi bruger derfor -Inf/Inf og lader grob'en selv håndtere positioning
  bar_grob <- switch(position,
    top = grid::rectGrob(
      x = grid::unit(0.5, "npc"),
      y = grid::unit(1 - size/2, "npc"),
      width = grid::unit(1, "npc"),
      height = grid::unit(size, "npc"),
      gp = grid::gpar(fill = color, col = NA)
    ),
    bottom = grid::rectGrob(
      x = grid::unit(0.5, "npc"),
      y = grid::unit(size/2, "npc"),
      width = grid::unit(1, "npc"),
      height = grid::unit(size, "npc"),
      gp = grid::gpar(fill = color, col = NA)
    ),
    left = grid::rectGrob(
      x = grid::unit(size/2, "npc"),
      y = grid::unit(0.5, "npc"),
      width = grid::unit(size, "npc"),
      height = grid::unit(1, "npc"),
      gp = grid::gpar(fill = color, col = NA)
    ),
    right = grid::rectGrob(
      x = grid::unit(1 - size/2, "npc"),
      y = grid::unit(0.5, "npc"),
      width = grid::unit(size, "npc"),
      height = grid::unit(1, "npc"),
      gp = grid::gpar(fill = color, col = NA)
    ),
    stop("position must be one of: top, bottom, left, right")
  )

  # Add annotation with -Inf/Inf til at fylde hele plot area
  plot <- plot +
    ggplot2::annotation_custom(
      bar_grob,
      xmin = -Inf, xmax = Inf,
      ymin = -Inf, ymax = Inf
    )

  # Disable clipping to show the annotation
  plot <- plot + ggplot2::coord_cartesian(clip = "off")

  return(plot)
}

#' BFH-style plot labels with automatic uppercase
#'
#' @description
#' Wrapper around ggplot2::labs() that automatically converts axis labels,
#' subtitles, and legend titles to uppercase, following BFH visual identity
#' guidelines. Only the main title is left unchanged to preserve natural
#' capitalization.
#'
#' @param ... Named arguments passed to ggplot2::labs(). Character values will
#'   be converted to uppercase except for title. Common arguments include:
#'   - title: Plot title (unchanged - natural case)
#'   - subtitle: Plot subtitle (uppercase)
#'   - caption: Plot caption (uppercase)
#'   - x: X-axis label (uppercase)
#'   - y: Y-axis label (uppercase)
#'   - color/colour: Legend title for color aesthetic (uppercase)
#'   - fill: Legend title for fill aesthetic (uppercase)
#' @return A ggplot2 labels object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # Only title unchanged, everything else uppercase
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh() +
#'   bfh_labs(
#'     title = "Fuel efficiency analysis",     # → "Fuel efficiency analysis" (unchanged)
#'     subtitle = "Motor Trend data",          # → "MOTOR TREND DATA"
#'     x = "weight (tons)",                    # → "WEIGHT (TONS)"
#'     y = "miles per gallon"                  # → "MILES PER GALLON"
#'   )
#'
#' # Time series example
#' ggplot(time_data, aes(date, value, color = group)) +
#'   geom_line() +
#'   theme_bfh() +
#'   bfh_labs(
#'     title = "Patient trends over time",     # → "Patient trends over time" (unchanged)
#'     subtitle = "Bispebjerg og Frederiksberg Hospital 2020-2024",  # → "BISPEBJERG..." (uppercase)
#'     x = "date",                             # → "DATE"
#'     y = "number of patients",               # → "NUMBER OF PATIENTS"
#'     color = "department"                    # → "DEPARTMENT"
#'   )
#' }
bfh_labs <- function(...) {
  args <- list(...)

  # Labels that should NOT be uppercased
  keep_as_is <- c("title")

  # Convert character arguments to uppercase, except title
  args <- lapply(names(args), function(name) {
    value <- args[[name]]

    if (is.character(value) && !name %in% keep_as_is) {
      toupper(value)
    } else {
      value
    }
  })

  # Restore names
  names(args) <- names(list(...))

  # Call ggplot2::labs() with converted arguments
  do.call(ggplot2::labs, args)
}

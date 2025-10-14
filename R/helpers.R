#' Save a Plot with BFH Specifications
#'
#' @description
#' Wrapper around [ggplot2::ggsave()] that applies BFH-recommended dimensions,
#' resolution, and message output for reproducible plot exports.
#'
#' @details
#' Use the `preset` argument to quickly match internal communication formats.
#' Width/height arguments override presets when supplied. For more control,
#' pair with [get_bfh_dimensions()] to retrieve structured size guidance.
#'
#' @param filename File name to save the plot. Include an extension such as
#'   `"plot.png"` or `"figure.pdf"`.
#' @param plot Plot to save. Defaults to the last displayed plot.
#' @param preset Character string specifying size presets:
#'   `"report_full"` (7x5 in), `"report_half"` (3.5x3 in), `"presentation"` (10x6 in),
#'   `"presentation_wide"` (12x6.75 in), `"square"` (6x6 in), `"poster"` (12x9 in).
#' @param width Plot width. Overrides `preset` when provided.
#' @param height Plot height. Overrides `preset` when provided.
#' @param units Units for width/height (`"in"`, `"cm"`, `"mm"`, `"px"`). Defaults to `"in"`.
#' @param dpi Resolution in dots per inch. Defaults to 300.
#' @param ... Additional arguments passed to [ggplot2::ggsave()].
#' @return Invisibly returns `filename`.
#' @export
#'
#' @importFrom ggplot2 ggsave last_plot labs annotation_custom coord_cartesian annotate theme
#' @importFrom grid rectGrob unit gpar
#' @seealso [get_bfh_dimensions()], [theme_bfh()], [bfh_title_block()]
#' @family BFH helpers
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
    # Modernized with %||% NULL coalescing operator
    width <- width %||% dims$width
    height <- height %||% dims$height
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

#' Get Recommended Plot Dimensions
#'
#' @description
#' Supplies canonical width/height combinations for common BFH output formats,
#' facilitating consistent figure sizing across documents and slides.
#'
#' @param type Output target. One of `"report"`, `"presentation"`, `"poster"`,
#'   `"web"`, or `"print"`. Defaults to `"report"`.
#' @param format Aspect ratio. One of `"standard"`, `"wide"`, or `"square"`.
#'   Defaults to `"standard"`.
#' @return Named list with `width` and `height` in inches.
#' @export
#' @seealso [bfh_save()], [theme_bfh()]
#' @family BFH helpers
#' @details Invalid `type`/`format` combinations trigger a warning and fall back
#' to the closest supported option.
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

#' Create a Multi-Panel Figure with Shared Legend
#'
#' @description
#' Arranges multiple ggplot2 plots into a single layout with an optional shared
#' legend, ideal for BFH report panels and slide decks.
#'
#' @details
#' The function currently depends on the `patchwork` package. When unavailable a
#' descriptive error is raised; install `patchwork` to use this helper.
#'
#' @param plots List of ggplot2 plot objects.
#' @param ncol Optional number of columns in the layout.
#' @param nrow Optional number of rows in the layout.
#' @param legend_position Legend placement. One of `"bottom"`, `"top"`, `"left"`,
#'   `"right"`, or `"none"`. Defaults to `"bottom"`.
#' @return Combined plot object produced by `patchwork`.
#' @export
#' @seealso [patchwork::wrap_plots()], [bfh_save()]
#' @family BFH helpers
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

#' Add a BFH Colour Bar Annotation
#'
#' @description
#' Adds a slim coloured band to any plot edge—a simple way to inject BFH brand
#' cues without altering the main chart area.
#'
#' @details
#' The `size` argument is expressed as a fraction of the plotting area (0–1).
#' Values between 0.015 and 0.04 typically balance visibility with subtlety.
#'
#' @param plot A ggplot2 object.
#' @param position Plot side on which the bar should appear: `"top"`, `"bottom"`,
#'   `"left"`, or `"right"`. Defaults to `"top"`.
#' @param color Fill colour of the bar. Defaults to `bfh_cols("hospital_primary")`.
#' @param size Thickness of the bar (height for horizontal, width for vertical)
#'   expressed as a fraction of the plotting area. Defaults to `0.02`.
#' @return ggplot2 object with the annotation added.
#' @export
#' @seealso [add_bfh_footer()], [add_bfh_logo()], [bfh_title_block()]
#' @family BFH branding
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

#' BFH-Style Plot Labels with Automatic Uppercase
#'
#' @description
#' Wrapper around [ggplot2::labs()] that converts subtitles, captions, axes, and
#' legend titles to uppercase, matching BFH typographic guidance while leaving
#' the main title unchanged.
#'
#' @details
#' Only the argument named `"title"` is exempt from uppercasing. Supply other
#' character values via `...` and they will be converted using [base::toupper()].
#'
#' @param ... Named arguments passed to [ggplot2::labs()]. Character values are
#'   uppercased except for `title`. Common keys include:
#'   \itemize{
#'     \item `title`: Plot title (kept in natural case).
#'     \item `subtitle`: Subtitle (uppercased).
#'     \item `caption`: Caption (uppercased).
#'     \item `x`, `y`: Axis labels (uppercased).
#'     \item `color`/`colour`, `fill`: Legend titles (uppercased).
#'   }
#' @return A ggplot2 labels object.
#' @export
#' @importFrom purrr map
#' @seealso [ggplot2::labs()], [bfh_title_block()]
#' @family BFH helpers
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

  # Modernized with purrr::map() for functional iteration
  args <- purrr::map(names(args), function(name) {
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

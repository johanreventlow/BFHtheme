#' BFH ggplot2 Theme
#'
#' @description
#' A complete theme following Bispebjerg og Frederiksberg Hospital visual identity.
#' This is the main theme for creating professional, consistent plots.
#'
#' @param base_size Base font size in points. Default is 12.
#' @param base_family Base font family. Default is "sans".
#' @param base_line_size Base line size. Default is base_size/22.
#' @param base_rect_size Base rectangle size. Default is base_size/22.
#' @return A ggplot2 theme object
#' @export
#'
#' @importFrom ggplot2 theme theme_minimal element_text element_rect element_line element_blank margin rel unit
#' @importFrom marquee element_marquee
#' @importFrom grid unit
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#' }
theme_bfh <- function(base_size = 12,
                      base_family = NULL,
                      base_line_size = base_size / 22,
                      base_rect_size = base_size / 22) {

  # Auto-detect best font if not specified
  if (is.null(base_family)) {
    base_family <- get_bfh_font(check_installed = TRUE, silent = TRUE)
  }

  # Start with theme_minimal as base
  ggplot2::theme_minimal(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  ) +
  ggplot2::theme(
    # Plot
    plot.title = marquee::element_marquee(
      size = base_size * 1.3,
      hjust = 0,
      margin = ggplot2::margin(b = base_size * 0.5)
    ),
    plot.subtitle = marquee::element_marquee(
      size = base_size * 1.1,
      hjust = 0,
      margin = ggplot2::margin(b = base_size * 0.5)
    ),
    plot.caption = marquee::element_marquee(
      size = base_size * 0.8,
      color = "grey50",
      hjust = 1,
      margin = ggplot2::margin(t = base_size * 0.5)
    ),

    plot.title.position = "plot", #NEW parameter. Apply for subtitle too.
    plot.caption.position =  "plot", #NEW parameter


    plot.background = ggplot2::element_rect(fill = "white", color = NA),
    plot.margin = ggplot2::margin(base_size, base_size, base_size, base_size),

    # Panel
    # panel.grid.major = ggplot2::element_line(color = "grey90", linewidth = 0.5),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.border = ggplot2::element_blank(),

    # Axes
    axis.title = ggplot2::element_text(size = base_size, face = "plain"),
    axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = base_size * 0.5), face = "plain", hjust = 0, color = "grey30"),
    axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = base_size * 0.5), face = "plain", hjust = 1, color = "grey30"),

    axis.text = ggplot2::element_text(size = base_size * 0.9, color = "grey30", face = "plain"),
    axis.text.y = ggplot2::element_text(size = base_size * 0.9, color = "grey30", face = "plain"),
    axis.ticks.y.left = ggplot2::element_line(color = "grey70", linewidth = 0.5),
    axis.ticks.length.y.left = grid::unit(-.15, "cm"),
    axis.ticks.x = ggplot2::element_blank(),
    axis.line = ggplot2::element_line(color = "grey70", linewidth = 0.5),

    # Legend
    legend.position = "bottom",
    legend.title = ggplot2::element_text(size = base_size * 0.9, face = "plain"),
    legend.text = ggplot2::element_text(size = base_size * 0.9),
    legend.background = ggplot2::element_rect(fill = "white", color = NA),
    legend.key = ggplot2::element_rect(fill = "white", color = NA),
    legend.margin = ggplot2::margin(t = base_size * 0.5),

    # Strip (for facets)
    strip.text = ggplot2::element_text(
      size = base_size,
      face = "bold",
      margin = ggplot2::margin(b = base_size * 0.3)
    ),
    strip.background = ggplot2::element_rect(fill = "grey95", color = NA)
  )
}

#' BFH Minimal Theme
#'
#' @description
#' A minimal version of theme_bfh with reduced visual elements.
#' Good for presentations or when you want a cleaner look.
#'
#' @inheritParams theme_bfh
#' @return A ggplot2 theme object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh_minimal()
#' }
theme_bfh_minimal <- function(base_size = 12,
                              base_family = NULL,
                              base_line_size = base_size / 22,
                              base_rect_size = base_size / 22) {

  if (is.null(base_family)) {
    base_family <- get_bfh_font(check_installed = TRUE, silent = TRUE)
  }

  theme_bfh(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  ) +
  ggplot2::theme(
    panel.grid.major = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank()
  )
}

#' BFH Print Theme
#'
#' @description
#' Theme optimized for print output with higher contrast and
#' more prominent elements.
#'
#' @inheritParams theme_bfh
#' @return A ggplot2 theme object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh_print()
#' }
theme_bfh_print <- function(base_size = 14,
                            base_family = NULL,
                            base_line_size = base_size / 22,
                            base_rect_size = base_size / 22) {

  if (is.null(base_family)) {
    base_family <- get_bfh_font(check_installed = TRUE, silent = TRUE)
  }

  theme_bfh(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  ) +
  ggplot2::theme(
    # Darker text for better print contrast
    text = ggplot2::element_text(color = "black"),
    axis.text = ggplot2::element_text(color = "black"),

    # Thicker lines for print
    panel.grid.major = ggplot2::element_line(color = "grey80", linewidth = 0.7),
    axis.line = ggplot2::element_line(color = "black", linewidth = 0.7),
    axis.ticks = ggplot2::element_line(color = "black", linewidth = 0.5),

    # More prominent title
    plot.title = ggplot2::element_text(
      size = base_size * 1.4,
      face = "bold"
    )
  )
}

#' BFH Presentation Theme
#'
#' @description
#' Theme optimized for presentations with larger text and
#' higher contrast elements for visibility.
#'
#' @inheritParams theme_bfh
#' @return A ggplot2 theme object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh_presentation()
#' }
theme_bfh_presentation <- function(base_size = 16,
                                   base_family = NULL,
                                   base_line_size = base_size / 22,
                                   base_rect_size = base_size / 22) {

  if (is.null(base_family)) {
    base_family <- get_bfh_font(check_installed = TRUE, silent = TRUE)
  }

  theme_bfh(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  ) +
  ggplot2::theme(
    # Larger text for visibility
    plot.title = ggplot2::element_text(
      size = base_size * 1.5,
      face = "bold"
    ),
    plot.subtitle = ggplot2::element_text(
      size = base_size * 1.2
    ),

    # Thicker grid for visibility
    panel.grid.major = ggplot2::element_line(color = "grey85", linewidth = 0.8),

    # Larger legend
    legend.text = ggplot2::element_text(size = base_size),
    legend.title = ggplot2::element_text(size = base_size * 1.1, face = "plain")
  )
}

#' BFH Dark Theme
#'
#' @description
#' A dark version of the BFH theme for presentations or
#' when a dark background is preferred.
#'
#' @inheritParams theme_bfh
#' @return A ggplot2 theme object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point(color = "white") +
#'   theme_bfh_dark()
#' }
theme_bfh_dark <- function(base_size = 12,
                           base_family = NULL,
                           base_line_size = base_size / 22,
                           base_rect_size = base_size / 22) {

  if (is.null(base_family)) {
    base_family <- get_bfh_font(check_installed = TRUE, silent = TRUE)
  }

  theme_bfh(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  ) +
  ggplot2::theme(
    # Dark backgrounds
    plot.background = ggplot2::element_rect(fill = "#1a1a1a", color = NA),
    panel.background = ggplot2::element_rect(fill = "#1a1a1a", color = NA),
    legend.background = ggplot2::element_rect(fill = "#1a1a1a", color = NA),

    # Light text
    text = ggplot2::element_text(color = "white"),
    plot.title = ggplot2::element_text(color = "white", face = "bold"),
    plot.subtitle = ggplot2::element_text(color = "grey90"),
    plot.caption = ggplot2::element_text(color = "grey70"),
    axis.text = ggplot2::element_text(color = "grey80"),
    axis.title = ggplot2::element_text(color = "white", face = "bold"),
    legend.text = ggplot2::element_text(color = "white"),
    legend.title = ggplot2::element_text(color = "white", face = "bold"),
    strip.text = ggplot2::element_text(color = "white", face = "bold"),

    # Adjusted grid and axes
    panel.grid.major = ggplot2::element_line(color = "grey30", linewidth = 0.5),
    axis.line = ggplot2::element_line(color = "grey50", linewidth = 0.5),
    axis.ticks = ggplot2::element_line(color = "grey50", linewidth = 0.5),
    strip.background = ggplot2::element_rect(fill = "grey20", color = NA)
  )
}

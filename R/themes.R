# Internal helper: Resolve base_family with font auto-detection
# Bruges af alle theme funktioner for at undgå code duplication
.resolve_base_family <- function(base_family) {
  base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)
}

#' BFH ggplot2 Theme
#'
#' @description
#' Primary ggplot2 theme aligned with Bispebjerg og Frederiksberg Hospital's
#' visual identity guidelines. Applies typography, spacing, and layout defaults
#' that mirror official templates.
#'
#' @details
#' The theme builds on `ggplot2::theme_minimal()` and augments it with
#' BFH-specific typography via `marquee::element_marquee`, custom axis styling,
#' and legend placement. When `base_family = NULL` (the default) the best
#' available BFH font is detected automatically using [get_bfh_font()]. Use
#' the `base_*` arguments to fine-tune typography while preserving the brand
#' aesthetic.
#'
#' @param base_size Base font size in points. Default is 12.
#' @param base_family Base font family. Set to `NULL` (default) to auto-detect a
#'   BFH approved font via [get_bfh_font()].
#' @param base_line_size Base line size. Default is `base_size / 22`.
#' @param base_rect_size Base rectangle size. Default is `base_size / 22`.
#' @return A [ggplot2::theme] object that can be added to ggplot graphs.
#' @family BFH themes
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
  base_family <- .resolve_base_family(base_family)

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

    # Panel - grid lines removed for cleaner appearance
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.border = ggplot2::element_blank(),

    # Axes
    axis.title = ggplot2::element_text(size = base_size, face = "plain"),
    axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = base_size * 0.5), face = "plain", hjust = 0, color = "grey30"),
    axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = base_size * 0.5), face = "plain", hjust = 1, color = "grey30"),

    axis.text = ggplot2::element_text(size = base_size * 0.9, color = "grey30", face = "plain"),
    axis.text.y = ggplot2::element_text(size = base_size * 0.9, color = "grey30", face = "plain", hjust = 0),
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


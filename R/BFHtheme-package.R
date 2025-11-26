#' BFHtheme: BFH Theme and Color Palettes for ggplot2
#'
#' @description
#' The BFHtheme package provides a comprehensive theming solution for creating
#' ggplot2 graphics that follow the visual identity guidelines of
#' Bispebjerg og Frederiksberg Hospital (BFH) and Region Hovedstaden.
#'
#' @section Main Features:
#' \describe{
#'   \item{Color Palettes}{Multiple predefined color palettes for both Hospital and Region H branding}
#'   \item{Themes}{Various theme functions optimized for different outputs}
#'   \item{Scale Functions}{Easy-to-use color and fill scales for ggplot2}
#'   \item{Helper Functions}{Utilities for saving plots and managing defaults}
#'   \item{Branding Tools}{Functions for adding logos, watermarks, and footers}
#' }
#'
#' @section Getting Started:
#' The easiest way to start using BFHtheme is with the `set_bfh_defaults()` function:
#' \preformatted{
#' library(BFHtheme)
#' library(ggplot2)
#'
#' # Set BFH defaults for all plots
#' set_bfh_defaults()
#'
#' # Now all plots will use BFH theme and colors
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point()
#' }
#'
#' @section Key Functions:
#' \describe{
#'   \item{Themes}{`theme_bfh()`, `theme_region_h()` (customize via `theme()` calls)}
#'   \item{Colors}{`bfh_colors`, `bfh_cols()`, `bfh_palettes`, `bfh_pal()`}
#'   \item{Scales}{`scale_color_bfh()`, `scale_fill_bfh()`}
#'   \item{Helpers}{`bfh_save()`, `set_bfh_defaults()`, `add_bfh_logo()`}
#' }
#'
#' @section Color Palettes:
#' The package includes two sets of official colors:
#' \describe{
#'   \item{Hospital Colors}{For Bispebjerg og Frederiksberg Hospital branding}
#'   \item{Region H Colors}{For Region Hovedstaden koncern branding}
#' }
#'
#' Access colors using:
#' \preformatted{
#' # Hospital colors
#' bfh_cols("hospital_primary", "hospital_blue")
#'
#' # Region Hovedstaden colors
#' bfh_cols("regionh_primary", "regionh_blue")
#' }
#'
#' @docType package
#' @name BFHtheme-package
#' @aliases BFHtheme
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

# Package-level state to track what was configured
.bfh_state <- new.env(parent = emptyenv())

# Configure graphics and fonts at package load
.onLoad <- function(libname, pkgname) {
  # Track what we configure for .onAttach message
  .bfh_state$ragg_configured <- FALSE
  .bfh_state$fonts_registered <- FALSE


  # Set knitr defaults to use ragg for high-quality font rendering

  # This applies to both Windows and Mac for consistent quality
  if (requireNamespace("knitr", quietly = TRUE) &&
      requireNamespace("ragg", quietly = TRUE)) {
    tryCatch({
      knitr::opts_chunk$set(dev = "ragg_png", dpi = 300)
      .bfh_state$ragg_configured <- TRUE
    }, error = function(e) NULL)
  }

  # Windows-specific: Register fonts with grDevices::windowsFonts
  # This is a fallback for when ragg is not used (e.g., base R plots)
  if (.Platform$OS.type == "windows") {
    fonts_to_register <- c("Mari", "Mari Office", "Roboto", "Arial")

    if (requireNamespace("systemfonts", quietly = TRUE)) {
      for (font_name in fonts_to_register) {
        match_result <- tryCatch({
          systemfonts::match_fonts(font_name)
        }, error = function(e) NULL)

        if (!is.null(match_result) &&
            !is.null(match_result$path) &&
            !is.na(match_result$path) &&
            nzchar(match_result$path)) {
          tryCatch({
            font_list <- stats::setNames(
              list(grDevices::windowsFont(font_name)),
              font_name
            )
            do.call(grDevices::windowsFonts, font_list)
            .bfh_state$fonts_registered <- TRUE
          }, error = function(e) NULL)
        }
      }
    }
  }

  invisible()
}

# Package startup message
.onAttach <- function(libname, pkgname) {
  # Build informative startup message

  msg_parts <- "BFHtheme loaded!"

  # Check what was configured
  config_info <- character(0)

  if (isTRUE(.bfh_state$ragg_configured)) {
    config_info <- c(config_info, "knitr: ragg_png (dpi=300)")
  }

  if (isTRUE(.bfh_state$fonts_registered)) {
    config_info <- c(config_info, "Windows fonts registered")
  }

  if (length(config_info) > 0) {
    msg_parts <- paste0(msg_parts, " [", paste(config_info, collapse = ", "), "]")
  }

  # Check font availability
  has_mari <- FALSE
  if (requireNamespace("systemfonts", quietly = TRUE)) {
    mari_result <- tryCatch({
      systemfonts::match_fonts("Mari")
    }, error = function(e) NULL)

    has_mari <- !is.null(mari_result) &&
                !is.null(mari_result$path) &&
                !is.na(mari_result$path) &&
                nzchar(mari_result$path)
  }

  # Add font warning if needed
  if (!has_mari) {
    msg_parts <- paste0(
      msg_parts, "\n",
      "Note: Mari font not detected. Using fallback font.\n",
      "  - Install Roboto: https://fonts.google.com/specimen/Roboto"
    )
  }

  # Suggest ragg installation if not available
  if (!requireNamespace("ragg", quietly = TRUE)) {
    msg_parts <- paste0(
      msg_parts, "\n",
      "Tip: Install 'ragg' for better font rendering: install.packages('ragg')"
    )
  }

  packageStartupMessage(msg_parts)
}

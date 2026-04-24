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
#'   \item{Themes}{`theme_bfh()` (customize via `theme()` calls)}
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

# Package-level state environments
.bfh_state <- new.env(parent = emptyenv())
.bfh_logo_cache <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  .bfh_state$fonts_registered <- FALSE

  if (.Platform$OS.type == "windows") {
    fonts_to_register <- c("Mari", "Mari Office", "Roboto", "Arial")

    for (font_name in fonts_to_register) {
      if (font_available(font_name)) {
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

  invisible()
}

.onAttach <- function(libname, pkgname) {
  msg_parts <- "BFHtheme loaded!"

  if (isTRUE(.bfh_state$fonts_registered)) {
    msg_parts <- paste0(msg_parts, " [Windows fonts registered]")
  }

  if (!font_available("Mari")) {
    msg_parts <- paste0(
      msg_parts, "\n",
      "Note: Mari font not detected. Using fallback font.\n",
      "  - Install Roboto: https://fonts.google.com/specimen/Roboto"
    )
  }

  if (!requireNamespace("ragg", quietly = TRUE)) {
    msg_parts <- paste0(
      msg_parts, "\n",
      "Tip: Install 'ragg' for better font rendering: install.packages('ragg')\n",
      "     Then call use_bfh_knitr_defaults() to enable ragg in knitr."
    )
  }

  packageStartupMessage(msg_parts)
}

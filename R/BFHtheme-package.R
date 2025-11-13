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

# Package startup message
.onAttach <- function(libname, pkgname) {
  # Check font availability using modern systemfonts
  has_mari <- FALSE

  if (requireNamespace("systemfonts", quietly = TRUE)) {
    # Check for Mari fonts using match_fonts (modern API)
    mari_result <- tryCatch({
      systemfonts::match_fonts("Mari")
    }, error = function(e) NULL)

    has_mari <- !is.null(mari_result) &&
                !is.null(mari_result$path) &&
                !is.na(mari_result$path) &&
                nzchar(mari_result$path)
  }

  # Show helpful message if Mari not found
  if (!has_mari) {
    packageStartupMessage(
      "BFHtheme loaded!\n",
      "Note: Mari font not detected. For best font rendering:\n",
      "  - Install Roboto (https://fonts.google.com/specimen/Roboto)\n",
      "  - Or use: use_bfh_showtext() to load fonts via showtext\n",
      "  - See: ?set_bfh_graphics for device recommendations"
    )
  } else {
    packageStartupMessage("BFHtheme loaded!")
  }
}

#' Enable BFH knitr Defaults (Opt-in)
#'
#' @description
#' Sets knitr chunk options to use ragg-based rendering at 300 DPI — the
#' recommended output device for BFH-styled graphics in R Markdown and Quarto
#' documents.
#'
#' @details
#' **This function must be called explicitly.** `library(BFHtheme)` does NOT
#' modify knitr options automatically. This is intentional: modifying global
#' session state on package load would silently override any knitr configuration
#' the user has already set.
#'
#' Call `use_bfh_knitr_defaults()` once in your setup chunk:
#' \preformatted{
#' library(BFHtheme)
#' use_bfh_knitr_defaults()
#' }
#'
#' Requires the `ragg` package. Install with `install.packages("ragg")`.
#'
#' @param dpi Output resolution in dots per inch. Defaults to `300`.
#' @return Invisibly returns `NULL`. Called for its side effect of setting
#'   knitr chunk options.
#' @export
#' @seealso [set_bfh_defaults()]
#' @family BFH defaults
#' @examples
#' \dontrun{
#' library(BFHtheme)
#' use_bfh_knitr_defaults()
#' # knitr::opts_chunk$get("dev") is now "ragg_png"
#' }
use_bfh_knitr_defaults <- function(dpi = 300) {
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop(
      "Package 'knitr' is required. Install with: install.packages('knitr')",
      call. = FALSE
    )
  }
  if (!requireNamespace("ragg", quietly = TRUE)) {
    stop(
      "Package 'ragg' is required for ragg_png rendering. ",
      "Install with: install.packages('ragg')",
      call. = FALSE
    )
  }

  knitr::opts_chunk$set(dev = "ragg_png", dpi = dpi)
  invisible(NULL)
}

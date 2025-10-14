#' NULL coalescing operator
#'
#' @description
#' Returns the left-hand side if it's not NULL, otherwise returns the right-hand side.
#' This is similar to the \code{\%||\%} operator in rlang and purrr.
#'
#' @param x First value
#' @param y Second value to use if x is NULL
#' @return x if not NULL, otherwise y
#' @keywords internal
#' @examples
#' \dontrun{
#' NULL %||% "default"      # "default"
#' "value" %||% "default"   # "value"
#' }
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

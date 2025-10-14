#' Input validation helpers for BFH functions
#'
#' @description
#' Internal utility functions for validating common argument types across
#' the BFHtheme package. These helpers ensure consistent error messages
#' and reduce code duplication.
#'
#' @name validation_helpers
#' @keywords internal
NULL

#' Validate palette argument
#'
#' @description
#' Ensures that a palette argument is a single, non-empty character string.
#'
#' @param palette Character string to validate
#' @return The validated palette string (unchanged if valid)
#' @keywords internal
#' @examples
#' \dontrun{
#' validate_palette_argument("main")      # Returns "main"
#' validate_palette_argument("")          # Error
#' validate_palette_argument(c("a", "b")) # Error
#' }
validate_palette_argument <- function(palette) {
  if (!is.character(palette) || length(palette) != 1 || is.na(palette) || !nzchar(palette)) {
    stop("palette must be a single character string", call. = FALSE)
  }
  palette
}

#' Validate logical argument
#'
#' @description
#' Ensures that a logical argument is a single, non-NA logical value.
#'
#' @param value Logical value to validate
#' @param name Character string naming the argument (for error messages)
#' @return The validated logical value (unchanged if valid)
#' @keywords internal
#' @examples
#' \dontrun{
#' validate_logical_argument(TRUE, "reverse")   # Returns TRUE
#' validate_logical_argument(NA, "reverse")     # Error
#' validate_logical_argument(c(T, F), "reverse") # Error
#' }
validate_logical_argument <- function(value, name) {
  if (!is.logical(value) || length(value) != 1 || is.na(value)) {
    stop(sprintf("%s must be a single logical value (TRUE or FALSE)", name), call. = FALSE)
  }
  value
}

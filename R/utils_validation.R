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

#' Validate numeric range
#'
#' @description
#' Ensures that a numeric argument falls within a specified range.
#'
#' @param value Numeric value to validate
#' @param name Character string naming the argument (for error messages)
#' @param min Minimum allowed value (inclusive)
#' @param max Maximum allowed value (inclusive)
#' @param allow_null Logical; allow NULL values? Defaults to FALSE
#' @return The validated numeric value (unchanged if valid)
#' @keywords internal
#' @examples
#' \dontrun{
#' validate_numeric_range(0.5, "size", 0, 1)     # Returns 0.5
#' validate_numeric_range(1.5, "size", 0, 1)     # Error: out of range
#' validate_numeric_range(NULL, "size", 0, 1)    # Error: NULL not allowed
#' validate_numeric_range(NULL, "size", 0, 1, allow_null = TRUE) # Returns NULL
#' }
validate_numeric_range <- function(value, name, min, max, allow_null = FALSE) {
  if (is.null(value)) {
    if (allow_null) {
      return(NULL)
    }
    stop(sprintf("%s cannot be NULL", name), call. = FALSE)
  }

  if (!is.numeric(value) || length(value) != 1 || is.na(value)) {
    stop(sprintf("%s must be a single numeric value", name), call. = FALSE)
  }

  if (value < min || value > max) {
    stop(sprintf("%s must be between %g and %g (inclusive)", name, min, max), call. = FALSE)
  }

  value
}

#' Validate choice from allowed options
#'
#' @description
#' Ensures that a value is one of the allowed choices.
#'
#' @param value Value to validate
#' @param name Character string naming the argument (for error messages)
#' @param choices Character vector of allowed values
#' @param allow_null Logical; allow NULL values? Defaults to FALSE
#' @return The validated value (unchanged if valid)
#' @keywords internal
#' @examples
#' \dontrun{
#' validate_choice("topright", "position", c("topleft", "topright", "bottomleft", "bottomright"))
#' validate_choice("invalid", "position", c("topleft", "topright"))  # Error
#' }
validate_choice <- function(value, name, choices, allow_null = FALSE) {
  if (is.null(value)) {
    if (allow_null) {
      return(NULL)
    }
    stop(sprintf("%s cannot be NULL", name), call. = FALSE)
  }

  if (!is.character(value) || length(value) != 1 || is.na(value)) {
    stop(sprintf("%s must be a single character value", name), call. = FALSE)
  }

  if (!(value %in% choices)) {
    stop(sprintf("%s must be one of: %s", name, paste(dQuote(choices), collapse = ", ")), call. = FALSE)
  }

  value
}

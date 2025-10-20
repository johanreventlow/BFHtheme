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
#' Ensures that a numeric argument is within a specified range.
#'
#' @param value Numeric value to validate
#' @param name Character string naming the argument (for error messages)
#' @param min Minimum allowed value (inclusive by default)
#' @param max Maximum allowed value (inclusive by default)
#' @param allow_null Logical. If TRUE, NULL values are allowed (default: FALSE)
#' @param exclusive_min Logical. If TRUE, minimum is exclusive (default: FALSE)
#' @param exclusive_max Logical. If TRUE, maximum is exclusive (default: FALSE)
#' @return The validated numeric value (unchanged if valid), or NULL if allow_null = TRUE
#' @keywords internal
#' @examples
#' \dontrun{
#' validate_numeric_range(0.5, "size", 0, 1)           # Returns 0.5
#' validate_numeric_range(1.5, "alpha", 0, 1)          # Error
#' validate_numeric_range(NULL, "size", 0, 1, allow_null = TRUE)  # Returns NULL
#' validate_numeric_range(0, "size", 0, 1, exclusive_min = TRUE)  # Error
#' }
validate_numeric_range <- function(value, name, min, max,
                                   allow_null = FALSE,
                                   exclusive_min = FALSE,
                                   exclusive_max = FALSE) {
  # Handle NULL
  if (is.null(value)) {
    if (allow_null) {
      return(NULL)
    }
    stop(sprintf("%s must be numeric", name), call. = FALSE)
  }

  # Type validation
  if (!is.numeric(value) || length(value) != 1 || is.na(value)) {
    if (!is.numeric(value)) {
      stop(sprintf("%s must be numeric", name), call. = FALSE)
    }
    if (length(value) != 1) {
      stop(sprintf("%s must be a single numeric value", name), call. = FALSE)
    }
    stop(sprintf("%s must be numeric", name), call. = FALSE)
  }

  # Range validation
  if (exclusive_min && value <= min) {
    stop(sprintf("%s must be greater than %s", name, min), call. = FALSE)
  }
  if (!exclusive_min && value < min) {
    stop(sprintf("%s must be between %s and %s", name, min, max), call. = FALSE)
  }

  if (exclusive_max && value >= max) {
    stop(sprintf("%s must be less than %s", name, max), call. = FALSE)
  }
  if (!exclusive_max && value > max) {
    stop(sprintf("%s must be between %s and %s", name, min, max), call. = FALSE)
  }

  value
}

#' Validate choice from allowed options
#'
#' @description
#' Ensures that a value is one of a predefined set of choices.
#'
#' @param value Value to validate (typically character string)
#' @param name Character string naming the argument (for error messages)
#' @param choices Character vector of allowed choices
#' @param allow_null Logical. If TRUE, NULL values are allowed (default: FALSE)
#' @return The validated value (unchanged if valid), or NULL if allow_null = TRUE
#' @keywords internal
#' @examples
#' \dontrun{
#' validate_choice("topleft", "position", c("topleft", "topright"))  # Returns "topleft"
#' validate_choice("middle", "position", c("top", "bottom"))         # Error
#' validate_choice(NULL, "position", c("top", "bottom"), allow_null = TRUE)  # Returns NULL
#' }
validate_choice <- function(value, name, choices, allow_null = FALSE) {
  # Handle NULL
  if (is.null(value)) {
    if (allow_null) {
      return(NULL)
    }
    stop(sprintf("%s must be one of: %s", name, paste(choices, collapse = ", ")),
         call. = FALSE)
  }

  # Type validation
  if (!is.character(value)) {
    stop(sprintf("%s must be a character string", name), call. = FALSE)
  }

  # Length validation
  if (length(value) != 1) {
    stop(sprintf("%s must be a single value", name), call. = FALSE)
  }

  # Choice validation
  if (!value %in% choices) {
    stop(sprintf("%s must be one of: %s", name, paste(choices, collapse = ", ")),
         call. = FALSE)
  }

  value
}

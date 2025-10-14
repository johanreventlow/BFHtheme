# Package-level font cache environment
.bfh_font_cache <- new.env(parent = emptyenv())

#' Get BFH font family
#'
#' @description
#' Returns the best available font for BFH plots with automatic fallback.
#' Results are cached for the session to improve performance.
#' Priority order: Mari/Mari Office → Roboto → Arial → sans
#'
#' @param check_installed Logical. If TRUE, checks if fonts are actually installed.
#'   Default is TRUE.
#' @param silent Logical. If TRUE, suppresses informational messages.
#'   Default is FALSE.
#' @param force_refresh Logical. If TRUE, bypasses cache and re-checks fonts.
#'   Default is FALSE.
#' @return Character string with font family name
#' @export
#'
#' @importFrom ggplot2 theme_update element_text
#' @examples
#' # Get best available font (cached after first call)
#' font <- get_bfh_font()
#'
#' # Use in theme
#' theme_bfh(base_family = get_bfh_font())
#'
#' # Force refresh cache if fonts change
#' font <- get_bfh_font(force_refresh = TRUE)
get_bfh_font <- function(check_installed = TRUE, silent = FALSE, force_refresh = FALSE) {

  # Font priority list
  fonts <- c(
    "Mari",         # Primary BFH font (installed on employee PCs)
    # "Mari Office",         # Alternative name
    "Roboto",       # Open source fallback
    "Arial",        # Universal fallback
    "sans"          # System fallback
  )

  if (!check_installed) {
    return(fonts[1])
  }

  # Check cache first
  cache_key <- "selected_font"
  if (!force_refresh && exists(cache_key, envir = .bfh_font_cache, inherits = FALSE)) {
    cached_font <- get(cache_key, envir = .bfh_font_cache, inherits = FALSE)
    if (!silent) message("Using cached font: ", cached_font)
    return(cached_font)
  }

  # Check which fonts are available (vectorized for performance)
  selected_font <- NULL

  if (requireNamespace("systemfonts", quietly = TRUE)) {
    # Use systemfonts package for robust checking
    available_fonts <- systemfonts::system_fonts()$family

    # Vectorized matching - much faster than loops
    matched_idx <- match(fonts, available_fonts, nomatch = 0L)
    first_match <- which(matched_idx > 0)[1]

    if (!is.na(first_match)) {
      selected_font <- fonts[first_match]
      if (!silent) message("Using font: ", selected_font)
    }
  } else if (requireNamespace("extrafont", quietly = TRUE)) {
    # Fallback: try with extrafont if available
    available_fonts <- extrafont::fonts()

    # Vectorized matching
    matched_idx <- match(fonts, available_fonts, nomatch = 0L)
    first_match <- which(matched_idx > 0)[1]

    if (!is.na(first_match)) {
      selected_font <- fonts[first_match]
      if (!silent) message("Using font: ", selected_font)
    }
  }

  # If no font checking available or no fonts found, use sans
  if (is.null(selected_font)) {
    selected_font <- "sans"
    if (!silent) message("Using fallback font: sans")
  }

  # Cache the result for subsequent calls
  assign(cache_key, selected_font, envir = .bfh_font_cache)

  return(selected_font)
}

#' Clear font cache
#'
#' @description
#' Clears the cached font selection. Useful if fonts are installed or uninstalled
#' during the R session, or if you want to force re-detection.
#'
#' @return Invisibly returns TRUE
#' @export
#' @examples
#' # Clear font cache after installing new fonts
#' clear_bfh_font_cache()
#'
#' # Font will be re-detected on next call
#' font <- get_bfh_font()
clear_bfh_font_cache <- function() {
  rm(list = ls(envir = .bfh_font_cache), envir = .bfh_font_cache)
  message("BFH font cache cleared")
  invisible(TRUE)
}

#' Check if BFH fonts are installed
#'
#' @description
#' Checks system for BFH preferred fonts and reports availability.
#'
#' @return Invisibly returns a named logical vector of font availability
#' @export
#' @examples
#' \dontrun{
#' check_bfh_fonts()
#' }
check_bfh_fonts <- function() {
  fonts_to_check <- c(
    "Mari Office" = "Mari Office",
    "Mari" = "Mari",
    "Roboto" = "Roboto",
    "Arial" = "Arial"
  )

  results <- logical(length(fonts_to_check))
  names(results) <- names(fonts_to_check)

  cat("\n=== BFH Font Availability ===\n\n")

  if (requireNamespace("systemfonts", quietly = TRUE)) {
    available_fonts <- systemfonts::system_fonts()$family

    # Vectorized matching - much faster than loops
    results_vec <- fonts_to_check %in% available_fonts
    names(results_vec) <- names(fonts_to_check)
    results <- results_vec

    # Display results
    statuses <- ifelse(results, "\u2713 Available", "\u2717 Not found")
    output <- sprintf("%-15s: %s", names(fonts_to_check), statuses)
    cat(paste(output, collapse = "\n"), "\n")

  } else if (requireNamespace("extrafont", quietly = TRUE)) {
    available_fonts <- extrafont::fonts()

    # Vectorized matching
    results_vec <- fonts_to_check %in% available_fonts
    names(results_vec) <- names(fonts_to_check)
    results <- results_vec

    # Display results
    statuses <- ifelse(results, "\u2713 Available", "\u2717 Not found")
    output <- sprintf("%-15s: %s", names(fonts_to_check), statuses)
    cat(paste(output, collapse = "\n"), "\n")

  } else {
    cat("Install 'systemfonts' or 'extrafont' package to check fonts:\n")
    cat("  install.packages('systemfonts')\n\n")
    results[] <- NA
  }

  cat("\nRecommended font: ", get_bfh_font(silent = TRUE), "\n\n")

  if (!any(results[1:2], na.rm = TRUE)) {
    cat("NOTE: Mari fonts not found. These are installed on BFH employee computers.\n")
    cat("For external users, Roboto is recommended.\n\n")
  }

  invisible(results)
}

#' Install Roboto font (helper)
#'
#' @description
#' Provides instructions for installing Roboto font on different systems.
#' Roboto is an open-source font by Google, free to use and distribute.
#'
#' @export
#' @examples
#' \dontrun{
#' install_roboto_font()
#' }
install_roboto_font <- function() {
  cat("\n=== Installing Roboto Font ===\n\n")
  cat("Roboto is a free, open-source font by Google.\n")
  cat("License: Apache License 2.0\n\n")

  cat("Installation options:\n\n")

  cat("1. AUTOMATIC (recommended):\n")
  cat("   # Install showtext package\n")
  cat("   install.packages('showtext')\n")
  cat("   library(showtext)\n")
  cat("   font_add_google('Roboto', 'Roboto')\n")
  cat("   showtext_auto()\n\n")

  cat("2. MANUAL DOWNLOAD:\n")
  cat("   Download from: https://fonts.google.com/specimen/Roboto\n\n")

  cat("3. SYSTEM INSTALLATION:\n")
  if (Sys.info()["sysname"] == "Darwin") {
    cat("   macOS: Download .ttf files and double-click to install\n")
    cat("          Or use: brew install --cask font-roboto\n\n")
  } else if (Sys.info()["sysname"] == "Windows") {
    cat("   Windows: Download .ttf files, right-click and 'Install'\n\n")
  } else {
    cat("   Linux: sudo apt-get install fonts-roboto (Ubuntu/Debian)\n")
    cat("          Or download from Google Fonts\n\n")
  }

  cat("After installation:\n")
  cat("   - Restart R session\n")
  cat("   - Run: check_bfh_fonts()\n\n")
}

#' Setup fonts for BFH theme
#'
#' @description
#' Helper function to setup fonts for BFH theme. Handles both system fonts
#' and showtext/sysfonts for better cross-platform compatibility.
#'
#' @param use_showtext Logical. If TRUE, attempts to use showtext package
#'   for better font rendering. Default is FALSE.
#' @return Character string with font family to use
#' @export
#' @examples
#' \dontrun{
#' # Setup fonts
#' font <- setup_bfh_fonts()
#'
#' # Use in plot
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh(base_family = font)
#' }
setup_bfh_fonts <- function(use_showtext = FALSE) {

  if (use_showtext && requireNamespace("showtext", quietly = TRUE)) {
    # Try to add Roboto from Google Fonts
    tryCatch({
      showtext::font_add_google("Roboto", "Roboto")
      showtext::showtext_auto()
      message("Loaded Roboto font via Google Fonts (showtext)")
      return("Roboto")
    }, error = function(e) {
      message("Could not load Roboto from Google Fonts: ", e$message)
    })
  }

  # Fall back to system font detection
  font <- get_bfh_font(check_installed = TRUE, silent = FALSE)
  return(font)
}

#' Update theme defaults to use BFH fonts
#'
#' @description
#' Sets BFH fonts as default for all themes. This is a convenience wrapper
#' that combines font setup with theme defaults.
#'
#' @param use_showtext Logical. Use showtext for font rendering. Default FALSE.
#' @return Invisibly returns the font family being used
#' @export
#' @examples
#' \dontrun{
#' # Set BFH fonts as default
#' set_bfh_fonts()
#'
#' # Now all themes use BFH fonts automatically
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#' }
set_bfh_fonts <- function(use_showtext = FALSE) {
  font <- setup_bfh_fonts(use_showtext = use_showtext)

  # Update ggplot2 theme defaults
  ggplot2::theme_update(text = ggplot2::element_text(family = font))

  message("BFH fonts set as default: ", font)
  invisible(font)
}

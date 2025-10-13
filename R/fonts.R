#' Get BFH font family
#'
#' @description
#' Returns the best available font for BFH plots with automatic fallback.
#' Priority order: Mari/Mari Office → Roboto → Arial → sans
#'
#' @param check_installed Logical. If TRUE, checks if fonts are actually installed.
#'   Default is TRUE.
#' @param silent Logical. If TRUE, suppresses informational messages.
#'   Default is FALSE.
#' @return Character string with font family name
#' @export
#'
#' @importFrom ggplot2 theme_update element_text
#' @examples
#' # Get best available font
#' font <- get_bfh_font()
#'
#' # Use in theme
#' theme_bfh(base_family = get_bfh_font())
get_bfh_font <- function(check_installed = TRUE, silent = FALSE) {

  # Font priority list
  fonts <- c(
    "Mari",  # Primary BFH font (installed on employee PCs)
    # "Mari Office",         # Alternative name
    "Roboto",       # Open source fallback
    "Arial",        # Universal fallback
    "sans"          # System fallback
  )

  if (!check_installed) {
    return(fonts[1])
  }

  # Check which fonts are available
  if (requireNamespace("systemfonts", quietly = TRUE)) {
    # Use systemfonts package for robust checking
    available_fonts <- systemfonts::system_fonts()$family

    for (font in fonts) {
      if (font %in% available_fonts) {
        if (!silent) message("Using font: ", font)
        return(font)
      }
    }
  } else {
    # Fallback: try with extrafont if available
    if (requireNamespace("extrafont", quietly = TRUE)) {
      available_fonts <- extrafont::fonts()

      for (font in fonts) {
        if (font %in% available_fonts) {
          if (!silent) message("Using font: ", font)
          return(font)
        }
      }
    }
  }

  # If no font checking available or no fonts found, return sans
  if (!silent) message("Using fallback font: sans")
  return("sans")
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

    for (i in seq_along(fonts_to_check)) {
      font_name <- fonts_to_check[i]
      is_available <- font_name %in% available_fonts
      results[i] <- is_available

      status <- if (is_available) "\u2713 Available" else "\u2717 Not found"
      cat(sprintf("%-15s: %s\n", names(fonts_to_check)[i], status))
    }
  } else if (requireNamespace("extrafont", quietly = TRUE)) {
    available_fonts <- extrafont::fonts()

    for (i in seq_along(fonts_to_check)) {
      font_name <- fonts_to_check[i]
      is_available <- font_name %in% available_fonts
      results[i] <- is_available

      status <- if (is_available) "\u2713 Available" else "\u2717 Not found"
      cat(sprintf("%-15s: %s\n", names(fonts_to_check)[i], status))
    }
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

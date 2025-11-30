# Package-level font cache environment
.bfh_font_cache <- new.env(parent = emptyenv())

#' Determine BFH Font Family
#'
#' @description
#' Identifies the best available typeface for BFH-branded plots, caching the
#' result to avoid repeated system queries. The priority order is:
#' Mari → Mari Office → Roboto → Arial → sans.
#'
#' @details
#' When `systemfonts` package is installed, the function uses
#' `systemfonts::match_font()` to robustly check font availability on your system.
#'
#' Results are cached in the package environment; use [clear_bfh_font_cache()]
#' or set `force_refresh = TRUE` after installing new fonts.
#'
#' **Font availability notes:**
#' - **Mari fonts**: Only available on BFH employee computers (proprietary)
#' - **Roboto**: Free open-source font (install via OS or use `use_bfh_showtext()`)
#' - **Arial**: System font on most platforms
#' - **sans**: Universal fallback (system default)
#'
#' **For embedding fonts in outputs:** Use modern graphics devices like
#' `ragg::agg_png()`, `svglite::svglite()`, or `grDevices::cairo_pdf()`.
#' See `set_bfh_graphics()` for recommended device setup.
#'
#' @param check_installed Logical. If `TRUE` (default) verify fonts are installed.
#'   Set to `FALSE` to simply return the highest-priority font name.
#' @param silent Logical. Suppress informational messages when `TRUE`. Defaults to `FALSE`.
#' @param force_refresh Logical. When `TRUE`, bypass the cache and re-run the detection.
#'   Defaults to `FALSE`.
#' @return Character string containing the selected font family.
#' @export
#'
#' @importFrom ggplot2 theme_update element_text
#' @seealso [check_bfh_fonts()], [set_bfh_fonts()], [set_bfh_defaults()]
#' @family BFH fonts
#' @examples
#' # Get best available font (cached after first call)
#' font <- get_bfh_font()
#'
#' # Use in theme
#' theme_bfh(base_family = get_bfh_font())
#'
#' # Force refresh cache if fonts change
#' font <- get_bfh_font(force_refresh = TRUE)
#'
#' # For external users without Mari fonts:
#' # Install showtext for automatic Roboto loading
#' \dontrun{
#' install.packages("showtext")
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_bfh()
#' # Roboto will be auto-loaded via Google Fonts if not installed
#' }
get_bfh_font <- function(check_installed = TRUE, silent = FALSE, force_refresh = FALSE) {

  # Font priority list
  fonts <- c(
    "Mari",         # Primary BFH font (preferred when available)
    "Mari Office",  # Alternative/legacy name on some systems
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

  # Modern approach: Use systemfonts::match_font() for robust detection
  selected_font <- NULL

  if (requireNamespace("systemfonts", quietly = TRUE)) {
    # Try each font in priority order using match_fonts (modern API)
    for (font_name in fonts) {
      if (font_name == "sans") {
        # Always accept sans as final fallback
        selected_font <- "sans"
        break
      }

      match_result <- tryCatch({
        systemfonts::match_fonts(font_name)
      }, error = function(e) NULL)

      # Check if font was successfully matched (has valid path)
      if (!is.null(match_result) &&
          !is.null(match_result$path) &&
          !is.na(match_result$path) &&
          nzchar(match_result$path)) {
        selected_font <- font_name
        if (!silent) message("Using font: ", selected_font)
        break
      }
    }
  }

  # Final fallback to sans if nothing else worked
  if (is.null(selected_font)) {
    selected_font <- "sans"
    if (!silent) message("Using fallback font: sans")
  }

  # Cache the result for subsequent calls
  assign(cache_key, selected_font, envir = .bfh_font_cache)

  return(selected_font)
}

#' Clear Font Cache
#'
#' @description
#' Removes cached font detection results, ensuring that the next call to
#' [get_bfh_font()] triggers a fresh lookup.
#'
#' @return Invisibly returns `TRUE`.
#' @keywords internal
#' @seealso [get_bfh_font()]
#' @family BFH fonts
#' @examples
#' # Clear font cache after installing new fonts
#' BFHtheme:::clear_bfh_font_cache()
#'
#' # Font will be re-detected on next call
#' font <- get_bfh_font()
clear_bfh_font_cache <- function() {
  rm(list = ls(envir = .bfh_font_cache), envir = .bfh_font_cache)
  message("BFH font cache cleared")
  invisible(TRUE)
}

#' Check BFH Font Availability
#'
#' @description
#' Reports whether key BFH fonts (Mari, Roboto, Arial) are installed on the
#' system, using `systemfonts` or `extrafont` when available.
#'
#' @return Invisibly returns a named logical vector with font availability.
#' @keywords internal
#' @seealso [get_bfh_font()]
#' @family BFH fonts
#' @examples
#' \dontrun{
#' BFHtheme:::check_bfh_fonts()
#' }
check_bfh_fonts <- function() {
  fonts_to_check <- c(
    "Mari" = "Mari",
    "Mari Office" = "Mari Office",
    "Roboto" = "Roboto",
    "Arial" = "Arial"
  )

  results <- logical(length(fonts_to_check))
  names(results) <- names(fonts_to_check)

  cat("\n=== BFH Font Availability ===\n\n")

  if (requireNamespace("systemfonts", quietly = TRUE)) {
    # Use match_fonts() for robust detection (same as get_bfh_font())
    for (i in seq_along(fonts_to_check)) {
      font_name <- fonts_to_check[i]
      match_result <- tryCatch({
        systemfonts::match_fonts(font_name)
      }, error = function(e) NULL)

      # Check if font was successfully matched
      results[i] <- !is.null(match_result) &&
                    !is.null(match_result$path) &&
                    !is.na(match_result$path) &&
                    nzchar(match_result$path)
    }

    # Display results
    statuses <- ifelse(results, "\u2713 Available", "\u2717 Not found")
    output <- sprintf("%-15s: %s", names(fonts_to_check), statuses)
    cat(paste(output, collapse = "\n"), "\n")

  } else {
    cat("Install 'systemfonts' package to check fonts:\n")
    cat("  install.packages('systemfonts')\n\n")
    results[] <- NA
  }

  cat("\nRecommended font: ", get_bfh_font(silent = TRUE), "\n\n")

  if (!any(results[1:2], na.rm = TRUE)) {
    cat("NOTE: Mari fonts not found. These are installed on BFH employee computers.\n")
    cat("For external users, Roboto is recommended.\n")
    cat("See ?set_bfh_graphics for device recommendations.\n\n")
  }

  invisible(results)
}

#' Install Roboto Font (Guidance Helper)
#'
#' @description
#' Prints platform-agnostic instructions for installing Google's Roboto font,
#' the recommended open-source fallback when Mari is unavailable.
#'
#' @details
#' No files are downloaded or installed automatically; the function only
#' provides guidance that you can follow manually.
#'
#' **Note:** If you install the `showtext` package, BFHtheme will automatically
#' download and use Roboto from Google Fonts when needed - no manual installation
#' required!
#'
#' @keywords internal
#' @seealso [get_bfh_font()]
#' @family BFH fonts
#' @examples
#' \dontrun{
#' BFHtheme:::install_roboto_font()
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

#' Configure Fonts for BFH Themes
#'
#' @description
#' Ensures an appropriate font is available for BFH visuals. Optionally loads
#' Roboto via the `showtext` package when system fonts are not accessible.
#'
#' @param use_showtext Logical. When `TRUE`, attempts to load Roboto through
#'   `showtext::font_add_google()` and enable `showtext_auto()`. Defaults to `FALSE`.
#' @return Character string naming the font family that should be used.
#' @keywords internal
#' @seealso [get_bfh_font()]
#' @family BFH fonts
#' @examples
#' \dontrun{
#' # Setup fonts
#' font <- BFHtheme:::setup_bfh_fonts()
#'
#' # Use in plot
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh(base_family = font)
#' }
setup_bfh_fonts <- function(use_showtext = FALSE) {

  if (use_showtext &&
      requireNamespace("showtext", quietly = TRUE) &&
      requireNamespace("sysfonts", quietly = TRUE)) {
    # Try to add Roboto from Google Fonts
    tryCatch({
      sysfonts::font_add_google("Roboto", "Roboto")
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

#' Update Theme Defaults with BFH Fonts
#'
#' @description
#' Convenience wrapper around [setup_bfh_fonts()] that immediately updates
#' `ggplot2`'s global theme text family to the detected BFH font.
#'
#' @param use_showtext Logical. Forwarded to internal setup function. Defaults to `FALSE`.
#' @return Invisibly returns the font family that was set.
#' @keywords internal
#' @seealso [get_bfh_font()], [set_bfh_defaults()]
#' @family BFH fonts
#' @examples
#' \dontrun{
#' # Set BFH fonts as default
#' BFHtheme:::set_bfh_fonts()
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

#' Setup Modern Graphics Devices for BFH Plots
#'
#' @description
#' Configures recommended graphics devices for high-quality BFH plots with
#' proper font embedding. Sets up `ragg` for raster output and `svglite` for
#' vector graphics when used in knitr/quarto documents.
#'
#' @details
#' This function sets knitr chunk defaults to use modern graphics devices:
#' - **PNG/JPEG:** `ragg::agg_png()` - high-quality raster with font support
#' - **PDF:** Recommend using `ggsave()` with `device = grDevices::cairo_pdf`
#' - **SVG:** Recommend using `ggsave()` with `device = svglite::svglite`
#'
#' These devices work seamlessly with system fonts via `systemfonts`,
#' avoiding the need for PostScript font databases or `extrafont`.
#'
#' @param dpi Resolution for raster graphics (default: 300 for print quality)
#'
#' @return Invisibly returns `TRUE`.
#' @keywords internal
#' @seealso [get_bfh_font()], [bfh_save()]
#' @family BFH fonts
#' @examples
#' \dontrun{
#' # Setup at the start of your analysis
#' library(BFHtheme)
#' BFHtheme:::set_bfh_graphics()
#'
#' # Now all knitr chunks will use high-quality devices
#' # For manual saving:
#' p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_bfh()
#' ggsave("plot.pdf", p, device = grDevices::cairo_pdf)
#' ggsave("plot.svg", p, device = svglite::svglite)
#' }
set_bfh_graphics <- function(dpi = 300) {
  # Check if we're in a knitr context
  if (requireNamespace("knitr", quietly = TRUE)) {
    # Use ragg for high-quality raster output
    if (requireNamespace("ragg", quietly = TRUE)) {
      knitr::opts_chunk$set(
        dev = "ragg_png",
        dpi = dpi
      )
      message("knitr device set to ragg_png (dpi = ", dpi, ")")
    } else {
      message("Install 'ragg' package for best raster quality:\n",
              "  install.packages('ragg')")
    }
  }

  # Print recommendations for manual saving
  message("\nRecommended devices for ggsave():")
  message("  PDF: ggsave('plot.pdf', device = grDevices::cairo_pdf)")
  if (requireNamespace("svglite", quietly = TRUE)) {
    message("  SVG: ggsave('plot.svg', device = svglite::svglite)")
  } else {
    message("  SVG: Install 'svglite' for vector graphics")
  }
  if (requireNamespace("ragg", quietly = TRUE)) {
    message("  PNG: ggsave('plot.png', device = ragg::agg_png, dpi = ", dpi, ")")
  }

  invisible(TRUE)
}

#' Enable Showtext for Font Embedding
#'
#' @description
#' Explicitly enables `showtext` for embedding fonts in graphics when system
#' fonts are not available or when you need to embed custom fonts.
#'
#' @details
#' **When to use this:**
#' - Deploying to servers without Mari fonts (e.g., Posit Connect)
#' - Need to embed custom fonts in PDFs
#' - System fonts not rendering correctly
#'
#' **Note:** This is opt-in by design. Most users should rely on system fonts
#' with modern devices (`ragg`, `svglite`, `cairo_pdf`).
#'
#' @param font_paths Named list with paths to font files (regular, bold, italic).
#'   If NULL, attempts to load Roboto from Google Fonts.
#' @param family Font family name to register (default: "Roboto")
#'
#' @return Invisibly returns the font family name.
#' @keywords internal
#' @seealso [get_bfh_font()]
#' @family BFH fonts
#' @examples
#' \dontrun{
#' # Option 1: Load Roboto from Google Fonts
#' BFHtheme:::use_bfh_showtext()
#'
#' # Option 2: Load custom fonts from files
#' BFHtheme:::use_bfh_showtext(
#'   font_paths = list(
#'     regular = "path/to/Mari-Regular.ttf",
#'     bold = "path/to/Mari-Bold.ttf",
#'     italic = "path/to/Mari-Italic.ttf"
#'   ),
#'   family = "Mari"
#' )
#' }
use_bfh_showtext <- function(font_paths = NULL, family = "Roboto") {
  if (!requireNamespace("showtext", quietly = TRUE) ||
      !requireNamespace("sysfonts", quietly = TRUE)) {
    stop("Install 'showtext' and 'sysfonts' packages:\n  install.packages(c('showtext', 'sysfonts'))",
         call. = FALSE)
  }

  if (is.null(font_paths)) {
    # Load from Google Fonts
    tryCatch({
      sysfonts::font_add_google(family, family)
      message("Loaded ", family, " from Google Fonts via showtext")
    }, error = function(e) {
      stop("Could not load ", family, " from Google Fonts: ", e$message,
           call. = FALSE)
    })
  } else {
    # Load from local files
    if (!all(c("regular") %in% names(font_paths))) {
      stop("font_paths must contain at least 'regular' entry", call. = FALSE)
    }

    sysfonts::font_add(
      family = family,
      regular = font_paths$regular,
      bold = font_paths$bold %||% font_paths$regular,
      italic = font_paths$italic %||% font_paths$regular,
      bolditalic = font_paths$bolditalic %||% font_paths$regular
    )
    message("Loaded ", family, " from local files via showtext")
  }

  # Enable showtext
  showtext::showtext_auto()
  message("showtext enabled - fonts will be embedded in graphics")

  invisible(family)
}

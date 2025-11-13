#' BFH Brand Color Definitions
#'
#' @description
#' Master vector of Bispebjerg og Frederiksberg Hospital and Region Hovedstaden
#' brand colors. Values are hex codes that comply with the official visual
#' identity guidelines.
#'
#' @details
#' The object exposes both official color names (e.g. `"hospital_primary"`) and
#' pragmatic aliases (e.g. `"primary"`, `"blue"`) for quick scripting. Use
#' [bfh_cols()] to extract colors safely with validation and helpful error
#' messages.
#'
#' @format A named character vector where each element is a hex color code.
#' @export
#' @seealso [bfh_cols()], [bfh_palettes], [show_bfh_palettes()]
#' @family BFH colors
#'
#' @importFrom grDevices colorRampPalette
#' @importFrom graphics par title
#' @importFrom scales show_col
bfh_colors <- c(
  # === HOSPITAL COLORS (Bispebjerg og Frederiksberg Hospital) ===
  # Primary hospital color (identitetsfarve)
  `hospital_primary`    = "#007dbb",  # RGB: 0,125,187

  # Secondary hospital colors
  `hospital_blue`       = "#009ce8",  # RGB: 0,156,232
  `hospital_light_blue1`= "#cce5f1",  # RGB: 204,211,221
  `hospital_light_blue2`= "#e5f2f8",  # RGB: 229,242,248

  # Neutral/grey colors (hospital)
  `hospital_grey`       = "#646c6f",  # RGB: 100,108,111
  `hospital_dark_grey`  = "#333333",  # RGB: 51,51,51
  `hospital_white`      = "#ffffff",  # RGB: 255,255,255

  # === REGION HOVEDSTADEN COLORS (Koncern) ===
  # Primary Region H color (identitetsfarve)
  `regionh_primary`     = "#002555",  # RGB: 0,37,85

  # Secondary Region H colors
  `regionh_blue`        = "#007dbb",  # RGB: 0,125,187
  `regionh_light_grey1` = "#ccd3dd",  # RGB: 204,211,221
  `regionh_light_grey2` = "#e5e9ee",  # RGB: 229,233,238

  # Neutral/grey colors (Region H)
  `regionh_grey`        = "#646c6f",  # RGB: 100,108,111
  `regionh_dark_grey`   = "#333333",  # RGB: 51,51,51
  `regionh_white`       = "#ffffff",  # RGB: 255,255,255

  # === ALIASES FOR EASIER USE ===
  # Hospital aliases
  `primary`             = "#007dbb",
  `blue`                = "#009ce8",
  `light_blue`          = "#cce5f1",
  `very_light_blue`     = "#e5f2f8",
  `grey`                = "#646c6f",
  `dark_grey`           = "#333333",
  `white`               = "#ffffff",

  # Region H primary
  `regionh_navy`        = "#002555"
)

#' Extract BFH Colors
#'
#' @description
#' Retrieves one or more BFH brand colors by name with validation and friendly
#' error messages.
#'
#' @param ... Character names present in [bfh_colors]. If omitted, all colors are
#'   returned.
#' @return Character vector of hex color codes in the order requested.
#' @export
#' @details
#' The function accepts both official color identifiers (e.g.
#' `"hospital_primary"`) and provided aliases (e.g. `"primary"`). Invalid names
#' trigger an informative error listing available options.
#' @family BFH colors
#' @examples
#' # Get a single color
#' bfh_cols("primary")
#'
#' # Get multiple colors
#' bfh_cols("hospital_primary", "hospital_blue")
#'
#' # Get all colors
#' bfh_cols()
#'
#' # Using aliases
#' bfh_cols("blue", "grey")
bfh_cols <- function(...) {
  cols <- c(...)

  # Return all colors when no arguments provided
  # c(...) with no args gives character(0), not NULL
  if (length(cols) == 0)
    return(bfh_colors)

  # Input validation
  if (!is.character(cols)) {
    stop("Color names must be character strings", call. = FALSE)
  }

  # Check for invalid color names
  invalid_cols <- setdiff(cols, names(bfh_colors))
  if (length(invalid_cols) > 0) {
    stop(
      "Unknown color name(s): ", paste(invalid_cols, collapse = ", "), "\n",
      "Available colors: ", paste(names(bfh_colors), collapse = ", "),
      call. = FALSE
    )
  }

  bfh_colors[cols]
}

#' BFH Color Palettes (Named List)
#'
#' @description
#' Predefined discrete and sequential palettes covering hospital, regional, and
#' legacy BFH use cases. Palettes are sourced from [bfh_colors].
#'
#' @details
#' The list is structured for use with [bfh_pal()] and the `scale_*_bfh*()`
#' helpers. Palettes ending in `"_seq"` are suited for continuous scales while
#' the rest target categorical data and infographics.
#'
#' @export
#' @seealso [bfh_pal()], [show_bfh_palettes()], [scale_color_bfh()]
#' @family BFH colors
bfh_palettes <- list(
  # === HOSPITAL PALETTES ===
  `main` = bfh_cols("hospital_primary", "hospital_blue", "hospital_grey", "dark_grey"),

  `hospital` = bfh_cols("hospital_primary", "hospital_blue", "hospital_grey", "dark_grey"),

  `hospital_blues` = bfh_cols("hospital_primary", "hospital_blue", "light_blue",
                               "very_light_blue"),

  `hospital_blues_seq` = bfh_cols("hospital_primary", "hospital_blue",
                                   "light_blue", "very_light_blue", "white"),

  `hospital_infographic` = bfh_cols("hospital_primary", "hospital_blue", "light_blue",
                                     "hospital_grey", "dark_grey"),

  # === REGION HOVEDSTADEN PALETTES ===
  `regionh` = bfh_cols("regionh_primary", "regionh_blue", "regionh_grey", "dark_grey"),

  `regionh_main` = bfh_cols("regionh_primary", "regionh_blue", "regionh_light_grey1",
                            "regionh_grey"),

  `regionh_blues` = bfh_cols("regionh_primary", "regionh_blue", "regionh_light_grey1",
                             "regionh_light_grey2"),

  `regionh_blues_seq` = bfh_cols("regionh_primary", "regionh_blue",
                                 "regionh_light_grey1", "regionh_light_grey2", "white"),

  `regionh_infographic` = bfh_cols("regionh_primary", "regionh_blue",
                                   "regionh_light_grey1", "regionh_grey", "dark_grey"),

  # === LEGACY/COMPATIBILITY PALETTES ===
  `primary` = bfh_cols("hospital_primary", "hospital_blue"),

  `blues` = bfh_cols("hospital_primary", "hospital_blue", "light_blue",
                     "very_light_blue"),

  `blues_sequential` = bfh_cols("hospital_primary", "hospital_blue",
                                "light_blue", "very_light_blue", "white"),

  `greys` = bfh_cols("dark_grey", "hospital_grey", "light_blue", "very_light_blue"),

  `contrast` = bfh_cols("hospital_primary", "hospital_grey", "hospital_blue",
                        "dark_grey"),

  `infographic` = bfh_cols("hospital_primary", "hospital_blue", "light_blue",
                           "hospital_grey", "dark_grey")
)

# Package-level palette cache environment
.bfh_pal_cache <- new.env(parent = emptyenv())

#' Interpolate a BFH Color Palette
#'
#' @description
#' Creates a color interpolation function for any named palette in
#' [bfh_palettes], enabling smooth gradients or truncated palette selections.
#'
#' @param palette Character name of the palette in [bfh_palettes]. Defaults to `"main"`.
#' @param reverse Logical; reverse the palette order. Defaults to `FALSE`.
#' @param ... Additional arguments forwarded to [grDevices::colorRampPalette()].
#' @return Function that accepts an integer `n` and returns `n` colors.
#' @export
#' @seealso [bfh_palettes], [scale_color_bfh()], [scale_fill_bfh()]
#' @family BFH colors
#' @examples
#' bfh_pal("main")(5)
#' bfh_pal("blues", reverse = TRUE)(3)
bfh_pal <- function(palette = "main", reverse = FALSE, ...) {
  # Validate palette name
  if (!palette %in% names(bfh_palettes)) {
    stop(
      "Unknown palette: '", palette, "'\n",
      "Available palettes: ", paste(names(bfh_palettes), collapse = ", "),
      call. = FALSE
    )
  }

  # Create cache key from palette name and reverse flag
  cache_key <- paste0(palette, "_", reverse)

  # Check cache first
  if (exists(cache_key, envir = .bfh_pal_cache, inherits = FALSE)) {
    return(get(cache_key, envir = .bfh_pal_cache, inherits = FALSE))
  }

  # Create and cache the palette function
  pal <- bfh_palettes[[palette]]
  if (reverse) pal <- rev(pal)

  pal_fn <- grDevices::colorRampPalette(pal, ...)

  # Store in cache
  assign(cache_key, pal_fn, envir = .bfh_pal_cache)

  pal_fn
}

#' Clear Palette Cache
#'
#' @description
#' Removes cached palette interpolation functions, ensuring that the next call to
#' [bfh_pal()] triggers fresh palette creation. Useful after modifying palettes
#' or for testing purposes.
#'
#' @return Invisibly returns `TRUE`.
#' @keywords internal
#' @seealso [bfh_pal()]
#' @family BFH colors
#' @examples
#' # Clear palette cache
#' BFHtheme:::clear_bfh_pal_cache()
#'
#' # Next call will recreate palette
#' pal <- bfh_pal("main")
clear_bfh_pal_cache <- function() {
  rm(list = ls(envir = .bfh_pal_cache), envir = .bfh_pal_cache)
  message("BFH palette cache cleared")
  invisible(TRUE)
}

#' Visualise BFH Palettes
#'
#' @description
#' Displays every palette defined in [bfh_palettes] using `scales::show_col()`
#' to assist with palette selection.
#'
#' @param n Optional integer specifying how many colors to preview from each
#'   palette. When `NULL` (default) all palette entries are shown.
#' @export
#' @importFrom purrr walk
#' @family BFH colors
#' @examples
#' \dontrun{
#' show_bfh_palettes()
#' }
show_bfh_palettes <- function(n = NULL) {
  if (!requireNamespace("scales", quietly = TRUE)) {
    stop("Package 'scales' is required for this function.")
  }

  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par))

  pal_names <- names(bfh_palettes)
  n_pals <- length(pal_names)

  graphics::par(mfrow = c(n_pals, 1), mai = c(0.2, 0.6, 0.2, 0.2))

  # Modernized with purrr::walk() for functional iteration
  purrr::walk(pal_names, function(pal_name) {
    # Use %||% for NULL coalescing
    pal <- if (is.null(n)) {
      bfh_palettes[[pal_name]]
    } else {
      bfh_pal(pal_name)(n)
    }

    scales::show_col(pal, labels = TRUE, borders = NA, cex_label = 0.8)
    graphics::title(main = pal_name, line = -1)
  })
}

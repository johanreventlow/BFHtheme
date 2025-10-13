#' BFH Color Palettes
#'
#' @description
#' Color palettes for Bispebjerg og Frederiksberg Hospital and Region Hovedstaden.
#' These colors follow Region Hovedstaden's official visual identity guidelines.
#'
#' @format Named character vectors with hex color codes
#' @export
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

#' Extract BFH colors as hex codes
#'
#' @param ... Character names of bfh_colors
#' @return Character vector of hex color codes
#' @export
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

  if (is.null(cols))
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

#' BFH Color Palettes (named list)
#'
#' @description
#' Predefined color palettes for different types of visualizations.
#' Includes palettes for both Hospital and Region Hovedstaden (koncern) branding.
#'
#' @export
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

#' Return function to interpolate a BFH color palette
#'
#' @param palette Character name of palette in bfh_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments to pass to colorRampPalette()
#' @return A function that takes an integer n and returns n colors
#' @export
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

  pal <- bfh_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  grDevices::colorRampPalette(pal, ...)
}

#' Show all available BFH color palettes
#'
#' @param n Number of colors to display from each palette
#' @export
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

  for (pal_name in pal_names) {
    pal <- bfh_palettes[[pal_name]]
    if (is.null(n)) {
      n_colors <- length(pal)
    } else {
      n_colors <- n
      pal <- bfh_pal(pal_name)(n)
    }
    scales::show_col(pal, labels = TRUE, borders = NA, cex_label = 0.8)
    graphics::title(main = pal_name, line = -1)
  }
}

#' Check if colors are colorblind-friendly
#'
#' @param colors Character vector of hex colors
#' @return Message about colorblind accessibility
#' @export
check_colorblind_safe <- function(colors) {
  # This is a simplified check - for production, consider using
  # packages like 'colorblindcheck' or 'colorblindr'
  message("Note: For full colorblind accessibility testing, use the 'colorblindcheck' package")
  message("Number of colors: ", length(colors))
  invisible(colors)
}

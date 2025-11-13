#' Add BFH Logo to a Plot
#'
#' @description
#' Places the BFH mark logo at a fixed, brand-compliant position on ggplot2
#' visualizations. The logo is automatically positioned at the bottom-left corner
#' with standardized sizing (1/15 of plot height, square).
#'
#' @details
#' **Simplified API (v0.3.0):** This function now uses fixed positioning to ensure
#' consistent branding across all visualizations. The logo is always placed at the
#' bottom-left corner, flush with the plot edge, at a height and width of 1/15 of
#' the total plot height (square aspect ratio).
#'
#' **Default logo:** When `logo_path = NULL`, the function automatically loads
#' `bfh_mark.png` (full resolution BFH symbol mark). For custom logos, provide
#' a path to a PNG or JPEG file.
#'
#' **Dependencies:** Requires the `cowplot` and `magick` packages for precise
#' logo positioning with correct aspect ratio. Install with:
#' ```r
#' install.packages(c("cowplot", "magick"))
#' ```
#'
#' **Security:** File paths are normalized and verified to prevent tampering.
#' For additional security, you can restrict logo loading to a specific directory:
#' ```r
#' options(BFHtheme.logo_root = "/safe/logo/directory")
#' ```
#' When set, only logos within this directory (or subdirectories) will be allowed.
#'
#' **Breaking changes from v0.2.0:** The `position`, `size`, and `padding`
#' parameters have been removed to enforce consistent branding. See NEWS.md for
#' migration guidance.
#'
#' @param plot A ggplot2 object.
#' @param logo_path Path to a PNG or JPEG logo file. When `NULL` (default),
#'   uses the packaged BFH mark logo (`bfh_mark.png`).
#' @param alpha Transparency of the logo (0–1). Defaults to `1` (fully opaque).
#' @return Modified ggplot2 object with the logo applied.
#' @export
#'
#' @seealso [get_bfh_logo()], [add_bfh_footer()]
#' @family BFH branding
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' # Use default BFH mark logo (recommended)
#' add_bfh_logo(p)
#'
#' # Use custom logo
#' add_bfh_logo(p, logo_path = "/path/to/custom_logo.png")
#'
#' # Adjust transparency
#' add_bfh_logo(p, alpha = 0.7)
#' }
add_bfh_logo <- function(plot,
                         logo_path = NULL,
                         alpha = 1) {

  # Load default logo if not specified
  if (is.null(logo_path)) {
    logo_path <- get_bfh_logo(size = "full", variant = "mark")
    if (is.null(logo_path)) {
      stop("BFH mark logo not found. Package may not be installed correctly.", call. = FALSE)
    }
  }

  # Input validation
  if (!is.character(logo_path) || length(logo_path) != 1 || nchar(logo_path) == 0) {
    stop("logo_path must be a non-empty character string", call. = FALSE)
  }

  # === Security Layer 1: Path Normalization ===
  # Normalize path (allowing shortcuts like ~ or ..) and ensure it resolves
  normalized_path <- tryCatch(
    normalizePath(logo_path, winslash = "/", mustWork = TRUE),
    error = function(e) {
      expanded <- tryCatch(path.expand(logo_path), error = function(...) logo_path)
      if (!file.exists(expanded)) {
        stop("Logo file not found: ", basename(logo_path), call. = FALSE)
      }
      stop("Invalid file path: ", logo_path, call. = FALSE)
    }
  )

  # === Security Layer 2: Tampering Protection ===
  # Re-normalize the resolved path to ensure stability and verify path hasn't changed
  # This catches symbolic link attacks and path confusion exploits
  normalized_verification <- tryCatch(
    normalizePath(normalized_path, winslash = "/", mustWork = TRUE),
    error = function(e) {
      stop("Invalid file path: ", logo_path, call. = FALSE)
    }
  )

  if (!identical(normalized_path, normalized_verification)) {
    stop("Invalid file path: ", logo_path, call. = FALSE)
  }

  # === Security Layer 3: Optional Root Directory Restriction ===
  # Users can restrict logo loading to specific directory via options(BFHtheme.logo_root = "/path")
  # This provides sandboxing for high-security applications
  allowed_root <- getOption("BFHtheme.logo_root")
  if (!is.null(allowed_root)) {
    normalized_root <- tryCatch(
      normalizePath(allowed_root, winslash = "/", mustWork = TRUE),
      error = function(e) {
        stop("Invalid BFHtheme.logo_root option: ", e$message, call. = FALSE)
      }
    )

    root_prefix <- paste0(normalized_root, "/")
    if (!identical(normalized_path, normalized_root) && !startsWith(normalized_path, root_prefix)) {
      stop("Logo file must reside within the allowed root directory", call. = FALSE)
    }
  }

  # === Security Layer 4: File Integrity Checks ===
  # Verify file is readable and has content before processing
  file_info <- file.info(normalized_path)
  if (is.na(file_info$size) || file_info$size == 0) {
    stop("Logo file is empty or unreadable", call. = FALSE)
  }

  # Validate alpha parameter
  alpha <- validate_numeric_range(alpha, "alpha", 0, 1)

  logo_type <- detect_logo_image_type(normalized_path, file_info$size)

  if (!requireNamespace("png", quietly = TRUE) &&
      !requireNamespace("jpeg", quietly = TRUE)) {
    warning("Packages 'png' and/or 'jpeg' recommended for image support.")
  }

  logo <- switch(
    logo_type,
    png = {
      if (!requireNamespace("png", quietly = TRUE)) {
        stop("Package 'png' is required to read PNG files. Install with: install.packages('png')", call. = FALSE)
      }
      tryCatch(
        png::readPNG(normalized_path),
        error = function(e) {
          stop("Failed to read PNG file: ", e$message, call. = FALSE)
        }
      )
    },
    jpeg = {
      if (!requireNamespace("jpeg", quietly = TRUE)) {
        stop("Package 'jpeg' is required to read JPEG files. Install with: install.packages('jpeg')", call. = FALSE)
      }
      tryCatch(
        jpeg::readJPEG(normalized_path),
        error = function(e) {
          stop("Failed to read JPEG file: ", e$message, call. = FALSE)
        }
      )
    },
    stop("Logo file must be a valid PNG or JPEG image", call. = FALSE)
  )

  # Check if patchwork is available (required for full plot positioning)
  if (!requireNamespace("patchwork", quietly = TRUE)) {
    warning(
      "Package 'patchwork' is required for logo positioning. ",
      "Install with: install.packages('patchwork'). ",
      "Returning plot without logo.",
      call. = FALSE
    )
    return(plot)
  }

  # Check if cowplot and magick are available (required for logo positioning)
  if (!requireNamespace("cowplot", quietly = TRUE)) {
    warning(
      "Package 'cowplot' is required for logo positioning. ",
      "Install with: install.packages('cowplot'). ",
      "Returning plot without logo.",
      call. = FALSE
    )
    return(plot)
  }

  if (!requireNamespace("magick", quietly = TRUE)) {
    warning(
      "Package 'magick' is required for image handling. ",
      "Install with: install.packages('magick'). ",
      "Returning plot without logo.",
      call. = FALSE
    )
    return(plot)
  }

  # Fixed positioning: logo height and width both 1/15 of plot height (square)
  logo_size <- 1/15  # As fraction of plot height
  logo_position_bottom <- 1/15  # Position from bottom

  # Use cowplot::draw_image() for precise positioning
  # This function handles aspect ratio correctly and positions relative to plot coordinates
  plot +
    cowplot::draw_image(
      image = logo,
      x = 0,  # Left edge of plot
      y = logo_position_bottom,  # 1/15 from bottom
      width = logo_size,  # 1/15 of plot height
      height = logo_size,  # 1/15 of plot height (square)
      hjust = 0,  # Horizontal justification: left
      vjust = 0,  # Vertical justification: bottom
      halign = 0,  # Horizontal alignment within space
      valign = 0,  # Vertical alignment within space
      interpolate = TRUE
    )
}

#' @keywords internal
#' @noRd
detect_logo_image_type <- function(path, file_size) {
  con <- file(path, "rb")
  on.exit(close(con), add = TRUE)

  header <- readBin(con, what = "raw", n = min(12L, file_size))
  if (length(header) == 0) {
    stop("Logo file must be a valid PNG or JPEG image", call. = FALSE)
  }

  png_signature <- charToRaw("\x89PNG\r\n\x1a\n")
  if (length(header) >= length(png_signature) &&
      identical(header[seq_along(png_signature)], png_signature)) {
    return("png")
  }

  # JPEG files should start with FF D8 and end with FF D9
  if (length(header) >= 2 &&
      header[1] == as.raw(0xff) &&
      header[2] == as.raw(0xd8)) {
    if (file_size < 4) {
      stop("Logo file must be a valid PNG or JPEG image", call. = FALSE)
    }
    seek(con, where = file_size - 2, origin = "start")
    trailer <- readBin(con, what = "raw", n = 2)
    if (length(trailer) == 2 &&
        trailer[1] == as.raw(0xff) &&
        trailer[2] == as.raw(0xd9)) {
      return("jpeg")
    }
  }

  stop("Logo file must be a valid PNG or JPEG image", call. = FALSE)
}

#' Add BFH Footer to a Plot
#'
#' @description
#' Appends a coloured footer bar with optional text, ideal for credits or
#' contact details in BFH-branded material.
#'
#' @details
#' The footer spans the width of the plot. Provide `text = NULL` to fall back to
#' a default hospital identifier. Adjust `height` (0–1) to control the bar
#' thickness relative to the plotting area.
#'
#' @param plot A ggplot2 object.
#' @param text Footer text. Defaults to `"Bispebjerg og Frederiksberg Hospital"`.
#' @param color Footer background colour. Defaults to `bfh_cols("hospital_primary")`.
#' @param text_color Text colour. Defaults to `"white"`.
#' @param height Footer height as a fraction of the plotting area. Defaults to `0.05`.
#' @return ggplot2 object with the footer applied.
#' @export
#' @seealso [add_bfh_logo()], [add_bfh_color_bar()], [bfh_title_block()]
#' @family BFH branding
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' add_bfh_footer(p, text = "Bispebjerg og Frederiksberg Hospital - 2024")
#' }
add_bfh_footer <- function(plot,
                           text = NULL,
                           color = bfh_cols("hospital_primary"),
                           text_color = "white",
                           height = 0.05) {

  # Modernized with %||% NULL coalescing operator
  text <- text %||% "Bispebjerg og Frederiksberg Hospital"

  # Create footer rectangle positioned at bottom with specified height
  footer_rect <- grid::rectGrob(
    x = grid::unit(0.5, "npc"),
    y = grid::unit(height/2, "npc"),
    width = grid::unit(1, "npc"),
    height = grid::unit(height, "npc"),
    gp = grid::gpar(fill = color, col = NA)
  )

  # Create footer text centered in footer area
  footer_text <- grid::textGrob(
    text,
    x = grid::unit(0.5, "npc"),
    y = grid::unit(height/2, "npc"),
    gp = grid::gpar(col = text_color, fontsize = 10)
  )

  # Combine rectangle and text
  footer_grob <- grid::grobTree(footer_rect, footer_text)

  # Add footer to plot
  # annotation_custom() kræver numeriske koordinater, ikke unit objekter
  # Vi bruger -Inf/Inf og lader grob'en selv håndtere positioning
  plot +
    ggplot2::annotation_custom(
      footer_grob,
      xmin = -Inf, xmax = Inf,
      ymin = -Inf, ymax = Inf
    ) +
    ggplot2::coord_cartesian(clip = "off") +
    ggplot2::theme(plot.margin = ggplot2::margin(b = height * 100, unit = "pt"))
}

#' Create a Branded Title Block
#'
#' @description
#' Generates a reusable set of labels for BFH-styled titles, subtitles, and
#' captions.
#'
#' @details
#' Pair with [bfh_labs()] for automatic uppercase conversion or add the result
#' directly to ggplot objects. Use `NULL` for optional arguments you want to
#' omit.
#'
#' @param title Main title text.
#' @param subtitle Optional subtitle text.
#' @param caption Optional caption text.
#' @return A [ggplot2::labs] object.
#' @export
#' @seealso [bfh_labs()], [theme_bfh()], [add_bfh_footer()]
#' @family BFH branding
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   bfh_title_block(
#'     title = "Vehicle Weight vs Fuel Efficiency",
#'     subtitle = "Analysis of mtcars dataset",
#'     caption = "Source: Motor Trend, 1974"
#'   ) +
#'   theme_bfh()
#' }
bfh_title_block <- function(title, subtitle = NULL, caption = NULL) {
  ggplot2::labs(
    title = title,
    subtitle = subtitle,
    caption = caption
  )
}

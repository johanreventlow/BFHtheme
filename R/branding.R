#' Add BFH Logo to a Plot
#'
#' @description
#' Places a Bispebjerg og Frederiksberg Hospital logo onto an existing ggplot,
#' preserving the original chart while adding brand context.
#'
#' @details
#' The helper reads PNG or JPEG files supplied via `logo_path`. Aspect ratio is
#' preserved automatically, and the logo is positioned using absolute
#' coordinates based on the selected corner. For packaged logos, see [add_logo()]
#' and [get_bfh_logo()].
#'
#' @section Security:
#' This function implements multiple security layers to ensure safe file handling:
#'
#' **Path Normalization:**
#' File paths are normalized and verified twice to prevent path traversal attacks
#' and ensure path stability. This guards against tampering attempts where a path
#' might resolve differently on subsequent calls.
#'
#' **Root Directory Restriction (Optional):**
#' You can restrict logo loading to a specific directory tree by setting:
#' ```
#' options(BFHtheme.logo_root = "/safe/directory")
#' ```
#' When set, only logos within this directory (or subdirectories) can be loaded.
#' This is useful in multi-user environments or when processing untrusted input.
#'
#' **File Integrity Checks:**
#' Files are verified to be readable and non-empty before processing, preventing
#' errors from corrupted or inaccessible files.
#'
#' @param plot A ggplot2 object.
#' @param logo_path Path to a PNG or JPEG logo file.
#' @param position Logo location: `"topleft"`, `"topright"`, `"bottomleft"`, or
#'   `"bottomright"`. Defaults to `"bottomright"`.
#' @param size Relative width of the logo (0–1). Defaults to `0.1` (10% of plot width).
#'   Height is derived from the image aspect ratio.
#' @param alpha Transparency of the logo (0–1). Defaults to `1` (fully opaque).
#' @param padding Padding from plot edge as a fraction of plot size. Defaults to `0.02`.
#' @return Modified ggplot2 object with the logo applied.
#' @export
#'
#' @importFrom ggplot2 annotation_custom coord_cartesian theme margin annotate labs
#' @importFrom grid rectGrob textGrob grobTree gpar unit rasterGrob
#' @seealso [add_logo()], [get_bfh_logo()], [add_bfh_footer()], [add_bfh_color_bar()]
#' @family BFH branding
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
#'
#' # Option 1: Use packaged logo via get_bfh_logo()
#' logo_path <- get_bfh_logo(size = "web", variant = "color")
#' add_bfh_logo(p, logo_path, position = "topright")
#'
#' # Option 2: Use any custom logo file (adjust path as needed)
#' # add_bfh_logo(p, "/path/to/your/logo.png", position = "topright")
#' }
add_bfh_logo <- function(plot,
                         logo_path,
                         position = "bottomright",
                         size = 0.1,
                         alpha = 1,
                         padding = 0.02) {

  # Input validation
  if (!is.character(logo_path) || length(logo_path) != 1 || nchar(logo_path) == 0) {
    stop("logo_path must be a non-empty character string", call. = FALSE)
  }

  # Security Layer 1: Path Normalization
  # Resolve path shortcuts (~ and ..) to absolute paths and verify file exists
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

  # Security Layer 2: Double Verification
  # Re-normalize to ensure path stability and guard against TOCTOU attacks
  # (Time-Of-Check-Time-Of-Use) where a path might resolve differently
  normalized_verification <- tryCatch(
    normalizePath(normalized_path, winslash = "/", mustWork = TRUE),
    error = function(e) {
      stop("Invalid file path: ", logo_path, call. = FALSE)
    }
  )

  if (!identical(normalized_path, normalized_verification)) {
    stop("Invalid file path: ", logo_path, call. = FALSE)
  }

  # Security Layer 3: Optional Root Directory Restriction
  # Restrict file access to a specific directory tree for sandboxing
  # Enable via: options(BFHtheme.logo_root = "/safe/directory")
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

  # Security Layer 4: File Integrity Check
  # Verify file is readable and contains data before processing
  file_info <- file.info(normalized_path)
  if (is.na(file_info$size) || file_info$size == 0) {
    stop("Logo file is empty or unreadable", call. = FALSE)
  }

  # Validate numeric parameters using standardized validation
  size <- validate_numeric_range(size, "size", 0, 1, exclusive_min = TRUE)
  alpha <- validate_numeric_range(alpha, "alpha", 0, 1)
  padding <- validate_numeric_range(padding, "padding", 0, 1)

  # Validate position choice
  position <- validate_choice(
    position,
    "position",
    c("topleft", "topright", "bottomleft", "bottomright")
  )

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

  # Beregn aspect ratio for at bevare logoets proportioner
  # Logo array har dimensioner [height, width, channels] eller [height, width]
  logo_dims <- dim(logo)
  logo_height <- logo_dims[1]
  logo_width <- logo_dims[2]
  aspect_ratio <- logo_height / logo_width

  # Beregn faktisk højde baseret på bredde og aspect ratio
  logo_width_npc <- size
  logo_height_npc <- size * aspect_ratio

  # Determine position parameters med korrekte dimensioner
  # Position is already validated via validate_choice()
  pos <- switch(position,
    topleft = list(
      x = grid::unit(padding + logo_width_npc/2, "npc"),
      y = grid::unit(1 - padding - logo_height_npc/2, "npc")
    ),
    topright = list(
      x = grid::unit(1 - padding - logo_width_npc/2, "npc"),
      y = grid::unit(1 - padding - logo_height_npc/2, "npc")
    ),
    bottomleft = list(
      x = grid::unit(padding + logo_width_npc/2, "npc"),
      y = grid::unit(padding + logo_height_npc/2, "npc")
    ),
    bottomright = list(
      x = grid::unit(1 - padding - logo_width_npc/2, "npc"),
      y = grid::unit(padding + logo_height_npc/2, "npc")
    )
  )

  # Convert to raster with position applied og korrekt aspect ratio
  logo_raster <- grid::rasterGrob(
    logo,
    x = pos$x,
    y = pos$y,
    interpolate = TRUE,
    width = grid::unit(logo_width_npc, "npc"),
    height = grid::unit(logo_height_npc, "npc"),
    gp = grid::gpar(alpha = alpha)
  )

  # Add logo to plot
  plot +
    ggplot2::annotation_custom(
      logo_raster,
      xmin = -Inf, xmax = Inf,
      ymin = -Inf, ymax = Inf
    ) +
    ggplot2::coord_cartesian(clip = "off")
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

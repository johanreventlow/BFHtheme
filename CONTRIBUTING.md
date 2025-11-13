# Contributing to BFHtheme

Thank you for your interest in contributing to BFHtheme! This guide will help you get started with development, testing, and submitting contributions.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Package Architecture](#package-architecture)
3. [Utility Helper Conventions](#utility-helper-conventions)
4. [Caching Strategy](#caching-strategy)
5. [Development Workflow](#development-workflow)
6. [Code Style Guidelines](#code-style-guidelines)
7. [Testing](#testing)
8. [Documentation](#documentation)
9. [Commit Guidelines](#commit-guidelines)
10. [Pull Request Process](#pull-request-process)
11. [Review Checklist](#review-checklist)

---

## Getting Started

### Prerequisites

- R (>= 4.0.0)
- RStudio (recommended)
- Git

### Setup Development Environment

1. **Clone the repository:**

```bash
git clone https://github.com/johanreventlow/BFHtheme.git
cd BFHtheme
```

2. **Install development dependencies:**

```r
# Install devtools if not already installed
install.packages("devtools")

# Install all package dependencies
devtools::install_dev_deps()

# Install suggested packages for full functionality
install.packages(c("testthat", "covr", "lintr", "styler", "roxygen2"))
```

3. **Load the package for development:**

```r
devtools::load_all()
```

4. **Verify installation:**

```r
# Run all tests
devtools::test()

# Check package
devtools::check()
```

---

## Package Architecture

Understanding the module structure of BFHtheme helps you navigate the codebase and know where to add new features.

### Module Overview

BFHtheme is organized into **focused, single-responsibility modules**:

```
R/
├── themes.R              # ggplot2 theme functions
├── colors.R              # Color palettes and color utilities
├── scales.R              # ggplot2 scale functions
├── fonts.R               # Font detection with session caching
├── helpers.R             # Plot utilities (save, combine, labs)
├── branding.R            # Logo and branding overlay functions
├── logo_helpers.R        # Logo path resolution
├── defaults.R            # Global defaults management
├── utils_operators.R     # Internal operators (%||%)
├── utils_validation.R    # Input validation helpers
└── BFHtheme-package.R    # Package-level documentation
```

### Module Responsibilities

#### Core Theming
- **`themes.R`** - ggplot2 theme() objects
  - Exports: `theme_bfh()`, `theme_region_h()`
  - Responsibilities: Define theme elements, typography, spacing, grids
  - Dependencies: `fonts.R` for font detection, `marquee` for text rendering
  - Note: Theme variants removed in v0.2.0 - users customize via `theme()` calls

- **`colors.R`** - Color definitions and palette management
  - Exports: `bfh_colors`, `bfh_palettes`, `bfh_cols()`, `bfh_pal()`
  - Responsibilities: Store official colors, create palette generators
  - Pattern: Uses session-level caching for palette functions

- **`scales.R`** - ggplot2 scale_* functions
  - Exports: `scale_color_bfh()`, `scale_fill_bfh()`, `scale_*_date_bfh()`, etc.
  - Responsibilities: Bridge between palettes and ggplot2's scale system
  - Dependencies: `colors.R` for palette data

#### Supporting Infrastructure
- **`fonts.R`** - Font detection and caching
  - Exports: `get_bfh_font()`, `check_bfh_fonts()`, `clear_bfh_font_cache()`
  - Responsibilities: Auto-detect available fonts (Mari → Roboto → Arial → sans)
  - Pattern: Session-level caching for 10-15x speedup
  - Internal: `.bfh_font_cache` environment

- **`defaults.R`** - Global plot defaults
  - Exports: `set_bfh_defaults()`, `reset_bfh_defaults()`
  - Responsibilities: Set package theme/colors as global ggplot2 defaults
  - Pattern: Uses ggplot2's `theme_set()` and `update_geom_defaults()`

#### User Utilities
- **`helpers.R`** - Plot workflow utilities
  - Exports: `bfh_save()`, `bfh_combine()`, `bfh_labs()`
  - Responsibilities: Simplify common tasks (saving with presets, combining plots, uppercase labels)
  - Dependencies: Uses `patchwork` for combining (suggested dependency)

- **`branding.R`** - Visual branding overlays
  - Exports: `add_bfh_logo()`, `add_bfh_footer()`, `bfh_title_block()`
  - Responsibilities: Add logos, footers, and branded elements to plots
  - Pattern: Uses `grid` graphics to overlay elements post-rendering
  - Security: Validates file paths to prevent path traversal

- **`logo_helpers.R`** - Logo path resolution
  - Exports: `get_bfh_logo()`, `get_region_h_logo()`
  - Responsibilities: Resolve logo paths for different sizes/variants (color, grey, mark)
  - Pattern: Uses `system.file()` to locate package-bundled logos

#### Internal Utilities
- **`utils_operators.R`** - Common operators
  - Exports: None (internal only)
  - Provides: `%||%` (NULL coalescing operator)
  - Usage: `value <- input %||% default`

- **`utils_validation.R`** - Input validation helpers
  - Exports: None (internal only)
  - Provides: `validate_palette()`, `validate_size()`, `validate_logical()`, etc.
  - Pattern: Fail-fast validation at function entry points

- **`BFHtheme-package.R`** - Package documentation
  - Exports: Package-level help (`?BFHtheme`)
  - Responsibilities: Import statements, package description, global docs

### Data Flow & Interactions

```
User Code
    ↓
┌───────────────────────────────────────────────┐
│  themes.R                                     │
│  ├→ fonts.R (get font)                        │
│  └→ returns theme() object                    │
└───────────────────────────────────────────────┘
    ↓
┌───────────────────────────────────────────────┐
│  scales.R                                     │
│  ├→ colors.R (get palette)                    │
│  └→ returns scale_* object                    │
└───────────────────────────────────────────────┘
    ↓
    ggplot2 rendering
    ↓
┌───────────────────────────────────────────────┐
│  branding.R                                   │
│  ├→ logo_helpers.R (resolve path)             │
│  └→ grid overlay on plot                      │
└───────────────────────────────────────────────┘
    ↓
┌───────────────────────────────────────────────┐
│  helpers.R                                    │
│  └→ save with presets or combine plots        │
└───────────────────────────────────────────────┘
```

### Where to Add New Code

**New theme variant?**
→ Add to `themes.R`
- Follow existing pattern (`theme_bfh_*`)
- Use `get_bfh_font()` for font detection
- Return a complete `theme()` object

**New color palette?**
→ Add to `colors.R`
- Add colors to `bfh_colors` list
- Add palette definition to `bfh_palettes` list
- Update palette documentation

**New scale function?**
→ Add to `scales.R`
- Follow naming: `scale_<aesthetic>_bfh()`
- Use `bfh_pal()` for palette generation
- Support both discrete and continuous if applicable

**New branding element?**
→ Add to `branding.R`
- Validate file paths with `normalizePath()`
- Use `grid` graphics for overlays
- Test with different plot types

**New plot helper?**
→ Add to `helpers.R`
- Keep functions composable and simple
- Document presets/defaults clearly
- Use `%||%` for default parameter handling

**Internal utility?**
→ Add to `utils_*.R` files
- `utils_operators.R` for operators
- `utils_validation.R` for validation functions
- Prefix internal functions with `.`

### Architectural Principles

1. **Single Responsibility**: Each module has one clear purpose
2. **Composability**: Functions work together via `+` operator or piping
3. **Graceful Degradation**: Fallbacks for missing fonts/resources
4. **Session-level Caching**: Expensive operations cached per R session
5. **Input Validation**: All exported functions validate inputs early
6. **NULL Safety**: Use `%||%` for safe default handling

### Example: Adding a New Feature

Let's say you want to add a new theme variant `theme_bfh_compact()`:

1. **Open `R/themes.R`**
2. **Write the function:**
   ```r
   #' BFH Compact Theme
   #'
   #' @param base_size Base font size
   #' @param base_family Base font family
   #' @export
   theme_bfh_compact <- function(base_size = 10, base_family = NULL) {
     # Validate inputs
     if (!is.numeric(base_size) || base_size <= 0) {
       stop("base_size must be positive", call. = FALSE)
     }

     # Get font with fallback
     base_family <- base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)

     # Build theme
     theme_bfh(base_size = base_size, base_family = base_family) +
       theme(
         plot.margin = margin(5, 5, 5, 5),
         # ... compact spacing
       )
   }
   ```

3. **Add tests in `tests/testthat/test-themes.R`:**
   ```r
   test_that("theme_bfh_compact creates valid theme", {
     theme <- theme_bfh_compact()
     expect_s3_class(theme, "theme")
   })
   ```

4. **Document and check:**
   ```r
   devtools::document()
   devtools::test()
   devtools::check()
   ```

---

## Utility Helper Conventions

BFHtheme provides standardized utility helpers to ensure consistent input validation, error handling, and NULL safety across the codebase. **All contributors must use these helpers** to maintain code quality and consistency.

### NULL Coalescing Operator (`%||%`)

The `%||%` operator (defined in `utils_operators.R`) provides safe NULL handling for default values.

**Definition:**
```r
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
```

**When to use:**
- Setting default values for optional parameters
- Providing fallbacks when values might be NULL
- Avoiding verbose `if (is.null(x))` checks

**Pattern:**
```r
# ✅ Good - Use %||% for NULL defaults
your_function <- function(base_family = NULL, text = NULL, width = NULL) {
  # Simple, readable NULL coalescing
  base_family <- base_family %||% get_bfh_font()
  text <- text %||% "Default text"
  width <- width %||% dims$width

  # ... rest of function
}

# ❌ Bad - Verbose NULL checking
your_function <- function(base_family = NULL) {
  if (is.null(base_family)) {
    base_family <- get_bfh_font()
  }
  # ... rest of function
}
```

**Real-world examples from BFHtheme:**
```r
# From themes.R - Font fallback
base_family <- base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)

# From helpers.R - Dimension defaults
width <- width %||% dims$width
height <- height %||% dims$height

# From branding.R - Text fallback
text <- text %||% "Bispebjerg og Frederiksberg Hospital"

# From fonts.R - Font path fallbacks
bold = font_paths$bold %||% font_paths$regular,
italic = font_paths$italic %||% font_paths$regular
```

**Important:** Only use `%||%` for NULL checks. For other default logic, use explicit `if` statements.

---

### Validation Helpers

All validation helpers are defined in `utils_validation.R` and provide **consistent error messages** and **fail-fast behavior**.

#### 1. `validate_palette_argument(palette)`

**Purpose:** Validate palette name is a single, non-empty string

**Usage:**
```r
scale_color_bfh <- function(palette = "main", ...) {
  # Validate at function entry
  palette <- validate_palette_argument(palette)

  # Now safe to use palette
  colors <- bfh_pal(palette)
}
```

**Validates:**
- ✅ Is character type
- ✅ Has length 1 (not a vector)
- ✅ Is not NA
- ✅ Is not empty string (`""`)

**Error example:**
```r
validate_palette_argument("")
# Error: palette must be a single character string

validate_palette_argument(c("main", "secondary"))
# Error: palette must be a single character string
```

---

#### 2. `validate_logical_argument(value, name)`

**Purpose:** Validate boolean flags are proper logical values

**Usage:**
```r
scale_color_bfh <- function(palette = "main", reverse = FALSE, discrete = TRUE, ...) {
  palette <- validate_palette_argument(palette)
  reverse <- validate_logical_argument(reverse, "reverse")

  if (discrete) {
    discrete <- validate_logical_argument(discrete, "discrete")
  }
}
```

**Validates:**
- ✅ Is logical type
- ✅ Has length 1 (not a vector)
- ✅ Is not NA

**Error example:**
```r
validate_logical_argument(NA, "reverse")
# Error: reverse must be a single logical value (TRUE or FALSE)

validate_logical_argument(c(TRUE, FALSE), "discrete")
# Error: discrete must be a single logical value (TRUE or FALSE)
```

---

#### 3. `validate_numeric_range(value, name, min, max, allow_null = FALSE)`

**Purpose:** Validate numeric values are within allowed ranges

**Usage:**
```r
add_bfh_logo <- function(plot, logo_path, size = 0.1, alpha = 1, padding = 0.02) {
  # ... other validation

  # Validate numeric parameters with ranges
  size <- validate_numeric_range(size, "size", 0.001, 1)
  alpha <- validate_numeric_range(alpha, "alpha", 0, 1)
  padding <- validate_numeric_range(padding, "padding", 0, 1)
}
```

**Validates:**
- ✅ Is numeric type
- ✅ Has length 1 (not a vector)
- ✅ Is not NA
- ✅ Falls within [min, max] range (inclusive)
- ✅ Optionally allows NULL if `allow_null = TRUE`

**Error examples:**
```r
validate_numeric_range(1.5, "size", 0, 1)
# Error: size must be between 0 and 1 (inclusive)

validate_numeric_range(NULL, "alpha", 0, 1)
# Error: alpha cannot be NULL

validate_numeric_range(NULL, "padding", 0, 1, allow_null = TRUE)
# Returns NULL (valid when allow_null = TRUE)
```

---

#### 4. `validate_choice(value, name, choices, allow_null = FALSE)`

**Purpose:** Validate value is from a set of allowed options

**Usage:**
```r
add_bfh_logo <- function(plot, logo_path, position = "bottomright", ...) {
  # Validate position is one of 4 corners
  position <- validate_choice(
    position,
    "position",
    c("topleft", "topright", "bottomleft", "bottomright")
  )

  # Now safe to use in switch() or if/else
  coords <- switch(position, ...)
}
```

**Validates:**
- ✅ Is character type
- ✅ Has length 1 (not a vector)
- ✅ Is not NA
- ✅ Matches one of the allowed choices
- ✅ Optionally allows NULL if `allow_null = TRUE`

**Error example:**
```r
validate_choice("center", "position", c("topleft", "topright", "bottomleft", "bottomright"))
# Error: position must be one of: "topleft", "topright", "bottomleft", "bottomright"
```

---

### Error Handling Patterns

#### Use `call. = FALSE` for User-Facing Errors

**Always** use `call. = FALSE` in `stop()` for errors triggered by user input. This hides internal function calls from error messages.

```r
# ✅ Good - Clean error message
if (!file.exists(path)) {
  stop("Logo file not found: ", basename(path), call. = FALSE)
}
# Error: Logo file not found: logo.png

# ❌ Bad - Exposes internal call stack
if (!file.exists(path)) {
  stop("Logo file not found: ", basename(path))
}
# Error in add_bfh_logo(...): Logo file not found: logo.png
```

#### Write Clear, Actionable Error Messages

Error messages should:
1. **State the problem** clearly
2. **Include the parameter name** when relevant
3. **Suggest valid alternatives** when possible
4. **Avoid technical jargon** unless necessary

```r
# ✅ Good - Clear and actionable
if (!(position %in% valid_positions)) {
  stop(
    sprintf("position must be one of: %s", paste(dQuote(valid_positions), collapse = ", ")),
    call. = FALSE
  )
}
# Error: position must be one of: "topleft", "topright", "bottomleft", "bottomright"

# ❌ Bad - Vague and unhelpful
if (!(position %in% valid_positions)) {
  stop("Invalid position")
}
# Error: Invalid position
```

#### Validation Order

Validate parameters in this order:
1. **Type checks** (is it a character, numeric, logical?)
2. **Structural checks** (is length correct?)
3. **Content checks** (is value in allowed range/set?)
4. **External checks** (does file exist? is package available?)

```r
your_function <- function(palette = "main", size = 0.1, position = "topright") {
  # 1. Type & structure (via validation helpers)
  palette <- validate_palette_argument(palette)
  size <- validate_numeric_range(size, "size", 0, 1)
  position <- validate_choice(position, "position", c("topleft", "topright", "bottomleft", "bottomright"))

  # 2. Content validation
  if (!(palette %in% names(bfh_palettes))) {
    stop("Unknown palette: ", palette, call. = FALSE)
  }

  # 3. External dependencies
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' required but not installed", call. = FALSE)
  }

  # ... now safe to proceed with function logic
}
```

---

### Complete Example: Function with Proper Validation

Here's a complete example showing all validation patterns:

```r
#' Add Custom Branding Element
#'
#' @param plot ggplot object
#' @param element_type Type of element ("logo", "watermark", "footer")
#' @param position Position on plot
#' @param size Size as proportion of plot (0-1)
#' @param text Text to display (optional)
#' @param alpha Transparency (0-1)
#' @export
add_branding_element <- function(plot,
                                  element_type,
                                  position = "bottomright",
                                  size = 0.1,
                                  text = NULL,
                                  alpha = 1) {

  # === Input Validation (fail-fast at function entry) ===

  # 1. Required parameters
  if (missing(plot) || !inherits(plot, "ggplot")) {
    stop("plot must be a ggplot object", call. = FALSE)
  }

  if (missing(element_type)) {
    stop("element_type is required", call. = FALSE)
  }

  # 2. Use validation helpers for standard types
  element_type <- validate_choice(
    element_type,
    "element_type",
    c("logo", "watermark", "footer")
  )

  position <- validate_choice(
    position,
    "position",
    c("topleft", "topright", "bottomleft", "bottomright")
  )

  size <- validate_numeric_range(size, "size", 0.001, 1)
  alpha <- validate_numeric_range(alpha, "alpha", 0, 1)

  # 3. Optional parameter with NULL coalescing
  text <- text %||% "Default Branding Text"

  # 4. Conditional validation (only if text provided)
  if (!is.character(text) || length(text) != 1) {
    stop("text must be a single character string", call. = FALSE)
  }

  # === Function Logic (inputs now validated) ===

  # Safe to proceed - all inputs validated
  result <- switch(
    element_type,
    logo = add_logo_internal(plot, position, size, alpha),
    watermark = add_watermark_internal(plot, text, alpha),
    footer = add_footer_internal(plot, text, position)
  )

  return(result)
}
```

---

### Checklist: Adding Validation to Functions

When writing or reviewing a function, ensure:

- [ ] **All parameters validated at function entry** (fail-fast)
- [ ] **Use validation helpers** for standard types (palette, logical, numeric, choice)
- [ ] **Use `%||%`** for NULL defaults instead of verbose `if` checks
- [ ] **Use `call. = FALSE`** in all user-facing `stop()` calls
- [ ] **Error messages are clear** and include parameter names
- [ ] **Validation order**: type → structure → content → external
- [ ] **Required parameters checked** before optional ones
- [ ] **Custom validation** only when helpers don't fit

---

## Caching Strategy

BFHtheme uses **session-level caching** to optimize performance by avoiding expensive operations like font detection and palette interpolation. Understanding the caching strategy is essential when:
- Adding new cached operations
- Modifying cached functions
- Debugging caching issues
- Writing tests that depend on cache state

### Why Caching Exists

#### Performance Benefits

**Font Detection (10-15x speedup):**
- **Without caching:** Each `theme_bfh()` call queries the system for available fonts
- **With caching:** Font detected once per R session, reused for all subsequent calls
- **Impact:** Creating 100 plots goes from ~30 seconds to ~2 seconds

**Palette Interpolation:**
- **Without caching:** Each `scale_color_bfh()` creates a new `colorRampPalette()` function
- **With caching:** Palette function created once per palette+reverse combination
- **Impact:** Faster plot rendering, especially with many categorical values

#### User Experience

Caching makes BFHtheme feel **instant and responsive** rather than sluggish, especially when:
- Creating multiple plots in a session
- Using RMarkdown/Quarto with many figures
- Interactive exploration with Shiny apps
- Building reports with consistent theming

---

### Font Caching

**Location:** `R/fonts.R`
**Cache environment:** `.bfh_font_cache`
**Primary function:** `get_bfh_font()`

#### How Font Caching Works

```r
# Package-level cache environment (created when package loads)
.bfh_font_cache <- new.env(parent = emptyenv())

get_bfh_font <- function(check_installed = TRUE, silent = FALSE, force_refresh = FALSE) {
  fonts <- c("Mari", "Mari Office", "Roboto", "Arial", "sans")

  if (!check_installed) {
    return(fonts[1])  # No caching needed
  }

  # Cache key (simple string)
  cache_key <- "selected_font"

  # Check cache first
  if (!force_refresh && exists(cache_key, envir = .bfh_font_cache, inherits = FALSE)) {
    cached_font <- get(cache_key, envir = .bfh_font_cache, inherits = FALSE)
    if (!silent) message("Using cached font: ", cached_font)
    return(cached_font)
  }

  # Expensive operation: Detect available fonts
  selected_font <- detect_best_font(fonts)  # Simplified

  # Store in cache for future calls
  assign(cache_key, selected_font, envir = .bfh_font_cache)

  return(selected_font)
}
```

#### Cache Key Structure

**Current implementation:**
- **Simple string:** `"selected_font"`
- **No parameters in key:** Assumes font availability doesn't change during session

**Future consideration (if needed):**
```r
# If you need to cache different results based on parameters:
cache_key <- paste0("font_", paste(fonts, collapse = "_"), "_", check_installed)
```

#### When to Clear Font Cache

Call `clear_bfh_font_cache()` after:
- ✅ Installing new fonts (Mari, Roboto, etc.)
- ✅ Uninstalling fonts
- ✅ Modifying system font configuration
- ✅ Testing font detection logic

```r
# Example: After installing Roboto
install.packages("showtext")
library(showtext)
font_add_google("Roboto", "Roboto")

# Clear cache so next call detects Roboto
clear_bfh_font_cache()

# Now Roboto will be detected
get_bfh_font()
```

#### Bypassing Cache (Force Refresh)

Use `force_refresh = TRUE` for one-time cache bypass:
```r
# Bypass cache without clearing it
font <- get_bfh_font(force_refresh = TRUE)
```

---

### Palette Caching

**Location:** `R/colors.R`
**Cache environment:** `.bfh_pal_cache`
**Primary function:** `bfh_pal()`

#### How Palette Caching Works

```r
# Package-level cache environment
.bfh_pal_cache <- new.env(parent = emptyenv())

bfh_pal <- function(palette = "main", reverse = FALSE, ...) {
  # Validation
  palette <- validate_palette_argument(palette)
  reverse <- validate_logical_argument(reverse, "reverse")

  # Cache key combines palette name and reverse flag
  cache_key <- paste0(palette, "_", reverse)

  # Check cache first
  if (exists(cache_key, envir = .bfh_pal_cache, inherits = FALSE)) {
    return(get(cache_key, envir = .bfh_pal_cache, inherits = FALSE))
  }

  # Create palette function (expensive)
  pal <- bfh_palettes[[palette]]
  if (reverse) pal <- rev(pal)

  pal_fn <- grDevices::colorRampPalette(pal, ...)

  # Store in cache
  assign(cache_key, pal_fn, envir = .bfh_pal_cache)

  return(pal_fn)
}
```

#### Cache Key Structure

**Current implementation:**
```r
cache_key <- paste0(palette, "_", reverse)

# Examples:
# "main_FALSE"         → bfh_pal("main")
# "main_TRUE"          → bfh_pal("main", reverse = TRUE)
# "blues_FALSE"        → bfh_pal("blues")
# "hospital_blues_TRUE" → bfh_pal("hospital_blues", reverse = TRUE)
```

**Why include reverse in key:**
- Different `reverse` values produce different palette functions
- Must cache separately to return correct results

**⚠️ Known limitation:**
- Additional arguments via `...` are **NOT** included in cache key
- If you call `bfh_pal("main", alpha = TRUE)` and then `bfh_pal("main")`, the second call returns the cached version **with alpha** (potentially unexpected)

**Solution if `...` args become important:**
```r
# Future-proof cache key if needed
cache_key <- paste0(
  palette, "_",
  reverse, "_",
  digest::digest(list(...))  # Hash of additional arguments
)
```

#### When to Clear Palette Cache

Call `clear_bfh_pal_cache()` after:
- ✅ Modifying `bfh_palettes` list (during development)
- ✅ Changing palette definitions
- ✅ Testing palette generation logic
- ❌ **Not needed** during normal package use

```r
# Example: After modifying palettes during development
bfh_palettes$new_palette <- c("#007dbb", "#009ce8", "#cce5f1")

# Clear cache so next call uses new palette
clear_bfh_pal_cache()

# Now new_palette is available
pal <- bfh_pal("new_palette")
```

---

### Extending the Caching System

When adding new cached operations, follow these patterns:

#### 1. Create Package-Level Cache Environment

```r
# At top of R/your_file.R
.your_cache <- new.env(parent = emptyenv())
```

#### 2. Design Cache Key

**Principles:**
- Include **all parameters that affect the result**
- Use **simple string concatenation** for readability
- Use **consistent separators** (underscore `_` is standard)
- Consider **hash functions** for complex objects

**Examples:**
```r
# Simple: Single parameter
cache_key <- palette_name

# Moderate: Multiple parameters
cache_key <- paste0(theme, "_", size, "_", variant)

# Complex: Hash of list
cache_key <- digest::digest(list(theme, options, data))
```

#### 3. Implement Cache Check Pattern

```r
your_function <- function(param1, param2, force_refresh = FALSE) {
  # Build cache key
  cache_key <- paste0(param1, "_", param2)

  # Check cache (unless force_refresh)
  if (!force_refresh && exists(cache_key, envir = .your_cache, inherits = FALSE)) {
    return(get(cache_key, envir = .your_cache, inherits = FALSE))
  }

  # Expensive operation
  result <- expensive_computation(param1, param2)

  # Store in cache
  assign(cache_key, result, envir = .your_cache)

  return(result)
}
```

#### 4. Provide Cache Clear Function

```r
#' Clear Your Feature Cache
#'
#' @return Invisibly returns TRUE
#' @export
clear_your_cache <- function() {
  rm(list = ls(envir = .your_cache), envir = .your_cache)
  message("Your cache cleared")
  invisible(TRUE)
}
```

#### 5. Document Caching Behavior

In roxygen documentation:
```r
#' @details
#' Results are cached in the package environment; use [clear_your_cache()]
#' or set `force_refresh = TRUE` after modifying underlying data.
```

---

### Cache Lifecycle

**Cache creation:**
- Environments created when package loads (`.onLoad()`)
- Empty at package load time

**Cache population:**
- Happens **lazily** on first function call
- Each unique cache key populated independently

**Cache persistence:**
- Lasts for **entire R session**
- Cleared when R session ends
- **Not** saved between sessions

**Cache invalidation:**
- Manual: Call `clear_*_cache()` functions
- Force refresh: Use `force_refresh = TRUE` parameter
- Restart R session: Clears all caches

---

### Testing with Caches

#### Clear Caches in Test Setup

```r
test_that("function works with clean cache", {
  # Clear cache before test
  clear_bfh_font_cache()
  clear_bfh_pal_cache()

  # Now test with fresh state
  result <- get_bfh_font()
  expect_type(result, "character")
})
```

#### Test Cache Behavior

```r
test_that("font cache speeds up subsequent calls", {
  clear_bfh_font_cache()

  # First call populates cache
  time1 <- system.time(font1 <- get_bfh_font(silent = TRUE))

  # Second call uses cache (should be faster)
  time2 <- system.time(font2 <- get_bfh_font(silent = TRUE))

  expect_identical(font1, font2)
  expect_lt(time2["elapsed"], time1["elapsed"])
})
```

#### Test Force Refresh

```r
test_that("force_refresh bypasses cache", {
  clear_bfh_font_cache()

  # Populate cache
  font1 <- get_bfh_font(silent = TRUE)

  # Force refresh should re-detect
  font2 <- get_bfh_font(force_refresh = TRUE, silent = TRUE)

  expect_identical(font1, font2)
})
```

---

### Performance Considerations

#### When to Add Caching

**Good candidates:**
- ✅ File system operations (font detection, logo path resolution)
- ✅ Complex computations (palette interpolation, color conversions)
- ✅ External system queries (font availability, package checks)
- ✅ Operations called repeatedly with same arguments

**Poor candidates:**
- ❌ Fast operations (< 1ms)
- ❌ Operations with unique arguments each time
- ❌ Operations with side effects
- ❌ Operations requiring fresh data

#### Cache Size Management

**Current caches are small:**
- Font cache: 1 entry (`"selected_font"`)
- Palette cache: ~20-30 entries (palette × reverse combinations)
- Memory impact: Negligible (< 1 KB total)

**If cache grows large:**
```r
# Add size limit to cache function
if (length(ls(envir = .your_cache)) > 100) {
  # Clear oldest entries or implement LRU
  warning("Cache size exceeded limit, clearing cache")
  clear_your_cache()
}
```

---

### Checklist: Adding New Cached Function

When implementing a new cached operation:

- [ ] Create package-level cache environment (`.your_cache`)
- [ ] Design cache key that includes **all** relevant parameters
- [ ] Implement cache check with `exists()` and `get()`
- [ ] Add `force_refresh` parameter for cache bypass
- [ ] Store result with `assign()`
- [ ] Create `clear_your_cache()` function
- [ ] Export clear function with `@export`
- [ ] Document caching behavior in roxygen `@details`
- [ ] Write tests for cache hit/miss scenarios
- [ ] Add cache clear to test setup/teardown
- [ ] Update this documentation with new cache details

---

### Available Cache Functions

**Font caching:**
```r
clear_bfh_font_cache()  # Defined in R/fonts.R
```

**Palette caching:**
```r
clear_bfh_pal_cache()   # Defined in R/colors.R
```

**Clear all caches:**
```r
# Helper function (add if useful)
clear_all_bfh_caches <- function() {
  clear_bfh_font_cache()
  clear_bfh_pal_cache()
  invisible(TRUE)
}
```

---

## Development Workflow

BFHtheme follows **Test-Driven Development (TDD)** principles:

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

**Branch naming conventions:**
- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation changes
- `test/` - Test additions or modifications

### 2. Write Tests First

Before implementing any feature or fix:

```r
# Create or modify test file in tests/testthat/
# Example: tests/testthat/test-your-feature.R

test_that("your feature works correctly", {
  result <- your_function(input)
  expect_equal(result, expected_output)
})
```

### 3. Implement the Feature

Write minimal code to make tests pass:

```r
# In R/your-file.R
your_function <- function(input) {
  # Implementation
}
```

### 4. Run Tests Continuously

```r
# Run all tests
devtools::test()

# Run specific test file
testthat::test_file("tests/testthat/test-your-feature.R")

# Check entire package
devtools::check()
```

### 5. Document Your Code

Update roxygen comments and regenerate documentation:

```r
devtools::document()
```

### 6. Code Quality Checks

```r
# Format code
styler::style_pkg()

# Lint code
lintr::lint_package()

# Check code coverage
covr::package_coverage()
```

---

## Code Style Guidelines

### Naming Conventions

- **Functions**: `snake_case`
- **Arguments**: `snake_case`
- **Objects/Variables**: `snake_case`
- **Internal functions**: Prefix with `.` (e.g., `.resolve_base_family`)

```r
# ✅ Good
theme_bfh <- function(base_size = 12, base_family = NULL) { }

# ❌ Bad
themeBFH <- function(baseSize = 12, baseFamily = NULL) { }
```

### Comments

- **Danish comments** for internal documentation
- **English** for exported function documentation (roxygen2)

```r
# Danske kommentarer for intern logik
.resolve_base_family <- function(base_family) {
  base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)
}

#' BFH Theme for ggplot2
#'
#' English documentation for exported functions
#' @export
theme_bfh <- function() { }
```

### Defensive Programming

Always validate inputs for exported functions:

```r
theme_bfh <- function(base_size = 12, base_family = NULL, ...) {
  # Input validation
  if (!is.numeric(base_size) || base_size <= 0) {
    stop("base_size must be a positive number", call. = FALSE)
  }

  # NULL coalescing with %||% operator
  base_family <- base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)

  # ... implementation
}
```

### NULL Handling

Use the `%||%` operator (defined in `utils_operators.R`):

```r
# ✅ Good - use %||% for defaults
base_family <- base_family %||% get_bfh_font()
text <- text %||% "Default text"

# ❌ Bad - missing fallback
base_family <- base_family
```

### ggplot2 Patterns

```r
# ✅ Good - Return ggplot objects for composition
create_plot <- function(data) {
  ggplot(data, aes(x = x, y = y)) +
    geom_line() +
    theme_bfh()
}

# ❌ Bad - Don't print inside functions
create_plot <- function(data) {
  plot <- ggplot(data, aes(x = x, y = y)) + geom_line()
  print(plot)  # DON'T DO THIS
}
```

---

## Testing

### Test Structure

Tests are organized in `tests/testthat/` by module:

- `test-themes.R` - Theme functions
- `test-colors.R` - Color palettes
- `test-scales.R` - Scale functions
- `test-fonts.R` - Font detection
- `test-helpers.R` - Plot helpers
- `test-branding.R` - Logo and branding
- `test-defaults.R` - Global defaults

### Writing Tests

```r
test_that("function handles valid input correctly", {
  # Arrange
  input <- valid_data

  # Act
  result <- your_function(input)

  # Assert
  expect_type(result, "character")
  expect_length(result, 5)
})

test_that("function validates input parameters", {
  # Act & Assert
  expect_error(
    your_function(invalid_input),
    "Expected error message"
  )
})
```

### Running Tests

```r
# All tests
devtools::test()

# Specific test file
testthat::test_file("tests/testthat/test-colors.R")

# With coverage report
covr::package_coverage()
```

### Coverage Goals

- **≥90% overall coverage** (current: 89.74%)
- **100% on exported functions**
- **Edge cases**: NULL inputs, empty data, invalid types
- **Security tests**: Path traversal, input validation

### Test Best Practices

1. Test one thing per test
2. Use descriptive test names
3. Include both positive and negative test cases
4. Test edge cases and error conditions
5. Use `skip_if_not_installed()` for optional dependencies

```r
test_that("add_bfh_logo requires ggplot2", {
  skip_if_not_installed("ggplot2")

  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
  result <- add_bfh_logo(p, get_bfh_logo())

  expect_s3_class(result, "ggplot")
})
```

---

## Documentation

### Roxygen2 Format

All exported functions must have complete roxygen documentation:

```r
#' Short Title (One Line)
#'
#' @description
#' Detailed description of what the function does, when to use it,
#' and any important details about behavior.
#'
#' @param param_name Description of parameter, including type and valid values
#' @param another_param Another parameter description
#'
#' @return Description of what is returned, including type
#'
#' @export
#'
#' @examples
#' # Example with comments
#' result <- my_function(x = 1:10)
#'
#' # More complex example
#' result2 <- my_function(x = data, param = "value")
#'
#' \dontrun{
#' # Example requiring external data
#' my_function(data = external_data)
#' }
my_function <- function(param_name, another_param = NULL) {
  # Implementation
}
```

### Required Roxygen Tags

- `@description` - Detailed function description
- `@param` - For each parameter
- `@return` - What the function returns
- `@export` - For exported functions
- `@examples` - Working examples
- `@importFrom` - For imported functions from other packages

### Update Documentation

After modifying roxygen comments:

```r
# Regenerate documentation and NAMESPACE
devtools::document()

# Verify documentation builds without errors
devtools::check_man()
```

### Vignettes

For major features, consider adding a vignette:

```r
# Create new vignette
usethis::use_vignette("your-feature-name")
```

---

## Commit Guidelines

### Commit Message Format

```
type(scope): short action-oriented description

Optional longer description providing context and rationale.

- Bullet points for multiple changes
- Breaking changes marked explicitly
```

### Commit Types

- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code refactoring (no behavior change)
- `test` - Adding or modifying tests
- `docs` - Documentation changes
- `chore` - Maintenance tasks
- `perf` - Performance improvements

### Examples

```bash
# Good commit messages
git commit -m "feat(themes): add custom theme styling option"
git commit -m "fix(colors): resolve bfh_cols() zero-argument bug"
git commit -m "test(fonts): add coverage for extrafont fallback path"
git commit -m "docs(readme): update installation instructions"

# Bad commit messages
git commit -m "update code"
git commit -m "fix bug"
git commit -m "changes"
```

### Important Commit Rules

**DO NOT include:**
- ❌ "🤖 Generated with [Claude Code]"
- ❌ "Co-Authored-By: Claude <noreply@anthropic.com>"
- ❌ Other AI attribution footers

These should only be used when explicitly requested by maintainers.

---

## Pull Request Process

### Before Submitting

Complete this checklist:

- [ ] All tests pass (`devtools::test()`)
- [ ] Package check passes (`devtools::check()`)
- [ ] Code is formatted (`styler::style_pkg()`)
- [ ] Code is linted (`lintr::lint_package()`)
- [ ] Documentation is updated (`devtools::document()`)
- [ ] Examples are verified and working
- [ ] NAMESPACE is regenerated (via `devtools::document()`)
- [ ] Coverage is maintained or improved

### Creating a Pull Request

1. **Push your branch:**

```bash
git push origin feature/your-feature-name
```

2. **Create PR on GitHub:**
   - Go to https://github.com/johanreventlow/BFHtheme
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template

3. **PR Description Template:**

```markdown
## Summary
Brief description of changes

## Motivation
Why this change is needed

## Changes
- List of specific changes
- Include breaking changes if any

## Testing
How the changes were tested

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Code formatted and linted
```

### PR Review Process

- Maintainers will review your PR
- Address any feedback or requested changes
- Tests must pass before merging
- At least one maintainer approval required

---

## Review Checklist

When reviewing code (or self-reviewing before submission):

### Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled
- [ ] Error messages are informative
- [ ] No breaking changes to existing API (unless discussed)

### Code Quality
- [ ] Follows snake_case naming convention
- [ ] Input validation for exported functions
- [ ] NULL safety using `%||%` operator
- [ ] No hardcoded values (use constants/parameters)
- [ ] DRY principle followed (no unnecessary duplication)

### Testing
- [ ] Tests are comprehensive
- [ ] Tests cover edge cases
- [ ] Tests include error conditions
- [ ] Coverage maintained or improved (≥90%)

### Documentation
- [ ] Roxygen documentation complete
- [ ] Examples are working and useful
- [ ] README updated if needed
- [ ] Vignettes updated if applicable

### Performance
- [ ] No obvious performance issues
- [ ] Efficient algorithms used
- [ ] Caching used where appropriate

### Security
- [ ] Input validation prevents path traversal
- [ ] No hardcoded credentials or sensitive data
- [ ] File operations use safe paths

---

## Additional Resources

### Package Development
- [R Packages book](https://r-pkgs.org/)
- [ggplot2 documentation](https://ggplot2.tidyverse.org/)
- [testthat documentation](https://testthat.r-lib.org/)

### BFHtheme Specific
- [CLAUDE.md](CLAUDE.md) - Detailed development instructions
- [README.md](README.md) - Package overview and usage
- [FONTS.md](FONTS.md) - Font system documentation
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues

### Getting Help

- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/johanreventlow/BFHtheme/issues)
- **Discussions**: Ask questions in GitHub Discussions
- **Email**: Contact the maintainers directly

---

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Focus on what's best for the project and community
- Accept constructive criticism gracefully
- Show empathy towards other contributors

### Our Responsibilities

Maintainers are responsible for clarifying standards of acceptable behavior and will take appropriate action in response to any unacceptable behavior.

---

## License

By contributing to BFHtheme, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to BFHtheme! Your efforts help make healthcare data visualization more accessible and professional.

# Claude Instructions – BFHtheme

> ## ⚠️ BOOTSTRAP REQUIRED
>
> **Læs først:** `~/.claude/rules/CLAUDE_BOOTSTRAP_WORKFLOW.md`
>
> Denne fil instruerer hvilke globale standarder der skal læses baseret på projekttype.

---

## 1) Project Overview

- **Project Type:** R Package
- **Purpose:** ggplot2 theming og branding package for Bispebjerg og Frederiksberg Hospital samt Region Hovedstaden. Beautiful defaults, publication-ready output og multi-organizational branding support.
- **Status:** Production

**Technology Stack:**
- ggplot2 (theme framework)
- marquee (advanced text rendering)
- grid/grDevices (logo placement, branding)
- systemfonts/extrafont (font detection)

---

## 2) Project-Specific Architecture

### Package Structure

```
BFHtheme/
├── R/
│   ├── themes.R              # ggplot2 theme functions
│   ├── colors.R              # Color palettes and helpers
│   ├── scales.R              # ggplot2 scale functions
│   ├── fonts.R               # Font detection with session caching
│   ├── helpers.R             # Plot helpers (save, combine, labs)
│   ├── branding.R            # Logo and branding functions
│   ├── logo_helpers.R        # Logo path resolvers
│   ├── defaults.R            # Global defaults management
│   ├── utils_operators.R     # Internal operators (%||%)
│   └── BFHtheme-package.R    # Package documentation
├── inst/logos/               # Hospital logos (BFH, Region H)
├── tests/testthat/           # Unit tests
├── vignettes/                # Long-form documentation
└── man/                      # Auto-generated documentation
```

### Core Components

**Themes:**
- `theme_bfh()` - Main professional theme
- `theme_bfh_minimal()` - Minimal variant
- `theme_bfh_dark()` - Dark mode variant
- `theme_region_h()` - Region Hovedstaden theme

**Colors:**
- `bfh_colors` - Named color list (28 colors)
- `bfh_palettes` - Curated palettes (main, secondary, accent, blues, greens, etc.)
- `bfh_cols()` - Color accessor function
- `bfh_pal()` - Palette generator

**Branding:**
- `add_bfh_logo()` - Add hospital logo to plots
- `add_bfh_footer()` - Add branded footer
- `bfh_title_block()` - Create branded title blocks
- `get_bfh_logo()` - Resolve logo paths

### Font Auto-Detection with Caching

**Session-level caching (10-15x speedup):**

```r
# Package-level cache environment
.bfh_font_cache <- new.env(parent = emptyenv())

# Cache pattern
get_bfh_font <- function(fonts = c("Mari", "Roboto", "Arial"),
                         check_installed = FALSE,
                         silent = FALSE) {
  cache_key <- paste0(fonts, check_installed, collapse = "_")

  # Check cache
  if (exists(cache_key, envir = .bfh_font_cache, inherits = FALSE)) {
    return(get(cache_key, envir = .bfh_font_cache, inherits = FALSE))
  }

  # Detect and cache
  selected_font <- .detect_font(fonts, check_installed, silent)
  assign(cache_key, selected_font, envir = .bfh_font_cache)

  return(selected_font)
}
```

### NULL Coalescing Pattern

**VIGTIGT:** Package bruger `%||%` operator defineret i `utils_operators.R`:

```r
# Definition
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

# Usage throughout package
base_family <- base_family %||% get_bfh_font()
text <- text %||% "Default text"
width <- width %||% dims$width
```

Dette er standard R pattern (brugt i rlang, purrr).

---

## 3) Critical Project Constraints

### Do NOT Modify

- **Exported function signatures** - Breaking changes kræver major version bump
- **NAMESPACE** - Auto-generated via `devtools::document()`, ALDRIG manuel edit
- **Color hex values** - Officielle hospital farver, kræver godkendelse
- **Logo files** - Brand assets, koordinér med kommunikationsafdeling

### Breaking Changes Policy

**Kræver:**
- Major version bump (semver)
- Deprecation warnings i minor version først
- Migration guide
- Notification til downstream packages (BFHcharts, SPCify)

### Security Considerations

**Path Traversal Protection:**

```r
# KRITISK: Validér paths i file loading functions
add_bfh_logo <- function(plot, logo_path, ...) {
  # Block path traversal patterns
  if (grepl("\\.\\.", logo_path) || grepl("^~", logo_path)) {
    stop("Path traversal patterns (.., ~) not allowed", call. = FALSE)
  }

  # Normalize and validate
  normalized_path <- tryCatch(
    normalizePath(logo_path, mustWork = FALSE),
    error = function(e) stop("Invalid file path provided", call. = FALSE)
  )

  if (!file.exists(normalized_path)) {
    stop("Logo file not found", call. = FALSE)
  }

  # ... rest of implementation
}
```

**Input Validation Pattern:**

```r
# Comprehensive validation for all exported functions
validate_palette <- function(palette) {
  if (!is.character(palette) || length(palette) != 1 || nchar(palette) == 0) {
    stop("palette must be a non-empty character string", call. = FALSE)
  }
}

validate_size <- function(size) {
  if (!is.numeric(size) || size <= 0 || size > 1) {
    stop("size must be between 0 and 1 (exclusive of 0)", call. = FALSE)
  }
}

validate_logical <- function(value, name) {
  if (!is.logical(value) || length(value) != 1 || is.na(value)) {
    stop(paste(name, "must be TRUE or FALSE"), call. = FALSE)
  }
}
```

---

## 4) Cross-Repository Coordination

### Integration with Downstream Packages

**BFHtheme provides theming infrastructure for:**
- **BFHcharts** - SPC chart visualization package
- **SPCify** - Shiny application for SPC analysis

**Responsibility Boundaries:**

**BFHtheme ansvar:**
- ggplot2 themes
- Color palettes
- Font detection
- Logo/branding helpers
- Publication-ready defaults

**Downstream package ansvar:**
- Chart-specific rendering (BFHcharts)
- User interface (SPCify)
- Data processing
- Application logic

### Communication Channel

**For feature requests fra downstream:**
1. Opret issue i BFHtheme repo
2. Label: `enhancement`, `from-bfhcharts`, eller `from-spcify`
3. Reference downstream use case
4. Diskutér API design før implementation

---

## 5) Project-Specific Configuration

### API Design Principles

**Consistent Interface:**

```r
# Themes
theme_bfh(base_size = 12, base_family = NULL, ...)

# Colors
bfh_cols(...) # Specific colors or all if no args
bfh_pal(palette = "main", reverse = FALSE, ...)

# Scales
scale_color_bfh(palette = "main", discrete = TRUE, reverse = FALSE, ...)
scale_fill_bfh(palette = "main", discrete = TRUE, reverse = FALSE, ...)

# Branding
add_bfh_logo(plot, logo_path, position = "topright", size = 0.1, ...)
```

**Composability:**

```r
# Themes return ggplot2 theme objects
p <- ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh() +
  scale_color_bfh(palette = "main") +
  labs(title = "Custom Title")

# Add branding
p <- add_bfh_logo(p, get_bfh_logo(size = "web", variant = "color"))
```

**Graceful Defaults:**
- Auto-detect fonts med fallback til "sans"
- Return all colors hvis ingen specifikke requested
- Session-level font caching for performance

### Development Commands

```r
# Development workflow
devtools::load_all()           # Load package for testing
devtools::document()           # Generate docs + NAMESPACE
devtools::test()               # Run all tests (323 tests)
devtools::check()              # Full package check

# Code quality
styler::style_pkg()            # Format code
lintr::lint_package()          # Lint code

# Testing
testthat::test_file("tests/testthat/test-colors.R")
covr::package_coverage()       # Current: 89.74%, target: ≥90%

# Documentation
devtools::build_vignettes()
# pkgdown::build_site()        # (future)
```

---

## 6) Domain-Specific Guidance

### ggplot2 Best Practices

**Layer Composition:**

```r
# ✅ Korrekt: Build incrementally
base_plot <- ggplot(data, aes(x = x, y = y)) +
  geom_line() +
  theme_bfh()

enhanced_plot <- base_plot +
  scale_color_bfh() +
  labs(title = "Title")

# ❌ Forkert: Massive nested calls
ggplot(...) + geom_line(...) + theme_bfh(...) + scale_color_bfh(...) + ...
```

**Theme Design Pattern:**

```r
# Themes skal returnere theme() objects
theme_bfh <- function(base_size = 12, base_family = NULL, ...) {
  # Auto-detect font if not specified
  base_family <- base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)

  theme_minimal(
    base_size = base_size,
    base_family = base_family,
    ...
  ) +
  theme(
    plot.title = marquee::element_marquee(
      size = base_size * 1.3,
      hjust = 0,
      margin = margin(b = base_size * 0.5)
    ),
    axis.title = element_text(size = base_size * 1.1),
    # ... more theme elements
  )
}
```

**Color Palette Pattern:**

```r
# ✅ Korrekt: Use package functions
bfh_cols("hospital_primary", "hospital_blue")

# Use in ggplot2
ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  scale_color_bfh(palette = "main")

# ❌ Forkert: Hardcode hex values
colors <- c("#007dbb", "#009ce8")  # Use bfh_cols() instead
```

### Testing Strategy

**Coverage Goals:**
- **≥90% samlet coverage** (current: 89.74%)
- **100% på exported functions**
- **Edge cases** - NULL inputs, empty data, invalid types, path traversal
- **Integration tests** - Full workflow theme → plot → save

**Test Patterns:**

```r
# Unit tests
test_that("bfh_cols returns all colors when no arguments provided", {
  result <- bfh_cols()

  expect_type(result, "character")
  expect_length(result, 28)
  expect_true(all(grepl("^#[0-9a-fA-F]{6}$", result)))
})

# Security tests
test_that("add_bfh_logo blocks path traversal attempts", {
  skip_if_not_installed("ggplot2")

  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()

  expect_error(add_bfh_logo(p, "../../../etc/passwd"))
  expect_error(add_bfh_logo(p, "~/logo.png"))
  expect_error(add_bfh_logo(p, "..\\..\\Windows\\System32\\config\\SAM"))
})

# Visual regression tests (MANGLER - prioriteret)
test_that("theme_bfh produces consistent visual output", {
  skip_if_not_installed("vdiffr")
  skip_if_not_installed("ggplot2")

  data <- data.frame(x = 1:10, y = rnorm(10))
  plot <- ggplot(data, aes(x, y)) + geom_line() + theme_bfh()

  vdiffr::expect_doppelganger("theme_bfh_basic", plot, writer = "svg")
})
```

### Known Issues & Technical Debt

**High Priority:**
1. **Coverage gaps:**
   - `R/fonts.R`: 72.90% - extrafont fallback path untested
   - `R/logo_helpers.R`: 77.42% - grey/mark variants untested
   - `R/branding.R`: 86.36% - JPEG support untested

2. **Missing features:**
   - Visual regression tests (vdiffr) - ingen implementeret
   - MIME validation i `add_bfh_logo()` - kun file extension check
   - Placeholder function `check_colorblind_safe()` - gør ingenting

3. **Code quality:**
   - Validation duplication i `scales.R` - 84 linjer duplikeret
   - Commented code i `themes.R:72`, `fonts.R:35` - skal fjernes/dokumenteres

### Danish Language

- **Function names:** Engelsk
- **Function documentation:** Engelsk
- **Internal comments:** Dansk
- **Error messages:** Engelsk (standard for R packages)

**Exports:**
- `theme_bfh()` ikke `tema_bfh()`
- `add_bfh_logo()` ikke `tilfoej_bfh_logo()`

---

## 📚 Global Standards Reference

**Dette projekt følger:**
- **R Development:** `~/.claude/rules/R_STANDARDS.md`
- **Architecture Patterns:** `~/.claude/rules/ARCHITECTURE_PATTERNS.md`
- **Git Workflow:** `~/.claude/rules/GIT_WORKFLOW.md`
- **Development Philosophy:** `~/.claude/rules/DEVELOPMENT_PHILOSOPHY.md`
- **Troubleshooting:** `~/.claude/rules/TROUBLESHOOTING_GUIDE.md`

**Globale agents:** tidyverse-code-reviewer, performance-optimizer, security-reviewer, test-coverage-analyzer, refactoring-advisor, legacy-code-detector, r-package-code-reviewer

**Globale commands:** /bootstrap, /debugger

---

**Original documentation:** Detaljeret dokumentation (12 sektioner, appendices) gemt som backup hvis nødvendigt.

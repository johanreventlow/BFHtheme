# Claude Instruktioner – BFHtheme

## 1) Projektoversigt

**BFHtheme** er en R package til **ggplot2 theming og branding** for Bispebjerg og Frederiksberg Hospital samt Region Hovedstaden. Pakken leverer beautiful defaults, publication-ready output og multi-organizational branding support.

**Formål:**
- Professional ggplot2 themes optimeret for healthcare visualiseringer
- Officielle farvepaletter for BFH og Region H
- Branding helpers (logo, footer, color bars)
- Font auto-detection med session-level caching
- Publication-ready defaults uden manuel styling

**Udviklingsstatus:** Production-ready R package med test-driven development, defensive programming og stabil API.

---

## 2) Udviklingsprincipper

### 2.1 Test-First Development (TDD)

✅ **OBLIGATORISK:** Al udvikling følger TDD:

1. Skriv tests først
2. Kør tests kontinuerligt – skal altid bestå
3. Refactor med test-sikkerhed
4. Ingen breaking changes uden eksplicit godkendelse

**Test-kommandoer:**
```r
# Alle tests
devtools::test()

# Specifik test-fil
testthat::test_file("tests/testthat/test-*.R")

# Check package
devtools::check()

# Code coverage
covr::package_coverage()
```

**Nuværende status:**
- 323 passing tests
- 89.74% coverage (mål: ≥90%)
- 0 errors, 3 warnings (acceptable), 2 notes

### 2.2 Defensive Programming

* **Input validation** ved exported functions
* **Error handling** via `tryCatch()` med informative messages
* **Type checking** med `stopifnot()`, `is.*()` checks
* **Graceful degradation** med fallback defaults
* **NULL safety** – eksplicit NULL-håndtering med `%||%` operator

```r
# Eksempel: Input validation pattern
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

### 2.3 Git Workflow (OBLIGATORISK)

✅ **KRITISKE REGLER:**

1. **ALDRIG merge til main uden eksplicit godkendelse**
2. **ALDRIG push til remote uden anmodning**
3. **STOP efter feature branch commit – vent på instruktioner**
4. **Do NOT add Claude co-authorship footer to commits**

**Workflow:**
```bash
git checkout -b fix/feature-name
# ... arbejd og commit ...
git commit -m "beskrivelse"
# STOP - vent på instruktion
```

**VIGTIGT:** Commit messages skal IKKE indeholde:
- ❌ "🤖 Generated with [Claude Code]"
- ❌ "Co-Authored-By: Claude <noreply@anthropic.com>"
- ❌ Andre Claude attribution footers

Undtagelse: Simple operationer (`git status`, `git diff`, `git log`)

### 2.3.1 Windows Environment & GitHub API Integration

**Når du arbejder på Windows uden direkte GitHub CLI adgang:**

GitHub CLI (`gh`) er ofte ikke tilgængelig på managed Windows systemer (IT-administreret). I stedet bruges **GitHub REST API via curl** til issue management.

**Setup (én gang):**
```bash
# Gem GitHub Personal Access Token i git config
git config --global github.token ghp_YOUR_TOKEN_HERE
```

**GitHub API Operationer:**

```bash
# Hent token fra config
GITHUB_TOKEN=$(git config --global github.token)

# Hent issue information
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/johanreventlow/BFHtheme/issues/25

# Kommenter på issue
curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/johanreventlow/BFHtheme/issues/25/comments \
  -d '{"body":"Issue resolved message"}'

# Luk issue
curl -s -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/johanreventlow/BFHtheme/issues/25 \
  -d '{"state":"closed"}'
```

**Git Workflow på Windows:**

```bash
# Standard git operationer fungerer normalt via Bash tool
git status
git checkout -b feature/branch-name
git add file.R
git commit -m "beskrivelse"
git push -u origin feature/branch-name

# Merge workflow (efter godkendelse)
git checkout main
git pull origin main
git merge feature/branch-name --no-edit
git push origin main
```

**Vigtigt:**
- Git virker via standard bash kommandoer
- GitHub CLI (`gh`) er IKKE tilgængelig - brug curl + GitHub API i stedet
- Token skal gemmes i git config for at kunne genbruges
- Alle git operationer skal bruge Bash tool (IKKE find, grep, cat - brug dedikerede tools til det)

### 2.4 Code Quality Standards

* **Danske kommentarer**, engelske funktionsnavne
* **snake_case** for all funktioner og objekter
* **Roxygen2 documentation** for all exported functions
* **Type safety**: eksplicit type checks før operationer
* **`lintr`** via `devtools::lint()` før commits
* **`styler`** for consistent formatting

### 2.5 Architecture Principles

* **Single Responsibility** – én opgave pr. funktion
* **Immutable patterns** – returnér nye ggplot objects, modificér ikke in-place
* **Composition over complexity** – byg komplekse plots fra simple layers
* **Minimal dependencies** – kun tilføj dependencies hvis strengt nødvendigt
* **Session-level caching** – font detection caches for performance (10-15x speedup)

---

## 3) Package Development Best Practices

### 3.1 R Package Structure

**Faktisk file organization i `/R/`:**
* `themes.R` – ggplot2 theme functions (theme_bfh, theme_bfh_minimal, theme_bfh_dark, etc.)
* `colors.R` – Color palettes og helpers (bfh_colors, bfh_palettes, bfh_cols)
* `scales.R` – ggplot2 scale functions (scale_color_bfh, scale_fill_bfh)
* `fonts.R` – Font detection og caching (get_bfh_font, check_bfh_fonts)
* `helpers.R` – Plot helpers (bfh_save, bfh_combine_plots, bfh_labs, add_bfh_color_bar)
* `branding.R` – Logo og branding (add_bfh_logo, add_bfh_footer, bfh_title_block)
* `logo_helpers.R` – Logo path resolvers (get_bfh_logo, add_logo)
* `defaults.R` – Global defaults (set_bfh_defaults, reset_bfh_defaults)
* `utils_operators.R` – Internal operators (%||%)
* `BFHtheme-package.R` – Package documentation

### 3.2 Function Design Patterns

**Exported functions:**
```r
#' BFH Theme for ggplot2
#'
#' A clean, professional theme optimized for healthcare visualizations.
#' Based on theme_minimal with custom typography and spacing.
#'
#' @param base_size Base font size (default: 12)
#' @param base_family Font family. If NULL, auto-detects BFH fonts (Mari, Roboto, Arial)
#' @param base_line_size Base line size (default: base_size/22)
#' @param base_rect_size Base rectangle size (default: base_size/22)
#'
#' @return A ggplot2 theme object
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_bfh()
theme_bfh <- function(base_size = 12,
                      base_family = NULL,
                      base_line_size = base_size / 22,
                      base_rect_size = base_size / 22) {
  # Implementation
}
```

**Internal utilities (ikke exported):**
```r
# Danske kommentarer for interne funktioner
# Resolver base font family with auto-detection
.resolve_base_family <- function(base_family) {
  base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)
}
```

### 3.3 ggplot2 Best Practices

**Layer composition:**
```r
# ✅ Korrekt: Build plot incrementally
base_plot <- ggplot(data, aes(x = x, y = y)) +
  geom_line() +
  theme_bfh()

enhanced_plot <- base_plot +
  scale_color_bfh() +
  bfh_labs(title = "Plot Title", x = "x-axis", y = "y-axis")

# ❌ Forkert: Massive nested calls
ggplot(...) + geom_line(...) + theme_bfh(...) + scale_color_bfh(...) + labs(...) + ...
```

**Theme design:**
```r
# Themes skal returnere theme() objects
theme_bfh <- function(base_size = 12, base_family = NULL, ...) {
  # Auto-detect font hvis ikke specificeret
  base_family <- .resolve_base_family(base_family)

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
    # ... more theme elements
  )
}
```

### 3.4 NULL Coalescing Operator

**VIGTIGT:** Pakken bruger `%||%` operator (defineret i `utils_operators.R`):

```r
# Definition
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

# Usage
base_family <- base_family %||% get_bfh_font()
text <- text %||% "Default text"
width <- width %||% dims$width
```

Dette er standard pattern i moderne R packages (rlang, purrr).

### 3.5 Dependencies & NAMESPACE

**ALDRIG ændre NAMESPACE manuelt:**
```r
# ✅ Korrekt: Lad roxygen2 håndtere NAMESPACE
#' @export
#' @importFrom ggplot2 ggplot aes theme
my_function <- function() { ... }

# Kør derefter:
devtools::document()
```

**Dependency management:**
* Brug `@importFrom pkg function` for specifikke funktioner
* Brug `pkg::function()` i kode når det giver mening
* Undgå `@import pkg` (importerer alt)
* Tilføj nye dependencies i DESCRIPTION under `Imports:` eller `Suggests:`

**Nuværende dependencies:**
```
Imports: ggplot2, grid, grDevices, marquee
Suggests: systemfonts, extrafont, showtext, png, jpeg, patchwork, scales, purrr
```

---

## 4) Testing Strategy

### 4.1 Test Organization

**Test files i `/tests/testthat/`:**
* `test-themes.R` – Tests for theme functions
* `test-colors.R` – Tests for color palettes og helpers
* `test-scales.R` – Tests for scale functions
* `test-fonts.R` – Tests for font detection og caching
* `test-helpers.R` – Tests for plot helpers
* `test-branding.R` – Tests for logo og branding functions
* `test-logo_helpers.R` – Tests for logo path resolvers
* `test-defaults.R` – Tests for global defaults

### 4.2 Test Patterns

**Unit tests:**
```r
test_that("bfh_cols returns all colors when no arguments provided", {
  # Arrange & Act
  result <- bfh_cols()

  # Assert
  expect_type(result, "character")
  expect_length(result, 28)  # Total antal farver
  expect_true(all(grepl("^#[0-9a-fA-F]{6}$", result)))  # Hex format
})

test_that("theme_bfh validates base_size parameter", {
  # Act & Assert
  expect_error(
    theme_bfh(base_size = -1),
    "base_size must be a positive number"
  )
})
```

**Security tests:**
```r
test_that("add_bfh_logo blocks path traversal attempts", {
  skip_if_not_installed("ggplot2")

  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()

  # Test path traversal patterns
  expect_error(add_bfh_logo(p, "../../../etc/passwd"))
  expect_error(add_bfh_logo(p, "~/logo.png"))
  expect_error(add_bfh_logo(p, "..\\..\\Windows\\System32\\config\\SAM"))
})
```

**Visual regression tests (vdiffr) - MANGLER:**
```r
test_that("theme_bfh produces consistent visual output", {
  skip_if_not_installed("vdiffr")
  skip_if_not_installed("ggplot2")

  # Arrange
  data <- data.frame(x = 1:10, y = rnorm(10))
  plot <- ggplot(data, aes(x, y)) + geom_line() + theme_bfh()

  # Act & Assert
  vdiffr::expect_doppelganger("theme_bfh_basic", plot, writer = "svg")
})
```

### 4.3 Coverage Goals

* **≥90% samlet coverage** (nuværende: 89.74%)
* **100% på exported functions**
* **Edge cases**: NULL inputs, empty data, invalid types, path traversal
* **Integration tests**: Full workflow fra theme → plot → save

**Coverage gaps (prioriteret):**
- `R/fonts.R`: 72.90% - extrafont fallback path mangler tests
- `R/logo_helpers.R`: 77.42% - logo variants (grey, mark) untested
- `R/branding.R`: 86.36% - JPEG support helt utestet

---

## 5) Documentation Standards

### 5.1 Roxygen2 Documentation

**Required fields for exported functions:**
```r
#' Function Title (One Line)
#'
#' @description
#' Longer description explaining what the function does, when to use it,
#' and any important details.
#'
#' @param param_name Description of parameter
#' @param another_param Description with details about expected values
#'
#' @return Description of what is returned
#'
#' @export
#'
#' @examples
#' # Commented example
#' result <- my_function(x = 1:10)
#'
#' \dontrun{
#' # Example that requires external data
#' my_function(data = my_data)
#' }
```

### 5.2 Vignettes

**Vignettes i `/vignettes/`:**
* `getting-started.Rmd` – Basic usage patterns
* `customization.Rmd` – Advanced customization options
* `theming.Rmd` – Multi-hospital branding guide

**Vignette struktur:**
```rmd
---
title: "Getting Started with BFHtheme"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Getting Started with BFHtheme}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

# Introduction

Brief introduction...

# Basic Usage

Example code...
```

### 5.3 README Updates

**Når funktionalitet ændres:**
1. Opdater eksempler i README.md
2. Verificer at eksempler kører uden fejl
3. Opdater screenshots hvis relevant

---

## 6) Workflow & Process

### 6.1 Development Lifecycle

1. **Problem definition** – Én-linje beskrivelse
2. **Test design** – Skriv failing tests
3. **Implementation** – Minimal implementation som får tests til at bestå
4. **Documentation** – Roxygen + eksempler
5. **Integration test** – Verificer i context
6. **Check package** – `devtools::check()`
7. **Commit** – Vent på godkendelse før merge

### 6.2 Pre-Commit Checklist

- [ ] Tests kørt og bestået (`devtools::test()`)
- [ ] Package check uden errors (`devtools::check()`)
- [ ] Roxygen documentation opdateret
- [ ] NAMESPACE regenereret (`devtools::document()`)
- [ ] Eksempler verificeret
- [ ] Code formateret (`styler::style_pkg()`)
- [ ] Linted (`lintr::lint_package()`)
- [ ] Manual test af ny funktionalitet

### 6.3 Commit Message Format

```
type(scope): kort handle-orienteret beskrivelse

Fritekst med kontekst og rationale.

- Bullet points for flere ændringer
- Breaking changes markeres eksplicit
```

**Typer:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`

**Branch naming:** `fix/`, `feat/`, `refactor/`, `docs/`, `test/`

---

## 7) Common Patterns & Anti-Patterns

### 7.1 ggplot2 Patterns

**✅ Korrekt:**
```r
# Return ggplot objects for composition
create_base_plot <- function(data) {
  ggplot(data, aes(x = x, y = y)) +
    geom_line() +
    theme_bfh()
}

# Users can add their own layers
plot <- create_base_plot(data) +
  geom_point() +
  labs(title = "Custom Title")
```

**❌ Forkert:**
```r
# Don't print inside functions
create_plot <- function(data) {
  plot <- ggplot(data, aes(x = x, y = y)) + geom_line()
  print(plot)  # DON'T DO THIS
}

# Don't modify global state without warning
create_plot <- function(data) {
  theme_set(theme_minimal())  # DON'T DO THIS (except in set_bfh_defaults)
  # ...
}
```

### 7.2 Color Palette Usage

**✅ Korrekt:**
```r
# Get specific colors
bfh_cols("hospital_primary", "hospital_blue")

# Get all colors
all_colors <- bfh_cols()

# Use in ggplot2
ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  scale_color_bfh(palette = "main")
```

**❌ Forkert:**
```r
# Don't hardcode hex values
colors <- c("#007dbb", "#009ce8")  # Use bfh_cols() instead
```

### 7.3 NULL Handling

**✅ Korrekt:**
```r
# Use %||% operator for defaults
base_family <- base_family %||% get_bfh_font()
text <- text %||% "Default text"

# Explicit NULL checks when needed
if (is.null(target_value)) {
  # Skip target line
} else {
  # Add target line
}
```

**❌ Forkert:**
```r
# Don't use implicit NULL behavior
base_family <- base_family  # Missing fallback!

# Don't check with is.null when c(...) is used
cols <- c(...)
if (is.null(cols)) { ... }  # WRONG! Use length(cols) == 0 instead
```

---

## 8) Security Considerations

### 8.1 Path Traversal Protection

**KRITISK:** Logo og file loading funktioner skal validere paths:

```r
# add_bfh_logo implementation pattern
add_bfh_logo <- function(plot, logo_path, ...) {
  # Security checks
  if (grepl("\\.\\.", logo_path) || grepl("^~", logo_path)) {
    stop("Path traversal patterns (.., ~) not allowed", call. = FALSE)
  }

  # Normalize path
  normalized_path <- tryCatch(
    normalizePath(logo_path, mustWork = FALSE),
    error = function(e) {
      stop("Invalid file path provided", call. = FALSE)
    }
  )

  # Verify file exists
  if (!file.exists(normalized_path)) {
    stop("Logo file not found", call. = FALSE)
  }

  # ... rest of implementation
}
```

### 8.2 Input Validation

Al input validation skal være comprehensive:

```r
# Validate string parameters
if (!is.character(palette) || length(palette) != 1 || nchar(palette) == 0) {
  stop("palette must be a non-empty character string", call. = FALSE)
}

# Validate numeric parameters with range
if (!is.numeric(size) || size <= 0 || size > 1) {
  stop("size must be between 0 and 1 (exclusive of 0)", call. = FALSE)
}

# Validate logical parameters
if (!is.logical(reverse) || length(reverse) != 1 || is.na(reverse)) {
  stop("reverse must be TRUE or FALSE", call. = FALSE)
}
```

---

## 9) Performance Optimization

### 9.1 Font Caching

**Implementeret:** Session-level font caching (10-15x speedup)

```r
# Package-level cache environment
.bfh_font_cache <- new.env(parent = emptyenv())

# Cache check pattern
cache_key <- paste0(fonts, check_installed, collapse = "_")
if (exists(cache_key, envir = .bfh_font_cache, inherits = FALSE)) {
  cached_font <- get(cache_key, envir = .bfh_font_cache, inherits = FALSE)
  return(cached_font)
}

# Cache assignment after detection
assign(cache_key, selected_font, envir = .bfh_font_cache)
```

### 9.2 Known Performance Bottlenecks

**Identificeret af performance-optimizer agent:**

1. **Palette lookups** - bfh_pal() kaldt på hver scale render
2. **String operations** - toupper() i bfh_labs() kunne optimeres
3. **Grid grob creation** - Recreates objects på hver call

**Løsninger under udvikling:**
- Palette caching
- bfh_labs() optimering med purrr::imap()
- Grob caching for repeated operations

---

## 10) Troubleshooting

### 10.1 Common Issues

**Missing %||% operator:**
```r
# Problem: "could not find function %||%"
# Solution: Ensure utils_operators.R is loaded
devtools::document()
devtools::load_all()
```

**bfh_cols() returns empty vector:**
```r
# Problem: bfh_cols() returns character(0) instead of all colors
# Solution: Fixed in commit 109c152
# Was checking is.null(cols) but should check length(cols) == 0
```

**Theme font not detected:**
```r
# Problem: Falls back to "sans" font
# Solution: Install systemfonts or extrafont package
install.packages("systemfonts")

# Check font availability
check_bfh_fonts()
```

**Logo file not found:**
```r
# Problem: Logo path not resolved
# Solution: Use get_bfh_logo() or verify file exists
logo_path <- get_bfh_logo(size = "web", variant = "color")
add_bfh_logo(plot, logo_path)
```

**Test failures:**
```r
# Problem: Tests fail after changes
# Solution: Run tests to identify issues
devtools::test()

# Problem: Specific test fails
testthat::test_file("tests/testthat/test-colors.R")
```

---

## 11) Known Issues & Technical Debt

### 11.1 Critical (from agent reports)

1. **Build artifacts in git** - `BFHtheme.Rcheck/` committed (skal fjernes)
2. **Commented code** - themes.R:72, fonts.R:35 (skal fjernes eller dokumenteres)

### 11.2 High Priority

1. **Validation duplication** - 84 linjer dupliceret validation i scales.R
2. **Missing MIME validation** - add_bfh_logo() kun checker file extension
3. **Placeholder function** - check_colorblind_safe() gør ingenting

### 11.3 Medium Priority

1. **Missing visual regression tests** - Ingen vdiffr tests
2. **JPEG support untested** - branding.R JPEG path helt utestet
3. **Logo variants untested** - grey/mark variants ikke testet
4. **Documentation warnings** - 3 warnings i R CMD check

### 11.4 Coverage Gaps

- fonts.R: 72.90% (extrafont fallback path)
- logo_helpers.R: 77.42% (grey/mark variants)
- branding.R: 86.36% (JPEG support)

**Mål:** 95%+ coverage på alle filer

---

## 12) Kommunikation & Filosofi

### 12.1 Udviklerkommunikation

* **Præcise action items**: "Tilføj parameter X til funktion Y i fil Z"
* **Faktuel rapportering** af resultater
* **Kritisk evaluering** – stil spørgsmål ved trade-offs
* **Intellektuel ærlighed** – vær direkte om begrænsninger

### 12.2 Development Philosophy

**Kerneprincipper:**
* **Quality over speed** – healthcare software kræver stabilitet
* **Test-driven confidence** – tests før implementation
* **User-focused design** – beautiful defaults, flexible customization
* **Minimal surprise** – følg R/ggplot2 conventions
* **Continuous improvement** – dokumentér beslutninger

**Goals:**
* Publication-ready output med minimalt setup
* Stabil API med backward compatibility
* Comprehensive documentation og eksempler
* Multi-organizational flexibility (BFH + Region H)
* Best practice compliance

### 12.3 Samtale Guidelines

* **Kritisk engagement** – evaluér forslag objektivt
* **Balanceret evaluering** – undgå tomme komplimenter
* **Retningsklarhed** – fokusér på long-term maintainability
* **Succeskriterium**: Fremmer dette produktiv tænkning eller standser det?

---

## 📎 Appendix A: Package Constraints

**Hard constraints:**
* Ingen commits til main uden godkendelse
* Ingen nye dependencies uden godkendelse
* ALDRIG modificer NAMESPACE direkte
* Ingen breaking changes til exported API uden diskussion
* Tests skal altid bestå før commit

**Soft guidelines:**
* Prefer simple solutions over clever ones
* Prefer composition over complexity
* Document "why", not just "what"
* Keep functions focused and testable

---

## 📎 Appendix B: Key Files Reference

| Fil | Ansvar | Vigtige funktioner |
|-----|--------|-------------------|
| **themes.R** | ggplot2 themes | `theme_bfh()`, `theme_bfh_minimal()`, `theme_bfh_dark()` |
| **colors.R** | Color palettes | `bfh_colors`, `bfh_palettes`, `bfh_cols()`, `bfh_pal()` |
| **scales.R** | ggplot2 scales | `scale_color_bfh()`, `scale_fill_bfh()` |
| **fonts.R** | Font detection | `get_bfh_font()`, `check_bfh_fonts()`, `.bfh_font_cache` |
| **helpers.R** | Plot helpers | `bfh_save()`, `bfh_combine_plots()`, `bfh_labs()` |
| **branding.R** | Logo/branding | `add_bfh_logo()`, `add_bfh_footer()`, `bfh_title_block()` |
| **logo_helpers.R** | Logo resolvers | `get_bfh_logo()`, `add_logo()` |
| **defaults.R** | Global defaults | `set_bfh_defaults()`, `reset_bfh_defaults()` |
| **utils_operators.R** | Operators | `%||%` |

---

## 📎 Appendix C: Quick Reference Commands

```bash
# Development workflow
devtools::load_all()           # Load package for testing
devtools::test()               # Run tests (323 tests)
devtools::check()              # Full package check
devtools::document()           # Update documentation + NAMESPACE

# Code quality
styler::style_pkg()            # Format code
lintr::lint_package()          # Lint code

# Testing
testthat::test_file("tests/testthat/test-colors.R")
covr::package_coverage()       # 89.74% current

# Documentation
devtools::build_vignettes()
# pkgdown::build_site()        # (future)

# Installation
devtools::install()            # Install lokalt
devtools::install_github("johanreventlow/BFHtheme")
```

---

## 📎 Appendix D: Recent Critical Fixes

**Commit 109c152 (2025-10-14):**
- ✅ Fixed missing `%||%` operator (was blocking all functionality)
- ✅ Fixed `bfh_cols()` zero-argument bug (was returning character(0))
- ✅ All 323 tests now pass
- ✅ Package is production-ready (0 errors)

**Known Issues Remaining:**
- 3 warnings in R CMD check (Rd file warnings, showtext dependency)
- 2 notes (acceptable for R CMD check)
- Coverage below 90% target (89.74% current)

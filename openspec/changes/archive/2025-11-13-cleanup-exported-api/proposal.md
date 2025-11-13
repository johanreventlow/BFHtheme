# Cleanup Exported API

## Why

BFHtheme currently exports 51 functions, many of which are low-level helpers, debug utilities, or convenience wrappers that clutter the user-facing API. This makes the package harder to understand for new users and increases the maintenance burden for breaking changes. Simplifying the exported API to ~39 core functions will improve discoverability, reduce cognitive load, and establish clearer boundaries between public API and internal implementation.

## What Changes

### Functions to Remove (Breaking)
- **`add_logo()`** - Redundant wrapper around `add_bfh_logo()` + `get_bfh_logo()`. Users can compose these directly.
- **`apply_bfh_theme()`** - Overly complex helper that returns list of ggplot2 components. Users should call `theme_bfh()` and scales directly for better composability.
- **`add_bfh_color_bar()`** - Niche styling helper with limited use cases. Can be replaced with custom ggplot2 code.

### Functions to Make Internal (Unexport)
- **Cache management:**
  - `clear_bfh_font_cache()` - Debug/maintenance function
  - `clear_bfh_pal_cache()` - Debug/maintenance function
  - `get_bfh_dimensions()` - Internal helper
- **Font setup:**
  - `check_bfh_fonts()` - Debug function
  - `install_roboto_font()` - One-time setup helper
  - `setup_bfh_fonts()` - One-time setup helper
  - `set_bfh_fonts()` - Low-level configuration
  - `set_bfh_graphics()` - Low-level configuration
  - `use_bfh_showtext()` - Low-level configuration

### Result
- **51 → 39 exported functions** (~24% reduction)
- Cleaner, more focused public API
- Better separation of concerns

## Impact

### Affected Specs
- `package-api` - Core exported function interface

### Affected Code
- **R/logo_helpers.R** - Remove `add_logo()` function
- **R/defaults.R** - Remove `apply_bfh_theme()` function
- **R/helpers.R** - Remove `add_bfh_color_bar()` function
- **R/fonts.R** - Unexport 5 font functions (remove `@export` tags)
- **R/colors.R** - Unexport `clear_bfh_pal_cache()` (remove `@export` tag)
- **R/helpers.R** - Unexport `get_bfh_dimensions()` (remove `@export` tag)
- **NAMESPACE** - Auto-regenerated via `devtools::document()`

### Affected Tests
- **tests/testthat/test-logo_helpers.R** - Update tests for `add_logo()` removal
- **tests/testthat/test-defaults.R** - Update tests for `apply_bfh_theme()` removal
- **tests/testthat/test-helpers.R** - Update tests for `add_bfh_color_bar()` and `get_bfh_dimensions()` removal

### Affected Documentation
- **Vignettes** - Update any examples using removed functions
- **README.md** - Update examples if they reference removed functions
- **Function documentation** - Add notes about removed/internal functions

### Breaking Changes
**BREAKING**: This is a major version change requiring semver bump from 0.4.0 → 1.0.0

**Migration Guide Required:**
```r
# OLD: add_logo()
add_logo(p, position = "topright", size = 0.15)

# NEW: Use add_bfh_logo() + get_bfh_logo()
add_bfh_logo(p, get_bfh_logo(), position = "topright", size = 0.15)

# OLD: apply_bfh_theme()
p + apply_bfh_theme(add_color_scale = TRUE)

# NEW: Compose directly
p + theme_bfh() + scale_color_bfh()

# OLD: add_bfh_color_bar()
add_bfh_color_bar(p, position = "top")

# NEW: Use ggplot2 directly
p + annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf,
             fill = bfh_cols("hospital_primary"), alpha = 0.1)
```

## Dependencies

None. This is a pure API cleanup with no external dependencies.

## Timeline

1. Create proposal (this document) - **Now**
2. Review and approve proposal - **1 day**
3. Implementation - **2-3 hours**
4. Testing and validation - **1 hour**
5. Documentation updates - **1 hour**
6. Version bump and release - **After approval**

## Related

- GitHub Issue: #45

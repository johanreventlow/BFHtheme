# Package API Specification - Delta

## ADDED Requirements

### Requirement: Internal Function Documentation
Internal functions (functions without `@export`) SHALL be documented with `@keywords internal` to indicate they are not part of the public API.

#### Scenario: Internal function access
- **WHEN** a user attempts to access an internal function
- **THEN** the function is accessible via `:::` operator with appropriate warnings
- **AND** the function does not appear in the exported namespace

#### Scenario: Internal function documentation
- **WHEN** a maintainer reads internal function documentation
- **THEN** documentation is complete and includes `@keywords internal` tag
- **AND** examples show proper usage within package context

## REMOVED Requirements

### Requirement: Convenience Logo Wrapper
**Removed:** `add_logo()` function that wraps `add_bfh_logo()` + `get_bfh_logo()`

**Reason:** Redundant wrapper that duplicates functionality without adding value. Users can compose `add_bfh_logo(p, get_bfh_logo())` directly in one line.

**Migration:**
```r
# OLD
add_logo(p, position = "topright", size = 0.15, variant = "grey")

# NEW
add_bfh_logo(
  p,
  get_bfh_logo(variant = "grey"),
  position = "topright",
  size = 0.15
)
```

### Requirement: Theme Application Helper
**Removed:** `apply_bfh_theme()` function that returns list of ggplot2 components

**Reason:** Overly complex API that obscures better ggplot2 composition patterns. Teaching users to compose `theme_bfh() + scale_color_bfh()` directly is more maintainable and aligns with ggplot2 best practices.

**Migration:**
```r
# OLD
p + apply_bfh_theme(add_color_scale = TRUE, add_fill_scale = TRUE)

# NEW
p + theme_bfh() + scale_color_bfh() + scale_fill_bfh()
```

### Requirement: Color Bar Annotation
**Removed:** `add_bfh_color_bar()` function

**Reason:** Niche styling helper with limited use cases. Standard ggplot2 annotation patterns are more flexible and discoverable.

**Migration:**
```r
# OLD
add_bfh_color_bar(p, position = "top", color = bfh_cols("hospital_primary"))

# NEW - Use ggplot2 annotate directly
p + annotate(
  "rect",
  xmin = -Inf, xmax = Inf,
  ymin = Inf, ymax = Inf,
  fill = bfh_cols("hospital_primary"),
  alpha = 0.1
)
```

### Requirement: Font Cache Management Exported
**Removed from exports:** `clear_bfh_font_cache()`, `clear_bfh_pal_cache()`

**Reason:** Debug/maintenance functions that users should rarely need. Making them internal simplifies the API while keeping functionality available for troubleshooting via `:::`.

**Migration:**
```r
# OLD (exported)
clear_bfh_font_cache()

# NEW (internal - only if needed for debugging)
BFHtheme:::clear_bfh_font_cache()
```

### Requirement: Plot Dimensions Helper Exported
**Removed from exports:** `get_bfh_dimensions()`

**Reason:** Internal helper function used by `bfh_save()`. Not intended for direct user access.

**Migration:** Not needed. Users should use `bfh_save()` which calls this internally.

### Requirement: Font Setup Functions Exported
**Removed from exports:**
- `check_bfh_fonts()`
- `install_roboto_font()`
- `setup_bfh_fonts()`
- `set_bfh_fonts()`
- `set_bfh_graphics()`
- `use_bfh_showtext()`

**Reason:** One-time setup and low-level configuration functions. Advanced users who need these can access via `:::`. Most users should rely on automatic font detection in `theme_bfh()`.

**Migration:**
```r
# OLD (exported)
setup_bfh_fonts()

# NEW (internal - only for advanced setup)
BFHtheme:::setup_bfh_fonts()

# RECOMMENDED: Let themes auto-detect fonts
library(BFHtheme)
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh()  # Automatically detects best available font
```

## MODIFIED Requirements

### Requirement: Exported Function Count
The package SHALL export approximately 39 core functions focused on:
- Themes: `theme_bfh()`, `theme_bfh_minimal()`, `theme_bfh_dark()`, `theme_bfh_print()`, `theme_bfh_presentation()`
- Colors: `bfh_colors`, `bfh_palettes`, `bfh_cols()`, `bfh_pal()`, `show_bfh_palettes()`
- Scales: `scale_color_bfh()`, `scale_fill_bfh()`, `scale_*_discrete_bfh()`, `scale_*_continuous_bfh()`, `scale_*_date_bfh()`, `scale_*_datetime_bfh()`
- Branding: `add_bfh_logo()`, `add_bfh_footer()`, `bfh_title_block()`, `get_bfh_logo()`
- Helpers: `bfh_save()`, `bfh_labs()`, `bfh_combine_plots()`
- Defaults: `set_bfh_defaults()`, `reset_bfh_defaults()`
- Font access: `get_bfh_font()`

#### Scenario: Core functionality available
- **WHEN** a user installs BFHtheme
- **THEN** all core theming, coloring, scaling, and branding functions are exported
- **AND** internal helpers are not polluting the namespace
- **AND** `library(BFHtheme); ls("package:BFHtheme")` shows ~39 functions

#### Scenario: User-facing documentation
- **WHEN** a user runs `?BFHtheme` or browses package documentation
- **THEN** only exported functions appear in help index
- **AND** internal functions are not listed in user-facing documentation
- **AND** package reference card shows clean, focused API

### Requirement: Backward Compatibility
The package SHALL provide clear migration guidance in NEWS.md and error messages for users of removed functions.

#### Scenario: Breaking change notification
- **WHEN** the package is released with API changes
- **THEN** NEWS.md contains a "Breaking Changes" section
- **AND** migration examples are provided for each removed function
- **AND** version is bumped to 1.0.0 (major version)

#### Scenario: User attempts to use removed function
- **WHEN** a user tries to call a removed function (e.g., `add_logo()`)
- **THEN** R returns "object 'add_logo' not found" error
- **AND** user can find migration guide in NEWS.md and package documentation
- **AND** vignettes demonstrate recommended patterns

### Requirement: Test Coverage Maintained
All functionality (exported and internal) SHALL maintain ≥90% test coverage.

#### Scenario: Internal function testing
- **WHEN** tests are run via `devtools::test()`
- **THEN** internal functions are tested using `:::` operator
- **AND** test coverage includes both exported and internal functions
- **AND** `covr::package_coverage()` reports ≥90% coverage

#### Scenario: Package check passes
- **WHEN** `devtools::check()` is run
- **THEN** check completes with 0 errors, 0 warnings, 0 notes
- **AND** all examples run successfully
- **AND** all tests pass

# BFHtheme 0.2.0

## Breaking Changes 🚨

This release simplifies the public API by removing redundant convenience wrappers, theme variants, and making low-level configuration functions internal. The package now exports **33 core functions** (down from 49), making it easier to learn and maintain.

### Functions Removed

Seven functions have been completely removed:

#### `add_logo()` → Use `add_bfh_logo()` + `get_bfh_logo()`

**Before (v0.1.0):**
```r
p <- ggplot(data, aes(x, y)) + geom_point() + theme_bfh()
add_logo(p, position = "topright", size = 0.15)
```

**After (v0.2.0):**
```r
p <- ggplot(data, aes(x, y)) + geom_point() + theme_bfh()
add_bfh_logo(p, get_bfh_logo(), position = "topright", size = 0.15)
```

#### `apply_bfh_theme()` → Use `theme_bfh()` + scales directly

**Before (v0.1.0):**
```r
ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  apply_bfh_theme(add_color_scale = TRUE)
```

**After (v0.2.0):**
```r
ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  theme_bfh() +
  scale_color_bfh()
```

#### `add_bfh_color_bar()` → Use ggplot2 annotations

**Before (v0.1.0):**
```r
p + add_bfh_color_bar(position = "top")
```

**After (v0.2.0):**
```r
# Use standard ggplot2 annotate for custom styling
p + annotate("rect",
             xmin = -Inf, xmax = Inf,
             ymin = Inf, ymax = Inf * 0.98,
             fill = bfh_cols("hospital_primary"),
             alpha = 0.1)
```

#### Theme Variants Removed → Use `theme_bfh()` only

**Removed functions:**
- `theme_bfh_minimal()`
- `theme_bfh_print()`
- `theme_bfh_presentation()`
- `theme_bfh_dark()`

**Before (v0.1.0):**
```r
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh_dark()  # or theme_bfh_minimal(), theme_bfh_print(), etc.
```

**After (v0.2.0):**
```r
# Use theme_bfh() and customize as needed
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh() +
  theme(
    # Customize for specific use cases
    plot.background = element_rect(fill = "#1a1a1a")  # for dark theme
  )
```

### Functions Made Internal

The following functions are now internal (unexported). Advanced users can still access them via `BFHtheme:::function_name()`, but they are no longer part of the official public API:

**Cache management:**
- `clear_bfh_font_cache()` - Debug function for font cache
- `clear_bfh_pal_cache()` - Debug function for palette cache
- `get_bfh_dimensions()` - Internal helper for `bfh_save()`

**Font configuration (one-time setup):**
- `check_bfh_fonts()` - Font availability checker
- `install_roboto_font()` - Installation guidance
- `setup_bfh_fonts()` - Font setup helper
- `set_bfh_fonts()` - Global font setter
- `set_bfh_graphics()` - Graphics device configuration
- `use_bfh_showtext()` - Showtext integration

**Migration for internal functions:**

Most users never needed these functions. If you do need them, access via `:::`:

```r
# OLD (v0.1.0)
check_bfh_fonts()
clear_bfh_font_cache()

# NEW (v0.2.0)
BFHtheme:::check_bfh_fonts()
BFHtheme:::clear_bfh_font_cache()
```

## Improvements

- **Cleaner API:** 37 focused core functions vs 49 previously (~24% reduction)
- **Better discoverability:** Removed wrapper functions that obscured ggplot2 patterns
- **Improved documentation:** Internal functions now marked with `@keywords internal`
- **Maintained functionality:** All features still available, just better organized

## Bug Fixes

- Fixed non-functional `date_labels` parameter in date scale functions (#32)

## Documentation

- Comprehensive contributor documentation added (closes #33, #34, #35)
- OpenSpec workflow integrated for structured change management
- Added AGENTS.md with OpenSpec instructions

---

# BFHtheme 0.1.0

Initial release with core theming functionality.

## Features

- BFH-branded ggplot2 themes
- Color palettes and scale functions
- Logo and branding helpers
- Font auto-detection with caching
- Publication-ready plot export

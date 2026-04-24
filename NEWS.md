# BFHtheme 0.5.1

## Breaking Changes

* `theme_bfh()` validerer nu `base_size` ved indgang. Kald med
  `base_size = NULL`, `base_size = 0` eller negative værdier stopper med
  "base_size must be positive numeric" frem for sen- eller uforklarlig fejl
  nede i `grid::unit()`.

* `theme_bfh()` validerer nu `base_family`. En vektor eller ikke-karakter-værdi
  stopper med "base_family must be a character scalar or NULL".

* `bfh_save()` validerer nu `width`, `height` og `dpi` ved indgang.
  Negative eller nul-værdier stopper med "X must be positive numeric" frem for
  sen hukommelsesfejl.

* `add_bfh_footer()` validerer nu `height`: værdier ≤ 0 eller > 1 stopper med
  "height must be in (0, 1]".

## Bug Fixes

* Tests skriver ikke længere midlertidige filer til brugerens hjemmemappe (`~`).
  `test-branding.R` bruger nu `withr::local_tempdir()`, `withr::local_dir()` og
  `withr::local_options()` i stedet for manuel `on.exit(setwd(...))` og
  `on.exit(options(...))`.

## Internal Changes

* `R/utils_validation.R`: `validate_numeric_range()` er udvidet med parameter
  `exclusive_min = FALSE`. Bruges af de nye valideringer ovenfor.

* `tests/testthat/Rplots.pdf` slettet fra repo. `.gitignore` og `.Rbuildignore`
  har nu eksplicitte rækker for `Rplots.pdf`.

* `CONTRIBUTING.md`: Tilføjet "Visual Regression Tests" sektion i Testing-
  kapitlet med procedure for inspektion og accept via `vdiffr::manage_cases()`.

# BFHtheme 0.5.0

## Breaking Changes

* `add_bfh_logo()` nu fejler med en klar fejlbesked i stedet for en advarsel,
  når `cowplot` ikke er installeret. Tidligere returnerede funktionen plottet
  uden logo; nu stoppes eksekveringen med en installationsvejledning.
  Installer med `install.packages("cowplot")` (#fix-add-bfh-logo-contract).

* `library(BFHtheme)` sætter ikke længere automatisk knitr-chunkoptioner
  (`dev = "ragg_png"`, `dpi = 300`). Kald `use_bfh_knitr_defaults()` eksplicit
  i dit setup-chunk for at opnå samme adfærd:
  ```r
  # Før:
  library(BFHtheme)  # satte automatisk knitr ragg_png
  # Efter:
  library(BFHtheme)
  use_bfh_knitr_defaults()  # eksplicit opt-in
  ```
  (#make-global-state-explicit).

* `reset_bfh_defaults()` gendanner nu præcis den aktive tilstand fra *før*
  `set_bfh_defaults()` blev kaldt i stedet for at gætte på ggplot2's
  standarder. Hvis `set_bfh_defaults()` ikke er kaldt i sessionen, bruges
  `theme_gray()` som fallback og der vises en besked.

## New Features

* Ny funktion `use_bfh_knitr_defaults(dpi = 300)` — opt-in aktivering af
  `ragg_png`-rendering i knitr-dokumenter (#make-global-state-explicit).

* `add_bfh_logo()` cacher nu det indlæste logobillede per sti og
  filændringsdato. Gentagne kald med samme uændrede fil undgår redundant
  diskadgang. Cachen nulstilles med `clear_bfh_logo_cache()`.

* `add_bfh_logo()` validerer nu logofilers størrelse (`BFHtheme.logo_max_bytes`,
  standard 5 MB) og billeders dimensioner (`BFHtheme.logo_max_dim`, standard
  4096 px) for at forhindre hukommelsesudmattelse ved store filer.

* `alpha`-parameteren i `add_bfh_logo()` er nu fuldt implementeret og sendes
  videre til `cowplot::draw_image()`.

## Bug Fixes

* Fixed font detection false positives: `systemfonts::match_fonts()` returns a
  Helvetica fallback path even for non-installed fonts on macOS, causing
  BFHtheme to report fonts like "Roboto" as available when they were not.
  Font availability is now checked via `systemfonts::system_fonts()$family`
  exact match, which is reliable across platforms. `systemfonts` moved from
  Suggests to Imports to guarantee availability (#67).

## Documentation

* Synced all documentation to current API (#68):
  - `README.md`: Replaced deprecated `add_logo()` and `add_watermark()` calls
    with current `add_bfh_logo()` API.
  - `vignettes/logo-and-branding.Rmd`: Rewritten for simplified
    `add_bfh_logo(plot, logo_path = NULL, alpha = 1)` signature; removed
    `position`, `size`, `variant`, `logo_size` parameters removed in v0.3.0.
  - `vignettes/troubleshooting.Rmd`: Replaced `add_logo()` references.
  - `inst/examples/color_demo.R`: Replaced `hospital_grey` (non-existent) with
    `regionh_grey`.
  - `inst/examples/basic_usage.R`: Replaced `theme_bfh_minimal()` and
    `theme_bfh_print()` (removed in v0.2.0) with `theme_bfh()`.
  - `inst/examples/logo_demo.R`: Rewritten to use only current exported API.
  - Added CI smoke test that parses all `inst/examples/*.R` files to catch
    future API drift.

# BFHtheme 0.3.0

## Breaking Changes 🚨

This release simplifies the `add_bfh_logo()` function to enforce consistent, brand-compliant logo placement across all visualizations.

### Logo Placement Simplified

The `add_bfh_logo()` function now uses **fixed positioning** to ensure consistent branding:

**Removed parameters:**
- `position` - Logo always placed bottom-left
- `size` - Logo height always 1/15 of plot height
- `padding` - Logo always flush with edge (0 padding)

**New default behavior:**
- Logo automatically loads BFH mark (`bfh_mark.png`) when `logo_path = NULL`
- Fixed position: bottom-left corner, flush with plot edge
- Fixed sizing: logo height = 1/15 of plot height, positioned 1/15 from bottom

**Migration:**

**Before (v0.2.0):**
```r
p <- ggplot(data, aes(x, y)) + geom_point() + theme_bfh()

# Custom positioning and sizing
add_bfh_logo(p, get_bfh_logo(), position = "topright", size = 0.15, padding = 0.02)
```

**After (v0.3.0):**
```r
p <- ggplot(data, aes(x, y)) + geom_point() + theme_bfh()

# Simplified API - fixed positioning
add_bfh_logo(p)  # Uses default bfh_mark.png, fixed position

# With custom logo
add_bfh_logo(p, logo_path = "/path/to/custom_logo.png")

# With transparency
add_bfh_logo(p, alpha = 0.7)
```

### Updated Function Signature

```r
# OLD
add_bfh_logo(plot, logo_path, position = "bottomright",
             size = 0.1, alpha = 1, padding = 0.02)

# NEW
add_bfh_logo(plot, logo_path = NULL, alpha = 1)
```

## Improvements

- **Consistency:** All plots use identical logo placement matching brand guidelines
- **Simplicity:** Fewer parameters = easier to use, harder to misuse
- **Quality:** Default to high-resolution mark (`bfh_mark.png`) for print-quality output
- **Compliance:** Fixed sizing ensures logo prominence requirements are met

---

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

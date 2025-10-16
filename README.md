# BFHtheme

> BFH Theme and Color Palettes for ggplot2

A comprehensive R package providing theming support for ggplot2 graphics following the visual identity guidelines of Bispebjerg og Frederiksberg Hospital (BFH).

## Features

- **Multiple Color Palettes**: Predefined palettes following BFH branding
- **Theme Functions**: Optimized themes for reports, presentations, and print
- **Scale Functions**: Easy-to-use color and fill scales for ggplot2
- **Helper Utilities**: Functions for saving plots with correct dimensions
- **Branding Tools**: Add logos, watermarks, and footers to your plots
- **Global Defaults**: Set BFH styling as default for all plots in a session

## Installation

```r
# Install from local package file
install.packages("BFHtheme_0.1.0.tar.gz", repos = NULL, type = "source")

# Or install from directory
devtools::install_local("/path/to/BFHtheme")

# Or if hosted on GitHub (update with your repo)
# devtools::install_github("yourusername/BFHtheme")
```

### Recommended: Install showtext for Font Support

For best typography results, especially for external users without access to BFH's proprietary Mari font:

```r
install.packages("showtext")
```

This enables automatic Roboto font loading from Google Fonts. See [Typography](#typography) section for details.

**Note:** Efter installation, genstart din R session for at sikre pakken er korrekt loaded.

## Quick Start

```r
library(BFHtheme)
library(ggplot2)

# Set BFH defaults for all plots
set_bfh_defaults()

# Create a plot - it will automatically use BFH theme and colors
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  bfh_labs(
    title = "Vehicle weight vs fuel efficiency",  # Natural case for titles
    x = "weight (1000 lbs)",                      # Uppercase for axes
    y = "miles per gallon"                        # Uppercase for axes
  )
```

## Usage Examples

### Basic Plot with BFH Theme

```r
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh() +
  labs(title = "A Professional BFH Plot")
```

### Using Different Color Palettes

```r
# Discrete colors
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_bfh(palette = "primary") +
  theme_bfh()

# Continuous colors
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_fill_bfh_continuous(palette = "blues") +
  theme_bfh()
```

### Available Themes

- `theme_bfh()` - Main BFH theme
- `theme_bfh_minimal()` - Minimal version with reduced elements
- `theme_bfh_print()` - Optimized for print output
- `theme_bfh_presentation()` - Large text for presentations
- `theme_bfh_dark()` - Dark background version

### Available Palettes

Based on Region Hovedstaden's official visual identity guidelines:

**Hospital Palettes (Bispebjerg og Frederiksberg Hospital):**
- `hospital` / `main` - Primary hospital colors for general use
- `hospital_blues` - Blue color gradient (hospital primary to light blue)
- `hospital_blues_seq` - Sequential blue palette including white
- `hospital_infographic` - Optimized for hospital infographics

**Region Hovedstaden Palettes (Koncern):**
- `regionh` - Primary Region H colors
- `regionh_main` - Main Region H palette
- `regionh_blues` - Region H blue gradient
- `regionh_blues_seq` - Sequential Region H blue palette including white
- `regionh_infographic` - Optimized for Region H infographics

**Legacy/Compatibility Palettes:**
- `primary` - Core identity colors
- `blues` / `blues_sequential` - Blue gradients
- `greys` - Grey to light blue palette
- `contrast` - High contrast colors for accessibility
- `infographic` - General infographic palette

View all palettes:

```r
show_bfh_palettes()
```

### Saving Plots

```r
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh()

# Use presets for common sizes
bfh_save("my_plot.png", p, preset = "report_full")
bfh_save("presentation.png", p, preset = "presentation")

# Or specify custom dimensions
bfh_save("custom.png", p, width = 10, height = 6, dpi = 600)
```

### BFH Style Guidelines

The package includes `bfh_labs()` which automatically converts axis labels, subtitles, and legend titles to uppercase, while keeping the main plot title in natural case, following BFH visual identity conventions:

```r
# Only title unchanged, everything else uppercase
ggplot(data, aes(date, value, color = group)) +
  geom_line() +
  theme_bfh() +
  bfh_labs(
    title = "Patient trends over time",    # → "Patient trends over time" (unchanged)
    subtitle = "2020-2024",                # → "2020-2024" (UPPERCASE)
    x = "date",                            # → "DATE"
    y = "number of patients",              # → "NUMBER OF PATIENTS"
    color = "department"                   # → "DEPARTMENT"
  )

# You can still use standard labs() if you prefer different styling
ggplot(data, aes(x, y)) +
  geom_point() +
  labs(title = "Custom Title", x = "custom x axis")
```

**Tip:** Use `bfh_labs()` for consistency with BFH branding guidelines. Only the main title remains in natural case; subtitle, axis labels, and legend titles are automatically uppercased.

### Adding Branding Elements

```r
p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_bfh()

# Add BFH logo (included in package)
p_logo <- add_logo(p, position = "topright")

# Or specify logo path manually
p_logo <- add_bfh_logo(p, get_bfh_logo(), position = "topright")

# Add watermark
p_watermark <- add_watermark(p, text = "DRAFT", alpha = 0.3)

# Add footer
p_footer <- add_bfh_footer(p, text = "Bispebjerg og Frederiksberg Hospital - 2024")
```

## Customization

### Official Colors

The package includes two sets of official colors:

**Hospital Colors (Bispebjerg og Frederiksberg Hospital):**
- **Primary (Identitetsfarve)**: `#007dbb` (RGB: 0,125,187)
- **Hospital Blue**: `#009ce8` (RGB: 0,156,232)
- **Light Blue 1**: `#cce5f1` (RGB: 204,211,221)
- **Light Blue 2**: `#e5f2f8` (RGB: 229,242,248)
- **Hospital Grey**: `#646c6f` (RGB: 100,108,111)
- **Dark Grey**: `#333333` (RGB: 51,51,51)

**Region Hovedstaden Colors (Koncern):**
- **Primary (Identitetsfarve)**: `#002555` (RGB: 0,37,85) - Navy
- **Region H Blue**: `#007dbb` (RGB: 0,125,187)
- **Light Grey 1**: `#ccd3dd` (RGB: 204,211,221)
- **Light Grey 2**: `#e5e9ee` (RGB: 229,233,238)
- **Region H Grey**: `#646c6f` (RGB: 100,108,111)
- **Dark Grey**: `#333333` (RGB: 51,51,51)

```r
# View all colors
bfh_colors

# Access hospital colors
bfh_cols("hospital_primary", "hospital_blue")

# Access Region H colors
bfh_cols("regionh_primary", "regionh_blue")
```

### Creating Custom Palettes

```r
# Create a custom palette
my_palette <- bfh_cols("primary_blue", "orange", "teal", "purple")

# Use in a plot
ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  scale_color_manual(values = my_palette)
```

## Typography

### Font Support

BFHtheme automatically selects the best available font using this priority order:

1. **Mari** (BFH official font - available on BFH employee computers)
2. **Mari Office** (alternative name on some systems)
3. **Roboto** (free open-source alternative)
4. **Arial** (system fallback)
5. **sans** (universal fallback)

### For External Users (Without Mari Font)

**Recommended: Install `showtext` package for automatic Roboto loading:**

```r
# Install showtext
install.packages("showtext")

# Use BFHtheme - Roboto will be auto-loaded from Google Fonts if needed
library(BFHtheme)
library(ggplot2)

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh()  # Roboto automatically loaded if Mari not available
```

**Alternative: Manual Roboto installation**

```r
# Check which fonts are available
check_bfh_fonts()

# Get installation instructions
install_roboto_font()

# After installing Roboto, clear cache and verify
clear_bfh_font_cache()
check_bfh_fonts()
```

**For custom fonts:**

```r
# Example with showtext package
library(showtext)
font_add("YourFont", "path/to/font.ttf")
showtext_auto()

# Use in theme
theme_bfh(base_family = "YourFont")
```

**Note:** Mari fonts are proprietary and only available on BFH employee computers. External users and collaborators should use Roboto (free, open-source, Apache 2.0 licensed) which provides excellent visual compatibility.

## Package Structure

```
BFHtheme/
├── R/
│   ├── colors.R          # Color palettes and utilities
│   ├── scales.R          # ggplot2 scale functions
│   ├── themes.R          # Theme functions
│   ├── defaults.R        # Global defaults management
│   ├── helpers.R         # Helper functions (saving, etc.)
│   ├── branding.R        # Logo and branding functions
│   └── BFHtheme-package.R # Package documentation
├── inst/
│   └── examples/
│       └── basic_usage.R # Usage examples
├── man/                  # Documentation (auto-generated)
├── DESCRIPTION
├── NAMESPACE
└── README.md
```

## Development

### Updating Documentation

After modifying roxygen comments:

```r
devtools::document()
```

### Building the Package

```r
devtools::build()
devtools::check()
```

### Running Examples

```r
source(system.file("examples/basic_usage.R", package = "BFHtheme"))
```

## Contributing

Issues and pull requests are managed through GitHub Issues. Please follow these guidelines:

1. Check existing issues before creating a new one
2. Provide clear descriptions and reproducible examples
3. Follow the existing code style
4. Update documentation as needed

## License

MIT License (update LICENSE file as needed)

## Contact

Bispebjerg og Frederiksberg Hospital

## Acknowledgments

Built with [ggplot2](https://ggplot2.tidyverse.org/) and inspired by other theme packages in the R community.

---

**Note**: Colors are based on Region Hovedstaden's official hospital visual identity guidelines (2024).

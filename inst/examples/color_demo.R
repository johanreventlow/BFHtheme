# BFHtheme - Color Palette Demonstration
# ========================================
# This script demonstrates the official Region Hovedstaden hospital colors

library(BFHtheme)
library(ggplot2)

# Display all available color palettes
cat("Region Hovedstaden Hospital Color Palettes\n")
cat("==========================================\n\n")

cat("Official Hospital Colors:\n")
cat("- Primary (Identitetsfarve): ", bfh_cols("hospital_primary"), "\n")
cat("- Hospital Blue:             ", bfh_cols("hospital_blue"), "\n")
cat("- Hospital Grey:             ", bfh_cols("hospital_grey"), "\n")
cat("- Dark Grey:                 ", bfh_cols("dark_grey"), "\n\n")

# Show all palettes visually
show_bfh_palettes()

# Example 1: Scatter plot with primary colors
cat("\nExample 1: Scatter Plot with Primary Hospital Colors\n")

p1 <- ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3, alpha = 0.8) +
  labs(
    title = "Køretøjsdata: Vægt vs Brændstofforbrug",
    subtitle = "Bispebjerg og Frederiksberg Hospital",
    x = "Vægt (1000 lbs)",
    y = "Miles per Gallon",
    color = "Cylindre"
  ) +
  theme_bfh() +
  scale_color_bfh(palette = "primary")

print(p1)

# Example 2: Bar chart with infographic palette
cat("\nExample 2: Bar Chart with Infographic Palette\n")

data_summary <- data.frame(
  Kategori = c("A", "B", "C", "D", "E"),
  Værdi = c(23, 45, 32, 18, 38)
)

p2 <- ggplot(data_summary, aes(x = Kategori, y = Værdi, fill = Kategori)) +
  geom_col() +
  labs(
    title = "Kategoriserede Data",
    subtitle = "Eksempel på infografik farvepalette",
    x = "Kategori",
    y = "Værdi"
  ) +
  theme_bfh() +
  scale_fill_bfh(palette = "infographic") +
  theme(legend.position = "none")

print(p2)

# Example 3: Continuous color scale with blues
cat("\nExample 3: Heatmap with Sequential Blue Palette\n")

p3 <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  labs(
    title = "Old Faithful Eruptionsmønster",
    subtitle = "Sekventiel blå farvepalette",
    x = "Ventetid (minutter)",
    y = "Eruptionsvarighed (minutter)",
    fill = "Tæthed"
  ) +
  theme_bfh() +
  scale_fill_bfh_continuous(palette = "blues_sequential")

print(p3)

# Example 4: Faceted plot with contrast palette
cat("\nExample 4: Faceted Plot with Contrast Palette\n")

p4 <- ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2, alpha = 0.7) +
  facet_wrap(~year) +
  labs(
    title = "Motorstørrelse vs Brændstofeffektivitet",
    subtitle = "Efter år og køretøjsklasse",
    x = "Motorstørrelse (L)",
    y = "Highway MPG",
    color = "Klasse"
  ) +
  theme_bfh() +
  scale_color_bfh(palette = "contrast")

print(p4)

# Example 5: Using global defaults
cat("\nExample 5: Setting Global BFH Defaults\n")

set_bfh_defaults(theme = "bfh", palette = "main")

p5 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 2.5) +
  labs(
    title = "Iris Dataset",
    subtitle = "Automatisk anvendelse af BFH tema"
  )

print(p5)

# Reset defaults when done
reset_bfh_defaults()

cat("\n✓ Color demonstration complete!\n")
cat("All plots use official Region Hovedstaden hospital colors.\n")

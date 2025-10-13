# BFHtheme - Logo Demonstration
# ==============================

library(BFHtheme)
library(ggplot2)

cat("BFH Logo Integration Demo\n")
cat("==========================\n\n")

# Check if logo is available
logo_path <- get_bfh_logo()
if (!is.null(logo_path)) {
  cat("✓ BFH logo found at:", logo_path, "\n\n")
} else {
  stop("BFH logo not found. Please ensure it's included in the package.")
}

# Example 1: Basic plot with logo in bottom right
cat("Example 1: Logo in bottom right (default)\n")

p1 <- ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "Køretøjsanalyse",
    subtitle = "Bispebjerg og Frederiksberg Hospital",
    x = "Vægt (1000 lbs)",
    y = "Miles per Gallon",
    color = "Cylindre"
  ) +
  theme_bfh() +
  scale_color_bfh(palette = "hospital")

# Add logo
p1_with_logo <- add_logo(p1)
print(p1_with_logo)

# Example 2: Logo in different positions
cat("\nExample 2: Logo in top right corner\n")

p2 <- ggplot(mpg, aes(x = class, fill = class)) +
  geom_bar() +
  labs(
    title = "Køretøjsklasser",
    subtitle = "Distribution",
    x = "Klasse",
    y = "Antal"
  ) +
  theme_bfh() +
  scale_fill_bfh(palette = "hospital_infographic") +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

p2_with_logo <- add_logo(p2, position = "topright", size = 0.12)
print(p2_with_logo)

# Example 3: High-resolution logo for print
cat("\nExample 3: High-resolution logo for print output\n")

p3 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 2.5, alpha = 0.7) +
  labs(
    title = "Iris Dataset Analysis",
    subtitle = "Sepal dimensions by species",
    x = "Sepal Length (cm)",
    y = "Sepal Width (cm)"
  ) +
  theme_bfh_print() +
  scale_color_bfh(palette = "hospital_blues")

p3_with_logo <- add_logo(p3, position = "bottomleft", logo_size = "full", size = 0.18)
print(p3_with_logo)

# Example 4: Manual logo path (alternative method)
cat("\nExample 4: Using manual logo path\n")

p4 <- ggplot(economics_long[economics_long$variable %in% c("unemploy", "pop"), ],
             aes(x = date, y = value01, color = variable)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Economic Indicators",
    subtitle = "Normalized values over time",
    x = "Year",
    y = "Normalized Value",
    color = "Indicator"
  ) +
  theme_bfh_minimal() +
  scale_color_bfh(palette = "hospital")

# Add logo with manual path
logo_path <- get_bfh_logo("web")
p4_with_logo <- add_bfh_logo(p4, logo_path, position = "topright", size = 0.12)
print(p4_with_logo)

# Example 5: Combine logo with other branding elements
cat("\nExample 5: Logo combined with color bar\n")

p5 <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  labs(
    title = "Old Faithful Eruptions",
    x = "Waiting Time (min)",
    y = "Eruption Duration (min)",
    fill = "Density"
  ) +
  theme_bfh() +
  scale_fill_bfh_continuous(palette = "hospital_blues_seq")

# Add both logo and color bar
p5_branded <- p5 %>%
  add_bfh_color_bar(position = "top", color = bfh_cols("hospital_primary")) %>%
  add_logo(position = "bottomright", size = 0.12, alpha = 0.85)

print(p5_branded)

# Save example with logo
cat("\nSaving plot with logo...\n")
bfh_save("plot_with_logo.png", p1_with_logo, preset = "report_full")

cat("\n✓ Logo demonstration complete!\n")
cat("Available logo sizes: 'full' (300 DPI), 'web' (800px), 'small' (400px)\n")

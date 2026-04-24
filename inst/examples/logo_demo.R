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

# Example 1: Basic plot with logo (default: BFH mark, bottom-left)
cat("Example 1: Logo with default placement\n")

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

p1_with_logo <- add_bfh_logo(p1)
print(p1_with_logo)

# Example 2: Logo with custom path and transparency
cat("\nExample 2: Logo with custom path\n")

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

logo_path_web <- get_bfh_logo(size = "web")
p2_with_logo <- add_bfh_logo(p2, logo_path = logo_path_web)
print(p2_with_logo)

# Example 3: Logo with transparency
cat("\nExample 3: Semi-transparent logo\n")

p3 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 2.5, alpha = 0.7) +
  labs(
    title = "Iris Dataset Analysis",
    subtitle = "Sepal dimensions by species",
    x = "Sepal Length (cm)",
    y = "Sepal Width (cm)"
  ) +
  theme_bfh() +
  scale_color_bfh(palette = "hospital_blues")

p3_with_logo <- add_bfh_logo(p3, alpha = 0.7)
print(p3_with_logo)

# Example 4: Logo combined with footer
cat("\nExample 4: Logo combined with footer\n")

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
  theme_bfh() +
  scale_color_bfh(palette = "hospital")

p4_branded <- add_bfh_logo(p4)
print(p4_branded)

# Save example with logo
cat("\nSaving plot with logo...\n")
bfh_save("plot_with_logo.png", p1_with_logo, preset = "report_full")

cat("\n✓ Logo demonstration complete!\n")
cat("Available logo sizes: 'full' (300 DPI), 'web' (800px), 'small' (400px)\n")

# BFHtheme - Basic Usage Examples
# ================================

library(BFHtheme)
library(ggplot2)

# 1. BASIC SCATTER PLOT WITH BFH THEME
# -------------------------------------

p1 <- ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "Vehicle Weight vs Fuel Efficiency",
    subtitle = "Motor Trend Car Road Tests",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon",
    color = "Cylinders"
  ) +
  theme_bfh() +
  scale_color_bfh()

print(p1)


# 2. BAR CHART WITH DIFFERENT PALETTE
# ------------------------------------

p2 <- ggplot(mpg, aes(x = class, fill = class)) +
  geom_bar() +
  labs(
    title = "Vehicle Class Distribution",
    x = "Vehicle Class",
    y = "Count"
  ) +
  theme_bfh() +
  scale_fill_bfh(palette = "cool") +
  theme(legend.position = "none")

print(p2)


# 3. LINE PLOT WITH MULTIPLE GROUPS
# ----------------------------------

p3 <- ggplot(economics_long, aes(x = date, y = value01, color = variable)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Economic Indicators Over Time",
    subtitle = "Normalized values (0-1 scale)",
    x = "Year",
    y = "Normalized Value",
    color = "Indicator"
  ) +
  theme_bfh_minimal() +
  scale_color_bfh(palette = "contrast")

print(p3)


# 4. FACETED PLOT
# ---------------

p4 <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  facet_wrap(~year) +
  labs(
    title = "Engine Displacement vs Highway MPG",
    subtitle = "By year and vehicle class",
    x = "Engine Displacement (L)",
    y = "Highway MPG",
    color = "Class"
  ) +
  theme_bfh() +
  scale_color_bfh(palette = "main")

print(p4)


# 5. CONTINUOUS COLOR SCALE (HEATMAP)
# ------------------------------------

p5 <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  labs(
    title = "Old Faithful Eruption Patterns",
    x = "Waiting Time (minutes)",
    y = "Eruption Duration (minutes)",
    fill = "Density"
  ) +
  theme_bfh() +
  scale_fill_bfh_continuous(palette = "blues")

print(p5)


# 6. BOXPLOT WITH CUSTOM COLORS
# ------------------------------

p6 <- ggplot(mpg, aes(x = class, y = hwy, fill = class)) +
  geom_boxplot() +
  labs(
    title = "Highway Fuel Efficiency by Vehicle Class",
    x = "Vehicle Class",
    y = "Highway MPG"
  ) +
  theme_bfh_print() +
  scale_fill_bfh(palette = "warm") +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(p6)


# 7. USING GLOBAL DEFAULTS
# -------------------------

# Set BFH defaults for all subsequent plots
set_bfh_defaults(theme = "bfh", palette = "main")

# Now plots automatically use BFH styling
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 2) +
  labs(title = "Iris Dataset - Sepal Dimensions")

# Reset to ggplot2 defaults when done
reset_bfh_defaults()


# 8. SAVING PLOTS
# ---------------

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh()

# Save with preset dimensions
bfh_save("plot_report.png", p, preset = "report_full")

# Save with custom dimensions
bfh_save("plot_presentation.png", p, preset = "presentation", dpi = 600)


# 9. VIEWING ALL AVAILABLE PALETTES
# ----------------------------------

# Display all color palettes
show_bfh_palettes()

# Display palettes with specific number of colors
show_bfh_palettes(n = 5)


# 10. COMBINING MULTIPLE PLOTS
# -----------------------------

if (requireNamespace("patchwork", quietly = TRUE)) {
  p1 <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
    geom_point() +
    theme_bfh()

  p2 <- ggplot(mtcars, aes(hp, mpg, color = factor(cyl))) +
    geom_point() +
    theme_bfh()

  p3 <- ggplot(mtcars, aes(disp, mpg, color = factor(cyl))) +
    geom_point() +
    theme_bfh()

  combined <- bfh_combine_plots(list(p1, p2, p3), ncol = 3)
  print(combined)
}

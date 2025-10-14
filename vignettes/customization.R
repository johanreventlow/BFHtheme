## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)


## ----load, message=FALSE------------------------------------------------------
library(BFHtheme)
library(ggplot2)


## ----theme-params-------------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "Custom Base Size") +
  theme_bfh(
    base_size = 14,           # Larger text
    base_family = "Arial",    # Specific font
    base_line_size = 0.6,     # Thicker lines
    base_rect_size = 0.6      # Thicker rectangles
  )


## ----theme-override-----------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "Custom Theme Elements") +
  theme_bfh() +
  theme(
    plot.title = element_text(color = bfh_cols("hospital_blue"), size = 18),
    axis.title.x = element_text(face = "bold"),
    panel.grid.major = element_line(color = "grey90", linewidth = 0.3)
  )


## ----legend-custom------------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "Custom Legend Position",
    color = "Cylinders"
  ) +
  scale_color_bfh() +
  theme_bfh() +
  theme(
    legend.position = "top",
    legend.direction = "horizontal",
    legend.box = "horizontal"
  )


## ----palettes-----------------------------------------------------------------
p <- ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  labs(title = "Hospital Blues Palette") +
  theme_bfh()

p + scale_fill_bfh(palette = "hospital_blues")


## ----reverse-palette----------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
  geom_point(size = 3) +
  labs(title = "Reversed Colour Scale") +
  scale_color_bfh_continuous(palette = "blues", reverse = TRUE) +
  theme_bfh()


## ----custom-palette-----------------------------------------------------------
# Create a custom palette with specific colours
custom_colors <- c(
  bfh_cols("hospital_primary"),
  bfh_cols("hospital_grey"),
  bfh_cols("regionh_primary")
)

ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  labs(title = "Custom Colour Selection") +
  scale_fill_manual(values = custom_colors) +
  theme_bfh()


## ----palette-function---------------------------------------------------------
# Generate colour ramp
blues_pal <- bfh_pal("hospital_blues")

# Use in continuous scale
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_fill_gradientn(colours = blues_pal(100)) +
  theme_bfh()


## ----footer, eval=FALSE-------------------------------------------------------
# p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#   geom_point() +
#   theme_bfh()
# 
# add_bfh_footer(
#   p,
#   text = "Bispebjerg og Frederiksberg Hospital - 2024",
#   color = bfh_cols("hospital_primary")
# )


## ----color-bar, eval=FALSE----------------------------------------------------
# p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#   geom_point() +
#   labs(title = "Vehicle Analysis") +
#   theme_bfh()
# 
# add_bfh_color_bar(
#   p,
#   position = "top",
#   color = bfh_cols("hospital_primary"),
#   size = 0.02
# )


## ----multi-panel, eval=FALSE--------------------------------------------------
# library(patchwork)
# 
# p1 <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#   geom_point() +
#   labs(title = "Weight vs MPG") +
#   scale_color_bfh() +
#   theme_bfh()
# 
# p2 <- ggplot(mtcars, aes(hp, mpg, color = factor(cyl))) +
#   geom_point() +
#   labs(title = "Horsepower vs MPG") +
#   scale_color_bfh() +
#   theme_bfh()
# 
# # Combine with shared legend
# p1 + p2 + plot_layout(guides = "collect") &
#   theme(legend.position = "bottom")


## ----combine-plots, eval=FALSE------------------------------------------------
# plots <- list(p1, p2)
# bfh_combine_plots(plots, ncol = 2, legend_position = "bottom")


## ----axis-format--------------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(
    title = "Custom Axis Formatting",
    x = "Vehicle Weight (1000 lbs)",
    y = "Fuel Efficiency (MPG)"
  ) +
  scale_y_continuous(
    breaks = seq(10, 35, 5),
    limits = c(10, 35)
  ) +
  theme_bfh()


## ----date-axis, eval=FALSE----------------------------------------------------
# library(lubridate)
# 
# date_data <- data.frame(
#   date = seq(as.Date("2024-01-01"), by = "month", length.out = 12),
#   value = cumsum(rnorm(12, 10, 3))
# )
# 
# ggplot(date_data, aes(x = date, y = value)) +
#   geom_line(color = bfh_cols("hospital_primary"), linewidth = 1) +
#   labs(
#     title = "Monthly Trends",
#     x = "Month",
#     y = "Value"
#   ) +
#   scale_x_date(
#     date_breaks = "2 months",
#     date_labels = "%b %Y"
#   ) +
#   theme_bfh()


## ----uppercase-labels---------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  bfh_labs(
    title = "Fuel efficiency analysis",      # Title unchanged
    subtitle = "Motor trend data",            # Converted to uppercase
    x = "weight (1000 lbs)",                  # Converted to uppercase
    y = "miles per gallon",                   # Converted to uppercase
    caption = "Source: Motor Trend, 1974"     # Converted to uppercase
  ) +
  theme_bfh()


## ----annotations--------------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  annotate(
    "text",
    x = 4.5, y = 30,
    label = "High efficiency zone",
    color = bfh_cols("hospital_primary"),
    size = 4
  ) +
  annotate(
    "rect",
    xmin = 1.5, xmax = 3.5,
    ymin = 25, ymax = 35,
    alpha = 0.1,
    fill = bfh_cols("hospital_blue")
  ) +
  labs(title = "Annotated Plot") +
  theme_bfh()


## ----facets-------------------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point(color = bfh_cols("hospital_primary")) +
  facet_wrap(~cyl, labeller = labeller(cyl = function(x) paste(x, "cylinders"))) +
  labs(title = "Fuel Efficiency by Cylinder Count") +
  theme_bfh() +
  theme(
    strip.background = element_rect(fill = bfh_cols("hospital_light_blue1")),
    strip.text = element_text(color = bfh_cols("hospital_primary"), face = "bold")
  )


## ----export, eval=FALSE-------------------------------------------------------
# p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#   geom_point() +
#   theme_bfh()
# 
# # High-resolution PNG
# bfh_save("figure.png", p, preset = "report_full", dpi = 600)
# 
# # Vector format for editing
# bfh_save("figure.pdf", p, preset = "report_full")
# 
# # Custom dimensions
# bfh_save("figure.png", p, width = 10, height = 8, units = "cm", dpi = 300)


## ----dimensions---------------------------------------------------------------
# Get dimensions for different output types
report_dims <- get_bfh_dimensions(type = "report", format = "standard")
print(report_dims)

presentation_dims <- get_bfh_dimensions(type = "presentation", format = "wide")
print(presentation_dims)


## ----cache, eval=FALSE--------------------------------------------------------
# # Font detection is cached automatically
# get_bfh_font()  # First call: detects font
# get_bfh_font()  # Subsequent calls: uses cache
# 
# # Clear cache if needed
# clear_bfh_font_cache()
# 
# # Force re-detection
# get_bfh_font(force_refresh = TRUE)


## ----performance, eval=FALSE--------------------------------------------------
# # Use alpha for overplotting
# ggplot(large_data, aes(x, y)) +
#   geom_point(alpha = 0.3) +
#   theme_bfh()
# 
# # Use geom_hex or geom_bin2d
# ggplot(large_data, aes(x, y)) +
#   geom_hex() +
#   scale_fill_bfh_continuous(palette = "blues") +
#   theme_bfh()
# 
# # Reduce point size
# ggplot(large_data, aes(x, y)) +
#   geom_point(size = 0.5) +
#   theme_bfh()


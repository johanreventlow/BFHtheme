## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)


## ----eval=FALSE---------------------------------------------------------------
# # install.packages("remotes")
# remotes::install_github("johanreventlow/BFHtheme")


## ----load-packages, message=FALSE---------------------------------------------
library(BFHtheme)
library(ggplot2)


## ----basic-theme, message=FALSE-----------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(
    title = "Fuel Efficiency by Vehicle Weight",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon"
  ) +
  theme_bfh()


## ----color-scales, message=FALSE----------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  labs(
    title = "Fuel Efficiency by Cylinder Count",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon",
    color = "Cylinders"
  ) +
  scale_color_bfh() +
  theme_bfh()


## ----continuous-colors, message=FALSE-----------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
  geom_point(size = 3) +
  labs(
    title = "Fuel Efficiency and Horsepower",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon",
    color = "Horsepower"
  ) +
  scale_color_bfh_continuous(palette = "blues") +
  theme_bfh()


## ----show-palettes, eval=FALSE------------------------------------------------
# # Display all available palettes
# show_bfh_palettes()


## ----colors-------------------------------------------------------------------
# Get specific colors
bfh_cols("hospital_primary", "hospital_blue")

# Get all colors
head(bfh_cols())


## ----theme-standard, message=FALSE--------------------------------------------
ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  labs(title = "Vehicle Count by Cylinder") +
  scale_fill_bfh() +
  theme_bfh()


## ----theme-minimal, message=FALSE---------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "Minimal Theme Example") +
  theme_bfh_minimal()


## ----theme-print, message=FALSE-----------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "Print Theme Example") +
  theme_bfh_print()


## ----theme-presentation, message=FALSE----------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "Presentation Theme") +
  theme_bfh_presentation()


## ----theme-dark, message=FALSE------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point(color = "white") +
  labs(title = "Dark Theme Example") +
  theme_bfh_dark()


## ----defaults, eval=FALSE-----------------------------------------------------
# # Set BFH theme and colors as defaults
# set_bfh_defaults()
# 
# # Now all plots automatically use BFH styling
# ggplot(mtcars, aes(x = wt, y = mpg)) +
#   geom_point()
# 
# # For plots with color mappings, still add the scale manually
# ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
#   geom_point() +
#   scale_color_bfh()
# 
# # Reset to ggplot2 defaults when done
# reset_bfh_defaults()


## ----save-plot, eval=FALSE----------------------------------------------------
# p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
#   geom_point() +
#   theme_bfh()
# 
# # Save with preset dimensions
# bfh_save("plot.png", p, preset = "report_full")
# 
# # Custom dimensions
# bfh_save("plot.pdf", p, width = 8, height = 6, dpi = 600)


## ----dimensions, eval=FALSE---------------------------------------------------
# get_bfh_dimensions("presentation", "wide")


## ----fonts, eval=FALSE--------------------------------------------------------
# check_bfh_fonts()


## ----font-setup, eval=FALSE---------------------------------------------------
# # Setup and enable fonts
# setup_bfh_fonts()
# 
# # Set as default for all themes
# set_bfh_fonts()


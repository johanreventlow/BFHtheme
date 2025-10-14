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


## ----hospital-colors----------------------------------------------------------
# Access hospital colours
hospital_primary <- bfh_cols("hospital_primary")
hospital_blue <- bfh_cols("hospital_blue")

print(hospital_primary)
print(hospital_blue)

# View all hospital colours
hospital_palette <- bfh_cols(
  "hospital_primary",
  "hospital_blue",
  "hospital_light_blue1",
  "hospital_light_blue2",
  "hospital_grey"
)
print(hospital_palette)


## ----hospital-plot------------------------------------------------------------
ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  labs(
    title = "Hospital Branding Example",
    x = "Cylinders",
    fill = "Cylinders"
  ) +
  scale_fill_bfh(palette = "hospital") +
  theme_bfh()


## ----regionh-colors-----------------------------------------------------------
# Access Region H colours
regionh_primary <- bfh_cols("regionh_primary")
regionh_blue <- bfh_cols("regionh_blue")

print(regionh_primary)
print(regionh_blue)

# View all Region H colours
regionh_palette <- bfh_cols(
  "regionh_primary",
  "regionh_blue",
  "regionh_light_grey1",
  "regionh_light_grey2",
  "regionh_grey"
)
print(regionh_palette)


## ----regionh-plot-------------------------------------------------------------
ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  labs(
    title = "Region Hovedstaden Branding",
    x = "Cylinders",
    fill = "Cylinders"
  ) +
  scale_fill_bfh(palette = "regionh") +
  theme_bfh()


## ----hospital-sequential------------------------------------------------------
# Create sample data
set.seed(123)
data <- expand.grid(x = 1:10, y = 1:10)
data$z <- with(data, x + y + rnorm(100, 0, 2))

ggplot(data, aes(x = x, y = y, fill = z)) +
  geom_tile() +
  labs(title = "Hospital Blues Sequential Palette") +
  scale_fill_bfh_continuous(palette = "hospital_blues_seq") +
  theme_bfh()


## ----regionh-sequential-------------------------------------------------------
ggplot(data, aes(x = x, y = y, fill = z)) +
  geom_tile() +
  labs(title = "Region H Blues Sequential Palette") +
  scale_fill_bfh_continuous(palette = "regionh_blues_seq") +
  theme_bfh()


## ----hospital-infographic-----------------------------------------------------
# Sample categorical data
category_data <- data.frame(
  category = LETTERS[1:5],
  value = c(23, 45, 12, 34, 28)
)

ggplot(category_data, aes(x = reorder(category, value), y = value, fill = category)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Hospital Infographic Colours",
    x = "Category",
    y = "Value"
  ) +
  scale_fill_bfh(palette = "hospital_infographic") +
  theme_bfh() +
  theme(legend.position = "none")


## ----regionh-infographic------------------------------------------------------
ggplot(category_data, aes(x = reorder(category, value), y = value, fill = category)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Region H Infographic Colours",
    x = "Category",
    y = "Value"
  ) +
  scale_fill_bfh(palette = "regionh_infographic") +
  theme_bfh() +
  theme(legend.position = "none")


## ----combined-hospital--------------------------------------------------------
# Hospital version
p_hospital <- ggplot(mtcars, aes(x = wt, y = mpg, colour = hp)) +
  geom_point(size = 3) +
  labs(
    title = "Hospital Analysis",
    subtitle = "Vehicle Performance Data"
  ) +
  scale_color_bfh_continuous(palette = "hospital_blues") +
  theme_bfh()

print(p_hospital)


## ----combined-regionh---------------------------------------------------------
# Region H version
p_regionh <- ggplot(mtcars, aes(x = wt, y = mpg, colour = hp)) +
  geom_point(size = 3) +
  labs(
    title = "Region Hovedstaden Analysis",
    subtitle = "Vehicle Performance Data"
  ) +
  scale_color_bfh_continuous(palette = "regionh_blues") +
  theme_bfh()

print(p_regionh)


## ----defaults-hospital, eval=FALSE--------------------------------------------
# # Set hospital as default
# set_bfh_defaults(palette = "hospital")
# 
# # All subsequent plots use hospital colours
# ggplot(mtcars, aes(x = factor(cyl))) +
#   geom_bar()


## ----defaults-regionh, eval=FALSE---------------------------------------------
# # Switch to Region H defaults
# set_bfh_defaults(palette = "regionh")
# 
# # All subsequent plots use Region H colours
# ggplot(mtcars, aes(x = factor(cyl))) +
#   geom_bar()


## ----contrast-----------------------------------------------------------------
# Hospital primary on white background
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point(colour = bfh_cols("hospital_primary"), size = 3) +
  labs(title = "Hospital Primary Colour") +
  theme_bfh()

# Region H primary on white background
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point(colour = bfh_cols("regionh_primary"), size = 3) +
  labs(title = "Region H Primary Colour") +
  theme_bfh()


## ----colorblind, eval=FALSE---------------------------------------------------
# # Basic check
# check_colorblind_safe(bfh_cols("hospital_primary", "hospital_blue"))
# 
# # For comprehensive testing, use specialised packages
# # install.packages("colorblindcheck")
# library(colorblindcheck)
# 
# palette_check(
#   bfh_palettes$hospital,
#   plot = TRUE
# )


## ----department-colors--------------------------------------------------------
# Define department colours using base palette
dept_emergency <- bfh_cols("hospital_primary")
dept_surgery <- bfh_cols("hospital_blue")
dept_pediatrics <- bfh_cols("hospital_light_blue1")

dept_colors <- c(
  "Emergency" = dept_emergency,
  "Surgery" = dept_surgery,
  "Pediatrics" = dept_pediatrics
)

# Use in plots
dept_data <- data.frame(
  department = names(dept_colors),
  patients = c(120, 85, 95)
)

ggplot(dept_data, aes(x = department, y = patients, fill = department)) +
  geom_col() +
  scale_fill_manual(values = dept_colors) +
  labs(
    title = "Patient Count by Department",
    x = "Department",
    y = "Number of Patients"
  ) +
  theme_bfh() +
  theme(legend.position = "none")


## ----multi-site---------------------------------------------------------------
# Sample multi-site data
site_data <- data.frame(
  site = rep(c("BFH", "Rigshospitalet", "Hvidovre"), each = 4),
  quarter = rep(paste0("Q", 1:4), 3),
  value = c(
    85, 88, 92, 90,  # BFH
    78, 82, 85, 83,  # Rigshospitalet
    82, 85, 88, 86   # Hvidovre
  )
)

ggplot(site_data, aes(x = quarter, y = value, group = site, colour = site)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  labs(
    title = "Quarterly Performance Across Sites",
    x = "Quarter",
    y = "Performance Score",
    colour = "Site"
  ) +
  scale_colour_manual(
    values = c(
      "BFH" = bfh_cols("hospital_primary"),
      "Rigshospitalet" = bfh_cols("regionh_primary"),
      "Hvidovre" = bfh_cols("hospital_grey")
    )
  ) +
  theme_bfh()


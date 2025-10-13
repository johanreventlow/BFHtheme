# BFHtheme - Region Hovedstaden Color Demonstration
# ===================================================
# This script demonstrates Region Hovedstaden koncern colors

library(BFHtheme)
library(ggplot2)

cat("Region Hovedstaden Koncern Farvepalette\n")
cat("========================================\n\n")

cat("Officielle Region Hovedstaden farver:\n")
cat("- Primary (Identitetsfarve): ", bfh_cols("regionh_primary"), " (Navy)\n")
cat("- Region H Blue:             ", bfh_cols("regionh_blue"), "\n")
cat("- Light Grey 1:              ", bfh_cols("regionh_light_grey1"), "\n")
cat("- Light Grey 2:              ", bfh_cols("regionh_light_grey2"), "\n")
cat("- Region H Grey:             ", bfh_cols("regionh_grey"), "\n\n")

# Example 1: Region H bar chart
cat("\nEksempel 1: Søjlediagram med Region H farver\n")

data_regionh <- data.frame(
  Enhed = c("Enhed A", "Enhed B", "Enhed C", "Enhed D", "Enhed E"),
  Værdi = c(45, 67, 52, 78, 58)
)

p1 <- ggplot(data_regionh, aes(x = Enhed, y = Værdi, fill = Enhed)) +
  geom_col() +
  labs(
    title = "Enheder i Region Hovedstaden",
    subtitle = "Koncernfarver",
    x = "Enhed",
    y = "Værdi"
  ) +
  theme_bfh() +
  scale_fill_bfh(palette = "regionh_infographic") +
  theme(legend.position = "none")

print(p1)

# Example 2: Region H scatter plot with primary colors
cat("\nEksempel 2: Scatterplot med Region H primærfarver\n")

p2 <- ggplot(mtcars, aes(x = wt, y = mpg, color = factor(gear))) +
  geom_point(size = 3, alpha = 0.8) +
  labs(
    title = "Køretøjsanalyse",
    subtitle = "Region Hovedstaden",
    x = "Vægt (1000 lbs)",
    y = "Miles per Gallon",
    color = "Gear"
  ) +
  theme_bfh() +
  scale_color_bfh(palette = "regionh")

print(p2)

# Example 3: Region H continuous scale
cat("\nEksempel 3: Heatmap med sekventiel Region H palette\n")

p3 <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  labs(
    title = "Datadensitet",
    subtitle = "Sekventiel Region H farvepalette",
    x = "Ventetid",
    y = "Varighed",
    fill = "Tæthed"
  ) +
  theme_bfh() +
  scale_fill_bfh_continuous(palette = "regionh_blues_seq")

print(p3)

# Example 4: Comparison of Hospital vs Region H colors
cat("\nEksempel 4: Sammenligning af Hospital vs Region H farver\n")

comparison_data <- data.frame(
  Kategori = rep(c("A", "B", "C", "D"), 2),
  Type = rep(c("Hospital", "Region H"), each = 4),
  Værdi = c(23, 45, 32, 18, 28, 42, 35, 22)
)

p4 <- ggplot(comparison_data, aes(x = Kategori, y = Værdi, fill = Type)) +
  geom_col(position = "dodge") +
  labs(
    title = "Hospital vs Region Hovedstaden Farver",
    subtitle = "Sammenligning af farvepaletter",
    x = "Kategori",
    y = "Værdi",
    fill = "Type"
  ) +
  theme_bfh() +
  scale_fill_manual(
    values = c(
      "Hospital" = bfh_cols("hospital_primary"),
      "Region H" = bfh_cols("regionh_primary")
    )
  )

print(p4)

# Example 5: Using Region H as default
cat("\nEksempel 5: Brug Region H som standard\n")

set_bfh_defaults(theme = "bfh", palette = "regionh")

p5 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 2.5) +
  labs(
    title = "Iris Dataset med Region H Farver",
    subtitle = "Automatisk anvendelse af Region H tema"
  )

print(p5)

# Reset defaults
reset_bfh_defaults()

cat("\n✓ Region Hovedstaden color demonstration complete!\n")
cat("Alle plots bruger officielle Region Hovedstaden koncernfarver.\n")

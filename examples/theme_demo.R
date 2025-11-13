# remove.packages("BFHtheme")
# install.packages("BFHtheme_0.1.0.tar.gz", repos = NULL, type = "source")
#
# library(BFHtheme)
library(ggplot2)

devtools::load_all()
# devtools::check()

# Lav tidsseriedata
set.seed(123)
dates <- seq(as.Date("2020-01-01"), as.Date("2021-12-31"), by = "month")
n_months <- length(dates)

# Simuler 3 forskellige afdelinger
time_data <- data.frame(
  dato = rep(dates, 3),
  afdeling = rep(c("Kardiologi", "Ortopædi", "Neurokirurgi"), each = n_months),
  antal_patienter = c(
    # Kardiologi - stigende trend
    cumsum(rnorm(n_months, mean = 5, sd = 10)) + 150,
    # Ortopædi - cyklisk mønster
    100 + 30 * sin(seq(0, 4*pi, length.out = n_months)) + cumsum(rnorm(n_months, 0, 5)),
    # Neurokirurgi - stabil med variation
    cumsum(rnorm(n_months, mean = 1, sd = 8)) + 80
  )
)

# Lav tidsserieplot med Hospital branding
p <- ggplot(time_data, aes(x = dato, y = antal_patienter, color = afdeling)) +
  geom_line(linewidth = 1.2) +
  scale_color_bfh(palette = "hospital") +
  scale_x_datetime_bfh(breaks = scales::breaks_pretty(n = 8)) +
  bfh_labs(
    title = "Patientforløb over tid",
    subtitle = "Bispebjerg og Frederiksberg Hospital",
    caption = "Produceret okt 2025, \
    Afdeling for Kvalitet og Uddannelse, \
    Bispebjerg og Frederiksberg Hospital",
    x = "Indlæggelsesdato",
    y = "Antal patienter",
    color = ""
  ) +
  theme_bfh() +
  theme(legend.position = "none") |>
  add_bfh_logo()



# Tilføj logo
# p_branded <- add_logo(p, position = "bottomright")
# print(p_branded)

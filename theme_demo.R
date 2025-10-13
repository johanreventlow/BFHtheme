# remove.packages("BFHtheme")
# install.packages("BFHtheme_0.1.0.tar.gz", repos = NULL, type = "source")
#
# library(BFHtheme)
library(ggplot2)

devtools::load_all()
# devtools::check()
# Lav et plot med Hospital branding
# p <-
  ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  theme_bfh() +
  scale_color_bfh(palette = "hospital") +
  labs(title = "Bispebjerg og Frederiksberg Hospital") +
  theme(
  #   axis.text = ggplot2::element_text(color = "grey30", face = "plain")
  )

# Tilføj logo
p_branded <- add_logo(p, position = "bottomright")
print(p_branded)

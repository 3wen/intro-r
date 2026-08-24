library(tidyverse)

# DGP----

# Per capit GDP at market price
gdp <- read_csv("sdg_08_10_page_linear_2_0.csv")


p <- ggplot(
  data = gdp |> filter(
    TIME_PERIOD == 2024,
    !str_detect(`Geopolitical entity (reporting)`, "Euro")
  ),
  mapping = aes(
    x = OBS_VALUE,
    y = fct_reorder(`Geopolitical entity (reporting)`, OBS_VALUE)
  )
) +
  geom_bar(fill = "grey", colour = "black", stat = "identity") +
  labs(
    x = NULL, y = NULL,
    title = "GDP per capita, in real terms, in Euro, in 2024",
    subtitle = "Source: Eurostat (ref: sdg_08_10)"
  ) +
  scale_x_continuous(labels = scales::label_number(suffix = "", scale = 1)) +
  theme(plot.title.position = "plot")

dir.create("../figs/session1/", recursive = TRUE)
ggsave(p, file = "../figs/session1/gdp_per_capita.pdf", width = 8, height = 4)



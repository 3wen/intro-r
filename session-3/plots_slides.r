library(tidyverse)

# Source: https://www.insee.fr/en/statistiques/serie/000436394
file <- "data/deces_france_insee/monthly_values.csv"
deces <- read_csv2(file, skip = 4, col_names = c("period", "deaths", "codes"))

deces <-
  deces |>
  mutate(
    date = ym(period),
    month = month(date, label = TRUE),
    year = year(date)
  )

data_plot_deaths <- deces |>
  mutate(
    year_excess = case_when(
      year == 2003 ~ "2003 (Drought)",
      year == 2020 ~ "2020 (Covid-19)",
      TRUE ~ "Other"
    ),
    year_excess = factor(
      year_excess,
      levels = c("2003 (Drought)", "2020 (Covid-19)", "Other")
    )
  )

p_deaths <- ggplot(
  data = data_plot_deaths,
  mapping = aes(x = month, y = deaths, group = year, colour = year_excess)
) +
  geom_line(alpha = .8) +
  scale_colour_manual(
    NULL, values = c(
      "2003 (Drought)" = "blue",
      "2020 (Covid-19)" = "red",
      "Other" = "darkgray"
    )
  ) +
  labs(x = NULL, y = "Deaths") +
  scale_y_continuous(
    labels = scales::label_number(suffix = "", scale = 1, big.mark = ",")
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

ggsave(p_deaths, file = "figs/session3/p_deaths.pdf", width = 5, height = 3)


p_txhousing <- ggplot(
  data = txhousing,
  mapping = aes(x = volume, y = sales)
) +
  geom_point()


ggsave(p_txhousing, filename = "figs/session3/txhousing.pdf", width = 5, height = 3)

p_txhousing_colours <- ggplot(
  data = txhousing,
  mapping = aes(x = volume, y = sales)
) +
  geom_point(mapping = aes(colour = listings))

ggsave(p_txhousing_colours, filename = "figs/session3/txhousing_colours.pdf", width = 5, height = 3)


# Histogram----

txhousing_median_barplot <- ggplot(
  data = txhousing,
  mapping = aes(x = median)
) +
  geom_histogram(colour = "white")

ggsave(txhousing_median_barplot, file = "figs/session3/txhousing_median_barplot.pdf", width = 5, height = 3)


# Density----

txhousing_median_density <- ggplot(
  data = txhousing,
  mapping = aes(x = median)
) +
  geom_density(colour = "blue")

ggsave(txhousing_median_density, file = "figs/session3/txhousing_median_density.pdf", width = 5, height = 3)


# Bar plot----

diamonds_cut_barplot <- ggplot(
  data = diamonds,
  mapping = aes(y = cut)
) +
  geom_bar(colour = "blue", fill = "grey")

ggsave(diamonds_cut_barplot, file = "figs/session3/diamonds_cut_barplot.pdf", width = 5, height = 3)


# Scatter plot----

twhousing_scatterplot <- ggplot(
  data = txhousing,
  mapping = aes(
    x = volume, y = sales,
    colour = listings,
    alpha = median,
    size = inventory
  )
) +
  geom_point() +
  theme(legend.position = "bottom")

ggsave(twhousing_scatterplot, file = "figs/session3/twhousing_scatterplot.pdf", width = 9, height = 5)


# Line plot----

txhousing_median_line <- ggplot(
  data = txhousing,
  mapping = aes(x = date, y = sales, group = city)
) +
  geom_line(colour = "blue", alpha = .3)

ggsave(txhousing_median_line, file = "figs/session3/txhousing_median_line.pdf", width = 5, height = 3)

# Labels----

p_labels <- ggplot(
  data = txhousing,
  mapping = aes(
    x = volume, y = sales,
    colour = listings
  )
) +
  geom_point() +
  labs(
    title = "No. housing sales vs. tot. volume",
    subtitle = "Texas, 2000 – 2015",
    x = "Total value of sales",
    y = "Number of sales",
    colour = "Total active listings"
  )

ggsave(p_labels, file = "figs/session3/p_labels.pdf", width = 5, height = 3)


# Scales----

p_txhousing_colours_scale <- ggplot(
  data = txhousing,
  mapping = aes(x = volume, y = sales)
) +
  geom_point(mapping = aes(colour = listings)) +
  scale_colour_gradient(
    "Total active listings",
    low = "yellow", high = "red"
  )

ggsave(p_txhousing_colours_scale, filename = "figs/session3/p_txhousing_colours_scale.pdf", width = 5, height = 3)



p_diamonds_scale <- ggplot(
  data = sample_n(diamonds, size = 1000),
  mapping = aes(
    x = carat, y = price, colour = cut
  )
) +
  geom_point() +
  scale_colour_manual(
    "Cut",
    values = c(
      "Fair" = "black",
      "Good" = "blue",
      "Very Good" = "darkgreen",
      "Premium" = "palegreen",
      "Ideal" = "yellow"
    )
  )

ggsave(p_diamonds_scale, filename = "figs/session3/p_diamonds_scale.pdf", width = 5, height = 3)


# Facetting

p_diamonds_facet_wrap <- ggplot(
  data = sample_n(diamonds, size = 5000),
  mapping = aes(
    x = carat, y = price
  )
) +
  geom_point(size = .5, alpha = .1) +
  facet_wrap(~ cut)

ggsave(p_diamonds_facet_wrap, filename = "figs/session3/p_diamonds_facet_wrap.pdf", width = 5, height = 3)


p_diamonds_facet_grid <-
  ggplot(
  data = sample_n(diamonds, size = 5000),
  mapping = aes(
    x = carat, y = price
  )
) +
  geom_point(size = .5, alpha = .1) +
  facet_grid(clarity ~ cut)

ggsave(p_diamonds_facet_grid, filename = "figs/session3/p_diamonds_facet_grid.pdf", width = 5, height = 5)

library(tidyverse)
library(ggplot2)

p_pop <- ggplot(
  data = tibble(
    year = c(1968, 1975, 1982, 1990, 1999, 2006, 2011, 2016, 2022),
    pop = c(89566, 110659, 121327, 123842, 134222, 142534, 140684, 143006, 147933)
  ),
  mapping = aes(x = year, y = pop)
) +
  geom_line() +
  geom_point() +
  labs(x = "Year", y = NULL, title = "Population in Aix-en-Provence") +
  scale_x_continuous(n.breaks = 10) +
  scale_y_continuous(labels = scales::label_number(scale = 1)) +
  theme(plot.title.position = "plot")

ggsave(p_pop, file = "../figs/session1/pop_aix.pdf", width = 8, height = 4)

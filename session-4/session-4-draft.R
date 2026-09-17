# Session 3----

library(tidyverse)

# First rows of the iris dataset
head(iris)

# A point of interest here: the 10th of the dataset
point_of_interest <- iris[10,]

# A first scatter plot
p_scatter_plot_iris <- ggplot(
  data = iris,
  mapping = aes(x = Sepal.Length, y = Sepal.Width)
) +
  annotate(
    geom = "text",
    x = point_of_interest$Sepal.Length,
    y = point_of_interest$Sepal.Width,
    label = "Our point",
    vjust = 1, # vertical justification
    hjust = -.25,
    colour = "Orange"
  ) +
  geom_point(
    mapping = aes(colour = Species)
  ) +
  geom_point(
    data = point_of_interest,
    size = 4,
    mapping = aes(colour = Species)
  ) +
  scale_colour_manual(
    name = "Espèce",
    values = c(
      "setosa" = "red",
      "versicolor" = "blue",
      "virginica" = "green"
    ),
    labels = c(
      "setosa" = "Setosa",
      "versicolor" = "Versicolor",
      "virginica" = "Virginica"
    ),
    # guide = "none" # If this is uncommented, the legend disappears
  ) +
  labs(
    title = "Sepal width vs. sepal length",
    subtitle = "Source: Iris dataset",
    #x = "Sepal Length",
    y = "Sepal Width",
    x = NULL
  ) +
  theme_minimal() +
  theme(plot.title.position = "plot") +
  coord_cartesian(xlim = c(4, 6), ylim = c(2.5, 4))

p_scatter_plot_iris +
  labs(x = "Sepal Length")

# A scatteplot with a numeric variable mapped to the colour of the
# dots.
ggplot(
  data = iris,
  mapping = aes(x = Sepal.Length, y = Sepal.Width)
) +
  geom_point(
    mapping = aes(colour = Petal.Length)
  ) +
  # scale_colour_continuous(
  #   palette = c("#EFEDF5", "#BCBDDC", "#756BB1")
  # )
  # scale_color_gradient(low = "#264d04", high = "#c8eba9")
  scale_color_gradient2(
    low = "red", mid = "white", high = "blue",
    midpoint = 3
  )


head(diamonds)

# The na.rm argument, when set to TRUE, ignores the NA values
# when calculating the mean
mean(c(2, 3, NA, 4))
mean(c(2, 3, NA, 4), na.rm = TRUE)

# Average price per cut in diamonds
avg_price_diamonds <- diamonds |>
  group_by(cut) |>
  summarise(
    avg_price = mean(price, na.rm = TRUE)
  )

p_barplot_diamond_prices <- ggplot(
  data = avg_price_diamonds,
  mapping = aes(
    y = fct_reorder(cut, avg_price),
    x = avg_price
  )
) +
  geom_col(mapping = aes(fill = cut)) +
  annotate(
    geom = "text",
    x = avg_price_diamonds$avg_price,
    y = avg_price_diamonds$cut,
    label = scales::dollar(round(avg_price_diamonds$avg_price)),
    hjust = -0.1
  ) +
  scale_fill_manual(
    values = c(
      "Premium" = "#FED100",
      "Fair" = "#FF8B7C",
      "Very Good" = "#FF7900",
      "Good" = "#33CCFF",
      "Ideal" = "#53DE94"
    ),
    guide = "none"
  ) +
  labs(
    title = "Average Price of Diamonds per cut",
    subtitle = "Source: diamonds dataset",
    x = "Price (USD)",
    y = NULL
  ) +
  theme_minimal() +
  theme(plot.title.position = "plot") +
  scale_x_continuous(labels = scales::label_comma()) +
  coord_cartesian(xlim = c(min(diamonds$price), 5000))
# theme(axis.text.x = element_blank())

p_barplot_diamond_prices

# Export in PDF
ggsave(
  filename = "figs/barplot_diamond_prices_per_cut.pdf",
  width = 8, # inches
  height = 4
)

# Export in PNG
ggsave(
  filename = "figs/barplot_diamond_prices_per_cut_300dpi.png",
  width = 8, # inches
  height = 4,
  dpi = 300
)

# With a lower resolution (100 dots per inches)
ggsave(
  filename = "figs/barplot_diamond_prices_per_cut_100dpi.png",
  width = 8, # inches
  height = 4,
  dpi = 100
)

# `plot_grid` from {cowplot} allows to graph multiple plots in
# a single figure
p <- cowplot::plot_grid(
  p_scatter_plot_iris, p_barplot_diamond_prices,
  ncol = 1)


# Faceting
# With `facet_grid()`, creates a matrix of plots
# with the levels of one variable in column and that of another
# variable in rows: first_var ~ second_var.
ggplot(
  data = iris,
  mapping = aes(x = Sepal.Length, y = Sepal.Width)
) +
  geom_point() +
  facet_grid(Species ~ .)


ggplot(
  data = diamonds,
  mapping = aes(x = carat, y = price)
) +
  geom_point() +
  facet_grid(color ~ cut)

# With `facet_wrap()`, creates a graph for each subset created in the
# data; no more a matrix of plots.
ggplot(
  data = diamonds,
  mapping = aes(x = carat, y = price)
) +
  geom_point() +
  facet_wrap(color ~ cut)

ggplot(
  data = diamonds,
  mapping = aes(x = carat, y = price)
) +
  geom_point(alpha = .2) +
  facet_grid(~ cut) +
  # geom_smooth(method = "lm") # linear fit
  geom_smooth(method = "gam")


# Session 4----

library(tidyverse)

tb <- read_csv("../data/out/gdp_lifesatisf.csv")

# Subsetting the data: happy countries and unhappy countries, in 2018
# Life satisfaction of 7 (on a scale from 1 to 10) used as the
# threshold.
happy <- filter(
  tb,
  life_satisf >= 7, year == 2018
)
unhappy <- filter(
  tb, life_satisf < 7, year == 2018
)

dim(happy)
dim(unhappy)
mean(happy$gdp, na.rm = TRUE)
mean(unhappy$gdp, na.rm = TRUE)

## Two sample t-test

# Null hypothesis: the mean of GDP is the same in
# happy and in unhappy countries.
t.test(happy$gdp, unhappy$gdp)

## Regression----
library(modelr)

# Fictious dataset
sim1

res_sim1 <- lm(y ~ x, data = sim1)
class(res_sim1)
coef(res_sim1)

# Summary of the estimation
summary(res_sim1)

# We can have a quick look at the residuals
plot(residuals(res_sim1))

# Prediction on the data that were used to train the model
predict(res_sim1)

# If we want to predict on new data, we need to provide a table
# with the same format as that used to train the model
# (same name of variables, and same type)
predict(res_sim1, newdata = tibble(x = c(2,4,5)))

# Presenting the results in a nice table
library(stargazer)
stargazer(res_sim1, type = "html", out = "tables/regresion.html")

# We can compare multiple regression on a single result table.
res_sim4_1 <- lm(y ~ x1,      data = sim4)
res_sim4_2 <- lm(y ~ x1 + x2, data = sim4)

stargazer(
  res_sim4_1,
  res_sim4_2, type = "html", out = "tables/regresion.html"
)

# Regressing life satisfation on per capita GDP.
model_lm <- lm(life_satisf ~ gdp, data = tb)
summary(model_lm)

tb |> filter(!is.na(life_satisf), !is.na(gdp))

confint(model_lm)

# The values in the table for the estimated slope
# and the corresponding t-test
summary(model_lm)
estimates <- summary(model_lm)$coefficients
intercept <- estimates[2, "Estimate"]
intercept_sd <- estimates[2, "Std. Error"]
t_obs <- intercept / intercept_sd
t_obs

ggplot(
  data = tibble(
    x = seq(-4, 15, by = .01),
    y = dt(x = seq(-4, 15, by = .01), df = 199)
  ),
  mapping = aes(x = x, y = y)
) +
  geom_vline(xintercept = t_obs, colour = "red", linetype = "dashed") +
  geom_line() +
  coord_cartesian(xlim = c(-4, 15))





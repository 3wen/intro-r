library(tidyverse)

tb <- read_csv("../data/out/gdp_lifesatisf.csv")


happy <- tb |> filter(life_satisf >= 7, year == 2018)
unhappy <- tb |> filter(life_satisf < 7, year == 2018)
t.test(happy$gdp, unhappy$gdp)

p <- ggplot(
  data = tb |> filter(year == 2018),
  mapping = aes(x = gdp, y = life_satisf)
) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Real per capita GDP in 2013 (2020 Euro)",
    y = "Life satisfaction"
  ) +
  scale_x_continuous(
    labels = scales::label_number(suffix = "", scale = 1, big.mark = ",")
  )
ggsave(p, file = "session-4/figs/lm_life_satisf.pdf", width = 5, height = 3)


# OLS----

library(modelr)

mod_sim1 <- lm(formula = y ~ x, data = modelr::sim1)
mod_sim1
coef(mod_sim1)
coef(mod_sim1)["(Intercept)"]
coef(mod_sim1)["x"]

predict(mod_sim1)
residuals(mod_sim1)

summary(mod_sim1)

library(stargazer)
stargazer(mod_sim1, type = "text")

## Predicted values----

p <-
  ggplot(
    data = sim1 |> mutate(
      pred = predict(mod_sim1, newdata = sim1)
    )
  ) +
  geom_point(mapping = aes(x = x, y = y)) +
  geom_line(
    mapping = aes(x = x, y = pred),
    colour= "dodgerblue", linewidth = 1
  )

ggsave(p, file = "session-4/figs/lm_sim1.pdf", width = 5, height = 3)

## Residuals----

p <- ggplot(
  data = sim1 |> mutate(
    resid = residuals(mod_sim1)
  )
) +
  # geom_freqpoly(
  geom_histogram(
    mapping = aes(x = resid),
    binwidth = 0.5, colour = "white"
  ) +
  labs(x = "Residuals", y = "Count")
ggsave(p, file = "session-4/figs/lm_sim1_residuals.pdf", width = 5, height = 3)

## Q-Q Plot----

p_qq <- ggplot(
  data = sim1 |> mutate(
    resid = residuals(mod_sim1)
  ),
  mapping = aes(sample = y)
) + stat_qq() + stat_qq_line() +
  labs(title = "Normal QQ plot")

ggsave(p_qq, file = "session-4/figs/lm_sim1_qq.pdf", width = 5, height = 3)

## Residuals vs. X----

p <- ggplot(
  data = sim1 |> mutate(
    resid = residuals(mod_sim1)
  )
) +
  geom_ref_line(h = 0) +
  geom_point(
    mapping = aes(x = x, y = resid),
  ) +
  labs(y = "Residuals")
ggsave(p, file = "session-4/figs/lm_sim1_residuals_biv.pdf", width = 5, height = 3)

# Categorical variable

mod_sim2 <- lm(y ~ x, data = sim2)
p <- ggplot(
  data = sim2 |>
    mutate(pred = predict(mod_sim2)),
  mapping = aes(x = x)
)+
  geom_point(mapping = aes(y = y)) +
  geom_point(
    mapping = aes(y = pred),
    colour = "red"
  )

ggsave(p, file = "session-4/figs/lm_sim2.pdf", width = 5, height = 3)


lm(y ~ x, data = sim2)

lm(
  y ~ x,
  data = sim2 |>
    mutate(x = factor(x, levels = c("c", "a", "b", "d"))),

)


lm(
  y ~ x,
  data = sim2 |>
    mutate(x = fct_relevel(x, "c"))

)

# Interaction terms----

p <- ggplot(
  data = sim3,
  mapping = aes(x = x1, y = y, colour = x2)) +
  geom_point() +
  geom_smooth()

ggsave(p, file = "session-4/figs/sim3_data.pdf", width = 5, height = 3)

(mod_bench <- lm(y ~ x1 + x2, data = sim3))
(mod_interact <- lm(y ~ x1 * x2, data = sim3))
mod_interact_bis <- lm(y ~ x1 + x2 + x1 : x2, data = sim3) # alternatively


p <- ggplot(
  data = sim3 |>
    gather_predictions(mod_bench, mod_interact) |>
    mutate(
      model = factor(
        model,
        levels = c("mod_bench", "mod_interact"),
        labels = c("Benchmark", "Interaction~between~x[1]~and~x[2]"))
    ),
  mapping = aes(x = x1, y = y, colour = x2)
) +
  geom_point() +
  geom_line(aes(y = pred)) +
  facet_wrap(
    ~ model,
    labeller = labeller(
      model = label_parsed
    )
  )

ggsave(p, file = "session-4/figs/sim3_slopes_comparison.pdf", width = 5, height = 3)

## Residuals


p <- ggplot(
  data = sim3 |>
    modelr::gather_residuals(mod_bench, mod_interact) |>
    mutate(
      model = factor(
        model,
        levels = c("mod_bench", "mod_interact"),
        labels = c("Benchmark", "Interaction~between~x[1]~and~x[2]"))
    ),
  mapping = aes(x = x1, y = resid, colour = x2)
) +
  geom_point() +
  facet_grid(
    model ~ x2,
    labeller = labeller(
      model = label_parsed
    )
  ) +
  labs(y = "residuals")

ggsave(p, file = "session-4/figs/sim3_interact_residuals_biv.pdf", width = 5*1.5, height = 3*1.5)



(mod1 <- lm(y ~ x1 + x2, data = sim4))
(mod2 <- lm(y ~ x1 * x2, data = sim4))

gather_predictions(data = sim4, mod1, mod2)

p <- ggplot(
  data = sim4 |>
    gather_predictions(mod1, mod2) |>
    mutate(
      model = factor(
        model,
        levels = c("mod1", "mod2"),
        labels = c("Benchmark", "Interaction~between~x[1]~and~x[2]"))
    ),
  mapping = aes(x = x1, y = pred, color = x2, group = x2)
) +
  geom_line() +
  facet_wrap( ~ model)

ggsave(p, file = "session-4/figs/sim4_interact_numeric.pdf", width = 5*1.5, height = 3*1.5)


lm(y ~ x + I(x^2), data = sim1)
lm(y ~ poly(x, 2, raw = TRUE), data = sim1)

lm(y ~ splines::ns(x, df = 2), data = sim1)



tb <- read_csv("data/out/gdp_lifesatisf.csv")
tb <- tb |> filter(year %in% c(2013, 2018, 2021, 2022, 2023, 2024))

## Pooling----

mod_fe <- lm(
  life_satisf ~ gdp + factor(year),
  data = tb
)

library(plm)
tb_pdata <- pdata.frame(tb, index = c("country", "year"))
mod_fe_plm <- plm(
  life_satisf ~ gdp + factor(year),
  data = tb_pdata,
  model = "pooling"
)

library(fixest)
mod_fe_fixest <- feols(life_satisf ~ gdp | year, data = tb)
etable(mod_fe_fixest)

stargazer(
  mod_fe, mod_fe_plm,
  type = "text", title = c("lm", "plm", "fixest")
)



## TWFE----


mod_twfe <- plm(
  life_satisf ~ gdp,
  data = tb_pdata,
  model = "within",
  effect = "twoways"
)

mod_twfe_lm <- lm(
  life_satisf ~ gdp + factor(country) + factor(year),
  data = tb
)

# mod_fe_within_plm <- plm(
#   life_satisf ~ gdp + factor(year),
#   data = tb_pdata,
#   model = "within", effect = "individual"
# )



# With the within estimator
mod_twfe_within <- lm(
  life_satisf ~ gdp + year_2018 + year_2021 +
    year_2022 + year_2023 + year_2024 - 1,
  data = tb |>
    na.omit() |>
    fastDummies::dummy_cols(
      select_columns = "year",
      remove_first_dummy = TRUE
    ) |>
    group_by(country) |>
    mutate(
      life_satisf = life_satisf - mean(life_satisf),
      gdp = gdp - mean(gdp),
      across(starts_with("year_"), ~ .x - mean(.x))
    ) |>
    ungroup()
)

stargazer(
  mod_twfe, mod_twfe_within,
  type = "text", title = c("lm", "plm", "fixest")
)


library(fixest)
mod_fe_fixest <- feols(life_satisf ~ gdp | year, data = tb)
etable(mod_fe_fixest)

mod_twfe_fixest <- feols(life_satisf ~ gdp | year + country, data = tb)
etable(mod_twfe_fixest)

library(tidyverse)
gdp <- read_csv("data/sdg_08_10_page_linear_2_0.csv")
life_satisf <- read_csv("data/ilc_pw01$defaultview_linear_2_0.csv")
life_satisf <- life_satisf |>
  select(geo, TIME_PERIOD, OBS_VALUE)
life_satisf <- life_satisf |>
  rename(
    country = geo,
    year = TIME_PERIOD,
    life_satisf = OBS_VALUE
  )

dir.create("data/out/", recursive = TRUE)
write_csv(life_satisf, file = "data/out/lifesat.csv")
gdp <- gdp |>
  select(geo, TIME_PERIOD, OBS_VALUE) |>
  rename(
    country = geo,
    year = TIME_PERIOD,
    gdp = OBS_VALUE
  ) |>
  write_csv(file = "data/out/gdp.csv")



combined_data <- gdp |> full_join(life_satisf)
combined_data |>
  write_csv(file = "data/out/gdp_lifesatisf.csv")

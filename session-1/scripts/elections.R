library(sf)
library(tidyverse)
library(readxl)

# Carte des départements
# Source: https://www.data.gouv.fr/datasets/carte-des-departements-2-1/
map_dpt <- read_sf("contour-des-departements.geojson")

# IGN — ADMIN EXPRESS / ADMIN EXPRESS COG (communes boundaries)
map_dep <- read_sf("ADMIN-EXPRESS_4-0__GPKG_LAMB93_FXX_2025-08-15/ADMIN-EXPRESS/1_DONNEES_LIVRAISON_2025-08-00153/ADE_4-0_GPKG_LAMB93_FXX-ED2025-08-15/ADE_4-0_GPKG_LAMB93_FXX-ED2025-08-15.gpkg", layer = "COMMUNE")

# Code officiel géographique au 1er janvier 2024
# Source: https://www.insee.fr/fr/information/7766585
cog <- read_csv("cog_ensemble_2024_csv/v_commune_2024.csv")



# Source: https://www.data.gouv.fr/datasets/elections-legislatives-des-30-juin-et-7-juillet-2024-resultats-definitifs-du-1er-tour/
# Élections législatives des 30 juin et 7 juillet 2024 - Résultats définitifs
# du 1er tour
# Resultats définitifs par commune
# Code commune: corresponds to Code INSEE...
elections <- read_excel("resultats-definitifs-par-communes.xlsx")
elections <- elections |>
  select(
    code_insee = `Code commune`,
    Inscrits, Votants) |>
  filter(!is.na(code_insee)) |>
  mutate(share_voters = 100 * Votants / Inscrits)



# elections <- elections |> filter(!is.na(`Code commune`)) |>
#   left_join(
#     cog |>
#       mutate(
#         COM = as.numeric(COM),
#         CAN = as.numeric(CAN)
#         ) |>
#       select(COM, code_insee = CAN),
#     by = c("Code commune" = "COM")
#   )

# elections |> group_by(`Code commune`) |> count() |> filter(n>1)

# Codes INSEE Communes géolocalisées
# Source: https://www.data.gouv.fr/datasets/codes-insee-communes-geolocalisees-nd/
# geoloc <- read_csv("Codes-INSEE-communes-geolocalisees.csv")

# Merge
# elections <- elections |>
#   mutate(`Code commune` = as.character(`Code commune`)) |>
#   left_join(
#     geoloc |>
#       select(Insee, longitude = longitude_radian, latitude = latitude_radian),
#     by = c("Code commune" = "Insee")
#   ) |>
#   mutate(
#     longitude = longitude * 180 / pi,
#     latitude = latitude * 180 / pi
#   )


# elections_sf <-
#   elections |> mutate(share_voters = 100 * Votants / Inscrits) |>
#   filter(!is.na(longitude)) |>
#   select(longitude, latitude, share_voters) |>
#   st_as_sf(coords = c("longitude", "latitude"))

# sf::st_crs(elections_sf) <- sf::st_crs(map_dpt)

# p_map_turnout <- ggplot() +
#   geom_sf(data = map_dpt) +
#   geom_sf(
#     data = elections_sf, mapping = aes(colour = share_voters),
#     size = .1) +
#   scale_colour_gradient("Turnout (%)", low = "#FDF8DA", high = "#3067A1") +
#   theme(legend.position = "bottom")

ecfd_turnout <- ecdf(elections$share_voters)
elections <-
  elections |>
  mutate(
    turnout_percentile = ecfd_turnout(share_voters) * 100
  )


p_map_turnout <- ggplot() +
  geom_sf(
    data = map_dep |>
      mutate(code_insee = as.numeric(code_insee)) |>
      left_join(
        elections |>
          select(code_insee, turnout_percentile),
        by = "code_insee"
      ),
    mapping = aes(fill = turnout_percentile),
    colour = NA
  ) +
  scale_fill_gradient("Turnout percentile (%)", low = "#FDF8DA", high = "#3067A1") +
  theme(legend.position = "bottom")



ggsave(p_map_turnout, file = "../figs/session1/turnout.png", width = 6, height = 6)

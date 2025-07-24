#' Visualise la consommation moyenne par tête par région sur une carte (version robuste)
#'
#' @param baseconso DataFrame contenant au minimum les colonnes "région" (nom ou code) et "conso_moy_kg"
#' @param shapefile_path Chemin vers le fichier shapefile (.shp) des régions
#' @param titre Titre de la carte (optionnel)
#'
#' @return Une carte tmap représentant la consommation moyenne par tête par région
#' @export
#'
#' @import dplyr sf stringi tmap
visualiser_consommation_par_région <- function(baseconso, shapefile_path, titre = "Consommation moyenne par tête (kg)") {
  library(dplyr)
  library(sf)
  library(tmap)
  library(stringi)



  noms_régions <- c("DAKAR", "ZIGUINCHOR", "DIOURBEL", "SAINT LOUIS", "TAMBACOUNDA",

                    "KAOLACK", "THIES", "LOUGA", "FATICK", "KOLDA",

                    "MATAM", "KAFFRINE", "KEDOUGOU", "SEDHIOU")
  baseconso$région <- noms_régions[baseconso$région]

  # Lecture du shapefile
  shapefile <- st_read(shapefile_path, quiet = TRUE)

  #correspondance
  correspondance <- data.frame(
    région = as.character(1:14),
    NOMREG = c("DAKAR", "ZIGUINCHOR", "DIOURBEL", "SAINT LOUIS", "TAMBACOUNDA",
               "KAOLACK", "THIES", "LOUGA", "FATICK", "KOLDA",
               "MATAM", "KAFFRINE", "KEDOUGOU", "SEDHIOU")
  )

  baseconso <- baseconso %>%
    mutate(NOMREG = région)



  # Fusionner
  shapefile_merged <- shapefile %>%
    left_join(baseconso, by = "NOMREG")

  # Affichage carte
  tmap_mode("plot")

  tm_shape(shapefile_merged) +
    tm_polygons(
      col = "Conso_par_personne_kg",
      palette = "YlGnBu",
      title = "Conso moyenne (kg)",
      style = "quantile",
      border.col = "white"
    ) +
    tm_text("NOMREG", size = 0.43, col = "black", just = "left") +
    tm_text(" ", size = 0.45, col = "black", ymod = -1.0, fontface = "bold") +
    tm_layout(
      main.title = titre,
      main.title.size = 1.2,
      legend.outside = TRUE,
      frame = FALSE
    )
}

#' Calcule la consommation moyenne de produits par tête et par région
#'
#' Cette fonction traite une base brute de consommation (comme `laitier`),
#' applique les conversions, fusionne avec la taille des ménages et les infos régionales,
#' et retourne la consommation moyenne par personne et par région.
#'
#' @param base_brute data.frame. Base brute de consommation (ex: laitier)
#' @param df_conv data.frame. Table de conversion avec poids
#' @param membres data.frame. Table des membres du ménage pour calculer la taille
#' @param adresse data.frame. Table avec les variables de région et milieu
#'
#' @return Un tableau avec région, total consommé, taille totale, consommation moyenne par tête
#' @export
#'
#' @examples
#' conso_par_tete_region(laitier, df_conv, membres, adresse)
Etape1_conso_regionale <- function(base_brute, df_conv, membres, adresse) {
  library(dplyr)
  library(stringr)

  # 1. Renommer les colonnes de la base brute
  base_brute <- base_brute %>%
    rename(
      menage = !!sym(names(base_brute)[1]),
      produit = !!sym(names(base_brute)[3]),
      quantite_consommee = !!sym(names(base_brute)[4]),
      unite = !!sym(names(base_brute)[5]),
      taille = !!sym(names(base_brute)[6])
    )
  base_brute <- base_brute %>%
    mutate(
      produit = as.character(produit),
      unite = as.character(unite),
      taille = as.character(taille)
    )

  df_conv <- df_conv %>%
    mutate(
      produit = as.character(produit),
      unite = as.character(unite),
      taille = as.character(taille)
    )

  # 2. Jointure avec la table de conversion
  df_merge <- base_brute %>%
    left_join(df_conv, by = c("produit", "unite", "taille"))

  # 3. Nettoyage des poids
  df_merge$poids <- as.numeric(sub(",", ".", df_merge$poids))

  # Gestion des poids manquants
  df_merge$poids[df_merge$produit == 174 & df_merge$taille == 2 & df_merge$unite == 142] <- 3400
  df_merge$poids[df_merge$produit == 174 & df_merge$taille == 0 & df_merge$unite == 115] <- 1200

  # 4. Conversion en kg
  df_merge <- df_merge %>%
    mutate(
      quantite_standard_kg = (quantite_consommee * poids) / 1000
    )

  # 5. Sélection des variables utiles
  df_merge <- df_merge %>%
    select(menage, produit, unite, taille, quantite_standard_kg)

  # 6. Récupérer l’identifiant `IDs`
  df_merge$IDs <- base_brute[[2]]

  # 7. Ajouter la taille du ménage
  membres <- membres %>%
    rename(IDs = !!sym(names(base_brute)[2])) %>%
    group_by(IDs) %>%
    summarise(Taille_Menage = n(), .groups = "drop")

  # 8. Ajouter l’adresse (région, milieu)
  adresse <- adresse %>%
    select(IDs = !!sym(names(adresse)[2]), region = !!sym(names(adresse)[7]), milieu = !!sym(names(adresse)[9]))

  # 9. Fusion de tout
  base_combinee <- df_merge %>%
    left_join(membres, by = "IDs") %>%
    left_join(adresse, by = "IDs")

  # 10. Agrégation par région
  base_finale <- base_combinee %>%
    filter(!is.na(region), !is.na(quantite_standard_kg), !is.na(Taille_Menage)) %>%
    group_by(region) %>%
    summarise(
      Quantite_totale_kg = sum(quantite_standard_kg, na.rm = TRUE),
      Population_totale = sum(Taille_Menage, na.rm = TRUE),
      Conso_par_personne_kg = Quantite_totale_kg / Population_totale
    ) %>%
    ungroup()

  return(base_finale)
}

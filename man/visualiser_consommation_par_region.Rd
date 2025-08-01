% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Etape2_carte.R
\name{visualiser_consommation_par_region}
\alias{visualiser_consommation_par_region}
\title{Visualise la consommation moyenne par tête par région sur une carte (version robuste)}
\usage{
visualiser_consommation_par_region(
  baseconso,
  shapefile_path,
  titre = "Consommation moyenne par tête (kg)"
)
}
\arguments{
\item{baseconso}{DataFrame contenant au minimum les colonnes "region" (nom ou code) et "conso_moy_kg"}

\item{shapefile_path}{Chemin vers le fichier shapefile (.shp) des régions}

\item{titre}{Titre de la carte (optionnel)}
}
\value{
Une carte tmap représentant la consommation moyenne par tête par région
}
\description{
Visualise la consommation moyenne par tête par région sur une carte (version robuste)
}

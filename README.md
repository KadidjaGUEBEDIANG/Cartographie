# COMMENT UTILISER LE PACKAGE
Pour utiliser le package Cartographie, il suffit d'exécuter ces codes mais en adaotat les chemins d'accès aux votres:
remotes::install_github("KadidjaGUEBEDIANG/Cartographie")


library(consoLaitierR)

data <- Etape1_traitement_initial("C:/Users/LENOVO/Desktop/R_project/Data/Raw/Base_X*.dta")

baseVUmenage <- Etape2_analyse_valeurs_unitaires_et_sources(data)

base_semi_apuree <- Etape3_conversion_standardisation(
  data,
  baseVUmenage,
  "C:/Users/LENOVO/Desktop/R_project/conversion.xlsx"
)

Ehcvm_all <- read_dta("C:/Users/LENOVO/Desktop/R_project/Ehcvm_all.dta")

Base_X1_Apurée <- Etape4_nettoyage_validation(
  base_semi_apuree,
  data,
  "C:/Users/LENOVO/Desktop/R_project",
  Ehcvm_all
)
View(Base_X1_Apurée)
fin <- Etape5_calcul_indicateurs(Base_X1_Apurée, data)
View(fin$indice_simpson)
View(fin$part_achat)
View(fin$part_autoconsommation)
View(fin$part_recue)
View(fin$diversite_sources)

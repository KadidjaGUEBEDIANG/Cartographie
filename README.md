# COMMENT UTILISER LE PACKAGE

  ## Installation du package

```r
# Installer depuis GitHub
remotes::install_github("KadidjaGUEBEDIANG/Cartographie")
```
 ## Exemple d'utilisation

```r
# Charger les bibliothèques nécessaires
library(CARTOGRAPHIE)
library(haven)
library(readxl)
library(sf)

# Charger les fichiers de données
laitier <- read_dta("C:/Users/LENOVO/Desktop/R_project/laitier.dta")
df_conv <- read_excel("C:/Users/LENOVO/Desktop/R_project/conversion.xlsx")
membres <- read_dta("C:/Users/LENOVO/Desktop/R_project/S00_S01_membres.dta")
adresse <- read_dta("C:/Users/LENOVO/Desktop/R_project/Ehcvm_all.dta")
shapefile <- st_read("C:/Users/LENOVO/Desktop/projet_8_visualisation/Base/Limite_Région.shp")

# Traitement
baseconso <- Etape1_conso_régionale(laitier, df_conv, membres, adresse)

# Visualisation cartographique
Vie <- visualiser_consommation_par_region(
  baseconso,
  shapefile_path = "C:/Users/LENOVO/Desktop/projet_8_visualisation/Base/Limite_Région.shp",
  titre = "Consommation moyenne par tête par région"
)

# Affichage
Vie
```

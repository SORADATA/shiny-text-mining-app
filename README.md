# 📊 Shiny App – Text Mining

Cette application développée avec **Shiny** permet d'explorer des données textuelles via des techniques de **text mining** (fouille de texte). Elle offre une interface interactive pour l’analyse, la visualisation et l’interprétation de contenus textuels.

## 🔍 Fonctionnalités principales

- 📁 Téléversement de fichiers texte (.txt ou .csv)
- ✂️ Nettoyage des données textuelles : suppression des stopwords, ponctuations, mise en minuscules
- 📈 Affichage des mots les plus fréquents
- ☁️ Génération de nuages de mots
- 📊 Histogrammes interactifs
- 🔧 Options de filtrage dynamiques

## 🛠 Technologies utilisées

- `R`
- `Shiny`
- `tm`, `tidytext`
- `wordcloud`, `ggplot2`, `dplyr`
- `shinydashboard` (ou `shinythemes`, selon ton choix)

## 🧪 Lancer l’application

1. Ouvre RStudio
2. Installe les dépendances si besoin :
```r
install.packages(c("shiny", "tm", "tidytext", "wordcloud", "ggplot2", "dplyr"))

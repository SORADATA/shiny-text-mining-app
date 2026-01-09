# 📊 Shiny App – Text Mining Analytics

Application interactive développée avec **Shiny** pour l'analyse et la visualisation de données textuelles via des techniques avancées de **text mining** et de traitement du langage naturel.

🔗 **[Accéder à l'application en ligne](https://0qbv48-sissoko-moussa.shinyapps.io/Analytics_text/)**

---

## 📋 Table des matières

- [Aperçu](#-aperçu)
- [Fonctionnalités](#-fonctionnalités)
- [Technologies utilisées](#-technologies-utilisées)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Structure du projet](#-structure-du-projet)
- [Captures d'écran](#-captures-décran)
- [Contribution](#-contribution)

---

## 🎯 Aperçu

Cette application Shiny permet d'explorer et d'analyser des corpus textuels de manière intuitive. Que vous travailliez sur des retours clients, des articles de presse ou des données de réseaux sociaux, l'outil offre une suite complète de visualisations et d'analyses pour extraire des insights pertinents de vos textes.

---

## ✨ Fonctionnalités

### 📥 Import de données
- **Formats supportés** : `.txt`, `.csv`, `.xlsx`
- **Import multiple** : Chargement simultané de plusieurs fichiers
- **Aperçu instantané** : Visualisation des données importées

### 🧹 Prétraitement textuel
- ✂️ Suppression des stopwords (mots vides)
- 🔤 Normalisation : conversion en minuscules
- 🚫 Élimination de la ponctuation et des caractères spéciaux
- 🔢 Gestion des nombres et symboles
- 🌍 Support multilingue (français, anglais)

### 📊 Analyses et visualisations
- **Analyse fréquentielle** : Identification des termes les plus utilisés
- ☁️ **Nuages de mots** : Représentation visuelle interactive avec personnalisation des couleurs
- 📈 **Histogrammes** : Distribution des fréquences avec filtres dynamiques
- 🕸️ **Analyse de réseau** : Relations entre termes et co-occurrences
- 🎨 **Topic Modeling (LDA)** : Extraction automatique de thématiques
- 📉 **Visualisation LDAvis** : Exploration interactive des topics
- 📋 **Tableaux de données** : Export et consultation des résultats

### ⚙️ Options interactives
- 🎚️ Filtrage dynamique du nombre de mots à afficher
- 🎨 Personnalisation des palettes de couleurs
- 💾 Export des résultats (CSV, PNG)
- 🔄 Rechargement à la volée des analyses

---

## 🛠️ Technologies utilisées

### Frameworks et packages principaux

| Package | Usage |
|---------|-------|
| `shiny` | Framework d'application web interactive |
| `shinythemes` | Thèmes visuels pour l'interface |
| `shinycssloaders` | Indicateurs de chargement |
| `shinydashboard` | Layout professionnel type dashboard |

### Traitement de texte

| Package | Usage |
|---------|-------|
| `tm` | Framework de text mining |
| `tidytext` | Analyse textuelle avec tidyverse |
| `stringr` | Manipulation de chaînes de caractères |
| `SnowballC` | Stemming et lemmatisation |

### Visualisation

| Package | Usage |
|---------|-------|
| `ggplot2` | Graphiques élaborés |
| `wordcloud` | Génération de nuages de mots |
| `RColorBrewer` | Palettes de couleurs |
| `ggraph` | Visualisation de graphes |
| `igraph` | Analyse de réseaux |
| `LDAvis` | Visualisation interactive de topics |

### Analyse avancée

| Package | Usage |
|---------|-------|
| `topicmodels` | Modélisation de thématiques (LDA) |
| `widyr` | Calculs de corrélations sur données tidy |
| `slam` | Matrices creuses pour performances optimales |

### Utilitaires

| Package | Usage |
|---------|-------|
| `dplyr`, `tidyr` | Manipulation de données |
| `readxl` | Lecture de fichiers Excel |
| `DT` | Tableaux interactifs |
| `scales` | Formatage des axes et échelles |

---

## 🚀 Installation

### Prérequis

- **R** version 4.0 ou supérieure
- **RStudio** (recommandé pour le développement)

### Installation des dépendances

```r
# Installer tous les packages nécessaires
install.packages(c(
  # Interface Shiny
  "shiny", "shinythemes", "shinycssloaders", "shinydashboard",
  
  # Manipulation de données
  "readxl", "dplyr", "tidyr", "stringr", "rlang", "tibble",
  
  # Text mining
  "tm", "tidytext", "SnowballC",
  
  # Visualisation
  "wordcloud", "RColorBrewer", "ggplot2", "scales",
  
  # Analyse avancée
  "widyr", "igraph", "ggraph", "topicmodels", "slam", "LDAvis",
  
  # Utilitaires
  "DT", "base64enc"
))
```

### Vérification de l'installation

```r
# Vérifier que tous les packages sont chargés
packages <- c("shiny", "tm", "tidytext", "wordcloud", "ggplot2", "topicmodels")
sapply(packages, require, character.only = TRUE)
```

---

## 💻 Utilisation

### Méthode 1 : Accès en ligne (recommandé)

Accédez directement à l'application hébergée :  
**https://0qbv48-sissoko-moussa.shinyapps.io/Analytics_text/**

### Méthode 2 : Exécution locale

#### Depuis RStudio

1. Clonez le dépôt :
```bash
git clone <url-du-repo>
cd shiny-text-mining
```

2. Ouvrez le projet dans RStudio

3. Ouvrez le fichier `app.R` ou `ui.R`

4. Cliquez sur **Run App** ou exécutez :
```r
shiny::runApp()
```

#### Depuis la console R

```r
# Définir le répertoire de l'application
setwd("chemin/vers/votre/application")

# Lancer l'application
shiny::runApp()

# Ou spécifier directement le chemin
shiny::runApp("chemin/vers/votre/application")
```

#### Options de lancement avancées

```r
# Lancer sur un port spécifique
shiny::runApp(port = 8080)

# Lancer en mode automatique avec rechargement
shiny::runApp(launch.browser = TRUE)

# Lancer avec affichage des erreurs détaillées
options(shiny.error = browser)
shiny::runApp()
```

---

## 📁 Structure du projet

```
shiny-text-mining/
│
├── app.R                    # Application Shiny (version fichier unique)
│   ├── ui.R                # Interface utilisateur (si structure séparée)
│   └── server.R            # Logique serveur (si structure séparée)
│
├── data/                    # Données d'exemple
│   ├── sample_text.txt
│   └── stopwords_fr.csv
│
├── www/                     # Ressources statiques
│   ├── styles.css          # Styles personnalisés
│   └── logo.png            # Logo de l'application
│
├── modules/                 # Modules Shiny réutilisables
│   ├── upload_module.R
│   ├── cleaning_module.R
│   └── viz_module.R
│
├── utils/                   # Fonctions utilitaires
│   ├── text_processing.R
│   └── plot_functions.R
│
├── README.md               # Documentation
└── requirements.txt        # Liste des dépendances R
```

---

## 🖼️ Captures d'écran

### Interface principale
![Dashboard](screenshots/dashboard.png)

### Nuage de mots
![Wordcloud](screenshots/wordcloud.png)

### Analyse de topics
![Topics](screenshots/topics.png)

*(Ajoutez vos captures d'écran dans un dossier `screenshots/`)*

---

## 🎓 Guide d'utilisation

### 1️⃣ Charger vos données
- Cliquez sur **"Parcourir"** et sélectionnez votre fichier
- Vérifiez l'aperçu des données importées

### 2️⃣ Configurer le nettoyage
- Sélectionnez la langue du corpus
- Activez/désactivez les options de nettoyage
- Cliquez sur **"Nettoyer les données"**

### 3️⃣ Explorer les résultats
- Naviguez entre les différents onglets
- Ajustez les paramètres de visualisation
- Exportez vos résultats au format souhaité

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment participer :

1. **Forkez** le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/nouvelle-analyse`)
3. Committez vos modifications (`git commit -m 'Ajout analyse de sentiments'`)
4. Pushez vers la branche (`git push origin feature/nouvelle-analyse`)
5. Ouvrez une **Pull Request**

### Idées d'améliorations

- [ ] Ajout d'analyse de sentiments
- [ ] Support de formats supplémentaires (PDF, DOCX)
- [ ] Export des visualisations en haute résolution
- [ ] Mode multi-corpus pour comparaisons
- [ ] Analyse de n-grams (bigrammes, trigrammes)

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

---

## 📞 Contact

**Développé par Sissoko Moussa**

- 📧 Email : votre.email@example.com
- 💼 LinkedIn : [Votre profil](https://linkedin.com/in/votre-profil)
- 🐙 GitHub : [@votre-username](https://github.com/votre-username)

---

## 🙏 Remerciements

- Communauté R et Shiny pour les packages exceptionnels
- [RStudio](https://www.rstudio.com/) pour l'IDE et l'hébergement shinyapps.io
- Contributeurs open-source des packages utilisés

---

**⭐ Si ce projet vous est utile, n'hésitez pas à lui donner une étoile !**

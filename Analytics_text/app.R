# ===================== CHARGEMENT DES PACKAGES =====================
# Liste exhaustive des packages nécessaires
packages <- c(
  "shiny", "shinythemes", "shinycssloaders", "readxl", "dplyr", "stringr", 
  "rlang", "tibble", "tm", "tidytext", "wordcloud", "RColorBrewer", 
  "ggplot2", "tidyr", "widyr", "igraph", "ggraph", "scales", 
  "topicmodels", "slam", "LDAvis", "DT", "base64enc"
)

# Vérification et installation des packages manquants
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

# ===================== FONCTIONS ET DONNÉES GLOBALES =====================

# Stopwords français par défaut
stopwords_fr <- tibble(word = stopwords("fr"))

# Liste personnalisée de stopwords (peut être étendue par l'utilisateur dans l'UI)
mots_a_supprimer <- tibble(word = c(
  "impact", "d", "impacts", "k", "à", "a", "aucune", "absolument", "actuellement", 
  "ainsi", "alors", "apparemment", "approximativement", "apres", "assez", "assurement", 
  "au", "aucunement", "aucuns", "aujourd'hui", "auparavant", "aussi", "aussitot", 
  "autant", "autre", "autrefois", "autrement", "avant", "avec", "avoir", "beaucoup", 
  "bien", "bientot", "bon", "car", "carrement", "ce", "cela", "cependant", 
  "certainement", "certes", "ces", "ceux", "chaque", "ci", "comme", "comment", 
  "completement", "d'", "abord", "dans", "davantage", "de", "debut", "dedans", 
  "dehors", "deja", "demain", "depuis", "derechef", "des", "desormais", "deux", 
  "devrait", "diablement", "divinement", "doit", "donc", "dorenavant", "dos", 
  "droite", "drolement", "du", "elle", "elles", "en", "en verite", "encore", 
  "enfin", "ensuite", "entierement", "environ", "essai", "est", "et", "etaient", 
  "etat", "ete", "etions", "etre", "eu", "extremement", "fait", "faites", "fois", 
  "font", "force", "grandement", "guere", "habituellement", "haut", "hier", "hors", 
  "ici", "il", "ils", "insuffisamment", "jadis", "jamais", "je", "joliment", "la", 
  "le", "les", "leur", "leurs", "lol", "longtemps", "lors", "ma", "maintenant", 
  "mais", "mdr", "meme", "mes", "moins", "mon", "mot", "naguere", "ne", "ni", 
  "nommes", "non", "notre", "nous", "nouveaux", "nullement", "ou", "oui", "par", 
  "parce", "parfois", "parole", "pas", "pas mal", "passablement", "personne", 
  "personnes", "peu", "peut", "piece", "plupart", "plus", "plutot", "point", 
  "pour", "pourquoi", "precisement", "premierement", "presque", "prou", "puis", 
  "quand", "quasi", "quasiment", "que", "quel", "quelle", "quelles", "quelque", 
  "quelquefois", "quels", "qui", "quoi", "quotidiennement", "rien", "rudement", 
  "s'", "sa", "sans", "sans doute", "ses", "seulement", "si", "sien", "sitot", 
  "soit", "son", "sont", "soudain", "sous", "souvent", "soyez", "subitement", 
  "suffisamment", "sur", "t'", "ta", "tandis", "tant", "tantot", "tard", 
  "tellement", "tels", "terriblement", "tes", "ton", "tot", "totalement", 
  "toujours", "tous", "tout", "toutefois", "tres", "trop", "tu", "un", "une", 
  "valeur", "vers", "voie", "voient", "volontiers", "vont", "votre", "vous", 
  "vraiment", "vraisemblablement", "ras"
))

# Combinaison des listes de stopwords
all_stopwords_base <- bind_rows(stopwords_fr, mots_a_supprimer) %>% distinct()

# ===================== INTERFACE UTILISATEUR (UI) =====================
ui <- fluidPage(
  theme = shinytheme("lumen"),
  tags$head(
    tags$style(HTML("
      /* --- Styles personnalisés --- */
      /* En-tête */
      .header-container { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; }
      .title-group h1 { color: #003366; margin-bottom: 0; }
      
      /* Titres h2, h3 et h4 en bleu */
      .title-group h2, h3, h4 { color: #003366; }
      .title-group h2 { margin-top: 5px; font-weight: 300; }

      /* Barre latérale avec un fond bleu clair */
      .well { background-color: #f5faff; border: 1px solid #e6f2ff; }

      /* Onglets */
      .nav-tabs > li > a { color: #0056b3; } /* Couleur du texte des onglets inactifs */
      .nav-tabs > li.active > a,
      .nav-tabs > li.active > a:hover,
      .nav-tabs > li.active > a:focus {
        color: #fff; /* Texte en blanc pour l'onglet actif */
        background-color: #003366; /* Fond bleu foncé pour l'onglet actif */
        border-color: #003366;
      }

      /* Boutons */
      .btn-primary { background-color: #003366; border-color: #002244; }
      
      /* Notifications */
      .shiny-notification { position:fixed; top: calc(50% - 50px); left: calc(50% - 150px); width: 300px; }
    "))
  ),
  
  div(class = "header-container",
      # Intégration directe du logo pour plus de robustesse
      uiOutput("logo_ui"),
      div(class = "title-group",
          h1("Analytics text"),
          
          
      )
  ),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      
      h4("1. Source des données"),
      fileInput("upload_file", "Charger un fichier Excel (.xlsx)", 
                accept = ".xlsx", buttonLabel = "Parcourir..."),
      
      # UI dynamiques pour la sélection de la feuille et de la colonne
      uiOutput("sheet_selector_ui"),
      uiOutput("column_selector_ui"),
      
      hr(),
      
      h4("2. Options d'analyse"),
      textAreaInput("custom_stopwords", "Mots à ignorer (séparés par une virgule)", 
                    placeholder = "ex: projet, client, entreprise"),
      
      actionButton("analyser", "Lancer l'analyse", icon = icon("play"), class = "btn-primary btn-lg"),
      
      hr(),
      
      h4("3. Analyse spécifique"),
      textInput("mot_cible", "Mot à analyser (corrélations) :", placeholder = "Entrez un mot..."),
      
      hr(),
      
      h4("4. Visualisation avancée"),
      actionButton("ldavis", "LDA Interactive", icon = icon("search-plus"))
    ), # Parenthèse et virgule manquantes ici !
    
    mainPanel(
      width = 9,
      tabsetPanel(
        id = "main_tabs",
        
        tabPanel("Aperçu des données", icon = icon("eye"),
                 h4("Données nettoyées prêtes pour l'analyse"),
                 withSpinner(DTOutput("cleaned_data_table"))),
        
        tabPanel("Fréquences", icon = icon("table"),
                 withSpinner(DTOutput("freq_table"))),
        
        tabPanel("Nuage de mots", icon = icon("cloud"),
                 tabsetPanel(
                   tabPanel("Global", 
                            sliderInput("nb_mots_global", "Nombre de mots :", min = 10, max = 200, value = 100),
                            withSpinner(plotOutput("wordcloud_global", height = "600px")),
                            downloadButton("download_wordcloud_global", "Télécharger")),
                   
                   tabPanel("Spécifique", 
                            textAreaInput("specific_words", "Mots spécifiques à afficher (séparés par une virgule)", 
                                          placeholder = "ex: baisse, perte, hausse, gain"),
                            sliderInput("nb_mots_specifique", "Nombre de mots :", min = 5, max = 100, value = 50),
                            withSpinner(plotOutput("wordcloud_specifique", height = "600px")),
                            downloadButton("download_wordcloud_specifique", "Télécharger"))
                 )),
        
        tabPanel("N-grammes", icon = icon("project-diagram"),
                 selectInput("ngram_n", "Type de n-gramme", choices = c("Bigrammes (2)" = 2, "Trigrammes (3)" = 3), selected = 2),
                 sliderInput("nb_ngrams", "Nombre de n-grammes à afficher :", min = 5, max = 50, value = 15),
                 withSpinner(plotOutput("ngram_plot", height = "700px")),
                 downloadButton("download_ngram_plot", "Télécharger")),
        
        tabPanel("Relations entre mots", icon = icon("network-wired"),
                 tabsetPanel(
                   tabPanel("Graphe de cooccurrences", 
                            sliderInput("cooc_freq", "Fréquence minimale de cooccurrence :", min = 1, max = 20, value = 2),
                            withSpinner(plotOutput("cooc_graph", height = "700px"))),
                   tabPanel("Corrélations (mot-cible)", 
                            withSpinner(plotOutput("correlation_plot", height = "700px")))
                 )),
        
        tabPanel("Analyse de Sentiment", icon = icon("smile-beam"),
                 withSpinner(plotOutput("sentiment_plot", height = "600px"))),
        
        tabPanel("Thèmes (LDA)", icon = icon("boxes"),
                 tabsetPanel(
                   tabPanel("Graphique des thèmes",
                            sliderInput("lda_k", "Nombre de thèmes :", min = 2, max = 10, value = 4),
                            sliderInput("lda_n_words", "Nombre de mots par thème :", min = 4, max = 20, value = 10),
                            withSpinner(plotOutput("lda_plot", height = "700px"))
                   ),
                   tabPanel("Visualisation Interactive (LDAvis)",
                            actionButton("run_ldavis", "Lancer la visualisation interactive", icon = icon("rocket")),
                            withSpinner(visOutput("ldavis_output"))
                   )
                 )
        )
      )
    )
  )
)

# ===================== SERVEUR =====================
server <- function(input, output, session) {
  
  # --- Logo UI ---
  output$logo_ui <- renderUI({
    logo_path <- "www/logo.png"
    if (file.exists(logo_path)) {
      # Convertir l'image en Data URI pour l'intégrer directement
      img_data <- base64enc::dataURI(file = logo_path, mime = "image/png")
      tags$img(src = img_data, height = "80px")
    } else {
      # Ne rien afficher si le logo n'est pas trouvé
      NULL
    }
  })
  
  
  
  # --- 1. GESTION DES DONNÉES DYNAMIQUES ---
  
  # Récupère les noms des feuilles du fichier uploadé
  sheet_names <- reactive({
    req(input$upload_file)
    excel_sheets(input$upload_file$datapath)
  })
  
  # Affiche le sélecteur de feuille
  output$sheet_selector_ui <- renderUI({
    req(sheet_names())
    selectInput("selected_sheet", "Choisir la feuille :", choices = sheet_names())
  })
  
  # Lit les données de la feuille sélectionnée
  raw_data <- reactive({
    req(input$upload_file, input$selected_sheet)
    read_excel(input$upload_file$datapath, sheet = input$selected_sheet)
  })
  
  # Affiche le sélecteur de colonne
  output$column_selector_ui <- renderUI({
    req(raw_data())
    selectInput("selected_column", "Choisir la colonne de texte :", choices = colnames(raw_data()))
  })
  
  # --- 2. TRAITEMENT PRINCIPAL (LANCÉ PAR LE BOUTON) ---
  
  analysis_data <- eventReactive(input$analyser, {
    req(raw_data(), input$selected_column)
    
    showNotification("Lancement de l'analyse...", type = "message", duration = 3)
    
    # Combinaison des stopwords
    custom_words <- str_split(input$custom_stopwords, ",\\s*")[[1]]
    final_stopwords <- bind_rows(
      all_stopwords_base,
      tibble(word = custom_words[custom_words != ""])
    ) %>% distinct()
    
    # Nettoyage du texte
    withProgress(message = 'Nettoyage et préparation des données', value = 0, {
      
      text_data <- raw_data() %>%
        mutate(doc_id = row_number()) %>%
        rename(text_raw = !!sym(input$selected_column)) %>%
        filter(!is.na(text_raw) & text_raw != "") %>%
        mutate(text_clean = text_raw %>%
                 str_to_lower() %>%
                 str_replace_all("[[:punct:]]", " ") %>%
                 str_replace_all("[[:digit:]]", " ") %>%
                 str_squish() %>%                 str_remove_all("\\b\\w{1,2}\\b"))
      
      incProgress(0.5, detail = "Tokenisation et filtrage...")
      
      # Tokenisation et suppression des stopwords
      tokens_df <- text_data %>%
        select(doc_id, text_clean) %>%
        unnest_tokens(word, text_clean) %>%
        filter(!word %in% final_stopwords$word)
      
      # Calcul des fréquences
      words_freq <- tokens_df %>%
        count(word, sort = TRUE)
      
      incProgress(1, detail = "Terminé !")
    })
    
    return(list(
      cleaned_data = tokens_df,
      words_freq = words_freq
    ))
  })
  
  # --- 3. SORTIES (OUTPUTS) ---
  
  # Onglet: Aperçu des données
  output$cleaned_data_table <- renderDT({
    df <- req(analysis_data())$cleaned_data
    datatable(head(df, 1000), options = list(pageLength = 15, scrollX = TRUE), caption = "1000 premiers mots (tokens) après nettoyage.")
  })
  
  # Onglet: Fréquences
  output$freq_table <- renderDT({
    df <- req(analysis_data())$words_freq
    datatable(df, options = list(pageLength = 20, autoWidth = TRUE), caption = "Fréquence de chaque mot dans le corpus.")
  })
  
  # Onglet: Nuage de mots (Global)
  wordcloud_global_plot <- reactive({
    df <- req(analysis_data())$words_freq
    req(nrow(df) > 0)
    
    set.seed(123)
    wordcloud(words = df$word, freq = df$n,
              max.words = input$nb_mots_global,
              random.order = FALSE,
              colors = brewer.pal(8, "Dark2"),
              scale = c(3.5, 0.5))
  })
  output$wordcloud_global <- renderPlot({
    wordcloud_global_plot()
  })
  output$download_wordcloud_global <- downloadHandler(
    filename = function() { paste0("wordcloud_global_", Sys.Date(), ".png") },
    content = function(file) {
      png(file, width = 800, height = 800)
      wordcloud_global_plot()
      dev.off()
    }
  )
  
  # Onglet: Nuage de mots (Spécifique)
  wordcloud_specifique_plot <- reactive({
    df <- req(analysis_data())$words_freq
    specific_words_vec <- str_split(input$specific_words, ",\\s*")[[1]]
    req(length(specific_words_vec) > 0 && specific_words_vec[1] != "")
    
    df_specific <- df %>% filter(word %in% specific_words_vec)
    req(nrow(df_specific) > 0)
    
    set.seed(123)
    wordcloud(words = df_specific$word, freq = df_specific$n,
              max.words = input$nb_mots_specifique,
              random.order = FALSE,
              colors = brewer.pal(8, "Set1"),
              scale = c(4, 0.8))
  })
  output$wordcloud_specifique <- renderPlot({
    wordcloud_specifique_plot()
  })
  output$download_wordcloud_specifique <- downloadHandler(
    filename = function() { paste0("wordcloud_specifique_", Sys.Date(), ".png") },
    content = function(file) {
      png(file, width = 800, height = 800)
      wordcloud_specifique_plot()
      dev.off()
    }
  )
  
  # Onglet: N-grammes
  ngram_plot_obj <- reactive({
    df <- req(analysis_data())$cleaned_data
    n_val <- as.numeric(input$ngram_n)
    
    ngrams <- df %>%
      unite("doc_text", word, sep = " ", na.rm = TRUE) %>%
      group_by(doc_id) %>%
      summarise(text = paste(doc_text, collapse = " "), .groups = 'drop') %>%
      unnest_tokens(ngram, text, token = "ngrams", n = n_val) %>%
      count(ngram, sort = TRUE)
    
    req(nrow(ngrams) > 0)
    
    ngrams %>%
      slice_max(n, n = input$nb_ngrams) %>%
      ggplot(aes(x = reorder(ngram, n), y = n)) +
      geom_col(fill = "#2c7fb8") +
      coord_flip() +
      labs(title = paste(input$nb_ngrams, "N-grammes les plus fréquents"), x = NULL, y = "Fréquence") +
      theme_minimal(base_size = 14)
  })
  output$ngram_plot <- renderPlot({
    print(ngram_plot_obj())
  })
  output$download_ngram_plot <- downloadHandler(
    filename = function() { paste0("ngrammes_", Sys.Date(), ".png") },
    content = function(file) { ggsave(file, plot = ngram_plot_obj(), width = 10, height = 8) }
  )
  
  # Onglet: Graphe de cooccurrences
  output$cooc_graph <- renderPlot({
    df <- req(analysis_data())$cleaned_data
    
    cooc <- df %>%
      pairwise_count(word, doc_id, sort = TRUE) %>%
      filter(n >= input$cooc_freq)
    
    # Affiche un message si pas assez de données
    if (nrow(cooc) < 2) {
      return(ggplot() + 
               labs(title = "Pas assez de cooccurrences trouvées.", 
                    subtitle = "Essayez de baisser la fréquence minimale ou de nettoyer moins de mots.") + 
               theme_void())
    }
    
    cooc %>%
      slice_max(n, n = 100) %>% # Limit to top 100 for readability
      graph_from_data_frame(directed = FALSE) %>%
      ggraph(layout = "fr") +
      geom_edge_link(aes(edge_alpha = n), show.legend = FALSE, color = "gray") +
      geom_node_point(color = "#003366", size = 5) +
      geom_node_text(aes(label = name), repel = TRUE, size = 4) +
      theme_void() +
      labs(title = "Graphe de cooccurrence des mots")
  })
  
  # Onglet: Corrélations par mot-cible
  output$correlation_plot <- renderPlot({
    req(input$mot_cible != "")
    df <- req(analysis_data())$cleaned_data
    
    correlations <- df %>%
      group_by(word) %>%
      filter(n() >= 5) %>% # Consider only words that appear at least 5 times
      pairwise_cor(word, doc_id, sort = TRUE)
    
    target_word <- tolower(trimws(input$mot_cible))
    
    correlations %>%
      filter(item1 == target_word) %>%
      slice_max(correlation, n = 20) %>%
      ggplot(aes(x = reorder(item2, correlation), y = correlation)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      labs(title = paste("Mots les plus corrélés à '", target_word, "'"),
           x = "Mot associé", y = "Corrélation (phi)") +
      theme_minimal(base_size = 14)
  })
  
  # Onglet: Analyse de Sentiment
  output$sentiment_plot <- renderPlot({
    df <- req(analysis_data())$words_freq
    
    # Utilisation du lexique 'bing' de tidytext
    bing_sentiments <- get_sentiments("bing")
    
    sentiment_words <- df %>%
      inner_join(bing_sentiments, by = "word")
    
    req(nrow(sentiment_words) > 0)
    
    sentiment_words %>%
      group_by(sentiment) %>%
      slice_max(n, n = 15) %>%
      ungroup() %>%
      mutate(word = reorder(word, n)) %>%
      ggplot(aes(x = word, y = n, fill = sentiment)) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~sentiment, scales = "free_y") +
      coord_flip() +
      labs(title = "Mots contributeurs au sentiment (Lexique Bing)", x = NULL, y = "Fréquence") +
      theme_minimal(base_size = 14)
  })
  
  # Onglet: Thèmes (LDA)
  output$lda_plot <- renderPlot({
    dtm <- analysis_data()$cleaned_data %>%
      count(doc_id, word) %>%
      cast_dtm(doc_id, word, n)
    
    req(nrow(dtm) > 1, ncol(dtm) > 1)
    
    lda_model <- LDA(dtm, k = input$lda_k, control = list(seed = 123))
    
    lda_topics <- tidy(lda_model, matrix = "beta")
    
    top_terms <- lda_topics %>%
      group_by(topic) %>%
      slice_max(beta, n = input$lda_n_words) %>%
      ungroup() %>%
      arrange(topic, -beta)
    
    top_terms %>%
      mutate(term = reorder_within(term, beta, topic)) %>%
      ggplot(aes(x = term, y = beta, fill = factor(topic))) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~ topic, scales = "free") +
      coord_flip() +
      scale_x_reordered() +
      labs(title = "Thèmes principaux identifiés par LDA", x = NULL, y = "Poids du mot (beta)")
  })
  
  # Action: LDAvis
  observeEvent(input$run_ldavis, {
    output$ldavis_output <- renderVis({
      req(analysis_data())
      
      withProgress(message = 'Génération de LDAvis...', value = 0, {
        
        dtm <- analysis_data()$cleaned_data %>%
          count(doc_id, word) %>%
          cast_dtm(doc_id, word, n)
        
        if (nrow(dtm) < 2 || ncol(dtm) < 2) {
          showNotification("Pas assez de données pour générer LDAvis.", type = "error")
          return()
        }
        
        incProgress(0.5, detail = "Entraînement du modèle LDA...")
        lda_model <- LDA(dtm, k = input$lda_k, control = list(seed = 123))
        
        incProgress(0.8, detail = "Création de la visualisation...")
        json_lda <- createJSON(
          phi = posterior(lda_model)$terms %>% as.matrix(),
          theta = posterior(lda_model)$topics %>% as.matrix(),
          doc.length = slam::row_sums(dtm),
          vocab = colnames(dtm),
          term.frequency = slam::col_sums(dtm)
        )
      })
      
      json_lda
    })
  })
  
}

# ===================== LANCEMENT DE L'APPLICATION =====================
shinyApp(ui = ui, server = server) 

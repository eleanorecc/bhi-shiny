function(input, output, session){
  
  rgn_set <- reactive({input$rgn_set})
  idx_dim <- reactive({input$idx_dim})
  gl_code <- reactive({input$gl_code})
  
  values <- reactiveValues()
  
  
  ## welcome page ----
  output$iframe_video <- renderUI({
    src = "https://www.youtube.com/embed/3g6Xfq9FOrU"
    tags$iframe(
      src=src, 
      width="115%", height="95%", 
      frameborder="0", 
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture")
  })
  output$iframe_podcast <- renderUI({
    src = "https://open.spotify.com/embed/episode/52grVGc6gBjR9vuWda8TGT?theme=0"
    tags$iframe(
      src=src, 
      width="100%", height="155", 
      frameborder="0", 
      allowtransparency="true"
    )
  })
  output$flowerplot <- renderImage({
    
  })
  
  
  ## map ----
  
  ## put map options 'absolute' panel on the left
  ## but make reactive to whether sidebar is collapsed or not
  ## https://github.com/RinteRface/shinydashboardPlus/issues/57
  values$collapsed <- FALSE
  observeEvent(input$sidebar_col_react, {
    values$collapsed =! values$collapsed
    ## still not resetting to single map when collapsing...
    if(isFALSE(values$collapsed)){values$map_data_alt <- NULL}
  })
  mapcontrols_pos <- reactive({
    if(values$collapsed){x <- 75} else {x <- 400}
    return(x)
  })
  output$mapcontrols_panel <- renderUI({
    absolutePanel(
      id = "mapcontrols", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
      top = 83, left = mapcontrols_pos(), right = "auto", bottom = "auto",
      ## width of pane set to 276 so two action buttons fit side-by-side
      width = 276, height = "auto",
      br(),
      selectInput(
        "gl_code",
        "Goal",
        choices = c(
          `Index` = "Index",
          `Artisanal Fishing Opportunity (AO)` = "AO",
          `Biodiversity (BD)` = "BD",
          `Carbon Storage (CS)` = "CS",
          `Clean Waters (CW)` = "CW",
          `Contaminants (CON)` = "CON",
          `Eutrophication (EUT)` = "EUT",
          `Trash (TRE)` = "TRA",
          `Food Provision (FP)` = "FP",
          `Wildcaught Fisheries (FIS)` = "FIS",
          `Mariculture (MAR)` = "MAR",
          `Coastal Livelihoods and Economies (LE)` = "LE",
          `Economies (ECO)` = "ECO",
          `Livelihoods (LIV)` = "LIV",
          `Sense of Place (LSP)` = "SP",
          `Iconic Species (ICO)` = "ICO",
          `Lasting Special Places (LSP)` = "LSP",
          `Natural Products (NP)` = "NP",
          `Tourism (TR)` = "TR"
        ),
        selected = "Index"
      ),
      selectInput(
        "rgn_set",
        "Region Set",
        choices = c(
          `BHI Regions` = "regions",
          `Subbasins` = "subbasins"
        ),
        selected = "regions"
      ),
      selectInput(
        "idx_dim",
        "Index Dimension",
        choices = c(
          `Score` = "score",
          `Likely Future` = "future",
          `Pressures` = "pressures",
          `Resilience` = "resilience",
          `Current Status` = "status",
          `Short Term Trend` = "trend"
        ),
        selected = "score"
      ),
      actionButton("splitmap", "Duplicate Map"),
      actionButton("unsplitmap", "Single Map View")
    )
  })
  mappopups_pos <- reactive({
    if(values$collapsed){x <- 360} else {x <- 680}
    return(x)
  })
  output$mappopups_panel <- renderUI({
    absolutePanel(
      id = "mappopups", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
      top = 83, left = mappopups_pos(), right = "auto", bottom = "auto",
      width = 135, height = "auto",
      br(),
      radioButtons(
        "mappopups_buttons", 
        "Pop-up", 
        choices = c(
          `Score Value` = "mappopscore",
          `Bar Plot` = "mappopbar",
          `Flower Plot` = "mappopflower"
        ),
        selected = "mappopscore"
      )
    )
  })
  ## make the map itself, based on inputs defined above
  ## still have an issue with duplicate/single view and collapsing/uncollapsing reset...
  observeEvent(input$splitmap, {
    values$map_data_alt <- wrangle_mapdata(
      df_scores,
      rgn_set = rgn_set(),
      goal_code = gl_code(),
      dim = idx_dim(),
      year = assess_year
    )
    updateRadioButtons(
      session, 
      "mappopups_buttons", 
      "Pop-up", 
      choices = c(`Score Value` = "mappopscore"),
      selected = "mappopscore"
    )
  })
  observeEvent(input$unsplitmap, {
    values$map_data_alt <- NULL
    updateRadioButtons(
      session,
      "mappopups_buttons", 
      "Pop-up", 
      choices = c(
        `Score Value` = "mappopscore",
        `Bar Plot` = "mappopbar",
        `Flower Plot` = "mappopflower"
      ),
      selected = "mappopscore"
    )
  })
  output$index_map <- renderLeaflet({
    map_data <- wrangle_mapdata(
      df_scores, 
      rgn_set = rgn_set(), 
      goal_code = gl_code(), 
      dim = idx_dim(), 
      year = assess_year
    )
    leafletmap <- make_map(map_data)
    if(!is.null(values$map_data_alt)){
      leafletmap <- split_map(leafletmap, values$map_data_alt)
    }
    return(leafletmap)
  })


  ## AO ----
  
  ## overall score box in top right
  callModule(scoreBox, "ao_infobox", goal_code = "AO")
  
  ## BD ----
  
  
  
  ## feedback ----
  output$iframe <- renderUI({
    src = "https://docs.google.com/forms/d/e/1FAIpQLSca7FSR3qy1kohCrh3uqkVBpTjCEKoS1wlB6DPkMrrB6w95fA/viewform?embedded=true"
    tags$iframe(src=src, width="640", height="1660", frameborder="0", marginheight="0", marginwidth="0")
  })
}
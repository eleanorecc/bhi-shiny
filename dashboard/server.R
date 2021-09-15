function(input, output, session){
  
  values <- reactiveValues()
  
  ## to make things reactive to whether sidebar is collapsed or not
  ## https://github.com/RinteRface/shinydashboardPlus/issues/57
  values$collapsed <- FALSE
  observeEvent(input$sidebar_col_react, {
    values$collapsed =! values$collapsed
  })
  
  
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
  ## flowerplot
  values$flower_rgn <- 0
  values$flowerwidth <- "85%"
  flowerListen <- reactive({
    list(input$flower_rgn, input$sidebar_col_react)
  })
  observeEvent(
    eventExpr = flowerListen(), {
      values$flower_rgn <- input$flower_rgn
      values$flowerwidth <- ifelse(isTRUE(values$collapsed), "63%", "90%")
      callModule(
        flowerplotCard, 
        "baltic_flowerplot",
        flower_rgn_selected = reactive(values$flower_rgn),
        flowerwidth = reactive(values$flowerwidth)
      )
    }, ignoreNULL = FALSE
  )
  
  
  ## map options ----
  
  ## set initial inputs, and then observe changes in selected inputs
  ## not using just input 'selected' argument because would reset map when sidebar collapses
  values$gl_code <- "Index"
  values$rgn_set <- "regions"
  values$idx_dim <- "score"
  values$mappopups_buttons <- "popupscore"
  
  ## put map options 'absolute' panel on the left
  ## but make reactive to whether sidebar is collapsed or not
  ## https://github.com/RinteRface/shinydashboardPlus/issues/57
  mapcontrols_pos <- reactive({
    if(values$collapsed){x <- 75} else {x <- 400}
    return(x)
  })
  output$mapcontrols_panel <- renderUI({
    absolutePanel(
      id = "mapcontrols", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
      top = 83, left = mapcontrols_pos(), right = "auto", bottom = "auto",
      ## width of pane set to 304 so two action buttons fit side-by-side
      width = 304, height = "auto",
      br(),
      selectInput(
        "gl_code",
        label = NULL,
        choices = c(
          `Index` = "Index",
          `Artisanal Fishing Opportunity (AO)` = "AO",
          `Biodiversity (BD)` = "BD",
          `Carbon Storage (CS)` = "CS",
          `Clean Waters (CW)` = "CW",
          `Contaminants (CON)` = "CON",
          `Eutrophication (EUT)` = "EUT",
          `Trash (TRA)` = "TRA",
          `Food Provision (FP)` = "FP",
          `Wildcaught Fisheries (FIS)` = "FIS",
          `Mariculture (MAR)` = "MAR",
          `Livelihoods & Economy (LE)` = "LE",
          `Blue Economy (ECO)` = "ECO",
          `Coastal Livelihoods (LIV)` = "LIV",
          `Sense of Place (LSP)` = "SP",
          `Iconic Species (ICO)` = "ICO",
          `Lasting Special Places (LSP)` = "LSP",
          `Natural Products (NP)` = "NP",
          `Tourism (TR)` = "TR"
        ),
        selected = values$gl_code
      ),
      selectInput(
        "rgn_set",
        label = NULL,
        choices = c(
          `BHI Regions` = "regions",
          `Subbasins` = "subbasins"
        ),
        selected = values$rgn_set
      ),
      selectInput(
        "idx_dim",
        label = NULL,
        choices = c(
          `Score` = "score",
          `Likely Future` = "future",
          `Pressures` = "pressures",
          `Resilience` = "resilience",
          `Current Status` = "status",
          `Short Term Trend` = "trend"
        ),
        selected = values$idx_dim
      ),
      selectInput(
        "mappopups_buttons",
        label = NULL,
        choices = c(
          `Pop-up with Score Value` = "mappopscore",
          `Pop-up with Flower Plot` = "mappopflower",
          `View with Bar Plot` = "mappopbar"
        ),
        selected = values$mappopups_buttons
      ),
      actionButton("split_unsplit_map", "Duplicate / Return to Single View"),
      actionButton("refresh_map", icon("sync"))
    )
  })
  mapcontrolsListen <- reactive({
    list(input$gl_code, input$rgn_set, input$idx_dim, input$mappopups_buttons)
  })
  observeEvent(
    eventExpr = mapcontrolsListen(), {
      values$rgn_set <- input$rgn_set
      values$gl_code <- input$gl_code
      values$idx_dim <- input$idx_dim
      values$mappopups_buttons <- input$mappopups_buttons
    }
  )
  
  ## map ----
  
  ## map split/duplicate/return to single view
  ## if either split/un-split or refresh_map buttons are clicked 
  ## calculate secondary polygons layer for duplicate view
  values$mapsplit <- FALSE
  observeEvent(input$split_unsplit_map, {
    values$mapsplit =! values$mapsplit
  })
  mapListen <- reactive({
    list(input$split_unsplit_map, input$refresh_map)
  })
  observeEvent(
    eventExpr = mapListen(), {
      if(isTRUE(values$mapsplit)){
        values$map_data_alt <- wrangle_mapdata(
          df_scores,
          rgn_set = values$rgn_set,
          goal_code = values$gl_code,
          dim = values$idx_dim,
          year = assess_year
        )
      } else {values$map_data_alt <- NULL}
    }, ignoreNULL = FALSE
  )
  
  # make the map itself, based on inputs defined above
  output$index_map <- renderLeaflet({leafletmap <- make_basemap()})
  # observeEvent({
  #   
  # })
  #   leafletmap <- make_basemap()
  #   map_data <- wrangle_mapdata(
  #     df_scores,
  #     rgn_set = values$rgn_set,
  #     goal_code = values$gl_code,
  #     dim = values$idx_dim,
  #     year = assess_year
  #   )
  #   leafletmap <- make_map(leafletmap, map_data)
  #   leafletmap <- add_popup(leafletmap, map_data, values$mappopups_buttons)
  #   if(isTRUE(values$mapsplit)){
  #     leafletmap <- make_map(leafletmap, values$map_data_alt, second_map = TRUE)
  #     leafletmap <- add_popup(leafletmap, values$map_data_alt, values$mappopups_buttons, second_map = TRUE)
  #   }
  #   
  #   
  #   return(leafletmap)
  # })


  ## AO ----
  
  ## overall score box in top right
  callModule(scoreBox, "ao_infobox", goal_code = "AO", goal_confidence = "HIGH")
  
  ## BD ----
  
  
  
  ## feedback ----
  output$iframe <- renderUI({
    src = "https://docs.google.com/forms/d/e/1FAIpQLSca7FSR3qy1kohCrh3uqkVBpTjCEKoS1wlB6DPkMrrB6w95fA/viewform?embedded=true"
    tags$iframe(src=src, width="640", height="1660", frameborder="0", marginheight="0", marginwidth="0")
  })
}
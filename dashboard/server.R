function(input, output, session){
  
  spatial_unit <- reactive({input$spatial_unit})
  dimension <- reactive({input$dimension})
  view_year <- reactive({input$view_year})
  
  ## WELCOME ----
  
  ## flowerplot
  values <- reactiveValues(flower_rgn = 0)
  observeEvent(
    eventExpr = input$flower_rgn, {
      values$flower_rgn <- input$flower_rgn
      
      ## update flowerplot based on selection
      callModule(
        flowerplotCard, 
        "baltic_flowerplot",
        dimension = "score",
        flower_rgn_selected = reactive(values$flower_rgn)
      )
    }, ignoreNULL = FALSE
  )
  
  ## map with reactivity
  output$index_map <- renderLeaflet({
    
    ## create leaflet map with popup text
    result <- leaflet_map(
      full_scores_lst,
      spatial_unit(),
      "Index", 
      dim = dimension(), 
      year = assess_year,
      "Index Scores"
    )
    
    popup_text <- paste(
      "<h5><strong>", "Score", "</strong>",
      result$data_sf[["score"]], "</h5>",
      "<h5><strong>", "Name", "</strong>",
      result$data_sf[["Name"]], "</h5>", sep = " "
    )
    result$map %>% addPolygons(popup = popup_text, fillOpacity = 0, stroke = FALSE)
  })
  
  ## selected-region overlay, based on spatial unit and flowerplot region
  select_region <- reactive({
    rgn_select <- values$flower_rgn
    rgns_shp[rgns_shp@data$BHI_ID == rgn_select,]
  })
  observe({
    select_region()
    leafletProxy("index_map") %>%
      addPolygons(
        layerId = "selected",
        data = select_region(),
        stroke = FALSE, opacity = 0,
        fillOpacity = 0.6, color = "magenta",
        smoothFactor = 3
      )
  })
  select_subbasin <- reactive({
    rgn_select <- values$flower_rgn
    subbasins_shp[subbasins_shp@data$HELCOM_ID == str_replace(rgn_select, "5", "SEA-0"),]
  })
  observe({
    select_region()
    leafletProxy("index_map") %>%
      addPolygons(
        layerId = "selected",
        data = select_subbasin(),
        stroke = FALSE, opacity = 0,
        fillOpacity = 0.6, color = "magenta",
        smoothFactor = 3
      )
  })
  
  ## AO ----
  ## Artisanal Fishing Opportunity
  
  callModule(
    scoreBox,
    "ao_infobox",
    goal_code = "AO"
  )
  
  callModule(
    mapCard, 
    "ao_map",
    goal_code = "AO",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "ao_barplot",
    goal_code = "AO",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$ao_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "AO") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "AO"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## BD ----
  ## Biodiversity
  
  callModule(
    scoreBox,
    "bd_infobox",
    goal_code = "BD"
  )
  
  callModule(
    mapCard, 
    "bd_map",
    goal_code = "BD",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "bd_barplot",
    goal_code = "BD",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$bd_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "BD") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "BD"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  ## CS ----
  ## Carbon Storage
  
  callModule(
    scoreBox,
    "cs_infobox",
    goal_code = "CS"
  )
  
  callModule(
    mapCard, 
    "cs_map",
    goal_code = "CS",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "cs_barplot",
    goal_code = "CS",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$cs_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "CS") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "CS"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## CW ----
  ## Clean Waters
  
  callModule(
    scoreBox,
    "cw_infobox",
    goal_code = "CW"
  )
  
  callModule(
    mapCard, 
    "cw_map",
    goal_code = "CW",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "cw_barplot",
    goal_code = "CW",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$cw_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "CW") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "CW"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  
  
  
  ## CON ----
  ## Contaminants
  
  ## overall score box in top right
  callModule(
    scoreBox,
    "con_infobox",
    goal_code = "CON"
  )
  
  ## map
  callModule(
    mapCard, 
    "con_map",
    goal_code = "CON",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  ## barplot
  callModule(
    barplotCard, "con_barplot",
    goal_code = "CON",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  ## info table about input data layers
  output$con_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "CON") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "CON"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## layers timeseries plot
  values <- reactiveValues(`con_tsplot-select` = "cw_con_pcb_bhi2019_bio")
  observeEvent(
    eventExpr = input$`con_tsplot-select`, {
      values$`con_tsplot-select` <- input$`con_tsplot-select`
      callModule(
        tsplotCard, 
        "con_tsplot",
        plot_type = "boxplot",
        layer_selected = reactive(values$`con_tsplot-select`),
        spatial_unit_selected = spatial_unit
      )
    }, ignoreNULL = FALSE
  )
  ## EUT ----
  ## Eutrophication
  
  callModule(
    scoreBox,
    "eut_infobox",
    goal_code = "EUT"
  )
  
  callModule(
    mapCard, 
    "eut_map",
    goal_code = "EUT",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "eut_barplot",
    goal_code = "EUT",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$eut_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "EUT") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "EUT"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## TRA ----
  ## Trash
  
  callModule(
    scoreBox,
    "tra_infobox",
    goal_code = "TRA"
  )
  
  callModule(
    mapCard, 
    "tra_map",
    goal_code = "TRA",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "tra_barplot",
    goal_code = "TRA",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$tra_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "TRA") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "TRA"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  ## FP ----
  ## Food Provision
  
  callModule(
    scoreBox,
    "fp_infobox",
    goal_code = "FP"
  )
  
  callModule(
    mapCard, 
    "fp_map",
    goal_code = "FP",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "fp_barplot",
    goal_code = "FP",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$fp_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "FP") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "FP"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  
  ## FIS ----
  ## Fisheries
  
  ## overall score box in top right
  callModule(
    scoreBox,
    "fis_infobox",
    goal_code = "FIS"
  )
  
  ## map
  callModule(
    mapCard, 
    "fis_map",
    goal_code = "FIS",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  ## barplot
  callModule(
    barplotCard, "fis_barplot",
    goal_code = "FIS",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  ## info table about input data layers
  output$fis_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "FIS") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "FIS"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## layers timeseries plot
  values <- reactiveValues(`fis_tsplot-select` = "fis_bbmsy_bhi2019_cod")
  observeEvent(
    eventExpr = input$`fis_tsplot-select`, {
      values$`fis_tsplot-select` <- input$`fis_tsplot-select`
      callModule(
        tsplotCard, 
        "fis_tsplot",
        plot_type = "barplot normalized",
        layer_selected = reactive(values$`fis_tsplot-select`),
        spatial_unit_selected = spatial_unit
      )
    }, ignoreNULL = FALSE
  )
  ## MAR ----
  ## Mariculture
  
  callModule(
    scoreBox,
    "mar_infobox",
    goal_code = "MAR"
  )
  
  callModule(
    mapCard, 
    "mar_map",
    goal_code = "MAR",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "mar_barplot",
    goal_code = "MAR",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$mar_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "MAR") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "MAR"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## LE ----
  ## Coastal Livelihoods & Economies
  
  callModule(
    scoreBox,
    "le_infobox",
    goal_code = "LE"
  )
  
  callModule(
    mapCard, 
    "le_map",
    goal_code = "LE",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "le_barplot",
    goal_code = "LE",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$le_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "LE") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "LE"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## ECO ----
  ## Economies
  
  callModule(
    scoreBox,
    "eco_infobox",
    goal_code = "ECO"
  )
  
  callModule(
    mapCard, 
    "eco_map",
    goal_code = "ECO",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "eco_barplot",
    goal_code = "ECO",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$eco_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "ECO") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "ECO"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  ## LIV ----
  ## Livelihoods
  
  callModule(
    scoreBox,
    "liv_infobox",
    goal_code = "LIV"
  )
  
  callModule(
    mapCard, 
    "liv_map",
    goal_code = "LIV",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "liv_barplot",
    goal_code = "LIV",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$liv_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "LIV") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "LIV"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## SP ----
  ## Sense of Place
  
  callModule(
    scoreBox,
    "sp_infobox",
    goal_code = "SP"
  )
  
  callModule(
    mapCard, 
    "sp_map",
    goal_code = "SP",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "sp_barplot",
    goal_code = "SP",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$sp_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "SP") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "SP"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## ICO ----
  ## Iconic Species
  
  callModule(
    scoreBox,
    "ico_infobox",
    goal_code = "ICO"
  )
  
  callModule(
    mapCard, 
    "ico_map",
    goal_code = "ICO",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "ico_barplot",
    goal_code = "ICO",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$ico_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "ICO") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "ICO"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## LSP ----
  ## Lasting Special Places
  
  callModule(
    scoreBox,
    "lsp_infobox",
    goal_code = "LSP"
  )
  
  callModule(
    mapCard, 
    "lsp_map",
    goal_code = "LSP",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "lsp_barplot",
    goal_code = "LSP",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$lsp_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "LSP") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "LSP"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  ## NP ----
  ## Natural Products
  
  callModule(
    scoreBox,
    "np_infobox",
    goal_code = "NP"
  )
  
  callModule(
    mapCard, 
    "np_map",
    goal_code = "NP",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "np_barplot",
    goal_code = "NP",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$np_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "NP") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "NP"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  
  ## TR ----
  ## Tourism & Recreation
  
  callModule(
    scoreBox,
    "tr_infobox",
    goal_code = "TR"
  )
  
  callModule(
    mapCard, 
    "tr_map",
    goal_code = "TR",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit,
    year_selected = view_year,
    legend_title = "Scores",
    popup_title = "Score:",
    popup_add_field = "Name",
    popup_add_field_title = "Name:"
  )
  
  callModule(
    barplotCard, "tr_barplot",
    goal_code = "TR",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  output$tr_datatable = renderDataTable({
    datatable(
      data_info %>% 
        filter(goal == "TR") %>% 
        select(-goal),
      options = list(
        dom = "t", 
        pageLength = nrow(filter(data_info, goal == "TR"))
      ),
      rownames = FALSE,
      escape = FALSE
    )
  })
  ## END ----
  ## signal end of goals pages stuff for rebuild functions
  
  
  ## COMPARE
  ## PRESSURES ----
  output$pressure_ts <- renderPlotly({
    
    # press_var <- input$press_var
    press_dat <- readr::read_csv(file.path(dir_main, "data", "layers_data.csv")) %>% 
      dplyr::left_join(
        select(thm$rgn_name_lookup, region_id, plot_title, subbasin),
        by = "region_id"
      ) %>% 
      # dplyr::filter(layer == press_var) %>% 
      dplyr::filter(category == "pressure") %>% 
      dplyr::rename(Name = plot_title, Pressure = value, Year = year) %>% 
      dplyr::mutate(
        layername = layer %>% 
          stringr::str_remove("_bhi2.*") %>% 
          stringr::str_replace_all("_", " ") %>% 
          stringr::str_to_upper()
      )
    
    
    if(spatial_unit() == "subbasins"){
      press_dat <- press_dat %>%
        left_join(
          readr::read_csv(file.path(dir_main, "data", "regions.csv")) %>% 
            select(region_id, area_km2), 
          by = "region_id"
        ) %>% 
        group_by(subbasin, layer, layername, Year) %>% 
        summarize(Pressure = weighted.mean(Pressure, area_km2) %>% round(3)) %>% 
        left_join(
          readr::read_csv(file.path(dir_main, "data", "basins.csv")) %>% 
            select(subbasin, order), 
          by = "subbasin"
        ) %>% 
        arrange(order) %>% 
        ungroup() %>% 
        mutate(Name = as.factor(subbasin))
      
    } else {
      press_dat <- press_dat %>%
        dplyr::filter(region_id %in% 1:42) %>% 
        select(Name, layer, layername, Year, Pressure) %>% 
        mutate(Pressure = round(Pressure, 3))
    }
    
    ## create color palette, have 16 distinct pressure layers
    pressure_cols <- colorRampPalette(RColorBrewer::brewer.pal(8, "Set2")[c(1:7)])(16) 
    
    ## bar plot
    ## once have timeseries data, can make this a timeseries plot
    plot_obj <- ggplot2::ggplot(data = press_dat) +
      
      geom_col(
        position = position_stack(),
        aes(
          x = Name,
          y = Pressure,
          fill = layer,
          text = sprintf("%s\n%s\nScore (scale 0-1):  %s", Name, layername, Pressure)
        )
      ) + 
      
      theme_bw() +
      theme(
        axis.text.x = element_text(size = 8, angle = 40, color = "grey40"),
        legend.position = "none"
      ) +
      scale_fill_manual(values = pressure_cols) +
      labs(x = NULL, y = NULL, main = "Cumulative Pressures \n")
    
    
    plotly::ggplotly(plot_obj, tooltip = "text")
  })
  
  ## DATA LAYERS ----
  ## scatter plot
  # output$layers_scatter <- renderPlot({
  # 
  #   gh_lyrs <- "https://raw.githubusercontent.com/OHI-Science/bhi-1.0-archive/draft/baltic2015/layers/"
  #   dat_x <- readr::read_csv(paste0(gh_lyrs, input$layerscatter_var_x))
  #   dat_y <- readr::read_csv(paste0(gh_lyrs, input$layerscatter_var_y))
  # 
  #   x_name <- str_to_upper(str_remove(input$layerscatter_var_x, ".csv"))
  #   y_name <- str_to_upper(str_remove(input$layerscatter_var_y, ".csv"))
  # 
  #   df <- left_join(dat_x, dat_y, by = "rgn_id")
  #   colnames(df) <- c("region_id", x_name, y_name)
  # 
  #   ggplot(data  = df) +
  #     geom_point(aes_string(x_name, y_name)) +
  #     theme_minimal() +
  #     theme(
  #       axis.title.x = element_blank(),
  #       axis.title.y = element_blank()
  #     )
  # })
  
  ## make datatable of data layers from bhi-prep
  ## will eventually read from bhi-prep repo, and won't need all filters...
  # output$layers_datatab <- DT::renderDataTable({
  #   gh_lyrs <- "https://raw.githubusercontent.com/OHI-Science/bhi-1.0-archive/draft/baltic2015/layers/"
  #   # all_lyrs <- bhiprep_github_layers()
  #   all_lyrs <- bhiprep_github_layers("https://api.github.com/repos/OHI-Science/bhi-1.0-archive/git/trees/draft?recursive=1") %>%  # a func defined in common.R
  #     dplyr::mutate(fn = str_extract(., pattern = "/[a-z0-9_].*.csv")) %>%
  #     dplyr::mutate(fn = str_remove(fn, pattern = "/layers/")) %>%
  #     dplyr::filter(!str_detect(., pattern = "without_social")) %>%
  #     dplyr::filter(!str_detect(fn, pattern = "gl2014")) %>%
  #     dplyr::filter(!str_detect(fn, pattern = "trend")) %>%
  #     dplyr::filter(!str_detect(fn, pattern = "slope")) %>%
  #     dplyr::filter(!str_detect(fn, pattern = "status")) %>%
  #     dplyr::filter(!str_detect(fn, pattern = "res_reg")) %>%
  #     dplyr::filter(!is.na(fn))
  # 
  #   lyrs_df <- readr::read_csv(paste0(gh_lyrs,  "/", all_lyrs$fn[1])) # 2 cols, one is 'rgn_id' but really should use while...
  #   colnames(lyrs_df) <- c("rgn_id", str_remove(all_lyrs$fn[1], ".csv"))
  #   for(lyr in all_lyrs$fn[-1]){
  #     tmp <- readr::read_csv(paste0(gh_lyrs,  "/", lyr))
  #     if(ncol(tmp) == 2 & "rgn_id" %in% colnames(tmp)){
  #       colnames(tmp) <- c("rgn_id", str_remove(lyr, ".csv"))
  #       lyrs_df <- dplyr::left_join(lyrs_df, tmp, by = "rgn_id") # c("region_id", "year")
  #     }
  #   }
  #   datatable(
  #     lyrs_df,
  #     extensions = "Buttons",
  #     options = list(
  #       dom = "Bfrtip",
  #       buttons = c("csv", "excel")
  #     )
  #   )
  # })
  
}

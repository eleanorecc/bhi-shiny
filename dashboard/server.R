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
      flower_rgn <- reactive(values$flower_rgn)
      callModule(
        flowerplotCard, 
        "baltic_flowerplot",
        dimension = "score",
        flower_rgn_selected = flower_rgn
      )
    }, ignoreNULL = FALSE
  )
  
  callModule(
    barplotCard, 
    "index_barplot",
    goal_code = "Index",
    dimension_selected = dimension,
    spatial_unit_selected = spatial_unit
  )
  
  observeEvent(
    eventExpr = input$flower_rgn, {
      values$flower_rgn <- input$flower_rgn
      flower_rgn <- reactive(values$flower_rgn)
      
      callModule(
        mapCard, 
        "index_map",
        goal_code = "Index",
        dimension_selected = dimension,
        spatial_unit_selected = spatial_unit,
        year_selected = view_year,
        flower_rgn_selected = flower_rgn,
        legend_title = "Scores",
        popup_title = "Score:",
        popup_add_field = "Name",
        popup_add_field_title = "Name:"
      )
    }, ignoreNULL = FALSE
  )


## AO ----
## Artisanal Fishing Opportunity
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "ao_infobox",
      goal_code = "AO",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "ao_map",
      goal_code = "AO",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## BD ----
## Biodiversity
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "bd_infobox",
      goal_code = "BD",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "bd_map",
      goal_code = "BD",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})
## CS ----
## Carbon Storage
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "cs_infobox",
      goal_code = "CS",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "cs_map",
      goal_code = "CS",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## CW ----
## Clean Waters
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "cw_infobox",
      goal_code = "CW",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "cw_map",
      goal_code = "CW",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## CON ----
## Contaminants
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "con_infobox",
      goal_code = "CON",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "con_map",
      goal_code = "CON",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
)

callModule(
  barplotCard, "con_barplot",
  goal_code = "CON",
  dimension_selected = dimension,
  spatial_unit_selected = spatial_unit
)

output$con_datatable = renderDataTable({
  datatable(
    data_info %>% 
      filter(goal == "CON") %>% 
      select(-goal),
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})
## EUT ----
## Eutrophication
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "eut_infobox",
      goal_code = "EUT",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "eut_map",
      goal_code = "EUT",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## TRA ----
## Trash
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "tra_infobox",
      goal_code = "TRA",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "tra_map",
      goal_code = "TRA",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})
## FP ----
## Food Provision
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "fp_infobox",
      goal_code = "FP",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "fp_map",
      goal_code = "FP",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## FIS ----
## Fisheries
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "fis_infobox",
      goal_code = "FIS",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "fis_map",
      goal_code = "FIS",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
)

callModule(
  barplotCard, "fis_barplot",
  goal_code = "FIS",
  dimension_selected = dimension,
  spatial_unit_selected = spatial_unit
)

output$fis_datatable = renderDataTable({
  datatable(
    data_info %>% 
      filter(goal == "FIS") %>% 
      select(-goal),
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## MAR ----
## Mariculture
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "mar_infobox",
      goal_code = "MAR",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "mar_map",
      goal_code = "MAR",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## LE ----
## Coastal Livelihoods & Economies
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "le_infobox",
      goal_code = "LE",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "le_map",
      goal_code = "LE",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## ECO ----
## Economies
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "eco_infobox",
      goal_code = "ECO",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "eco_map",
      goal_code = "ECO",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})
## LIV ----
## Livelihoods
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "liv_infobox",
      goal_code = "LIV",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "liv_map",
      goal_code = "LIV",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## SP ----
## Sense of Place
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "sp_infobox",
      goal_code = "SP",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "sp_map",
      goal_code = "SP",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## ICO ----
## Iconic Species
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "ico_infobox",
      goal_code = "ICO",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "ico_map",
      goal_code = "ICO",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## LSP ----
## Lasting Special Places
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "lsp_infobox",
      goal_code = "LSP",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "lsp_map",
      goal_code = "LSP",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})
## NP ----
## Natural Products
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "np_infobox",
      goal_code = "NP",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "np_map",
      goal_code = "NP",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})

## TR ----
## Tourism & Recreation
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "tr_infobox",
      goal_code = "TR",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "tr_map",
      goal_code = "TR",
      dimension_selected = dimension,
      spatial_unit_selected = spatial_unit,
      flower_rgn_selected = flower_rgn,
      legend_title = "Scores",
      popup_title = "Score:",
      popup_add_field = "Name",
      popup_add_field_title = "Name:"
    )
  },
  ignoreNULL = FALSE
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
    options = list(dom = "t"),
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
    press_dat <- readr::read_csv(here::here("dashboard", "data", "layers_data.csv")) %>% 
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
          readr::read_csv(here::here("dashboard", "data", "regions.csv")) %>% 
            select(region_id, area_km2), 
          by = "region_id"
        ) %>% 
        group_by(subbasin, layer, layername, Year) %>% 
        summarize(Pressure = weighted.mean(Pressure, area_km2) %>% round(3)) %>% 
        left_join(
          readr::read_csv(here::here("dashboard", "data", "basins.csv")) %>% 
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
  output$layers_scatter <- renderPlot({

    gh_lyrs <- "https://raw.githubusercontent.com/OHI-Science/bhi-1.0-archive/draft/baltic2015/layers/"
    dat_x <- readr::read_csv(paste0(gh_lyrs, input$layerscatter_var_x))
    dat_y <- readr::read_csv(paste0(gh_lyrs, input$layerscatter_var_y))

    x_name <- str_to_upper(str_remove(input$layerscatter_var_x, ".csv"))
    y_name <- str_to_upper(str_remove(input$layerscatter_var_y, ".csv"))

    df <- left_join(dat_x, dat_y, by = "rgn_id")
    colnames(df) <- c("region_id", x_name, y_name)

    ggplot(data  = df) +
      geom_point(aes_string(x_name, y_name)) +
      theme_minimal() +
      theme(
        axis.title.x = element_blank(),
        axis.title.y = element_blank()
      )
  })

  ## make datatable of data layers from bhi-prep
  ## will eventually read from bhi-prep repo, and won't need all filters...
  output$layers_datatab <- DT::renderDataTable({
    gh_lyrs <- "https://raw.githubusercontent.com/OHI-Science/bhi-1.0-archive/draft/baltic2015/layers/"
    # all_lyrs <- bhiprep_github_layers()
    all_lyrs <- bhiprep_github_layers("https://api.github.com/repos/OHI-Science/bhi-1.0-archive/git/trees/draft?recursive=1") %>%  # a func defined in common.R
      dplyr::mutate(fn = str_extract(., pattern = "/[a-z0-9_].*.csv")) %>%
      dplyr::mutate(fn = str_remove(fn, pattern = "/layers/")) %>%
      dplyr::filter(!str_detect(., pattern = "without_social")) %>%
      dplyr::filter(!str_detect(fn, pattern = "gl2014")) %>%
      dplyr::filter(!str_detect(fn, pattern = "trend")) %>%
      dplyr::filter(!str_detect(fn, pattern = "slope")) %>%
      dplyr::filter(!str_detect(fn, pattern = "status")) %>%
      dplyr::filter(!str_detect(fn, pattern = "res_reg")) %>%
      dplyr::filter(!is.na(fn))

    lyrs_df <- readr::read_csv(paste0(gh_lyrs,  "/", all_lyrs$fn[1])) # 2 cols, one is 'rgn_id' but really should use while...
    colnames(lyrs_df) <- c("rgn_id", str_remove(all_lyrs$fn[1], ".csv"))
    for(lyr in all_lyrs$fn[-1]){
      tmp <- readr::read_csv(paste0(gh_lyrs,  "/", lyr))
      if(ncol(tmp) == 2 & "rgn_id" %in% colnames(tmp)){
        colnames(tmp) <- c("rgn_id", str_remove(lyr, ".csv"))
        lyrs_df <- dplyr::left_join(lyrs_df, tmp, by = "rgn_id") # c("region_id", "year")
      }
    }
    datatable(
      lyrs_df,
      extensions = "Buttons",
      options = list(
        dom = "Bfrtip",
        buttons = c("csv", "excel")
      )
    )
  })

}

## UI code ----

## § (GOALCODE) GOALNAME ----
## GOALNAME
tabItem(
  tabName = "goalcode",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("GOALNAME"),
      width = 8
    ),
    scoreBoxUI(id = "goalcode_infobox"),
    box(
      h4(filter(goals_csv, goal == "GOALCODE")$description),
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    box(
      title = "Background Information", 
      status = "primary", 
      solidHeader = TRUE,
      "goaltext_key_information",
      width = 8
    ),
    box(
      title = "Scoring Criteria", 
      status = "primary", 
      solidHeader = TRUE,
      "goaltext_target",
      width = 4
    )
  ),
  
  ## plots and maps
  fluidRow(
    mapCardUI(
      id = "goalcode_map",
      title_text = "GOALNAME Scores Around the Baltic",
      sub_title_text = "A score of 100 indicates management thresholds are achieved (not necessarily pristine condition), while anything less represents failure to reach the 'acceptable' level.",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "goalcode_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to threshold or target level. Bar thickness corresponds to region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## insights and discussion, pressures, additional plots
  fluidRow(
    box(
      width = 8, 
      title = "Additional Insights & Discussion",
      status = "primary", 
      solidHeader = TRUE,
      "goaltext_key_messages"
    ),
    box(
      width = 4,
      title = "Pressures acting on this Goal",
      status = "primary", 
      solidHeader = TRUE,
      ## paste links info here...
    )
  ),
  
  fluidRow(
    tsplotCardUI(
      id = "goalcode_tsplot",
      title_text = "Visualizing Some of the Data Behind GOALNAME Scores",
      sub_title_text = "",
      ht = 340,
      select_choices = list(
        goal_ts_layer_choices
      )
    )
  ),
  
  ## methods link, expert who provided guidance
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS, ADDITIONAL FIGURES & MAPS, CODE",
      "goal_data_prep_link"
    )
  ),
  fluidRow(
    box(
      width = 12, 
      title = "Experts who guided us in the goal prep and calculation",
      status = "primary", 
      solidHeader = TRUE,
      goal_expert_info
    )
  ),
  
  ## data sources, considerations and improvements
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Sources", 
      DT::dataTableOutput("goalcode_datatable")
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding of regional marine health and provisioning.",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        goaltext_data_considerations
      )
    )
  )
), # end GOALCODE tab item

## Server code ----

## GOALCODE ----
## GOALNAME

## overall score box in top right
callModule(
  scoreBox,
  "goalcode_infobox",
  goal_code = "GOALCODE"
)

## map
callModule(
  mapCard, 
  "goalcode_map",
  goal_code = "GOALCODE",
  dimension_selected = dimension,
  spatial_unit_selected = spatial_unit,
  year_selected = view_year,
  legend_title = "Scores",
  lyrs_latlon = c(), 
  lyrs_polygons = list(),
  popup_title = "Score:",
  popup_add_field = "Name",
  popup_add_field_title = "Name:"
)

## barplot
callModule(
  barplotCard, "goalcode_barplot",
  goal_code = "GOALCODE",
  dimension_selected = dimension,
  spatial_unit_selected = spatial_unit
)

## info table about input data layers
output$goalcode_datatable = renderDataTable({
  datatable(
    data_info %>% 
      filter(goal == "GOALCODE") %>% 
      select(-goal),
    options = list(
      dom = "t", 
      pageLength = nrow(filter(data_info, goal == "GOALCODE"))
    ),
    rownames = FALSE,
    escape = FALSE
  )
})

## layers timeseries plot
values <- reactiveValues(`goalcode_tsplot-select` = goal_ts_default_layer)
observeEvent(
  eventExpr = input$`goalcode_tsplot-select`, {
    values$`goalcode_tsplot-select` <- input$`goalcode_tsplot-select`
    callModule(
      tsplotCard, 
      "goalcode_tsplot",
      plot_type = "boxplot",
      layer_selected = reactive(values$`goalcode_tsplot-select`),
      spatial_unit_selected = spatial_unit
    )
  }, ignoreNULL = FALSE
)

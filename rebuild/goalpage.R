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
      # h4(filter(goals_csv, goal == "GOALCODE")$short_def),
      h4(filter(goals_csv, goal == "GOALCODE")$description),
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    box(
      title = "Key Information", 
      status = "primary", 
      solidHeader = TRUE,
      "goaltext_key_information",
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "goaltext_target",
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "goalcode_map",
      title_text = "GOALNAME Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "goalcode_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key messages, timeseries plot, and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Messages",
      status = "primary", 
      solidHeader = TRUE,
      "goaltext_key_messages"
    )
  ),
  fluidRow(
    tsplotCardUI(
      id = "goalcode_tsplot",
      title_text = "GOALNAME Data Layers",
      sub_title_text = "",
      ht = 340,
      select_choices = list(
        goal_ts_layer_choices
      )
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("goalcode_datatable")
    )
  ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      "goal_data_prep_link"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
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
  legend_title = "Scores",
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
      layer_selected = reactive(values$`goalcode_tsplot-select`),
      spatial_unit_selected = spatial_unit
    )
  }, ignoreNULL = FALSE
)

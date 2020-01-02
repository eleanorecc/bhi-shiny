## UI code ----

## § (GOALCODE) GOALNAME ----
## GOALNAME
tabItem(
  tabName = "GOALCODE",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("GOALNAME"),
      width = 8
    ),
    column(
      width = 4,
      scoreBoxUI(id = "goalcode_infobox")
    ),
    box(
      h4(filter(goals_csv, goal == "GOALCODE")$short_def),
      p(filter(goals_csv, goal == "GOALCODE")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Target", 
      status = "info", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content",
      width = 6
    ),
    box(
      title = "Key Messages", 
      status = "info", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content",
      width = 6
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "goalcode_map",
      title_text = "GOALNAME Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      box_width = 8,
      ht = 555
    ),
    barplotCardUI(
      id = "goalcode_barplot",
      title_text = "Shortfall/Headway in GOALNAME",
      sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      title = "Key Information", 
      background = "teal", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      title = "Data Layers", 
      DT::dataTableOutput("goalcode_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/GOALCODE/goalcode_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("bold text:"),
          "bullet point one."
        ),
        tags$li(
          tags$b("bold text:"),
          "bullet point two."
        )
      )
    )
  )
) # end GOALCODE tab item

## Server code ----

## GOALCODE ----
## GOALNAME
observeEvent(
  eventExpr = input$flower_rgn, {
    
    values$flower_rgn <- input$flower_rgn
    flower_rgn <- reactive(values$flower_rgn)
    
    callModule(
      scoreBox,
      "goalcode_infobox",
      goal_code = "GOALCODE",
      flower_rgn_selected = flower_rgn
    )
    
    callModule(
      mapCard, 
      "goalcode_map",
      goal_code = "GOALCODE",
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
  barplotCard, "goalcode_barplot",
  goal_code = "GOALCODE",
  dimension_selected = dimension,
  spatial_unit_selected = spatial_unit
)

output$goalcode_datatable = renderDataTable({
  datatable(
    data_info %>% 
      filter(goal == "goalcode") %>% 
      select(-goal),
    options = list(dom = "t"),
    rownames = FALSE,
    escape = FALSE
  )
})
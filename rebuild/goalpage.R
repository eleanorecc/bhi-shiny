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
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
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
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
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
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/GOALCODE/goalcode_prep.md", gh_prep)
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
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end GOALCODE tab item

## Server code ----

## GOALCODE ----
## GOALNAME

callModule(
  scoreBox,
  "goalcode_infobox",
  goal_code = "GOALCODE"
)

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

callModule(
  barplotCard, "goalcode_barplot",
  goal_code = "GOALCODE",
  dimension_selected = dimension,
  spatial_unit_selected = spatial_unit
)

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

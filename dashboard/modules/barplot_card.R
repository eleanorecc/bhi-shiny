#' barplot for map card module
#'
#' this script contains two functions:
#' \code{barplotCardUI} generates the user interface for each card
#' \code{mapBarplotCard} generates the plot shown in the card

## barplot card ui function ----
barplotCardUI <- function(id, title_text = NULL, sub_title_text = NULL, source_text = NULL, box_width = 12){

  ns <- shiny::NS(id)
  items <- plotlyOutput(ns("barplot"), height = 555)
  tagList(box(
    collapsible = TRUE,
    title = title_text,
    list(p(sub_title_text), items, p(source_text)),
    width = box_width
  ))
}


## barplot card server function ----
barplotCard <- function(input, output, session, goal_code, dimension_selected, spatial_unit_selected){

  output$barplot <- renderPlotly({
    ## scores data matching selected dimension
    d <- dimension_selected()
    scores_csv <- filter(full_scores_csv, dimension == d)
    
    ## barplot
    thm <- apply_bhi_theme(plot_type = "flowerplot")
    scores_barplot(
      scores_csv,
      basins_or_rgns = spatial_unit_selected(),
      goal_code,
      dim = dimension_selected()
    )
  })
}

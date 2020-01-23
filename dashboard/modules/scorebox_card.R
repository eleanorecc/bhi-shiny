#' goal score infobox module
#'
#' this script contains two functions:
#' \code{scoreBoxUI} generates the user interface for each goal scorebox
#' \code{scoreBox} generates the infobox and text it contains

## scorebox ui function ----
scoreBoxUI <- function(id){
  ns <- shiny::NS(id)
  tagList(list(infoBoxOutput(ns("goal_scorebox"), width = 4)))
}

## scorebox server function ----
scoreBox <- function(input, output, session, goal_code){

  scores <- full_scores_csv %>%
    dplyr::filter(goal == goal_code, dimension == "score")

  output$goal_scorebox <- renderInfoBox(
    infoBox(
      title = "",
      icon = icon(thm$icons[[goal_code]]),
      tags$p(
        filter(scores, region_id == 0)$score, 
        style = "font-size: 260%; text-align:right; font-weight: lighter;"
      ),
      color =  filter(thm$palettes$goalpal_shiny, goal == goal_code)$color,
      fill = TRUE
    )
  )
}

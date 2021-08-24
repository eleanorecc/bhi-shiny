#' goal score infobox module
#'
#' this script contains two functions:
#' \code{scoreBoxUI} generates the user interface for each goal score box
#' \code{scoreBox} generates the score box and text it contains

## score-box ui function ----
scoreBoxUI <- function(id){
  ns <- shiny::NS(id)
  tagList(list(infoBoxOutput(ns("goal_scorebox"), width = 4)))
}

## score-box server function ----
scoreBox <- function(input, output, session, goal_code){
  
  scores <- df_scores %>%
    dplyr::filter(goal == goal_code, dimension == "score") %>% 
    mutate(score = round(score, 0))
  
  output$goal_scorebox <- renderInfoBox(
    infoBox(
      title = "",
      icon = icon(thm$icons[[goal_code]]),
      tags$p(
        "Current Score", 
        strong(filter(scores, region_id == "BHI-000")$score),
        style = "font-size: 180%; text-align:right; font-weight:100; padding-top:18px; padding-bottom:0px;"
      ),
      color = filter(thm$palettes$goalpal_shiny, goal == goal_code)$color,
      fill = TRUE
    )
  )
}

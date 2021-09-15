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
scoreBox <- function(input, output, session, goal_code, goal_confidence){
  
  scores <- df_scores %>%
    dplyr::filter(goal == goal_code, dimension == "score") %>% 
    mutate(score = round(score, 0))
  
  output$goal_scorebox <- renderInfoBox(
    infoBox(
      title = HTML(paste(
        tags$h4(
          "GOAL SCORE:", strong(filter(scores, region_id == "BHI-000")$score, style = "font-weight:800;"),
          style = "color:#f8f9fb; font-size: 200%; font-weight:400; text-align:right; padding-top:0px; padding-bottom:0px;"
        ),
        tags$h4(
          "CONFIDENCE:", goal_confidence,
          style = "color:#8099af; font-size: 125%; text-align:right; padding-top:0px; padding-bottom:0px;"
        )
      )),
      icon = icon(thm$icons[[goal_code]]),
      color = filter(thm$palettes$goalpal_shiny, goal == goal_code)$color,
      fill = TRUE
    )
  )
}

#' flowerplot card module
#'
#' this script contains two functions:
#' \code{flowerplotCardUI} generates the user interface for each flowerplot card
#' \code{flowerplotCard} generates the flowerplot shown in a card

## flowerplot card ui function ----
flowerplotCardUI <- function(id, title_text = NULL, sub_title_text = NULL){
  
  ## make namespace for the id-specific object
  ns <- shiny::NS(id)
  
  ## put together in box and return box
  tagList(box(
    width = 5,
    collapsible = TRUE,
    title = title_text,
    
    list(
      p(sub_title_text),
      addSpinner(
        imageOutput(ns("flowerplot"), height = 480),
        spin = "rotating-plane",
        color = "#d7e5e8"
      )
    )
  ))
}

## flowerplot card server function ----
flowerplotCard <- function(input, output, session, dimension, flower_rgn_selected){
  
  rgn_id <- flower_rgn_selected()
  dim <- dimension
  
  output$flowerplot <- renderImage({
    fig <- list.files(here::here("shiny", "figures")) %>% 
      grep(pattern = paste0("flowerplot", rgn_id), value = TRUE)
    list(
      src = here::here("shiny", "figures", fig), 
      contentType = "image/jpeg", 
      width = "455px", 
      height = "415px"
    )
  },
  deleteFile = FALSE)
}

#' flowerplot card module
#'
#' this script contains two functions:
#' \code{flowerplotCardUI} generates the user interface for each flowerplot card
#' \code{flowerplotCard} generates the flowerplot shown in a card

## flowerplot card ui function ----
flowerplotCardUI <- function(id, title_text = NULL, sub_title_text = NULL, additional_text = NULL){
  
  ## make namespace for the id-specific object
  ns <- shiny::NS(id)
  
  ## put together in box and return box
  tagList(box(
    solidHeader = TRUE,
    width = 6,
    h4(title_text),
    
    list(
      p(sub_title_text, br()),
      p(additional_text, br()),
      br(),
      addSpinner(
        imageOutput(ns("flowerplot"), height = 435),
        spin = "rotating-plane",
        color = "#d7e5e8"
      ),
      
      br(),
      br(),
      
      ## input region ----
      selectInput(
        "flower_rgn",
        label = NULL,
        # "Select Region for Flowerplot",
        list(
          `Baltic Sea` = 0,
          `Aland Sea` = c(
            `Aland Sea` = 514,
            `Aland Sea, Sweden` = 35,
            `Aland Sea, Finland` = 36
          ),
          `Arkona Basin` = c(
            `Arkona Basin` = 506,
            `Arkona Basin, Sweden` = 11,
            `Arkona Basin, Denmark` = 12,
            `Arkona Basin, Germany` = 13
          ),
          `Bay of Mecklenburg` = c(
            `Bay of Mecklenburg` = 505,
            `Bay of Mecklenburg, Denmark` = 9,
            `Bay of Mecklenburg, Germany` = 10
          ),
          `Bornholm Basin` = c(
            `Bornholm Basin` = 507,
            `Bornholm Basin, Sweden` = 14,
            `Bornholm Basin, Denmark` = 15,
            `Bornholm Basin, Germany` = 16,
            `Bornholm Basin, Poland` = 17
          ),
          `Bothnian Bay` = c(
            `Bothnian Bay` = 517,
            `Bothnian Bay, Sweden` = 41,
            `Bothnian Bay, Finland` = 42
          ),
          `Bothnian Sea` = c(
            `Bothnian Sea` = 515,
            `Bothnian Sea, Sweden` = 37,
            `Bothnian Sea, Finland` = 38
          ),
          `Eastern Gotland Basin` = c(
            `Eastern Gotland Basin` = 509,
            `Eastern Gotland Basin, Sweden` = 20,
            `Eastern Gotland Basin, Poland` = 21,
            `Eastern Gotland Basin, Russia` = 22,
            `Eastern Gotland Basin, Lithuania` = 23,
            `Eastern Gotland Basin, Latvia` = 24,
            `Eastern Gotland Basin, Estonia` = 25
          ),
          `Gdansk Basin` = c(
            `Gdansk Basin` = 508,
            `Gdansk Basin, Poland` = 18,
            `Gdansk Basin, Russia` = 19
          ),
          `Great Belt` = c(
            `Great Belt` = 502,
            `Great Belt, Denmark` = 3,
            `Great Belt, Germany` = 4
          ),
          `Gulf of Finland` = c(
            `Gulf of Finland` = 513,
            `Gulf of Finland, Finland` = 32,
            `Gulf of Finland, Russia` = 33,
            `Gulf of Finland, Estonia` = 34
          ),
          `Gulf of Riga` = c(
            `Gulf of Riga` = 511,
            `Gulf of Riga, Latvia` = 27,
            `Gulf of Riga, Estonia` = 28
          ),
          `Kattegat` = c(
            `Kattegat` = 501,
            `Kattegat, Sweden` = 1,
            `Kattegat, Denmark` = 2
          ),
          `Kiel Bay` = c(
            `Kiel Bay` = 504,
            `Kiel Bay, Denmark` = 7,
            `Kiel Bay, Germany` = 8
          ),
          `Northern Baltic Proper` = c(
            `Northern Baltic Proper` = 500,
            `Northern Baltic Proper, Sweden` = 29,
            `Northern Baltic Proper, Finland` = 30,
            `Northern Baltic Proper, Estonia` = 31
          ),
          `The Quark` = c(
            `The Quark` = 516,
            `The Quark, Sweden` = 39,
            `The Quark, Finland` = 40
          ),
          `The Sound` = c(
            `The Sound` = 503,
            `The Sound, Sweden` = 5,
            `The Sound, Denmark` = 6
          ),
          `Western Gotland Basin` = c(
            `Western Gotland Basin` = 510,
            `Western Gotland Basin, Sweden` = 26
          )
        )
      ) # end region input select menu
    )
  ))
}

## flowerplot card server function ----
flowerplotCard <- function(input, output, session, dimension, flower_rgn_selected){
  
  rgn_id <- flower_rgn_selected()
  dim <- dimension
  
  output$flowerplot <- renderImage({
    fig <- list.files(file.path(dir_main, "figures")) %>% 
      grep(pattern = paste0("flowerplot", rgn_id), value = TRUE)
    list(
      src = file.path(dir_main, "figures", fig), 
      contentType = "image/jpeg", 
      width = "478px", # "455px", 
      height = "436px" #"415px"
    )
  },
  deleteFile = FALSE)
}

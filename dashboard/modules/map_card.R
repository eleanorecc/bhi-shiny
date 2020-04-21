#' map card module
#'
#' this script contains two functions:
#' \code{mapCardUI} generates the user interface for each card
#' \code{mapCard} generates the plot shown in a card
#' from https://github.com/OHI-Northeast/ne-dashboard/blob/master/modules/map_card.R

## map card ui function ----
mapCardUI <- function(id, title_text = NULL, sub_title_text = NULL, box_width = 6, ht = 540, source_text = NULL){
  
  
  ns <- shiny::NS(id)
  items <- leafletOutput(ns("plot"), height = ht)
  
  ## put together in box and return box
  tagList(box(
    width = box_width,
    collapsible = TRUE,
    title = title_text,
    
    list(
      p(sub_title_text, br(), br()),
      addSpinner(items, spin = "rotating-plane", color = "#d7e5e8"),
      p(source_text)
    )
  ))
}

## map card server function ----
mapCard <- function(input, output, session,
                    goal_code, dimension_selected, spatial_unit_selected, 
                    year_selected, legend_title, 
                    popup_title = NA, popup_add_field = NA, popup_add_field_title = NA){
  
  output$plot <- renderLeaflet({
    ## scores data and spatial data
    scores_csv <- full_scores_csv %>%
      filter(dimension == dimension_selected())
    
    if(spatial_unit_selected() == "subbasins"){
      mapping_data_sp <- subbasins_shp
    } else {mapping_data_sp <- rgns_shp}
    
    ## create leaflet map
    result <- leaflet_map(
      goal_code, 
      mapping_data_sp,
      spatial_unit_selected(), 
      scores_csv, 
      dim = dimension_selected(), 
      year = assess_year,
      legend_title
    )
    
    ## create and add popup text
    popup_text <- paste(
      "<h5><strong>", popup_title, "</strong>",
      result$data_sf[["score"]], "</h5>",
      "<h5><strong>", popup_add_field_title, "</strong>",
      result$data_sf[[popup_add_field]], "</h5>", sep = " "
    )
    result$map %>% addPolygons(popup = popup_text, fillOpacity = 0, stroke = FALSE)
  })
}

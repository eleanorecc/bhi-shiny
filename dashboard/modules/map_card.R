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
                    lyrs_latlon = NA, lyrs_polygons = NA, 
                    popup_title = NA, popup_add_field = NA, popup_add_field_title = NA){
  
  output$plot <- renderLeaflet({
    
    ## create leaflet map
    result <- leaflet_map(
      full_scores_lst,
      basins_or_rgns = spatial_unit_selected(),
      goal_code, 
      dim = dimension_selected(), 
      year = year_selected(),
      legend_title
    )
    
    ## create and add popup text
    popup_text <- paste(
      "<h5><strong>", popup_title, "</strong>",
      result$data_sf[["score"]], "</h5>",
      "<h5><strong>", popup_add_field_title, "</strong>",
      result$data_sf[[popup_add_field]], "</h5>", sep = " "
    )
    
    
    if(length(lyrs_latlon)!=0|length(lyrs_polygons)!=0){
      ## add data overlays to goal maps
      result$map <- add_map_datalayers(
        result$map, 
        lyrs_latlon, 
        lyrs_polygons, 
        year = year_selected()
      )
    }
    
    result$map %>% addPolygons(popup = popup_text, fillOpacity = 0, stroke = FALSE)
  })
}

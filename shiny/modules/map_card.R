#' map card module
#'
#' this script contains two functions:
#' \code{mapCardUI} generates the user interface for each card
#' \code{mapCard} generates the plot shown in a card
#' from https://github.com/OHI-Northeast/ne-dashboard/blob/master/modules/map_card.R

## map card ui function ----
mapCardUI <- function(id, title_text = NULL, sub_title_text = NULL, box_width = 6, ht = 480, source_text = NULL){
  
  
  ns <- shiny::NS(id)
  items <- leafletOutput(ns("plot"), height = ht)
  
  ## put together in box and return box
  tagList(box(
    width = box_width,
    collapsible = TRUE,
    title = title_text,
    
    list(
      p(sub_title_text),
      addSpinner(items, spin = "rotating-plane", color = "#d7e5e8"),
      p(source_text)
    )
  ))
}

## map card server function ----
mapCard <- function(input, output, session,
                    goal_code, dimension_selected, spatial_unit_selected, 
                    year_selected, flower_rgn_selected = NULL,
                    legend_title, popup_title = NA, popup_add_field = NA, popup_add_field_title = NA){

  
  rgn_id <- flower_rgn_selected()
  
  output$plot <- renderLeaflet({
    ## scores data and spatial data
    scores_csv <- full_scores_csv %>%
      filter(dimension == dimension_selected())

    ## create selected-region overlay, based on spatial unit and flowerplot region
    if(!is.null(rgn_id) && rgn_id %in% c(1:42, 501:517)){
      
      if(rgn_id %in% 1:42){
        rgn_select <- rgns_shp %>% 
          dplyr::select(BHI_ID) %>% 
          dplyr::filter(BHI_ID == rgn_id)
      } else if(rgn_id %in% 501:517){
        rgn_select <- subbasins_shp %>% 
          dplyr::select(HELCOM_ID) %>% 
          dplyr::left_join(
            subbasins_df %>%
              dplyr::select(BHI_ID = subbasin_id, HELCOM_ID = helcom_id) %>%
              dplyr::mutate(HELCOM_ID = as.factor(HELCOM_ID)),
            by = "HELCOM_ID"
          ) %>%
          dplyr::filter(BHI_ID == rgn_id)
      }
    }
    
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
    
    ## create popup text
    popup_text <- paste(
      "<h5><strong>", popup_title, "</strong>",
      result$data_sf[[goal_code]], "</h5>",
      "<h5><strong>", popup_add_field_title, "</strong>",
      result$data_sf[[popup_add_field]], "</h5>", sep = " "
    )
    
    ## return leaflet map with popup added
    if(!is.null(rgn_id) && rgn_id %in% c(1:42, 501:517)){
      result$map %>%
        addPolygons(
          data = rgn_select,
          stroke = TRUE, weight = 4,
          opacity = 0.6, fillOpacity = 0, color = "red",
          smoothFactor = 3) %>%
        addPolygons(
          popup = popup_text,
          fillOpacity = 0,
          stroke = FALSE
        )
    } else {
      result$map %>%
        addPolygons(
          popup = popup_text,
          fillOpacity = 0,
          stroke = FALSE
        )
    }
  })
}

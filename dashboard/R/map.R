#' wrangle data for map
#'
#' @param df_scores bhi scores dataframe as read in global.R from the database
#' @param rgn_set spatial units to visualize in the map, either 'subbasins' or 'regions'
#' @param goal_code 'Index' or 2-3 letter code representing goal to visualize
#' @param dim 'score', 'status', 'trend', 'resilience', or 'pressure'
#' @param year assessment year to visualize
wrangle_mapdata <- function(df_scores, rgn_set = "subbasins", goal_code = "Index",
                            dim = "score", year = assess_year){
  
  ## wrangle/reshape and join with spatial info to make sf for plotting
  ## join with spatial information, using spatialdataframes with sp package, rather than sf...
  if(rgn_set == "subbasins"){
    mapping_data <- df_subbasins %>% 
      select(Name = subbasin, region_id) %>% 
      left_join(lst_scores[[goal_code]][[dim]][[as.character(year)]], by = "region_id")
    subbasins_shp@data <- subbasins_shp@data %>% 
      select(region_id) %>% 
      left_join(mapping_data, by = "region_id")
    mapsp <- subbasins_shp
  }
  if(rgn_set == "regions"){
    mapping_data <- df_regions %>% 
      select(Name = region_name, region_id) %>% 
      left_join(lst_scores[[goal_code]][[dim]][[as.character(year)]], by = "region_id")
    bhi_rgn_shp@data <- bhi_rgn_shp@data %>% 
      select(region_id) %>% 
      left_join(mapping_data, by = "region_id")
    mapsp <- bhi_rgn_shp
  }
  
  ## return sp object to make map as well as options
  return(list(
    mapsp = mapsp, 
    optn = list(rgn_set = rgn_set, goal_code = goal_code, dim = dim, year = year)
  ))
}

#' make bhi dash leaflet map
#'
#' @param mapsp_base object created using wrangle_mapdata function
make_map <- function(mapsp_base){
  
  ## handling different dimensions
  ## adjust or flip palettes
  if(mapsp_base$optn$dim == "trend"){paldomain = c(-1, 1)} else {paldomain = c(0, 100)}
  if(mapsp_base$optn$dim == "pressures"){
    pal <- leaflet::colorNumeric(
      palette = rev(thm$palettes$mappal),
      domain = paldomain,
      na.color = thm$cols$map_background1
    )
  } else {
    pal <- leaflet::colorNumeric(
      palette = thm$palettes$mappal,
      domain = paldomain,
      na.color = thm$cols$map_background1
    )
  }
  
  ## create basemap
  map <- leaflet::leaflet() %>%
    addMapPane("right", zIndex = 0) %>%
    addMapPane("left", zIndex = 0) %>%
    addProviderTiles(
      providers$Esri.WorldGrayCanvas,
      layerId = "baseid",
      options = pathOptions(pane = "right")
    ) %>%
    setView(19, 60, zoom = 5)
  
  ## scores polygons
  map <- map %>% 
    addPolygons(
      data = mapsp_base$mapsp,
      stroke = TRUE,
      opacity = 0.5,
      weight = 2,
      fillOpacity = 0.8,
      smoothFactor = 0.5,
      color = thm$cols$map_polygon_border1,
      fillColor = ~pal(score),
      highlightOptions = highlightOptions(
        color = "steelblue", weight = 1,
        bringToFront = TRUE
      ),
      group = "base",
      options = pathOptions(pane = "right")
    )
  
  ## minimap, easybuttons, legend
  map <- map %>% 
    addLegend(
      "bottomright",
      pal = pal,
      values = c(paldomain[1]:paldomain[2]),
      title = paste(
        str_to_upper(mapsp_base$optn$dim), 
        "<br>",
        str_to_upper(mapsp_base$optn$year),
        str_to_upper(mapsp_base$optn$goal_code)
      ),
      opacity = 0.8,
      layerId = "colorLegend_base"
    ) %>% 
    addMiniMap(
      tiles = providers$Esri.NatGeoWorldMap,
      zoomLevelOffset = -4,
      toggleDisplay = TRUE,
      position = "bottomleft",
      width = 150, height = 150,
      collapsedWidth = 18, collapsedHeight = 18,
      ## don't start with minimized 
      ## otherwise every time the map updates its shown collapsing
      minimized = FALSE
    ) %>%
    addEasyButton(
      easyButton(
        icon="fa-crosshairs", title="Locate Me",
        onClick=JS("function(btn, map){map.locate({setView: true});}")
      )
    ) %>%
    addEasyButton(
      easyButton(
        icon="fa-github-square", title="See the code",
        onClick=JS("function(){window.location.href = 'https://github.com/OHI-Baltic';}")
      )
    ) %>%
    addEasyButton(
      easyButton(
        icon="fa-database", title="Get the data",
        onClick=JS("function(){window.location.href = 'https://github.com/OHI-Baltic/bhi-shiny/tree/master/dashboard/data';}")
      )
    ) %>%
    ## https://github.com/trafficonese/leaflet.extras2/blob/master/inst/examples/easyprint_app.R
    leaflet.extras2::addEasyprint(
      options = leaflet.extras2::easyprintOptions(
        title = "Save map",
        position = "topleft",
        exportOnly = TRUE,
        filename = "mymap-baltic-health-index"
      )
    )
  return(map)
}

#' split leaflet map
#'
#' @param leaflet_map leaflet map created using the make_map function above
#' @param mapsp_alt object created using wrangle_mapdata function
split_map <- function(leaflet_map, mapsp_alt){
  
  ## handling different dimensions
  ## adjust or flip palettes
  if(mapsp_alt$optn$dim == "trend"){paldomain = c(-1, 1)} else {paldomain = c(0, 100)}
  if(mapsp_alt$optn$dim == "pressures"){
    pal <- leaflet::colorNumeric(
      palette = rev(thm$palettes$mappal),
      domain = paldomain,
      na.color = thm$cols$map_background1
    )
  } else {
    pal <- leaflet::colorNumeric(
      palette = thm$palettes$mappal,
      domain = paldomain,
      na.color = thm$cols$map_background1
    )
  }
  
  ## add second pane to basemap
  map <- leaflet_map %>%
    addProviderTiles(
      providers$Esri.WorldGrayCanvas,
      layerId = "altid",
      options = pathOptions(pane = "left")
    ) %>%
    addPolygons(
      data = mapsp_alt$mapsp,
      stroke = TRUE,
      opacity = 0.5,
      weight = 2,
      fillOpacity = 0.8,
      smoothFactor = 0.5,
      color = thm$cols$map_polygon_border1,
      fillColor = ~pal(score),
      highlightOptions = highlightOptions(
        color = "steelblue", weight = 1,
        bringToFront = TRUE
      ),
      group = "alt",
      options = pathOptions(pane = "left")
    ) %>% 
    addLegend(
      "bottomleft",
      pal = pal,
      values = c(paldomain[1]:paldomain[2]),
      title = paste(
        str_to_upper(mapsp_alt$optn$dim), 
        "<br>",
        str_to_upper(mapsp_alt$optn$year),
        str_to_upper(mapsp_alt$optn$goal_code)
      ),
      opacity = 0.8,
      layerId = "colorLegend_alt"
    ) %>% 
    leaflet.extras2::addSidebyside(layerId = "sidecontrols", rightId = "baseid", leftId = "altid")
  
  return(map)
}

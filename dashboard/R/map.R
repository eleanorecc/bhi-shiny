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
    df <- subbasins_shp
  }
  if(rgn_set == "regions"){
    mapping_data <- df_regions %>% 
      select(Name = region_name, region_id) %>% 
      left_join(lst_scores[[goal_code]][[dim]][[as.character(year)]], by = "region_id")
    bhi_rgn_shp@data <- bhi_rgn_shp@data %>% 
      select(region_id) %>% 
      left_join(mapping_data, by = "region_id")
    df <- bhi_rgn_shp
  }
  
  ## return sp object to make map as well as options
  return(list(
    df = df, 
    optn = list(rgn_set = rgn_set, goal_code = goal_code, dim = dim, year = year)
  ))
}

make_basemap <- function(){
  
  ## create basemap
  map <- leaflet() %>%
    addMapPane("right", zIndex = 0) %>%
    addMapPane("left", zIndex = 0) %>%
    addProviderTiles(
      providers$Esri.WorldGrayCanvas,
      layerId = "baseid",
      options = pathOptions(pane = "right")
    ) %>%
    setView(20, 60, zoom = 5) %>% 
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
    # addMeasure(
    #   position = "topleft", primaryLengthUnit = "meters", 
    #   primaryAreaUnit = "acres", secondaryAreaUnit = "sqmeters",
    #   activeColor = "#ff6f69", completedColor = "#00a9ff"
    # ) %>%
    ## https://github.com/trafficonese/leaflet.extras2/blob/master/inst/examples/easyprint_app.R
    leaflet.extras2::addEasyprint(
      options = leaflet.extras2::easyprintOptions(
        title = "Save map",
        position = "topleft",
        exportOnly = TRUE,
        filename = "mymap-baltic-health-index"
      )
    )
}

#' make bhi dash leaflet map
#'
#'#@param leaflet_map leaflet map created using make_basemap function
#' @param df object created using wrangle_mapdata function
#' @param duplicatemap
make_map <- function(leaflet_map, df, second_map = FALSE){
  
  ## vars to indicate which pane to add polygons to
  if(isFALSE(second_map)){
    add_to_group <- "base"
    add_to_pane <- "right"
    new_legend_pos <- "bottomright"
    new_legend_id <- "colorLegend_base"
  } else {
    add_to_group <- "alt"
    add_to_pane <- "left"
    new_legend_pos <- "bottomleft"
    new_legend_id <- "colorLegend_alt"
  }
  
  ## handling different dimensions
  ## adjust or flip palettes
  if(df$optn$dim == "trend"){paldomain = c(-1, 1)} else {paldomain = c(0, 100)}
  if(df$optn$dim == "pressures"){
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
  
  ## add scores polygons
  map <- leaflet_map %>% 
    addPolygons(
      data = df$df,
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
      group = add_to_group,
      options = pathOptions(pane = add_to_pane)
    ) %>% 
    addLegend(
      new_legend_pos,
      pal = pal,
      values = c(paldomain[1]:paldomain[2]),
      title = paste(
        str_to_upper(df$optn$dim), 
        "<br>",
        str_to_upper(df$optn$year),
        str_to_upper(df$optn$goal_code),
        "<br>",
        str_to_upper(df$optn$rgn_set)
      ),
      opacity = 0.8,
      layerId = new_legend_id
    )  
  
  if(isTRUE(second_map)){
    map <- map %>% 
      addProviderTiles(
        providers$Esri.WorldGrayCanvas,
        layerId = "altid",
        options = pathOptions(pane = "left")
      ) %>%
      leaflet.extras2::addSidebyside(
        layerId = "sidecontrols", 
        rightId = "baseid", 
        leftId = "altid"
      )
  }
  return(map)
}

add_popup <- function(leaflet_map, df, popup_type, second_map = FALSE){
  
  ## vars to indicate which pane to add pop-ups to
  if(isFALSE(second_map)){
    add_to_group <- "base"
    add_to_pane <- "right"
  } else {
    add_to_group <- "alt"
    add_to_pane <- "left"
  }
  
  if(popup_type == "mappopscore"){
    p <- paste(
      "<h5><strong>", paste(df$optn$goal_code, df$optn$dim), "</strong>",
      df$df[["score"]], "</h5>",
      "<h5><strong>", "Name", "</strong>",
      df$df[["Name"]], "</h5>", sep = " "
    )
    map <- leaflet_map %>%
      addPolygons(
        data = df$df, 
        popup = p,
        fillOpacity = 0,
        stroke = FALSE,
        group = add_to_group,
        options = pathOptions(pane = add_to_pane)
      )
  }
  if(popup_type == "mappopflower"){
    figs <- "https://raw.githubusercontent.com/OHI-Baltic/bhi-shiny/update/dashboard/figures/"
    map <- leaflet_map %>% 
      addPolygons(
        data = df$df, 
        popup = paste0("<img src = ", figs, "flowerplot", substr(df$df$region_id, 5, 7), ".png width=300>"), 
        fillOpacity = 0,
        stroke = FALSE,
        group = add_to_group,
        options = pathOptions(pane = add_to_pane)
      )
  }
  if(popup_type == "mappopbar"){
    
    ## palette to match the map
    ## handling different dimensions, adjust or flip palettes
    pal <- thm$palettes$mappal
    if(df$optn$dim == "trend"){paldomain = c(-1, 1)} else {paldomain = c(0, 100)}
    if(df$optn$dim == "pressures"){pal <- rev(pal)}
    
    ## get data and reorder factor levels so arranged roughly north to south
    plotdf <- df$df@data
    if(df$optn$rgn_set == "regions"){
      plotdf$region_id <- factor(plotdf$region_id, levels = rev(arrange(df_regions, region_order)$region_id))
    } else {
      plotdf$region_id <- factor(plotdf$region_id, levels = rev(arrange(df_subbasins, subbasin_order)$region_id))
    }
    
    
    ## make and save plot
    barplot <- ggplot(plotdf) + 
      geom_col(
        aes(x = region_id, y = score, fill = score), 
        color = "dimgrey", size = 0.1, show.legend = FALSE
      ) +
      geom_hline(yintercept = 100) +
      geom_text(
        aes(x = region_id, y = score, label = Name), 
        size = 1.7, alpha = 0.7, nudge_y = 10
      ) +
      coord_flip() +
      scale_fill_gradientn(
        colors = pal,
        na.value = thm$cols$map_background1, 
        limits = paldomain
      ) +
      theme_linedraw() +
      theme(
        axis.text = element_blank(),
        axis.ticks = element_blank(), 
        panel.grid = element_line(color = "gainsboro")
      ) +
      labs(x = NULL, y = NULL)
    
    ggsave(
      filename = file.path(dir_main, "www", "barplot.png"), 
      plot = barplot, 
      width = 2.3, height = 3.8, dpi = 400
    )
    p <- tags$div(HTML(
      "<div id='map'><div id='logoContainer'>
          <img src='barplot.png' width='300'>
          </div></div>"
    ))
    
    ## don't include bar plot when having split map
    ## because otherwise would have to resize, and there's not really room for it...
    if(isFALSE(second_map)){
      map <- leaflet_map %>%
        removeControl(layerId = "barplot") %>% 
        addControl(p, position = "topright", layerId = "barplot")
    } else {
      map <- leaflet_map %>%
        removeControl(layerId = "barplot")
    }
  }

  return(map)
}

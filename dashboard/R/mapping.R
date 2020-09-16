library(sp)
library(dplyr)
library(readr)
library(leaflet)

add_map_datalayers <- function(goalmap, lyrs_latlon, lyrs_polygons, polylyrs_pals, 
                               dim = "score", year = assess_year){
  
  
  ## set up overlays menu in top corner
  goalmap <- goalmap %>% 
    addLayersControl(
      overlayGroups = c(names(lyrs_latlon), names(lyrs_polygons)),
      options = layersControlOptions(collapsed = TRUE)
    )
  
  
  ## lyrs_polygons ----
  ## will need to be given with corresponding color palettes
  for(lyr in names(lyrs_polygons)){
    
    ## case when lyrs_polygon are dataframes with region_ids
    ## (will add case where polygons dont align with bhi regions e.g. MPAs later)
    if("region_id" %in% names(lyrs_polygons[[lyr]])){
      
      ## if the lyrs have multiple years and/or dimensions, 
      ## will filter to match selected year and ohi dimension
      ## also rename to specify column to map data from
      if(all(c("dimension", "scen_year") %in% names(lyrs_polygons[[lyr]]))){
        filterlyr <- filter(lyrs_polygons[[lyr]], scen_year == year, dimension == dim)
      } else {
        filterlyr <- lyrs_polygons[[lyr]]
      }
      colnames(filterlyr) <- stringr::str_replace(
        names(filterlyr), 
        polylyrs_pals[[lyr]][["plotvar"]], 
        "Value"
      )
      ## spatialdataframes with sp package, rather than sf...
      spatiallyr <- rgns_shp
      spatiallyr@data <- left_join(spatiallyr@data, filterlyr, by = "region_id")
      
      ## make color palette function for the additional data layer
      lyrpal <- leaflet::colorNumeric(
        palette = polylyrs_pals[[lyr]][["cols"]],
        domain = polylyrs_pals[[lyr]][["paldomain"]],
        na.color = thm$cols$map_background1
      )
      
      ## add the layers to the map!
      goalmap <- goalmap %>%
        addPolygons(
          group = lyr,
          stroke = TRUE, 
          opacity = 0.5, 
          weight = 2, 
          fillOpacity = 1, 
          smoothFactor = 0.5,
          color = thm$cols$map_polygon_border1, 
          fillColor = ~lyrpal(Value),
          data = spatiallyr
        ) %>% 
        addLegend(
          group = lyr,
          pal = lyrpal, 
          values = ~Value, 
          opacity = 1, 
          data = spatiallyr
        )
    }
  }
  
  ## lyrs_latlon ----
  ## will all be single color with transparency
  for(lyr in names(lyrs_latlon)){
    
    ## if the lyrs have multiple years and/or dimensions, 
    ## will filter to match selected year and ohi dimension
    if(all(c("dimension", "scen_year") %in% names(lyrs_latlon[[lyr]]))){
      filterlyr <- filter(lyrs_latlon[[lyr]], scen_year == year, dimension == dim)
    } else {
      filterlyr <- lyrs_latlon[[lyr]]
    }
    
    goalmap <- goalmap %>%
      addCircleMarkers(
        group = lyr,
        data = filterlyr, 
        fillColor = "midnightblue", 
        fillOpacity = 0.5,
        opacity = 0,
        radius = 4
      )
  }
  goalmap <- goalmap %>% 
    hideGroup(c(names(lyrs_latlon), names(lyrs_polygons)))
  
  
  return(goalmap)
}

#' create leaflet maps
#'
#' @param goal_code the two or three letter code indicating which goal/subgoal to create the plot for
#' @param mapping_data_sp  sf object associating scores with spatial polygons,
#' i.e. having goal score and geometries information
#' @param basins_or_rgns one of 'subbasins' or 'regions' to indicate which spatial units should be represented
#' @param scores_csv scores dataframe with goal, dimension, region_id, year and score columns,
#' e.g. output of ohicore::CalculateAll typically from calculate_scores.R
#' @param dim the dimension the object/plot should represent,
#' typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure'
#' @param year the scenario year to filter the data to, by default the current assessment year
#' @param legend_title text to be used as the legend title
#'
#' @return leaflet map with BHI goal scores by BHI region or Subbasins
leaflet_map <- function(full_scores_lst, basins_or_rgns = "subbasins",
                        goal_code = "Index", dim = "score", year = assess_year,
                        legend_title){
  
  ## wrangle data for plotting ----
  if(basins_or_rgns == "subbasins"){
    leaflet_plotting_sf <- make_subbasin_sf(
      subbasins_shp = read_rds(file.path(dir_main, "data", "subbasins.rds")), 
      scores_lst = full_scores_lst, 
      goal_code,
      dim, 
      year
    )
  } else {
    leaflet_plotting_sf <- make_rgn_sf(
      bhi_rgns_shp = read_rds(file.path(dir_main, "data", "regions.rds")), 
      scores_lst = full_scores_lst, 
      goal_code,
      dim, 
      year
    )
  }
  
  ## theme and map setup ----
  if(dim == "trend"){paldomain = c(-1, 1)} else {paldomain = c(0, 100)}
  thm <- apply_bhi_theme()
  
  ## create asymmetric color ranges for legend
  # colours = c("#8c031a", "#cc0033", "#fff78a", "#f6ffb3", "#009999", "#0278a7"),
  # values = c(0, 0.15, 0.4, 0.6, 0.8, 0.95, 1),
  
  rc1 <- colorRampPalette(colors = c("#8c031a", "#cc0033"), space = "Lab")(25)
  rc2 <- colorRampPalette(colors = c("#cc0033", "#fff78a"), space = "Lab")(20)
  rc3 <- colorRampPalette(colors = c("#fff78a", "#f6ffb3"), space = "Lab")(20)
  rc4 <- colorRampPalette(colors = c("#f6ffb3", "#009999"), space = "Lab")(15)
  rc5 <- colorRampPalette(colors = c("#009999", "#457da1"), space = "Lab")(5)
  
  pal <- leaflet::colorNumeric(
    palette = c(rc1, rc2, rc3, rc4, rc5),
    domain = paldomain,
    na.color = thm$cols$map_background1
  )
  
  ## create leaflet map ----
  map <- leaflet::leaflet(data = leaflet_plotting_sf) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    setView(18, 59, zoom = 5) %>%
    addLegend(
      "bottomright", 
      pal = pal, 
      values = c(paldomain[1]:paldomain[2]),
      title = legend_title, 
      opacity = 0.8, 
      layerId = "colorLegend"
    ) %>%
    addPolygons(
      layerId = ~Name,
      stroke = TRUE, 
      opacity = 0.5, 
      weight = 2, 
      fillOpacity = 0.6, 
      smoothFactor = 0.5,
      color = thm$cols$map_polygon_border1, 
      fillColor = ~pal(score)
    )
  
  ## return list result with dataframe too ----
  leaflet_fun_result <- list(
    map = map,
    data_sf = leaflet_plotting_sf@data
  )
  
  return(leaflet_fun_result)
}

#' make sf obj with subbasin-aggregated goal scores
#'
#' @param subbasins_shp a shapefile read into R as a sf (simple features) object;
#' must have an attribute column with subbasin full names
#' @param scores_csv scores dataframe with goal, dimension, region_id, year and score columns,
#' e.g. output of ohicore::CalculateAll typically from calculate_scores.R
#' @param dim the dimension the object/plot should represent,
#' typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure'
#' @param year the scenario year to filter the data to, by default the current assessment yearr
#'
#' @return sf obj with subbasin-aggregated goal scores

make_subbasin_sf <- function(subbasins_shp, scores_lst, goal_code = "Index", dim = "score", year = assess_year){
  
  ## wrangle/reshape and join with spatial info to make sf for plotting
  mapping_data <- left_join(
    rename(subbasins_df, Name = subbasin, region_id = subbasin_id),
    scores_lst[[goal_code]][[dim]][[as.character(year)]],
    by = "region_id"
  )
  ## join with spatial information from subbasin shapfile
  ## spatialdataframes with sp package, rather than sf...
  subbasins_shp_tab <- subbasins_shp@data %>% 
    dplyr::mutate(Name = as.character(Name)) %>%
    dplyr::mutate(Name = ifelse(
      Name == "Åland Sea",
      "Aland Sea", Name)
    ) %>%
    dplyr::left_join(mapping_data, by = "Name")
  subbasins_shp@data <- subbasins_shp_tab
  
  return(subbasins_shp)
}

#' make bhi-regiomns sf obj joined with goal scores
#'
#' @param bhi_rgns_shp a shapefile of the BHI regions, as a sf (simple features) object
#' @param scores_csv scores dataframe with goal, dimension, region_id, year and score columns,
#' e.g. output of ohicore::CalculateAll typically from calculate_scores.R
#' @param dim the dimension the object/plot should represent,
#' typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure'
#' @param year the scenario year to filter the data to, by default the current assessment yearr
#'
#' @return bhi-regions sf obj joined with goal scores

make_rgn_sf <- function(bhi_rgns_shp, scores_lst, goal_code = "Index", dim = "score", year = assess_year){
  
  ## wrangle/reshape and join with spatial info to make sf for plotting
  mapping_data <- left_join(
    rename(regions_df, Name = region_name),
    scores_lst[[goal_code]][[dim]][[as.character(year)]],
    by = "region_id"
  )
  ## join with spatial information from subbasin shapfile
  ## spatialdataframes with sp package, rather than sf...
  bhi_rgns_shp_tab <- bhi_rgns_shp@data %>% 
    dplyr::mutate(Name = sprintf("%s, %s", Subbasin, rgn_nam)) %>%
    dplyr::left_join(mapping_data, by = "Name")
  bhi_rgns_shp@data <- bhi_rgns_shp_tab
  
  return(bhi_rgns_shp)
}

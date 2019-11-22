library(sp)
library(rgdal)
library(dplyr)
library(readr)
library(leaflet)

#' create leaflet map
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
leaflet_map <- function(goal_code, mapping_data_sp, basins_or_rgns = "subbasins",
                        scores_csv = NULL, dim = "score", year = assess_year,
                        legend_title){
  
  ## check and wrangle for plotting ----
  bhi_goals <- full_scores_csv$goal %>% unique()
  if(length(goal_code) > 1|!goal_code %in% bhi_goals){
    stop(sprintf("goal must be one of: %s", paste(bhi_goals, collapse = ", ")))
  }
  
  if(dim != "score" | unique(mapping_data_sp@data$year) != year){
    mapping_data_sp@data <- dplyr::select(mapping_data_sp@data, -bhi_goals, -year, -dimension)
    
    if(basins_or_rgns == "subbasins"){
      mapping_data_sp <- make_subbasin_sf(
        subbasins_shp = mapping_data_sp, 
        scores_csv, 
        dim, 
        year
      )
    } else {
      mapping_data_sp <- make_rgn_sf(
        bhi_rgns_shp = mapping_data_sp, 
        scores_csv, 
        dim, 
        year
      )
    }
  } else {
    if(basins_or_rgns == "subbasins" & any(c("BHI_ID", "region_id") %in% names(mapping_data_sp@data))){
      stop("BHI regions spatial data given where Subbasin data is expected")
    }
  }
  mapping_data_sp@data <- dplyr::rename(mapping_data_sp@data, score = goal_code)
  leaflet_plotting_sf <- mapping_data_sp
  
  ## theme and map setup ----
  thm <- apply_bhi_theme()
  
  ## create asymmetric color ranges for legend
  rc1 <- colorRampPalette(
    colors = thm$palettes$divergent_red_blue[1:2],
    space = "Lab")(15)
  rc2 <- colorRampPalette(
    colors = thm$palettes$divergent_red_blue[2:3],
    space = "Lab")(25)
  rc3 <- colorRampPalette(
    colors = thm$palettes$divergent_red_blue[3:4],
    space = "Lab")(20)
  rc4 <- colorRampPalette(
    colors = thm$palettes$divergent_red_blue[4:5],
    space = "Lab")(15)
  rc5 <- colorRampPalette(
    colors = thm$palettes$divergent_red_blue[5:6],
    space = "Lab")(25)
  
  pal <- leaflet::colorNumeric(
    palette = c(rc1, rc2, rc3, rc4, rc5),
    domain = c(0, 100),
    na.color = thm$cols$map_background1
  )
  
  ## create leaflet map ----
  map <- leaflet::leaflet(data = leaflet_plotting_sf) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    setView(18, 59, zoom = 5) %>%
    addLegend(
      "bottomright", 
      pal = pal, 
      values = c(0:100),
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

make_subbasin_sf <- function(subbasins_shp, scores_csv, dim = "score", year = assess_year){
  
  ## raster::select conflict w dplyr...
  if("raster" %in% (.packages())){
    detach("package:raster",  unload = TRUE)
    library(tidyverse)
  }
  if("year" %in% colnames(scores_csv)){
    scores_csv <- scores_csv %>%
      dplyr::filter(year == year) %>%
      select(-year)
  } else {
    message("no year column in given scores_csv, assuming it has been properly filtered by year")
  }
  
  subbasin_data <- scores_csv %>%
    dplyr::filter(region_id >= 500) %>%
    dplyr::left_join(
      readr::read_csv(here("data", "basins.csv")) %>%
        select(region_id = subbasin_id, subbasin, area_km2),
      by = "region_id"
    ) %>%
    dplyr::filter(!is.na(subbasin))
  
  ## filter and spread data by goal
  mapping_data <- subbasin_data %>%
    dplyr::filter(dimension == dim) %>%
    dplyr::select(score, goal, Name = subbasin) %>%
    tidyr::spread(key = goal, value = score) %>%
    dplyr::filter(!is.na(Name)) %>%
    dplyr::mutate(dimension = dim, year = year)
 
  ## join with spatial information from subbasin shapfile
  # mapping_data_sp <- subbasins_shp %>%
  #   dplyr::mutate(Name = as.character(Name)) %>%
  #   dplyr::mutate(Name = ifelse(
  #     Name == "Åland Sea",
  #     "Aland Sea", Name)
  #   ) %>%
  #   dplyr::left_join(mapping_data, by = "Name") %>%
  #   sf::st_transform(crs = 4326)
  
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
  ## subbasins_shp@proj4string is initially epsg 3035, need epsg 4326 crs for mapping
  mapping_data_sp <- spTransform(subbasins_shp, CRS("+init=epsg:4326"))
  
  return(mapping_data_sp)
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

make_rgn_sf <- function(bhi_rgns_shp, scores_csv, dim = "score", year = assess_year){
  
  rgn_lookup <- readr::read_csv(here("data", "regions.csv")) %>%
    select(region_id, Name = region_name)
  
  if("year" %in% colnames(scores_csv)){
    scores_csv <- scores_csv %>%
      dplyr::filter(year == year) %>%
      select(-year)
  } else {
    message("no year column in given scores_csv, assuming it has been properly filtered by year")
  }
  
  ## wrangle/reshape and join with spatial info to make sf for plotting
  mapping_data <- scores_csv %>%
    dplyr::filter(dimension == dim, region_id %in% rgn_lookup$region_id) %>%
    dplyr::left_join(rgn_lookup, by = "region_id") %>%
    dplyr::select(-dimension) %>%
    tidyr::spread(key = goal, value = score) %>%
    dplyr::mutate(dimension = dim, year = year)
  
  ## join with spatial information from subbasin shapfile
  # mapping_data_sp <- bhi_rgns_shp %>%
  #   dplyr::mutate(Name = sprintf("%s, %s", Subbasin, rgn_nam)) %>%
  #   dplyr::left_join(mapping_data, by = "Name")
  
  ## join with spatial information from subbasin shapfile
  ## spatialdataframes with sp package, rather than sf...
  bhi_rgns_shp_tab <- bhi_rgns_shp@data %>% 
    dplyr::mutate(Name = sprintf("%s, %s", Subbasin, rgn_nam)) %>%
    dplyr::left_join(mapping_data, by = "Name")
  bhi_rgns_shp@data <- bhi_rgns_shp_tab
  mapping_data_sp <- bhi_rgns_shp
  
  return(mapping_data_sp)
}

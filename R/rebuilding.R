library(httr)
library(magrittr)
library(stringr)
library(here)
library(readr)
library(dplyr)


#' list all layers in bhi prep repository
#'
#' @param gh_api_bhiprep raw.githubusercontent url directing to bhi prep github repository
#'
#' @return list of scenario layers files found in the bhi prep repository

list_prep_layers <- function(gh_api_bhiprep){
  req <- httr::GET(gh_api_bhiprep)
  httr::stop_for_status(req)
  
  filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = FALSE) %>% 
    grep(pattern = "/layers/", value = TRUE) %>% 
    stringr::str_extract("/[a-zA-Z0-9_-]+.csv|/[a-zA-Z0-9_-]+$") %>% 
    stringr::str_remove_all(".csv") %>% 
    stringr::str_remove_all("/")
  
  return(filelist)
}

#' download layers from bhi prep repository and bind into one table
#'
#' @param gh_raw_bhiprep raw.githubusercontent url directing to bhi prep github repository
#' @param layers names of files in layers folder to download, without .csv extension
#' @param default_year value to assign as the year where layer have no year column
#'
#' @return merged layer datatable

get_layers <- function(gh_raw_bhiprep, layers, default_year){
  ## create data folder if needed
  if(!file.exists(here::here("data"))){dir.create(here::here("data"))}
  
  ## initialize dataframe for all layers
  all_lyrs_df <- data.frame(
    year = double(), 
    region_id = double(), 
    category = character(), 
    layer = character(), 
    value = numeric()
  )
  ## download and reformat data layers
  for(lyr in layers){
    lyr_df <- readr::read_csv(paste0(gh_raw_bhiprep, "layers/", unlist(lyr),  ".csv")) %>% 
      dplyr::mutate(layer = unlist(lyr))
    
    if(1 %in% dim(lyr_df)){
      message(sprintf("excluding layer %s, insufficient rows of data", unlist(lyr)))
    } else {
      
      ## generally reshape columns into a consistent format...
      if(!"year" %in% names(lyr_df)){
        lyr_df <- dplyr::mutate(lyr_df, year = default_year)
      }
      if(any(str_detect(names(lyr_df), "pressure"))){
        lyr_df <- dplyr::mutate(lyr_df, category = "pressure")
      }
      if(any(str_detect(names(lyr_df), "resilience"))){
        lyr_df <- dplyr::mutate(lyr_df, category = "resilience")
      }
      if(any(str_detect(names(lyr_df), "trend"))){
        lyr_df <- dplyr::mutate(lyr_df, category = "trend")
      }
      if(any(str_detect(names(lyr_df), "score")) & !any(str_detect(names(lyr_df), "dimension"))){
        lyr_df <- dplyr::mutate(lyr_df, category = "score")
      }
      if("dimension" %in% names(lyr_df)){
        lyr_df <- dplyr::rename(lyr_df, category = dimension)
      }
      colnames(lyr_df) <- gsub("::score$", "value", colnames(lyr_df))
      colnames(lyr_df) <- gsub("score$", "value", colnames(lyr_df))
      
      ## ugh why are there such random column names
      ## if missing value columns still
      ## if after all this there are columns other than region_id, year, category...
      matchcols <- c("rgn_id", "year", "value", "category", "layer")
      extracol <- setdiff(names(lyr_df), matchcols)
      
      if(!"value" %in% names(lyr_df) & length(extracol) == 1){
        if(class(dplyr::select(lyr_df, !!sym(extracol))[[1]]) == "numeric"){
          lyr_df <- dplyr::rename(lyr_df, value = !!sym(extracol))
        }
      }
      ## row bind to complete layers dataframe
      ## unless there are still undetermined columns, in which case just exclude the file from the table...
      if(all(names(lyr_df) %in% matchcols) & all(matchcols %in% names(lyr_df))){
        all_lyrs_df <- rbind(
          all_lyrs_df, 
          dplyr::select(lyr_df, year, region_id = rgn_id, category, layer, value)
        )
      }
    }
  }
  ## to download all individual files to data folder...
  # lapply(
  #   paste0(layers, ".csv"),
  #   function(x){
  #     read_csv(paste0(gh_raw_bhiprep, "layers/", unlist(x))) %>% 
  #       write_csv(here("data", unlist(x)))
  #   }
  # )
  return(all_lyrs_df)
}

#' extract from functions.R layers associated with a specific goal function
#'
#' @param functionsR_path location of functions.R to extract goal from
#' @param goal_code the two or three letter code indicating the goal or subgoal
#'
#' @return character vector naming layers

#' list functions.R goals
#'
#' @param functionsR_path location of functions.R to extract goal from
#' @param functionsR_text list of funcitons.R lines read eg using scan (if functionsR_path is not provided)
#'
#' @return goal codes character vector for goals having functions defined in functions.R

goal_layers <- function(gh_raw_bhi, scenario_folder, goal_code = "all"){
  
  functions_txt <- readLines(paste0(gh_raw_bhi, scenario_folder, "/conf/functions.R"))
  
  breaks_str <- "^[A-Z]{2,3}\\s<-\\sfunction\\(|^[A-Z]{2,3}\\s=\\sfunction\\("
  funs_goals <- stringr::str_extract(grep(breaks_str, functions_txt, value = TRUE), "^[A-Z]{2,3}")
  funs_breaks <- grep(breaks_str, functions_txt)
  
  goal_code <- stringr::str_to_upper(goal_code) %>% unlist()
  if(goal_code != "ALL" & any(!goal_code %in% funs_goals)){
    print("note: no function for some of the given goals")
  }
  if(stringr::str_to_upper(goal_code) == "ALL"){
    txt <- grep(pattern = "\\s*#{1,}.*", functions_txt, value = TRUE, invert = TRUE)
  } else {
    
    txt <- vector()
    for(gc in goal_code){
      
      fun_start <- grep(pattern = sprintf("^%s\\s<-\\sfunction\\(|^%s\\s=\\sfunction\\(", gc, gc), functions_txt)
      fun_end <- funs_breaks[1 + which.min(abs(fun_start - funs_breaks))] - 1
      
      goal_fun <- functions_txt[fun_start:fun_end] %>% 
        grep(pattern = "\\s*#{1,}.*", value = TRUE, invert = TRUE)
      txt <- c(txt, goal_fun)
    }
  }
  
  ## extract names of layers specified in functions.R (i.e. which do functions.R require)
  functionsR_layers <- txt %>%
    gsub(pattern = "layer_nm\\s{1,}=\\s{1,}", replacement = "layer_nm=") %>%
    # gsub(pattern = "", replacement = "layer_nm=") %>% # to catch pressure + resilience layers given with a different pattern
    stringr::str_split(" ") %>%
    unlist() %>%
    stringr::str_subset("layer_nm.*") %>% # pattern to ID layer fed into a function within fuctions.R
    stringr::str_extract("\"[a-z0-9_]*\"|\'[a-z0-9_]*\'") %>%
    stringr::str_sort() %>%
    stringr::str_remove_all("\"|\'") # remove any quotation marks around
  
  return(functionsR_layers)
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
    dplyr::collect() %>%
    dplyr::left_join(
      readr::read_csv(here("data", "basins.csv")) %>%
        select(region_id = subbasin_id, subbasin, area_km2) %>%
        collect(),
      by = "region_id"
    ) %>%
    dplyr::filter(!is.na(subbasin))
  
  ## filter and spread data by goal
  mapping_data <- subbasin_data %>%
    dplyr::filter(dimension == dim) %>%
    dplyr::select(score, goal, Name = subbasin) %>%
    tidyr::spread(key = goal, value = score) %>%
    dplyr::filter(!is.na(Name)) %>%
    dplyr::mutate(dimension = dim)
  
  ## simplify the polygons for plotting
  subbasins_shp <- rmapshaper::ms_simplify(input = subbasins_shp) %>%
    sf::st_as_sf()
  
  ## join with spatial information from subbasin shapfile
  mapping_data_sp <- subbasins_shp %>%
    dplyr::mutate(Name = as.character(Name)) %>%
    dplyr::mutate(Name = ifelse(
      Name == "Åland Sea",
      "Aland Sea", Name)
    ) %>%
    dplyr::left_join(mapping_data, by = "Name") %>%
    sf::st_transform(crs = 4326)
  
  return(mapping_data_sp)
}

#' make bhi-regiomns sf obj joined with goal scores
#'
#' @param bhi_rgns_shp a shapefile of the BHI regions, as a sf (simple features) object
#' @param scores_csv scores dataframe with goal, dimension, region_id, year and score columns,
#' e.g. output of ohicore::CalculateAll typically from calculate_scores.R
#' @param goal_code the two or three letter code indicating which goal/subgoal to create the plot for
#' @param dim the dimension the object/plot should represent,
#' typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure'
#' @param year the scenario year to filter the data to, by default the current assessment yearr
#' @param simplify_level number of times rmapshaper::ms_simplify function should be used on the shapefile,
#' to simplify polygons for display
#'
#' @return bhi-regions sf obj joined with goal scores

make_rgn_sf <- function(bhi_rgns_shp, scores_csv, dim = "score", year = assess_year){
  
  # bhi_rgns_shp <- sf::st_read("/Volumes/BHI_share/Shapefiles/BHI_shapefile", "BHI_shapefile") %>%
  #   dplyr::mutate(Subbasin = as.character(Subbasin)) %>%
  #   dplyr::mutate(Subbasin = ifelse(Subbasin == "Bothian Sea", "Bothnian Sea", Subbasin)) # NEED TO FIX THIS TYPO!!!!!!!!
  
  rgn_lookup <- readr:.read_csv(here("data", "regions")) %>%
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
    dplyr::mutate(dimension = dim)
 
  ## simplify the polygons for plotting
  bhi_rgns_shp <- rmapshaper::ms_simplify(input = bhi_rgns_shp) %>%
    sf::st_as_sf()
  
  ## join with spatial information from subbasin shapfile
  mapping_data_sp <- bhi_rgns_shp %>%
    dplyr::mutate(Name = sprintf("%s, %s", Subbasin, rgn_nam)) %>%
    dplyr::left_join(mapping_data, by = "Name")
  
  return(mapping_data_sp)
}

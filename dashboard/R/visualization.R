library(dplyr)
library(ggplot2)
library(plotly)
library(httr)
library(stringr)

#' read layers from bhi prep repository and bind into one table
#'
#' @param gh_raw_bhiprep raw.githubusercontent url directing to bhi prep github repository
#' @param layers names of files in layers folder to download, without .csv extension
#' @param default_year value to assign as the year where layer have no year column
#'
#' @return merged layer datatable

get_layers_data <- function(gh_raw_bhiprep, layers, default_year){
  ## create data folder if needed
  if(!file.exists(file.path(dir_main, "data"))){
    dir.create(file.path(dir_main, "data"))
  }
  
  ## initialize dataframe for all layers
  all_lyrs_df <- data.frame(
    year = double(), 
    region_id = double(), 
    category = character(), 
    layer = character(), 
    value = numeric()
  )
  matchcols <- c("region_id", "year", "value", "category", "layer")
  
  ## download and reformat data layers
  for(lyr in layers){
    lyr_df <- readr::read_csv(paste0(gh_raw_bhiprep, "layers/", unlist(lyr),  ".csv"), col_types = cols()) %>% 
      dplyr::mutate(layer = unlist(lyr))
    
    if(any(1:2 %in% dim(lyr_df))){
      message(sprintf("excluding layer %s, insufficient rows of data", unlist(lyr)))
    } else {
      
      ## reshape columns into a consistent format...
      if(!"year" %in% names(lyr_df)){
        lyr_df <- dplyr::mutate(lyr_df, year = default_year)
      }
      if("dimension" %in% names(lyr_df)){
        lyr_df <- dplyr::rename(lyr_df, category = dimension)
      } else if(any(str_detect(names(lyr_df), "pressure")) | str_detect(lyr, "pressure")){
        lyr_df <- dplyr::mutate(lyr_df, category = "pressure")
      } else if(any(str_detect(names(lyr_df), "resilience")) | str_detect(lyr, "resilience")){
        lyr_df <- dplyr::mutate(lyr_df, category = "resilience")
      } else if(any(str_detect(names(lyr_df), "trend")) | str_detect(lyr, "trend")){
        lyr_df <- dplyr::mutate(lyr_df, category = "trend")
      } else {
        lyr_df <- dplyr::mutate(lyr_df, category = "status")
      }
      colnames(lyr_df) <- gsub("::score$", "value", colnames(lyr_df))
      colnames(lyr_df) <- gsub("score$", "value", colnames(lyr_df))
      
      ## ugh why are there such random column names
      ## if missing value columns still
      ## if after all this there are columns other than region_id, year, category...
      extracol <- setdiff(names(lyr_df), matchcols)
      
      if(!"value" %in% names(lyr_df) & length(extracol) == 1){
        if(class(dplyr::select(lyr_df, !!sym(extracol))[[1]]) == "numeric"){
          lyr_df <- dplyr::rename(lyr_df, value = !!sym(extracol))
        }
      } else if("value" %in% names(lyr_df) & length(extracol) == 1){
        ## have value column already, so extra column must be a categorical variable...
        if(class(dplyr::select(lyr_df, !!sym(extracol))[[1]]) %in% c("character", "factor")){
          lyr_df <- lyr_df %>% 
            dplyr::mutate(category = paste(ifelse(
              !"category" %in% names(lyr_df), "score", category),
              !!sym(extracol), 
              sep = ", ")
            ) %>% 
            dplyr::select(-!!sym(extracol))
        }
      } else if(!"value" %in% names(lyr_df) & length(extracol) == 2){
        ## if two cols left over, assume one with more unique vals is score and other is a categorical var
        if(length(unique(lyr_df[[sym(extracol[1])]])) > length(unique(lyr_df[[sym(extracol[2])]]))){
          
          lyr_df <- lyr_df %>% 
            dplyr::mutate(category = paste(ifelse(
              !"category" %in% names(lyr_df), "score", category),
              !!sym(extracol[2]), 
              sep = ", ")
            ) %>% 
            dplyr::select(-!!sym(extracol[2])) %>% 
            dplyr::rename(value = !!sym(extracol[1]))
          
        } else {
          lyr_df <- lyr_df %>% 
            dplyr::mutate(category = paste(ifelse(
              !"category" %in% names(lyr_df), "score", category),
              !!sym(extracol[1]), 
              sep = ", ")
            ) %>% 
            dplyr::select(-!!sym(extracol[1])) %>% 
            dplyr::rename(value = !!sym(extracol[2]))
        }
      }
      ## row bind to complete layers dataframe
      ## unless there are still undetermined columns, in which case just exclude the file from the table...
      if(all(names(lyr_df) %in% matchcols) & all(matchcols %in% names(lyr_df))){
        all_lyrs_df <- rbind(
          all_lyrs_df, 
          dplyr::select(lyr_df, year, region_id, category, layer, value)
        )
        message(sprintf("successfully added layer %s to merged layers_data table", lyr))
      } else {message(sprintf("excluding layer %s because of column names mismatch...", lyr))}
    }
  }
  
  return(all_lyrs_df)
}

#' create barplot to accompany maps
#'
#' create a barplot with subbasin scores, arranged vertically approximately north-to-south
#' intended to present side-by-side with map, to show distances from reference points/room for improvement
#'
#' e.g. output of ohicore::CalculateAll typically from calculate_scores.R
#' @param scores_csv scores dataframe e.g. output of ohicore::CalculateAll
#' @param basins_or_rgns one of 'subbasins' or 'regions' to indicate which spatial units should be represented
#' @param goal_code the two or three letter code indicating which goal/subgoal to create the plot for
#' @param dim the dimension the barplot should represent (typically OHI 'score')
#' @param uniform_width if TRUE all subbasin bars will be the same width, otherwise a function of area
#'
#' @return returns ggplot or html plotly widget if 'make_html' arg is true

scores_barplot <- function(scores_csv, basins_or_rgns = "subbasins", 
                           goal_code = "Index", dim = "score", year = assess_year, 
                           uniform_width = FALSE){
  
  
  ## plotting setup, width of bars ----
  ## use uniform_width argument to define whether bars are uniform or scaled by a function of area...
  if(basins_or_rgns == "subbasins"){
    areas_df <- subbasins_df %>% 
      dplyr::select(name = subbasin, area_km2)
  } else {
    areas_df <- regions_df %>% 
      dplyr::select(name = region_id, area_km2)
  }
  
  if(uniform_width){
    weights <- areas_df %>%
      dplyr::mutate(weight = 1) %>%
      dplyr::select(-area_km2)
  } else {
    weights <- areas_df %>%
      ## scaling proportional to area results in some very thin bars
      ## can try different functions...
      dplyr::mutate(area_rescale = (area_km2-min(areas_df$area_km2))/diff(range(areas_df$area_km2)) + 1) %>%
      dplyr::mutate(weight = log(area_rescale) + 0.1) %>% # mutate(weight = area_km2 or area_km2^0.6)...
      dplyr::select(-area_rescale)
  }


  ## wrangle scores to create plotting dataframe ----
  ## which regions to plot, bhi or subbasins
  if(basins_or_rgns == "subbasins"){
    
    order_df <- subbasins_df %>%
      dplyr::select(name = subbasin, order) %>%
      dplyr::mutate(order = as.factor(order))
    
    plot_df <- full_scores_lst[[goal_code]][[dim]][[as.character(year)]] %>%
      dplyr::filter(region_id %in% unique(subbasins_df$subbasin_id)) %>% 
      dplyr::left_join(
        subbasins_df, 
        by = c("region_id" = "subbasin_id")
      ) %>% 
      dplyr::select(name = subbasin, score) %>%
      dplyr::left_join(weights, by = "name") %>%
      dplyr::left_join(order_df, by = "name") %>%
      dplyr::mutate(
        Name = name,
        score_unrounded = score,
        Score = round(score, 2),
        Area = paste(round(area_km2), "km2")
      )
  } else {
    
    order_df <- regions_df %>%
      dplyr::select(name = region_id, order) %>%
      dplyr::mutate(order = as.factor(order))
    
    plot_df <- full_scores_lst[[goal_code]][[dim]][[as.character(year)]] %>%
      dplyr::filter(region_id %in% unique(regions_df$region_id)) %>% 
      dplyr::left_join(regions_df, by = "region_id") %>% 
      dplyr::select(name = region_id, region_name, score) %>%
      dplyr::left_join(weights, by = "name") %>%
      dplyr::left_join(order_df, by = "name") %>%
      dplyr::mutate(
        Name = as.factor(region_name),
        score_unrounded = score,
        Score = round(score, 2),
        Area = paste(round(area_km2), "km2")
      )
  }
  plot_df <- plot_df %>%
    dplyr::arrange(order) %>%
    dplyr::mutate(pos = sum(weight) - (cumsum(weight) - 0.5 * weight)) %>%
    dplyr::mutate(pos_end = sum(weight)) %>%
    dplyr::mutate(plotNAs = ifelse(is.na(score_unrounded), 100, NA))
  
  
  ## create plot ----
  plot_obj <- ggplot(
    data = plot_df,
    aes(
      x = pos, y = score_unrounded,
      text =  sprintf("%s:\n%s", gsub(pattern = ", ", replacement = "\n", Name), Score),
      width = weight, fill = score_unrounded
    )
  )
  
  plot_obj <- plot_obj +
    geom_col(
      aes(y = ifelse(dim == "trend", 1, 100)),
      # stat = "identity",
      size = 0.2,
      color = "#acb9b6",
      alpha = 0,
      fill = NA,
      show.legend = FALSE
    ) +
    geom_col(
      aes(y = ifelse(dim == "trend", -1, 0)),
      # stat = "identity",
      size = 0.2,
      color = "#acb9b6",
      alpha = 0,
      fill = NA,
      show.legend = FALSE
    ) +
    geom_col(
      # stat = "identity",
      size = 0.2,
      color = "#acb9b6",
      alpha = 0.8,
      show.legend = FALSE
    ) +
    scale_fill_gradientn(
      colours = c("#8c031a", "#cc0033", "#fff78a", "#f6ffb3", "#009999", "#0278a7"),
      values = c(0, 0.15, 0.4, 0.6, 0.75, 0.9, 1),
      # breaks = c(15, 40, 60, 75, 90, 100),
      limits = c(ifelse(dim == "trend", -1, 0), ifelse(dim == "trend", 1, 101)),
      na.value = "black"
    ) +
    scale_y_continuous(limits = c(ifelse(dim == "trend", -1.1, 0), ifelse(dim == "trend", 1.1, 101)))
  
  ## overlay light grey for NAs
  if(any(!is.na(plot_df$plotNAs))){
    plot_obj <- plot_obj +
      geom_bar(
        aes(y = plotNAs),
        stat = "identity",
        size = 0.2,
        color = "#acb9b6",
        fill = "#fcfcfd"
      )
  }
  ## some formatting
  plot_obj <- plot_obj +
    geom_hline(data = NULL, aes(yintercept = ifelse(dim == "trend", 1, 100)), color = "royalblue", size = 0.8) +
    geom_hline(data = NULL, aes(yintercept = ifelse(dim == "trend", -1, 0)), color = "darkred", size = 0.2) +
    labs(x = NULL, y = NULL) +
    coord_flip() +
    theme(axis.text.y = element_blank())
  
  
  plot_obj <- plotly::ggplotly(plot_obj, tooltip = "text")
  
  return(invisible(plot_obj))
}

#' @param basins_or_rgns one of 'subbasins' or 'regions' to indicate which spatial units should be represented
#' @param rgns vector of bhi region ids by which to filter scores data and for which to create flowerplots
#' @param goal_code the two or three letter code indicating which goal/subgoal to create the plot for
#'
#' @return returns ggplot or html plotly widget if 'make_html' arg is true

ohi_dims_figure <- function(goal_code, rgn_selected = 0, year = assess_year){
  
  ## plotting dataframes ----

  ## the dimensions data, positions
  plotdf <- full_scores_csv %>% 
    dplyr::filter(goal == goal_code, region_id == rgn_selected, year == assess_year, dimension != "score") %>% 
    tidyr::pivot_wider(names_from = "dimension", values_from = "score") %>% 
    mutate(
      trend_prior = status, 
      trend_post = future, 
      status_current = status
    ) %>% 
    tidyr::pivot_longer(
      cols = c("status", "future"), 
      names_to = "dim", 
      values_to = "score"
    ) %>% 
    mutate(
      position = ifelse(dim == "status", 0, 1),
      position_shift = ifelse(dim == "status", -1.02, -0.02),
      trend_prior = ifelse(dim == "status", trend_prior-trend*100, trend_prior),
      trend_post = ifelse(dim == "status", score, trend_post),
      prs_prior = ifelse(dim == "status", status_current+pressures, status_current),
      res_prior = ifelse(dim == "status", status_current-resilience, status_current)
    ) %>% 
    mutate(
      prs = ifelse(pressures < 31, 0.01, (pressures-30)/70)*(-1),
      res = ifelse(resilience < 31, 0.01, (resilience-30)/70)
    ) %>% 
    select(-trend, -status_current, -dim) %>% 
    mutate(score = ifelse(position == 0, score, NA))
  
  ## for plot labeling
  txtdf <- plotdf %>%
    filter(position == 0) %>%
    select(resilience, pressures, score, res, prs) %>%
    tidyr::pivot_longer(cols = c("pressures", "resilience")) %>%
    mutate(
      xtxt = -0.5,
      ytxt = ifelse(name == "pressures", score + 15, score - 20),
      txtval = ifelse(name == "pressures", prs, res),
      # txt = sprintf("%s: %s", name, value)
      txt = sprintf("%s", name)
    )
  
  ## make plots ----
  dims_diagram <- ggplot(plotdf) +
    
    ## current and likely future status
    geom_col(
      aes(x = position, y = score), 
      width = 0.01, 
      fill = "#1d3548", 
      alpha = 0.8
    ) +
    geom_point(aes(x = position, y = score), size = 18, color = "paleturquoise",  alpha = 0.7) +
    geom_point(aes(x = position, y = score), size = 14, color = "navy", alpha = 0.3) +
    geom_point(aes(x = position, y = score), size = 12, color = "turquoise", alpha = 0.7) +
    geom_point(aes(x = position, y = score), size = 8, color = "paleturquoise",  alpha = 0.7) +
    geom_point(aes(x = position, y = score), size = 4, color = "white") +
    geom_hline(aes(yintercept = score), size = 0.2) +
    
    ## trend from past to present and to likely future
    geom_path(
      aes(x = position_shift, y = trend_prior, group = 1), 
      color = "dimgrey",  
      alpha = 0.9,
      linetype = 2,
      size = 0.3
    ) +
    geom_path(
      aes(x = position, y = trend_post, group = 1),
      color = "dimgrey",  
      alpha = 0.9,
      linetype = 2,
      size = 0.3,
      arrow = arrow(17, unit(0.5, "cm"), type = "closed")
    ) +
    
    ## pressures and resilience
    geom_path(
      aes(
        x = position_shift, 
        y = res_prior, 
        group = 1, 
        color = res
      ),
      arrow = arrow(17, unit(0.5, "cm"), type = "closed"),
      show.legend = FALSE
    ) +
    geom_path(
      aes(
        x = position_shift, 
        y = prs_prior, 
        group = 1, 
        color = prs
      ),
      arrow = arrow(17, unit(0.5, "cm"), type = "closed"),
      show.legend = FALSE
    ) +
    geom_text(
      data = txtdf, 
      aes(x = xtxt, y = ytxt, label = txt, color = txtval), 
      alpha = 0.8,
      size = 5,
      show.legend = FALSE
    ) +
    
    ## formatting and theme stuff ----
  labs(x = NULL, y = NULL) +
    coord_cartesian(ylim = c(5, 115), xlim = c(-0.8, 1.2)) +
    scale_y_continuous(breaks = seq(0, 100, 20)) +
    scale_color_gradient2(low = "#ff7e05", mid = "#cc618f", high = "#0e22a4") +
    theme_bw() +
    theme(
      panel.background = element_rect(fill = "#fafbf8"),
      axis.text.x = element_blank(), 
      axis.ticks.x = element_blank()
      
    )
  
  return(dims_diagram)
}

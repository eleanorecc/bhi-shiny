source(here::here("R", "theme.R"))
library(dplyr)
library(ggplot2)
library(plotly)

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

scores_barplot <- function(scores_csv, basins_or_rgns = "subbasins", goal_code = "Index", dim = "score", uniform_width = FALSE){
  
  ## apply bhi_theme, in this case the same as for flowerplot
  thm <- apply_bhi_theme(plot_type = "flowerplot")
  
  ## wrangle scores and join info to create plotting dataframe ----
  scores <- scores_csv
  if("dimension" %in% colnames(scores)){
    scores <- scores %>%
      dplyr::filter(dimension == dim) %>%
      dplyr::select(-dimension)
  }
  if("goal" %in% colnames(scores)){
    scores <- scores %>%
      dplyr::filter(goal == goal_code) %>%
      dplyr::select(-goal)
  }

  ## which regions to plot, bhi or subbasins
  if(basins_or_rgns == "subbasins"){
    
    order_df <- subbasins_df %>%
      dplyr::select(name = subbasin, order) %>%
      dplyr::mutate(order = as.factor(order))
    
    areas_df <- dplyr::select(subbasins_df, name = subbasin, area_km2)
    
    scores <- scores %>%
      dplyr::filter(region_id >= 500) %>%
      dplyr::left_join(
        dplyr::select(subbasins_df, region_id = subbasin_id, name = subbasin),
        by = "region_id"
      ) %>%
      dplyr::select(name, score)
    
  } else {
    order_df <- regions_df %>%
      dplyr::select(name = region_id, order) %>%
      dplyr::mutate(order = as.factor(order))
    
    areas_df <- dplyr::select(regions_df, name = region_id, area_km2)
    
    scores <- scores %>%
      dplyr::filter(region_id < 100 & region_id != 0) %>%
      dplyr::rename(name = region_id) %>%
      dplyr::left_join(
        dplyr::select(regions_df, name = region_id, region_name), 
        by = "name"
      )
  }
  
  ## use uniform_width argument to define whether bars are uniform or scaled by a function of area
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
  
  if(basins_or_rgns == "subbasins"){
    plot_df <- scores %>%
      dplyr::left_join(weights, by = "name") %>%
      dplyr::left_join(order_df, by = "name") %>%
      dplyr::mutate(
        Name = name,
        score_unrounded = score,
        Score = round(score, 2),
        Area = paste(round(area_km2), "km2")
      )
  } else {
    plot_df <- scores %>%
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
    dplyr::mutate(plotNAs = ifelse(is.na(score_unrounded), 100, NA)) %>% # for displaying NAs
    dplyr::select(
      order, Name, weight, Area,
      score_unrounded, Score,
      pos, pos_end, plotNAs
    )
  
  ## create plot ----
  plot_obj <- ggplot(
    plot_df,
    aes(
      x = pos, y = score_unrounded,
      text =  sprintf("%s:\n%s", str_replace(Name, ", ", "\n"), Score),
      # Name = Name, Score = Score, Area = Area,
      width = weight, fill = score_unrounded
    )
  ) +
    geom_bar(
      aes(y = 100),
      stat = "identity",
      size = 0.2,
      color = "#acb9b6",
      alpha = 0.6,
      fill = "white"
    ) +
    geom_bar(
      stat = "identity",
      size = 0.2,
      color = "#acb9b6",
      alpha = 0.8,
      show.legend = FALSE
    ) +
    scale_fill_gradientn(
      colours = c("#8c031a", "#cc0033", "#fff78a", "#f6ffb3", "#009999", "#0278a7"),
      breaks = c(15, 40, 60, 75, 90, 100),
      limits = c(0, 101),
      na.value = "black"
    )
  
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
    geom_hline(aes(yintercept = 100), color = thm$cols$dark_grey3) +
    geom_hline(aes(yintercept = 0), color = thm$cols$dark_grey3, size = 0.2) +
    labs(x = NULL, y = NULL) +
    coord_flip() +
    theme(axis.text.y = element_blank())
  
  plot_obj <- plotly::ggplotly(plot_obj, tooltip = "text")
  return(invisible(plot_obj))
}

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
      text =  sprintf("%s:\n%s", gsub(pattern = ", ", replacement = "\n", Name), Score),
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


#' @param scores_csv scores dataframe e.g. output of ohicore::CalculateAll
#' @param basins_or_rgns one of 'subbasins' or 'regions' to indicate which spatial units should be represented
#' @param rgns vector of bhi region ids by which to filter scores data and for which to create flowerplots
#' @param goal_code the two or three letter code indicating which goal/subgoal to create the plot for
#'
#' @return returns ggplot or html plotly widget if 'make_html' arg is true

future_dims <- function(scores_csv, basins_or_rgns = "subbasins", rgns = c(507, 508, 511), goal_code = "EUT"){
  
  if(basins_or_rgns == "subbasins" & !all(rgns %in% 501:517)){
    stop("the given regions args are not subbasin IDs")
  }

  ## wrangle for plotting
  plot_df <- scores_csv %>% 
    dplyr::mutate(score = ifelse(dimension == "trend", score*100, score)) %>% 
    dplyr::left_join(
      dplyr::select(regions_df, region_id, subbasin, area_km2, name = region_name),
      by = "region_id"
    ) %>% 
    rename(id_num = region_id)
  
  if(basins_or_rgns == "subbasins"){
    plot_df <- plot_df %>% 
      dplyr::select(-id_num) %>% 
      dplyr::left_join(
        dplyr::select(subbasins_df, subbasin, id_num = subbasin_id),
        by = "subbasin"
      ) %>% 
      dplyr::filter(id_num %in% rgns, goal %in% goal_codes) %>% 
      group_by(goal, dimension, subbasin, id_num) %>%
      summarise(basin_mean = weighted.mean(score, area_km2, na.rm = TRUE))
  }
   
  plot_df$dims_reordered <- factor(
    plot_df$dimension,
    levels = c("status", "future", "trend", "pressures", "resilience", "score")
  )
  
  ## color palette
  dims <- c("present state", "likely future", "trend", "pressures", "resilience", "status")
  dims_pal <- c("#a0bbd0e8", "#ead19cf0", "#de8b5fe8", "#b13a23db", "#63945ade", "#9483afed")
  
  dims_pal <- c("#78a6b0", "#dec887", "#d48c6e", "#b16868", "#80b078", "#a79bbb") # red #a95151 orange #ca7963
  
  ## make dimensions bar plot
  plot_obj <- ggplot(plot_df) + 
    geom_bar(
      aes(x = dims_reordered, y = basin_mean, fill = dims_reordered),
      stat = "identity",  
      position = "dodge",
      width = 0.5
    ) +
    # coord_cartesian(ylim = c(-70, 100)) +
    facet_grid(cols = vars(subbasin)) +
    guides(fill = guide_legend(nrow = 1)) +
    scale_fill_manual(
      values = dims_pal,
      labels = c(
        "Present Status", 
        "Likely Future Status",
        "Trend", 
        "Pressures", 
        "Resilience", 
        "Score"
      )
    ) +
    theme_light() +
    theme(
      axis.text.x = element_blank(),
      panel.border = element_rect(colour = "black", fill = NA),
      legend.direction = "horizontal",
      legend.position = c(0.3, 0.06),
      legend.background = element_rect(size = 0.6, colour = "grey"),
      axis.ticks.x = element_blank()
    ) +
    labs(fill = element_blank(), x = element_blank(), y = element_blank())
  
 return(plot_obj) 
}

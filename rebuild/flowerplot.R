source(file.path(dir_main, "R", "theme.R"))
library(ggplot2)
library(circlize)
library(magick)

#' create a BHI flowerplots
#'
#' This function creates BHI/OHI flower plots
#' requires a dataframe of OHI scores
#' reads in information from shiny/data
#'
#' @param rgn_scores scores dataframe e.g. output of ohicore::CalculateAll (typically from calculate_scores.R),
#' filtered to region
#' @param rgns vector of bhi region ids by which to filter scores data and for which to create flowerplots
#' @param plot_year year by which to filter region score input dataframe;
#' defaults to current year or maximum year in score data input
#' @param dim the dimension the flowerplot petals should represent (typically OHI 'score')
#' @param labels one of "none", "regular", "curved"
#' @param color_pal a color palette that will map to values of specified dimension 'dim';
#' ideally discrete for color_by 'goal' and continuous otherise
#' @param color_by either "goal" or "score"
#' @param include_ranges whether range bars should be calculated and displayed on plot, only for area-weighted averages ie region id = 0
#' @param fis_mar_petals a dataframe idicating how each subgoal of food provision should be presented (petal width) on the flowerplot
#'
#' @return result is a flower plot; if curved labels or legend table are included,
#' the resulting class is magick-image, otherwise the result is a ggplot object
#' 
make_flower_plot <- function(rgn_scores, rgns, plot_year, dim, labels, color_pal = NA, color_by = "goal", include_ranges = FALSE, fis_mar_petals){
  ## from PlotFlower.R from ohicore package
  ## original function by Casey O'Hara, Julia Lowndes, Melanie Frazier
  ## find original script in R folder of ohicore github repo (as of Mar 27, 2019)
  
  ## WRANGLING & CHECKS ----
  ## region scores data checks ----
  ## filtering/wrangling of rgn_scores for years and dimension
  unique_rgn <- unique(rgn_scores$region_id)
  if(length(unique_rgn) != 1){
    message("note: rgn_scores input contains data for more than one region, will plot all unless given rgn_id")
  }
  if(!"year" %in% names(rgn_scores)){
    if(is.na(plot_year)){
      plot_year <- substring(date(), 21, 24)
      message("no year column in rgn_scores; assuming data is for current year\n")
    } else {
      message(paste("no year column in rgn_scores; assuming data is for given plot_year", plot_year,"\n"))
    }
    rgn_scores$year <- plot_year
  } else {
    if(is.na(plot_year) | !plot_year %in% unique(rgn_scores$year)){
      plot_year <- max(rgn_scores$year)
      message(paste("plotting using most recent year in the input data:", plot_year,"\n"))
    }
  }
  ## filter to plot_year and dimension
  rgn_scores <- rgn_scores %>%
    dplyr::filter(year == plot_year, dimension == dim)
  
  ## check all/only BHI regions included, 
  ## for including ranges on overall BHI flowerplot...
  rgn_scores_summary <- rgn_scores %>%
    group_by(goal, dimension, year) %>%
    summarize(
      missing_rgn = list(
        setdiff(0:42, region_id)),
      n_na = sum(is.na(score)),
      scores_range = list(range(score, na.rm = TRUE) %>% round(digits = 1))
    ) %>%
    ungroup()
  if(!any(is.na(rgns))){
    if(!any(rgns == 0)){
      rgn_scores_summary <- rgn_scores_summary %>%
        select(-scores_range)
    }
    rgn_scores <- dplyr::filter(rgn_scores, region_id %in% rgns)
    unique_rgn <- unique(rgn_scores$region_id)
  }
  if(length(unlist(rgn_scores_summary$missing_rgn)) != 0 & isTRUE(include_ranges)){
    message("note: some missing regions for some goals... rgn_scores must be full scores.csv to include valid/actual ranges!")
  }
  
  ## FIS and MAR ----
  ## weights for fis vs. mar, uses fp_wildcaught_weight.csv layer
  ## info determines relative width in the flowerplot of the two food provision subgoals
  wgts <- fis_mar_petals %>%
    dplyr::filter(year == plot_year) %>%
    dplyr::select(-year)
  
  if(length(wgts$value) != 0){
    mean_wgt <- mean(wgts$value) # mean across regions within the year of interest
    
    ## area weighted subbasin means
    wgts_basin <- readr::read_csv(file.path(dir_main, "data", "regions.csv"), col_types = cols()) %>%
      dplyr::select(region_id, area_km2, subbasin) %>% 
      dplyr::left_join(wgts, by = "region_id") %>%
      dplyr::group_by(subbasin) %>%
      dplyr::summarize(value = weighted.mean(value, area_km2)) %>%
      dplyr::left_join(
        readr::read_csv(file.path(dir_main, "data", "basins.csv"), col_types = cols()) %>%
          dplyr::select(subbasin, region_id = subbasin_id),
        by = "subbasin"
      ) %>%
      ungroup() %>%
      dplyr::select(region_id, value)
    
    wgts <- rbind(
      data.frame(region_id = 0, value = mean_wgt),
      dplyr::filter(wgts, region_id %in% unique_rgn),
      wgts_basin
    )
  } else {
    message(paste("fp_wildcaught_weight.csv doesn't have data for the plot_year:", plot_year))
    fis_mar_petals <- NULL
  }
  if(is.null(fis_mar_petals)){message("plotting FIS and MAR with equal weighting\n")}
  
  ## PLOTTING CONFIGURATION & THEME
  ## sub/supra goals and positioning ----
  ## pos, pos_end, and pos_supra indicate positions, how wide different petals should be based on weightings
  plot_config <- readr::read_csv(file.path(dir_main, "data", "plot_conf.csv"), col_types = cols())
  goals_supra <- na.omit(unique(plot_config$parent))
  
  supra_lookup <- plot_config %>%
    dplyr::filter(goal %in% goals_supra) %>%
    dplyr::select(parent = goal, name_supra = name_flower)
  
  plot_config <- plot_config %>%
    dplyr::left_join(supra_lookup, by = "parent") %>%
    dplyr::filter(!(goal %in% goals_supra)) %>%
    dplyr::select(-preindex_function, -postindex_function, -description, -order_calculate) %>%
    dplyr::mutate(name_flower = gsub("\\n", "\n", name_flower, fixed = TRUE)) %>%
    dplyr::mutate(name_supra = gsub("\\n", "\n", name_supra, fixed = TRUE)) %>%
    dplyr::arrange(order_hierarchy)
  if(labels %in% c("curved", "arc")){
    plot_config <- plot_config %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        f = stringr::str_split(name_flower, "\n"),
        f1 = ifelse(order_hierarchy <= max(plot_config$order_hierarchy)/1.5, f[1],  f[2]),
        f2 = ifelse(order_hierarchy <= max(plot_config$order_hierarchy)/1.5, f[2], f[1])) %>%
      dplyr::select(-f)
  }
  
  thm <- apply_bhi_theme(plot_type = "flowerplot")
  
  color_by <- str_to_lower(color_by)
  if(color_by == "goal"){
    if(length(plot_config$goal) > length(color_pal)){
      color_df <- thm$palettes$goals_pal
      message("no palette given or too few colors for plotting by goal; using a predefined color palette\n")
    } else {
      color_pal <- color_pal[1:nrow(plot_config)*length(color_pal)/nrow(plot_config)]
      color_df <- tibble::tibble(goal = plot_config$goal, color = color_pal)
    }
  }
  
  ## LOOP OVER REGIONS ----
  ## region-specific configuration and then plotting
  for(r in unique_rgn){
    plot_config$weight[plot_config$goal == "FIS"] <- wgts$value[wgts$region_id == r]
    plot_config$weight[plot_config$goal == "MAR"] <- 1 - wgts$value[wgts$region_id == r]
    
    ## create plot_df ----
    plot_df <- rgn_scores %>%
      dplyr::filter(region_id == r) %>%
      dplyr::inner_join(plot_config, by = "goal") %>%
      dplyr::arrange(order_hierarchy) %>%
      dplyr::mutate(pos = sum(weight) - (cumsum(weight) - 0.5 * weight)) %>%
      dplyr::mutate(pos_end = sum(weight)) %>%
      dplyr::group_by(name_supra) %>%
      dplyr::mutate(pos_supra = ifelse(!is.na(name_supra), mean(pos), NA)) %>% # to deal with unequal weights
      dplyr::ungroup() %>%
      dplyr::filter(weight != 0) %>%
      dplyr::select(-dimension, -region_id, -year, -order_color, -parent, -name) %>%
      dplyr::mutate(plot_NA = ifelse(is.na(score), 100, NA)) # for displaying NAs
    if(color_by == "goal"){
      plot_df <- plot_df %>%
        dplyr::arrange(goal) %>% # for matching colors with correct petals, this arrangment is important...
        dplyr::left_join(color_df, by = "goal")
      # color_pal <- dplyr::arrange(plot_df, order_calculate)$color
    }
    ## for including goal ranges for overall index
    if(r == 0 & isTRUE(include_ranges)){
      plot_df <- plot_df %>%
        left_join(
          rgn_scores_summary %>%
            select(goal, scores_range),
          by = "goal"
        ) %>%
        rowwise() %>%
        mutate(
          min_score = unlist(scores_range)[1],
          max_score = unlist(scores_range)[2]
        )
    }
    
    ## FLOWERPLOTS ----
    if(color_by == "goal"){
      plot_obj <- ggplot(plot_df, aes(x = pos, y = score, width = weight, fill = goal)) +
        geom_bar(
          aes(y = 100), 
          stat = "identity",
          size = 0.2, 
          color = thm$cols$med_grey3, 
          fill = "white"
        ) +
        geom_bar(
          stat = "identity",
          size = 0.2, 
          color = thm$cols$med_grey3, 
          show.legend = FALSE
        ) +
        scale_fill_manual(values = plot_df$color, na.value = "black")
      
    } else {
      plot_obj <- ggplot(plot_df, aes(x = pos, y = score, width = weight, fill = score)) +
        geom_bar(
          aes(y = 100), 
          stat = "identity",
          size = 0.2, 
          color = thm$cols$med_grey3, 
          fill = "white"
        ) +
        geom_bar(
          stat = "identity", 
          size = 0.2, 
          color = thm$cols$med_grey3, 
          show.legend = FALSE
        ) +
        scale_fill_gradientn(colors = color_pal, na.value = "black", limits = c(0, 100))
    }
    
    if(any(!is.na(plot_df$plot_NA))){ # overlay light grey background for NAs
      plot_obj <- plot_obj +
        geom_bar(
          aes(y = plot_NA), 
          stat = "identity",
          size = 0.2, 
          color = thm$cols$med_grey3, 
          fill = thm$cols$light_grey1
        )
    }
    plot_obj <- plot_obj +
      geom_errorbar(
        aes(x = pos, ymin = 0, ymax = 0), # bolded baseline at zero
        size = 0.5, 
        show.legend = NA, 
        color = thm$cols$dark_grey3
      ) +
      geom_errorbar(
        aes(x = pos, ymin = 0, ymax = 0), # some kind of tipping-point line? currently zero...
        size = 0.25,
        show.legend = NA, 
        color = thm$cols$accent_bright
      ) +
      geom_errorbar(
        aes(x = pos, ymin = 109, ymax = 109), # outer ring indicating room for even more progress?
        size = 5, 
        show.legend = NA, 
        color = thm$cols$light_grey1
      )
    
    ## general flowerplot elements ----
    goal_labels <- dplyr::select(plot_df, goal, name_flower)
    name_and_title <- thm$rgn_name_lookup %>%
      dplyr::filter(region_id == r)
    blank_circle_rad <- -42
    ## labels, polar coordinates, adjust axes
    plot_obj <- plot_obj +
      labs(x = NULL, y = NULL) +
      coord_polar(start = pi * 0.5) + # from linear bar chart to polar
      scale_x_continuous(labels = NULL,
                         breaks = plot_df$pos,
                         limits = c(0, max(plot_df$pos_end))) +
      scale_y_continuous(limits = c(blank_circle_rad, ifelse(first(goal_labels == TRUE)|is.data.frame(goal_labels), 150, 100)))
    ## include average value in center
    score_index <- rgn_scores %>%
      dplyr::filter(region_id == r, goal == "Index", dimension == "score") %>%
      dplyr::select(region_id, score) %>%
      dplyr::mutate(score = round(score))
    
    plot_obj <- plot_obj +
      geom_text(
        data = score_index, # include central value
        inherit.aes = FALSE, aes(label = score_index$score),
        x = 0, y = blank_circle_rad, 
        hjust = 0.5, vjust = 0.5,
        size = 9, 
        color = thm$cols$dark_grey3
      )
    
    ## ranges for overall BHI flowerplot if include_ranges is true
    if(r == 0 & isTRUE(include_ranges)){
      plot_obj <- plot_obj +
        geom_errorbar(
          aes(ymin = min_score, ymax = max_score),
          alpha = 0.4, 
          width = 0.05
        ) +
        geom_errorbar(
          aes(ymin = min_score, ymax = max_score),
          alpha = 0.3,
          width = 0.05, 
          color = plot_df$color
        )
    }
    
    ## LABELS ----
    
    ## labeling with sub/supra goal names
    if(labels %in% c("regular", "standard", "normal", "level")){
      plot_obj <- plot_obj +
        # labs(title = name_and_title$plot_title) +
        geom_text(
          aes(label = name_supra, x = pos_supra, y = 150),
          size = 3.4, 
          hjust = 0.4, vjust = 0.8,
          color = thm$cols$med_grey1
        ) +
        geom_text(
          aes(label = name_flower, x = pos, y = 120),
          size = 3, 
          hjust = 0.5, vjust = 0.5,
          color = thm$cols$dark_grey3
        )
    }
    
    if(labels %in% c("curved", "arc")){
      temp_plot <- file.path(
        dir_main, "figures", 
        sprintf("flowerplot%s_%s.png", name_and_title$region_id, name_and_title$name)
      )
      ggplot2::ggsave(
        filename = temp_plot, 
        plot = plot_obj, 
        device = "png",
        height = 6, width = 8, units = "in", dpi = 300
      )
      
      temp_labels <- file.path(dir_main, "figures", paste0("flower_curvetxt_", name_and_title$name, ".png"))
      ## don't recreate curved labels if already exist....
      if(!file.exists(temp_labels)){
        circ_df <- plot_df %>%
          # dplyr::mutate(f1 = ifelse(weight <= 0.01, "", f1)) %>%
          # dplyr::mutate(f2 = ifelse(weight <= 0.01, "", f2)) %>%
          dplyr::select("goal", "f1", "f2", "name_supra", "weight", "order_hierarchy") %>%
          dplyr::mutate(weight = 0.15 + weight) %>% # spacing of labels around the circle based on weights...
          dplyr::mutate(x = sum(weight)-(cumsum(weight)-weight), x_end = sum(weight)-(cumsum(weight))) %>%
          tidyr::gather("start_end", "range", -goal, -name_supra, -weight, -order_hierarchy, -f1, -f2) %>%
          dplyr::select(-start_end, -weight, -goal) %>%
          dplyr::arrange(order_hierarchy)
        
        ## start creating plot and save with grDevices function
        # jpeg(temp_labels, width = 2450, height = 2450, quality = 220) # jpeg format is lossy, png seems better...
        png(temp_labels, width = 2490, height = 2490, bg = "transparent")
        message("creating curved labels for plot:\n")
        
        ## curved labels created with 'circlize' package ----
        ## setup/initialize new circlize plot
        circos.clear()
        circos.par(
          "track.height" = 0.1, 
          cell.padding = c(0.02, 0, 0.02, 0), 
          "clock.wise" = FALSE, 
          start.degree = 5
        )
        circos.initialize(
          factors = circ_df$order_hierarchy,
          x = circ_df$range
        )
        
        ## make tracks
        circos.track(
          factors = circ_df$order_hierarchy,
          y = circ_df$range, 
          panel.fun = function(x, y){
            circos.text(CELL_META$xcenter, CELL_META$ycenter, CELL_META$sector.index, col = "white")},
          bg.col = NA, 
          bg.border = FALSE
        )
        circos.track(
          factors = circ_df$order_hierarchy, 
          y = circ_df$range, 
          panel.fun = function(x, y){
            circos.text(
              CELL_META$xcenter, 
              CELL_META$ycenter,
              circ_df$f1[circ_df$order_hierarchy == as.numeric(CELL_META$sector.index)][1],
              cex = 5, 
              col = thm$cols$med_grey3, 
              adj = c(0.4, 1),
              facing = "bending.inside", 
              niceFacing = TRUE
            )
          },
          bg.col = NA, 
          bg.border = FALSE
        )
        circos.track(
          factors = circ_df$order_hierarchy, 
          y = circ_df$range, 
          panel.fun = function(x, y){
            circos.text(
              CELL_META$xcenter, 
              CELL_META$ycenter,
              circ_df$f2[circ_df$order_hierarchy == as.numeric(CELL_META$sector.index)][1],
              cex = 5, 
              col = thm$cols$med_grey3, 
              adj = c(0.5, 0),
              facing = "bending.inside", 
              niceFacing = TRUE
            )
          },
          bg.col = NA, 
          bg.border = FALSE
        )
        
        ## add supra goal labeling
        highlight.sector(
          circ_df$order_hierarchy[circ_df$name_supra != "Food Provision"|is.na(circ_df$name_supra)],
          track.index = 1, 
          text = "Food Provision", 
          cex = 6.5, 
          padding = c(0, 0, 0, 2.67),
          text.col = thm$cols$light_grey2, 
          col = NA,
          facing = "bending.outside", 
          niceFacing = TRUE
        )
        highlight.sector(
          circ_df$order_hierarchy[circ_df$name_supra != "Coastal Livelihoods & Economies"|is.na(circ_df$name_supra)],
          track.index = 1, 
          text = "Coastal Livelihoods & Economies", 
          cex = 6.5,
          text.col = thm$cols$light_grey2, 
          col = NA,
          facing = "bending.outside",
          niceFacing = TRUE
        )
        highlight.sector(
          circ_df$order_hierarchy[circ_df$name_supra != "Sense of Place"|is.na(circ_df$name_supra)],
          track.index = 1, 
          text = "Sense of Place", 
          cex = 6.5, 
          padding = c(0, 0, 0, 2.62),
          text.col = thm$cols$light_grey2, 
          col = NA,
          facing = "bending.outside",
          niceFacing = TRUE
        )
        highlight.sector(
          circ_df$order_hierarchy[circ_df$name_supra != "Clean Waters"|is.na(circ_df$name_supra)],
          track.index = 1, 
          text = "Clean Waters",
          cex = 6.5, 
          padding = c(0, 0.16, 0, 0),
          text.col = thm$cols$light_grey2, 
          col = NA,
          facing = "bending.outside", 
          niceFacing = TRUE
        )
        dev.off() # end saving labels image with grDevices function
      }
      ## combine plot and labels into one graphic
      img_text <- magick::image_read(temp_labels)
      img_plot <- magick::image_read(temp_plot)
      
      plot_obj <- image_composite(
        img_plot,
        image_scale(img_text, 1810), 
        offset = "+305-15"
      ) %>% image_crop(geometry_area(1750, 1620, 325, 120))
    }
    
    ## SAVE PLOT
    ## saving with method based on plot_obj class
    if(class(plot_obj) == "magick-image"){
      magick::image_write(
        image_scale(plot_obj, 600), # can adjust here to make smaller, sacrificing image quality...
        path = file.path(
          dir_main, "figures", 
          sprintf("flowerplot%s_%s.png", name_and_title$region_id, name_and_title$name)
        ), 
        format = "png"
      )
    } else {
      ggplot2::ggsave(
        filename = file.path(
          dir_main, "figures", 
          sprintf("flowerplot%s_%s.png", name_and_title$region_id, name_and_title$name)
        ), 
        plot = plot_obj, 
        device = "png",
        height = 3.5, width = 5, units = "in", dpi = 400
      )
    }
  }
  ## remove curvedtext labels from figures folder, these were only needed for interm. steps...
  file.remove(
    list.files(file.path(dir_main, "figures"), full.names = TRUE) %>% 
      grep(pattern = "flower_curvetxt", value = TRUE)
  )
  return(invisible(plot_obj)) # note this will only return the last plot
}
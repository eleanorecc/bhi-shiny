#' create a BHI flowerplots
#'
#' This function creates BHI/OHI flower plots
#' requires a dataframe of OHI scores; other info it reads in information from shiny/data
#'
#' @param rgn_scores scores dataframe i.e. output of ohicore::CalculateAll
#' @param rgns vector of bhi region ids by which to filter scores data and for which to create flowerplots
#' @param plotconf
#' @param plot_year year by which to filter region score input dataframe; defaults to current year or maximum year in score data input
make_flower_plot <- function(rgn_scores, rgns, plotconf, plot_year = NA){
  
  require(dplyr)
  require(ggplot2)
  require(circlize)
  require(magick)
  
  ## WRANGLING & CHECKS
  if(is.na(plot_year) | !plot_year %in% unique(rgn_scores$year)){
    plot_year <- max(rgn_scores$year)
    message(paste("plotting using most recent year in the input data:", plot_year))
  }
  ## filter to plot_year and score dimension
  rgn_scores <- rgn_scores %>%
    dplyr::filter(year == plot_year, dimension == "score")
  
  ## PLOTTING CONFIGURATION & THEME
  ## pos, pos_end, and pos_supra indicate positions, how wide different petals should be based on weightings
  goals_supra <- na.omit(unique(plotconf$parent))
  
  supra_lookup <- plotconf %>%
    filter(goal %in% goals_supra) %>%
    select(parent = goal, name_supra = name_flower)
  
  plotconf <- plotconf %>%
    left_join(supra_lookup, by = "parent") %>%
    filter(!(goal %in% goals_supra)) %>%
    mutate(name_flower = gsub("\\n", "\n", name_flower, fixed = TRUE)) %>%
    mutate(name_supra = gsub("\\n", "\n", name_supra, fixed = TRUE)) %>%
    arrange(order_hierarchy) %>% 
    rowwise() %>%
    mutate(
      f = stringr::str_split(name_flower, "\n"),
      f1 = ifelse(order_hierarchy <= max(plotconf$order_hierarchy)/1.5, f[1],  f[2]),
      f2 = ifelse(order_hierarchy <= max(plotconf$order_hierarchy)/1.5, f[2], f[1])) %>%
    select(-f)
  
  ## elements defined/set in theme.R
  ## predefined palette for goals also defined in theme.R
  thm <- apply_bhi_theme(plot_type = "flowerplot")
  color_df <- thm$palettes$goals_pal
  
  
  ## LOOP OVER REGIONS ----
  ## region-specific configuration and then plotting
  unique_rgn <- unique(rgn_scores$region_id)
  for(r in unique_rgn){
    
    ## create plot_df ----
    plot_df <- rgn_scores %>%
      filter(region_id == r) %>%
      inner_join(plotconf, by = "goal") %>%
      arrange(order_hierarchy) %>%
      mutate(pos = sum(weight) - (cumsum(weight) - 0.5 * weight)) %>%
      mutate(pos_end = sum(weight)) %>%
      group_by(name_supra) %>%
      mutate(pos_supra = ifelse(!is.na(name_supra), mean(pos), NA)) %>% # to deal with unequal weights
      ungroup() %>%
      filter(weight != 0) %>%
      select(-dimension, -region_id, -year, -parent, -name) %>%
      mutate(plot_NA = ifelse(is.na(score), 100, NA)) %>% # for displaying NAs
      arrange(goal) %>% # for matching colors with correct petals, this arrangment is important...
      left_join(color_df, by = "goal")
    
    ## FLOWERPLOTS
    plot_obj <- ggplot(plot_df, aes(x = pos, y = score, width = weight, fill = goal)) +
      geom_bar(
        aes(y = 100), 
        stat = "identity",
        size = 0.2, 
        color = thm$cols$med_grey3, 
        fill = "#fbfcfd" 
      ) +
      geom_bar(
        stat = "identity",
        size = 0.2, 
        color = thm$cols$med_grey3, 
        show.legend = FALSE
      ) +
      scale_fill_manual(values = plot_df$color, na.value = "black")
    
    ## overlay light grey background for NAs
    if(any(!is.na(plot_df$plot_NA))){ 
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
      ## bolded baseline at zero
      geom_errorbar(
        aes(x = pos, ymin = 0, ymax = 0), 
        size = 0.5, 
        show.legend = NA, 
        color = thm$cols$dark_grey3
      ) +
      ## some kind of tipping-point line? currently zero...
      geom_errorbar(
        aes(x = pos, ymin = 0, ymax = 0), 
        size = 0.25,
        show.legend = NA, 
        color = thm$cols$accent_bright
      ) +
      ## outer ring indicating room for even more progress?
      geom_errorbar(
        aes(x = pos, ymin = 109, ymax = 109), 
        size = 5, 
        show.legend = NA, 
        color = thm$cols$light_grey1
      )
    
    ## general flowerplot elements ----
    blank_circle_rad <- -42
    goal_labels <- dplyr::select(plot_df, goal, name_flower)
    
    ## labels, polar coordinates, adjust axes
    plot_obj <- plot_obj +
      labs(x = NULL, y = NULL) +
      ## from linear bar chart to polar
      coord_polar(start = pi * 0.5) + 
      scale_x_continuous(
        labels = NULL,
        breaks = plot_df$pos,
        limits = c(0, max(plot_df$pos_end))
      ) +
      scale_y_continuous(limits = c(blank_circle_rad, ifelse(first(goal_labels == TRUE)|is.data.frame(goal_labels), 150, 100)))
    
    ## include average value in center
    score_index <- rgn_scores %>%
      dplyr::filter(region_id == r, goal == "Index", dimension == "score") %>%
      dplyr::select(region_id, score) %>%
      dplyr::mutate(score = round(score))
    
    plot_obj <- plot_obj +
      ## include central value
      geom_text(
        data = score_index, 
        inherit.aes = FALSE, aes(label = score_index$score),
        x = 0, y = blank_circle_rad, 
        hjust = 0.5, vjust = 0.5,
        size = 15, 
        color = thm$cols$dark_grey3
      )
    
    ## LABELS
    temp_plot <- file.path(
      dir_main, "figures", 
      sprintf("flowerplot%s.png", substr(r, 5, 7))
    )
    ggplot2::ggsave(
      filename = temp_plot, 
      plot = plot_obj, 
      device = "png",
      bg = "white",
      height = 9, width = 12, units = "in", dpi = 400
    )
    temp_labels <- file.path(dir_main, "figures", paste0("flower_curvetxt_", substr(r, 5, 7), ".png"))
    
    if(!file.exists(temp_labels)){
      circ_df <- plot_df %>%
        select("goal", "f1", "f2", "name_supra", "weight", "order_hierarchy") %>%
        mutate(weight = 0.15 + weight) %>% # spacing of labels around the circle based on weights...
        mutate(x = sum(weight)-(cumsum(weight)-weight), x_end = sum(weight)-(cumsum(weight))) %>%
        tidyr::pivot_longer(cols = c(x, x_end), names_to = "start_end", values_to = "range") %>%
        select(-start_end, -weight, -goal) %>%
        arrange(order_hierarchy)
      
      ## start creating plot and save with grDevices function
      # jpeg(temp_labels, width = 2450, height = 2450, quality = 220) # jpeg format is lossy, png seems better...
      png(temp_labels, width = 3735, height = 3735, bg = "transparent")
      message("creating curved labels for plot:")
      
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
            cex = 7.5,
            col = "grey10", # thm$cols$med_grey3, 
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
            cex = 7.5,
            col = "grey10", # thm$cols$med_grey3, 
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
        unique(circ_df$order_hierarchy[circ_df$name_supra == "Food Provision" & !is.na(circ_df$name_supra)]),
        track.index = 1, 
        text = "Food Provision", 
        cex = 9.5, # 8.5, 
        text.col = "grey50", # thm$cols$light_grey2, 
        col = NA,
        facing = "bending.outside", 
        niceFacing = TRUE
      )
      highlight.sector(
        unique(circ_df$order_hierarchy[circ_df$name_supra == "Coastal Livelihoods & Economies" & !is.na(circ_df$name_supra)]),
        track.index = 1, 
        text = "Coastal Livelihoods & Economies", 
        cex = 9.5, # 8.5, 
        text.col = "grey50", # thm$cols$light_grey2, 
        col = NA,
        facing = "bending.outside",
        niceFacing = TRUE
      )
      highlight.sector(
        unique(circ_df$order_hierarchy[circ_df$name_supra == "Sense of Place" & !is.na(circ_df$name_supra)]),
        track.index = 1, 
        text = "Sense of Place", 
        cex = 9.5, # 8.5, 
        text.col = "grey50", # thm$cols$light_grey2, 
        col = NA,
        facing = "bending.outside",
        niceFacing = TRUE
      )
      highlight.sector(
        unique(circ_df$order_hierarchy[circ_df$name_supra == "Clean Waters" & !is.na(circ_df$name_supra)]),
        track.index = 1, 
        text = "Clean Waters",
        cex = 9.5, # 8.5, 
        text.col = "grey50", # thm$cols$light_grey2, 
        col = NA,
        facing = "bending.outside", 
        niceFacing = TRUE
      )
      dev.off() # end saving labels image with grDevices function
      
      ## can check the tracks and sectors with circos info
      # circos.info(plot = TRUE)
    }
    ## combine plot and labels into one graphic
    img_text <- image_read(temp_labels)
    img_plot <- image_read(temp_plot)
    
    plot_obj <- image_composite(
      img_plot,
      image_scale(img_text, 3580), 
      offset = "+605+0"
    ) %>% image_crop(geometry_area(3282, 3038, 795, 320))
    
    ## SAVE PLOT
    ## saving with method based on plot_obj class
    image_write(
      image_scale(plot_obj, 800), # can adjust here to make smaller, sacrificing image quality...
      path = file.path(
        dir_main, "figures", 
        sprintf("flowerplot%s.png", substr(r, 5, 7))
      ), 
      format = "png"
    )
  }
  
  ## remove curved text labels from figures folder...
  file.remove(
    list.files(file.path(dir_main, "figures"), full.names = TRUE) %>% 
      grep(pattern = "flower_curvetxt", value = TRUE)
  )
  
  ## note this will only return the last plot
  return(invisible(plot_obj))
}


#' make data layers table
#'
#' @param gh_raw_bhiprep raw.githubusercontent url directing to bhi prep github repository
#' @param bhi_version assessment year
make_data_table <- function(gh_raw_bhiprep, bhi_version){
  
  rmds <- sprintf(c(
    "CON/%s/con_prep", 
    "EUT/%s/eut_prep", 
    "FIS/%s/fis_prep",
    "MAR/v2019/mar_prep",
    "NP/%s/np_prep",
    "ECO/%s/eco_prep",
    "LIV/%s/liv_prep",
    "BD/%s/bd_prep",
    "AO/%s/ao_prep",
    "ICO/%s/ico_prep",
    "LSP/%s/lsp_prep",
    "TR/%s/tr_prep",
    "CS/%s/cs_prep",
    "TRA/%s/tra_prep"
  ), bhi_version)
  
  goals <- data.frame(
    c("CW", "CW", "FP", "FP", "NP", "LE", "LE", "BD", "AO", "SP", "SP", "TR", "CS", "CW"), 
    c("CON", "EUT", "FIS", "MAR", NA, "ECO", "LIV", NA, NA, "ICO", "LSP", NA, NA, "TRA"), 
    rmds, 
    stringsAsFactors = FALSE
  )
  colnames(goals) <- c("goal", "subgoal", "rmdlink")
  
  datalyrs_metainfo <- data.frame(
    goal = character(), 
    subgoal = character(), 
    layer = character(), 
    description = character(), 
    source = character(), 
    sourcelink = character(),
    stringsAsFactors = FALSE
  )
  
  for(g in 1:nrow(goals)){
    
    txt <- readr::read_lines(sprintf("%s/prep/%s.Rmd", gh_raw_bhiprep, goals[g, "rmdlink"]))
    txt <- txt[grep("^### 2.1 ", txt):ifelse(length(grep("^### 2.2 ", txt)) > 0, grep("^### 2.2 ", txt), grep("^## 3. ", txt))]
    
    headers <- c(grep("^#### .*[0-9] ", txt), length(txt))
    boldheaders <- grep("^\\*\\*", txt)
    srclnk <- grep("Source.*\\]\\(http.*\\)", txt)
    
    lyr <- c()
    src <- c()
    lnk <- c()
    for(h in 2:length(headers)){
      subheaders <- txt[boldheaders[boldheaders %in% headers[h-1]:(headers[h])]]
      newlyr <- gsub(", $", "", paste(
        gsub("#### .*[0-9] ", "", gsub(" \\{-\\}", "", txt[headers[h-1]])),
        gsub("\\[.*\\]\\(.*\\)", "", gsub("\\*\\*", "", subheaders)),
        sep = ", "
      ))
      lyr <- c(lyr, newlyr)
      
      lyrsrc <- srclnk[srclnk %in% headers[h-1]:headers[h]]
      if(length(lyrsrc) == 0){
        src <- c(src, NA)
        lnk <- c(lnk, NA)
      }
      if(length(lyrsrc) > length(newlyr)){
        ## likely a section with reference point information
        lyrsrctmp <- lyrsrc[grep("eference point .* \\[.*\\]\\(.*\\)|arget .* \\[.*\\]\\(.*\\)|eference point .* http|arget .* http|heshold .* http", txt[lyrsrc])]
        if(length(lyrsrctmp) == 0){
          ## or a link with additional information...
          lyrsrctmp <- lyrsrc[grep("more information|additional information|learn more|for details|supplement to paper|detailed info|has been compiled from", txt[lyrsrc], invert = TRUE)]
          if(length(lyrsrctmp) == 0){
            lyrsrc <- lyrsrc[1]
          } else {
            lyrsrc <- lyrsrctmp
          }
        } else {
          lyrsrc <- lyrsrctmp
        }
      }
      for(l in lyrsrc){
        chk <- gsub(".*\\[", "", stringr::str_split(txt[l], "\\]")[[1]][1])
        src <- c(src, ifelse(stringr::str_detect(chk, "http"), "Reference", chk))
        lnk <- c(lnk, gsub("\\)|\\):", "", stringr::str_split(stringr::str_extract(txt[l], "http.*"), " ")[[1]][1]))
      }
    }
    datalyrs_metainfo <- dplyr::bind_cols(
      goal = rep(goals[g, "goal"], length(lyr)),
      subgoal = rep(goals[g, "subgoal"], length(lyr)),
      layer = stringr::str_remove(lyr, " \\{\\-\\}"),
      description = rep("", length(lyr)), 
      source = src,
      sourcelink = lnk
    ) %>% filter(!is.na(source) & !is.na(sourcelink)) %>% dplyr::bind_rows(datalyrs_metainfo) 
  }
  
  datalyrs_metainfo <- datalyrs_metainfo %>% 
    dplyr::mutate(reflink = sprintf(
      "<a href=\"%s\" target = \"_blank\">%s</a>", 
      sourcelink, source
    )) %>%
    mutate(goal_subgoal = ifelse(is.na(subgoal), goal, subgoal)) %>% 
    rowwise() %>% 
    mutate(goal = list(c(goal, subgoal))) %>% 
    tidyr::unnest(cols = c(goal)) %>% 
    dplyr::filter(!is.na(goal)) %>% 
    dplyr::select(goal = goal_subgoal, dataset = layer, source, reflink)

  
  return(datalyrs_metainfo)
}

#' list all layers in bhi prep repository
#'
#' @param gh_api_bhiprep github api url directing to bhi prep github repository
#' @return list of scenario layers files found in the bhi prep repositorys
list_prep_layers <- function(gh_api_bhiprep){
  req <- httr::GET(gh_api_bhiprep)
  httr::stop_for_status(req)
  
  filelist <- unlist(lapply(httr::content(req)$tree, "[", "path"), use.names = FALSE) %>% 
    grep(pattern = "layers/", value = TRUE) %>% 
    stringr::str_extract("/[a-zA-Z0-9_-]+.csv|/[a-zA-Z0-9_-]+$") %>% 
    stringr::str_remove_all(".csv") %>% 
    stringr::str_remove_all("/")
  
  return(filelist)
}

#' timeseries plot card module
#'
#' this script contains two functions:
#' \code{tsplotCardUI} generates the user interface for each card
#' \code{tsplotCard} generates the plot shown in a card

## timeseries plot card ui function ----
tsplotCardUI <- function(id, title_text = NULL, sub_title_text = NULL, ht = 340, select_choices){
  
  ns <- shiny::NS(id)
  
  select <- selectInput(
    ns("select"),
    choices = select_choices,
    label = p("Plot Layer")
  )
  items <- list(select, plotlyOutput(ns("tsplot"), height = ht))
  
  ## put together in box and return box
  tagList(box(
    collapsible = TRUE,
    title = title_text,
    list(p(sub_title_text), items),
    width = 12
  ))
}

## timeseries plot card ui function ----
tsplotCard <- function(input, output, session, plot_type = "boxplot",
                       layer_selected, spatial_unit_selected, year_selected){
  
  selected <- layer_selected()
  
  output$tsplot <- renderPlotly({
    
    ## retrieve and wrangle plotting data
    lyr <- gsub("[0-9]{4}.*", stringr::str_extract(selected, "[0-9]{4}"), selected)
    lyr_data <- get_layers_data(gh_raw_bhiprep, layers = lyr, assess_year) %>% 
      left_join(regions_df, by = "region_id")
    
    if(spatial_unit_selected() == "subbasins"){
      plotdf <- dplyr::rename(lyr_data, region = subbasin) %>% 
        filter(stringr::str_detect(category, gsub(paste0(lyr, "_"), "", selected))) %>% 
        mutate(categorytxt = str_remove(str_replace_all(category, "_", " "), "^status, "))
      pallength <- 20
    } else {
      plotdf <- dplyr::rename(lyr_data, region = region_name) %>% 
        filter(stringr::str_detect(category, gsub(paste0(lyr, "_"), "", selected)))
      pallength <- 42
    }
    if(length(unique(plotdf$category)) > 1){
      plotdf <- mutate(plotdf, region = sprintf("%s (%s)", region, categorytxt))
      pallength <- length(unique(plotdf$category))*pallength
    }
  
    ## different kinds of timeseries plots, depending on categorical variables etc
    if(plot_type == "boxplot"){
      p <- ggplot(plotdf %>% mutate(year = as.factor(year))) +
        geom_boxplot(aes(year, value, fill = region, color = region), alpha = 0.2, size = 0.2) +
        labs(x = NULL, y = NULL, color = "Region", fill = "Region") +
        theme_bw() +
        theme(
          legend.background = element_rect(color = "grey"), 
          strip.text.y = element_text(size = 4+10/length(unique(plotdf$category)))
        ) +
        scale_color_manual(values = pal) +
        scale_fill_manual(values = pal) +
        facet_grid(rows = vars(str_to_upper(categorytxt)), switch = "y")
    }
    if(plot_type == "barplot"){
      p <- ggplot(plotdf, aes(year, value, fill = region)) +
        geom_col(color = "grey80", alpha = 0.4, size = 0.2, position = position_dodge()) +
        labs(x = NULL, y = NULL, fill = "Region") +
        theme_bw() +
        theme(
          legend.background = element_rect(color = "grey"), 
          strip.text.y = element_text(size = 4+10/length(unique(plotdf$category)))
        ) +
        scale_fill_manual(values = pal) +
        facet_grid(rows = vars(str_to_upper(categorytxt)), switch = "y")
    }
    if(plot_type == "pointplot"){
      p <- ggplot(plotdf, aes(year, value, color = region)) +
        geom_point(size = 0.2) +
        labs(x = NULL, y = NULL, fill = "Region") +
        theme_bw() +
        theme(
          legend.background = element_rect(color = "grey"), 
          strip.text.y = element_text(size = 4+10/length(unique(plotdf$category)))
        ) +
        scale_color_manual(values = pal) +
        facet_grid(rows = vars(str_to_upper(categorytxt)), switch = "y")
    }
    if(plot_type == "lineplot"){
      plotdf <- plotdf %>% mutate(categorytxt = gsub(paste0(lyr, "_"), "", selected))
      p <- ggplot(plotdf) +
        geom_line(aes(year, value, color = region), size = 0.4) +
        labs(x = NULL, y = NULL, fill = "Region") +
        theme_bw() +
        theme(
          legend.background = element_rect(color = "grey"), 
          strip.text.y = element_text(size = 4+10/length(unique(plotdf$categorytxt)))
        ) +
        scale_color_manual(values = pal) +
        facet_grid(rows = vars(str_to_upper(categorytxt)), switch = "y")
    }
    plotly::ggplotly(p)
  })
}

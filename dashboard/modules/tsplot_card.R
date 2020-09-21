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
  items <- list(
    select, 
    addSpinner(
      plotlyOutput(ns("tsplot"), height = ht), 
      spin = "rotating-plane", 
      color = "#d7e5e8"
    )
  )
  
  ## put together in box and return box
  tagList(box(
    collapsible = TRUE,
    collapsed = TRUE,
    title = title_text,
    list(p(sub_title_text), items),
    width = 12
  ))
  
}

## timeseries plot card ui function ----
tsplotCard <- function(input, output, session, plot_type = "boxplot", loc = gh_raw_bhi,
                       layer_selected, spatial_unit_selected, year_selected){
  
  selected <- layer_selected()
  
  output$tsplot <- renderPlotly({
    
    ## retrieve plotting data
    lyr <- gsub("[0-9]{4}.*", stringr::str_extract(selected, "[0-9]{4}"), selected)
    lyr_data <- get_layers_data(loc, layers = lyr, assess_year) %>% 
      left_join(regions_df, by = "region_id")
    
    if(nrow(lyr_data) == 0){
      lyr_data <- read_csv(sprintf("%sintermediate/%s.csv", loc, selected))
      colnames(lyr_data) <- names(lyr_data) %>% 
        stringr::str_replace("input.*tonnes", "Annual Input Tonnes") %>% 
        stringr::str_replace("year", "Year") %>% 
        stringr::str_replace("maximum_allowable_input", "Basin Max. Allowable Input (MAI)") %>% 
        stringr::str_replace("rollmean3yr.*", "3-Year Rolling Mean") %>% 
        stringr::str_replace("year", "Year")
    }
    
    
    ## just need eutrophication nutrient load plots to work for now.....
    if(str_detect(plot_type, "pointlinefaceted")){
      
      p <- ggplot(group_by(lyr_data, subbasin)) +
        geom_vline(xintercept = 1997, color = "gainsboro", size = 0.8) +
        geom_vline(xintercept = 2003, color = "gainsboro", size = 0.8) +
        geom_hline(aes(yintercept = `Basin Max. Allowable Input (MAI)`), color = "maroon") +
        geom_line(aes(Year, `3-Year Rolling Mean`), size = 0.3) +
        geom_point(aes(Year, `Annual Input Tonnes`), size  = 0.8) +
        labs(x = NULL, y = NULL) +
        theme(axis.text = element_text(size = 7.5, angle = 90)) +
        facet_grid(cols = vars(subbasin)) +
        theme_bw()
      
      
    } else {
      
      ## wrangle depending on categorical variables, and spatial units
      if(spatial_unit_selected() == "subbasins"){
        plotdf <- dplyr::rename(lyr_data, region = subbasin) %>% 
          filter(stringr::str_detect(category, gsub(paste0(lyr, "_"), "", selected))) %>% 
          mutate(categorytxt = str_remove(str_replace_all(category, "_", " "), "^status, "))
        if(nrow(plotdf) == 0){
          plotdf <- dplyr::rename(lyr_data, region = subbasin)
        }
        pallength <- 20
      } else {
        plotdf <- dplyr::rename(lyr_data, region = region_name) %>% 
          filter(stringr::str_detect(category, gsub(paste0(lyr, "_"), "", selected))) %>% 
          mutate(categorytxt = str_remove(str_replace_all(category, "_", " "), "^status, "))
        if(nrow(plotdf) == 0){
          plotdf <- dplyr::rename(lyr_data, region = subbasin)
        }
        pallength <- 42
      }
      if(length(unique(plotdf$category)) > 1){
        chkcategories <- nrow(plotdf) != nrow(distinct(select(plotdf, !!!syms(setdiff(names(plotdf), names(regions_df))))))
      }
      fullpal <- colorRampPalette(c(
        RColorBrewer::brewer.pal(8, "Dark2"), 
        RColorBrewer::brewer.pal(9, "Set1")
      ))(80)
      set.seed(2)
      pal <- fullpal[sample(1:pallength, pallength)]

      if(str_detect(plot_type, "boxplot")){
        p <- ggplot(plotdf %>% mutate(year = as.factor(year))) +
          geom_boxplot(aes(year, value, fill = region, color = region), alpha = 0.2, size = 0.2) +
          labs(x = NULL, y = NULL, color = NULL, fill = NULL) +
          theme_bw() +
          theme(
            legend.background = element_rect(color = "grey"), 
            strip.text.y = element_text(size = 4 + 8/length(unique(plotdf$category)))
          ) +
          scale_color_manual(values = pal) +
          scale_fill_manual(values = pal) +
          facet_grid(rows = vars(str_to_upper(categorytxt)), switch = "y")
      }
      
      if(str_detect(plot_type, "barplot")){
        p <- ggplot(plotdf, aes(year, value, fill = region)) +
          geom_col(color = "grey80", alpha = 0.4, size = 0.2, position = position_dodge()) +
          labs(x = NULL, y = NULL, fill = NULL) +
          theme_bw() +
          theme(
            legend.background = element_rect(color = "grey"), 
            strip.text.y = element_text(size = 4 + 8/length(unique(plotdf$category)))
          ) +
          scale_fill_manual(values = pal) +
          facet_grid(rows = vars(str_to_upper(categorytxt)), switch = "y")
      }
      
      if(str_detect(plot_type, "pointplot")){
        p <- ggplot(plotdf, aes(year, value, color = region)) +
          geom_point(size = 0.2) +
          labs(x = NULL, y = NULL, color = NULL) +
          theme_bw() +
          theme(
            legend.background = element_rect(color = "grey"), 
            strip.text.y = element_text(size = 4 + 8/length(unique(plotdf$category)))
          ) +
          scale_color_manual(values = pal) +
          facet_grid(rows = vars(str_to_upper(categorytxt)), switch = "y")
      }
      
      if(str_detect(plot_type, "lineplot")){
        if(chkcategories){
          plotdf <- mutate(plotdf, region = str_replace(categorytxt, "^[a-zA-Z0-9]", str_to_upper(substr(categorytxt, 1, 1))))
          pallength <- length(unique(plotdf$region))
          set.seed(2)
          pal <- fullpal[sample(1:pallength, pallength)]
        }
        plotdf <- plotdf %>% mutate(categorytxt = gsub(paste0(lyr, "_"), "", selected))
        p <- ggplot(plotdf) +
          geom_line(aes(year, value, color = region), size = 0.4) +
          labs(x = NULL, y = NULL, color = NULL) +
          theme_bw() +
          theme(
            legend.background = element_rect(color = "grey"), 
            strip.text.y = element_text(size = 4 + 8/length(unique(plotdf$categorytxt)))
          ) +
          scale_color_manual(values = pal)
        if(length(unique(plotdf$categorytxt)) > 1){
          p <- p + facet_grid(rows = vars(str_to_upper(categorytxt)), switch = "y")
        }
      }
      
      if(str_detect(plot_type, "normalized") & !str_detect(selected, "landings")){
        p <- p + geom_hline(aes(yintercept = 1), color = "blue")
      }
    }
  
    
    ## return the plot as an interactive plotly widget plot
    plotly::ggplotly(p)
  })
}

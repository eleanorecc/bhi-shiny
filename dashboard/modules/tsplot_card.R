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
tsplotCard <- function(input, output, session,
                       layer_selected, spatial_unit_selected, year_selected){
  
  selected <- layer_selected()
  
  output$tsplot <- renderPlotly({
    
    lyr <- gsub("[0-9]{4}.*", stringr::str_extract(selected, "[0-9]{4}"), selected)
    lyr_data <- get_layers_data(gh_raw_bhiprep, layers = lyr, assess_year) %>% 
      left_join(regions_df, by = "region_id")
    
    if(spatial_unit_selected() == "subbasins"){
      plotdf <- dplyr::rename(lyr_data, region = subbasin) %>% 
        filter(stringr::str_detect(category, gsub(paste0(lyr, "_"), "", selected)))
    } else {
      plotdf <- dplyr::rename(lyr_data, region = region_id) %>% 
        filter(stringr::str_detect(category, gsub(paste0(lyr, "_"), "", selected)))
    }
    pal <- colorRampPalette(c(brewer.pal(8, "Dark2"), brewer.pal(9, "Set1")))(30)[sample(1:18, 18)]
    
    plotly::ggplotly(
      ggplot(plotdf %>% mutate(year = as.factor(year))) +
        geom_boxplot(aes(year, value, fill = region, color = region), alpha = 0.2, size = 0.2) +
        labs(x = "Year", y = "Annual Mean", color = "Region", fill = "Region") +
        theme_bw() +
        theme(legend.background = element_rect(color =  "grey")) +
        scale_color_manual(values = pal) +
        scale_fill_manual(values = pal)
    )
  })
}

#' additional figures and plots card module
#'
#' this script contains two functions:
#' \code{addfigsCardUI} generates the user interface for each card
#' \code{addfigsCard} generates the plot shown in a card

## additional figures card ui function ----
addfigsCardUI <- function(id, title_text = NULL, sub_title_text = NULL, ht = 340, select_choices){
  
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

## additional figures card ui function ----
addfigsCard <- function(input, output, session, layer_selected, spatial_unit_selected, year_selected){

  
  selection <- layer_selected()
  lyr <- gsub("[0-9]{4}.*", stringr::str_extract(selection, "[0-9]{4}"), selection)
  plotconf <- filter(fig_info, data_filename == sprintf("%s.csv", lyr))
  
  if(str_detect(plotconf$plot_type, "basin|region|country")){
    spatial_units <- ifelse(
      str_detect(plotconf$plot_type, "basin"), 
      "subbasins",
      ifelse(
        str_detect(plotconf$plot_type, "region"), 
        "regions",
        "country"
      )
    )
  } else {
    spatial_units <- spatial_unit_selected()
  }
  
  
  output$tsplot <- renderPlotly({
    
    ## retrieve and wrangle plotting data ----
    ## read data and rename columns
    if(RCurl::url.exists(paste0(gh_raw_bhi, "layers/", unlist(lyr),  ".csv"))){
      dfloc <- paste0(gh_raw_bhi, "layers/", unlist(lyr),  ".csv")
    } else if(RCurl::url.exists(paste0(gh_raw_bhi, "intermediate/", unlist(lyr),  ".csv"))){
      dfloc <- paste0(gh_raw_bhi, "intermediate/", unlist(lyr),  ".csv")
    } else {
      warning(sprintf("file %s doesn't exist in either layers or intermediate folder", lyr))
      dfloc = NULL
    }
    plotdf <- readr::read_csv(dfloc, col_types = cols())
    if("region_id" %in% names(plotdf)){
      plotdf <- left_join(plotdf, regions_df, by = "region_id")
    }
    colnames(plotdf) <- names(plotdf) %>% 
      str_replace("scen_year", "year") %>% 
      str_replace(plotconf$y_var, "value")
    if(!is.na(plotconf$cat_var)){
      colnames(plotdf) <- str_replace(names(plotdf), plotconf$cat_var, "category")
    }
    
    ## wrangle depending on categorical variables, and spatial units
    if(spatial_units == "subbasins"){
      plotdf <- dplyr::rename(plotdf, region = subbasin)
      pallength <- 20
    } else if(spatial_units == "regions"){
      plotdf <- dplyr::rename(plotdf, region = region_name)
      pallength <- 42
    } else {
      spatial_units <- "country"
      plotdf <- dplyr::rename(plotdf, region_selected = region, region = eez)
      pallength <- 10 
    }
    if("category" %in% names(plotdf)){
      plotdf <- mutate(plotdf, categorytxt = str_to_upper(str_replace_all(category, "_", " ")))
      if(str_remove(selection, "^.*bhi[0-9]{4}_") != selection){
        plotdf <- filter(plotdf, str_detect(category, str_remove(selection, "^.*bhi[0-9]{4}_")))
      }
    }
    
    ## create color palette
    fullpal <- colorRampPalette(c(
      RColorBrewer::brewer.pal(8, "Dark2"), 
      RColorBrewer::brewer.pal(9, "Set1")
    ))(80)
    set.seed(2)
    pal <- fullpal[sample(1:pallength, pallength)]
  
    
    ## different plot types ----
    ## for the 'additional plots' shiny box
    ## 1) tsbar: time-series barplot by different categories
    ## 2) tsbarbasin/tsbarcountry: time-series barplot faceted by basins or countries
    ## 3) tspointline: time-series plot with points and/or line
    ## 4) tspointlinebasin/tspointlineregion: time-series plot with points and/or line faceted by basins or regions
    ## 5) tsboxplot: time-series plot with boxplots
    ## 6) catbar: categorical barplot
    ## 7) normalized: with horizontal reference line
    
    
    ## create plots
    
    ## tsbar: time-series barplot ----
    ## has bars representing value for each basin/region per year
    ## and different colors to represent different basin/region
    if(plotconf$plot_type == "tsbar"){
      
      p <- ggplot(group_by(plotdf, categorytxt)) +
        geom_col(
          aes(year, value, fill = region, text = paste0(
            "Year: ", year,
            "<br>", plotconf$y_var_name, ": ", round(value, 2),
            "<br>", str_to_sentence(spatial_units), ": ", region
          )),
          color = "grey80", 
          alpha = 0.4, 
          size = 0.1, 
          position = position_dodge()
        ) +
        labs(
          x = NULL, 
          y = plotconf$y_var_name,
          fill = NULL
        ) +
        theme_bw() +
        theme(
          strip.text.y = element_text(
            size = 4 + 8/length(unique(plotdf$category)),
            margin = margin(0.8, 0, 0.8, 0, "cm")
          ),
          legend.background = element_rect(color = "grey"),
          legend.justification = "top"
        ) +
        scale_fill_manual(values = pal) +
        facet_grid(
          rows = vars(categorytxt),
          switch = "y"
        )
    }
    
    ## tsbarbasin: time-series barplot faceted by basins
    ## has bars representing value each year, 
    ## one plot (facetted) per basin
    if(plotconf$plot_type == "tsbarbasin" | plotconf$plot_type == "tsbarcountry"){
      
      if("category" %in% names(plotdf)){
        plotdf <- distinct(plotdf, region, value, year, category, categorytxt)
      } else {
        plotdf <- distinct(plotdf, region, value, year)
      }
      
      p <- ggplot(group_by(plotdf, region)) +
        geom_col(
          aes(year, value, fill = value, text = paste0(
            "Year: ", year,
            "<br>", plotconf$y_var_name, ": ", round(value, 2)
          )),
          color = "grey80", 
          alpha = 0.4, 
          size = 0.1
        ) +
        scale_fill_viridis_c() +
        labs(
          x = NULL, 
          y = plotconf$y_var_name,
          fill = plotconf$y_var_name
        ) +
        theme_bw() +
        theme(legend.background = element_rect(color = "grey"))
      if(plotconf$plot_type == "tsbarcountry"){
        p <- p  +
          facet_grid(cols = vars(region)) +
          theme(
            strip.text.x = element_text(size = 8),
            strip.text.y = element_text(size = 4 + 8/length(unique(plotdf$category))),
            axis.text.x = element_text(size = 7.5, angle = 90)
          )
      } else {
        p <- p  +
          facet_wrap(~region) +
          theme(strip.text = element_text(size = 8))
      }
    }
    
    ## tspointline: time-series plot with points and/or line ----
    ## has points and lines (maybe rolling mean), 
    ## and different colors to represent different basin/region
    
    if(plotconf$plot_type == "tspointline"){
      
      p <- ggplot(group_by(plotdf, region)) +
        labs(
          x = NULL, 
          y = plotconf$y_var_name,
          color = str_to_sentence(spatial_units)
        ) +
        theme_bw() +
        theme(
          legend.background = element_rect(color = "grey"),
          legend.justification = "top"
        ) +
        scale_fill_manual(values = pal) 
      
      if(str_detect(plotconf$point_and_line, "point")){
        p <- p +
          geom_point(
            aes(year, value, color = region, text = paste0(
              "Year: ", year,
              "<br>", plotconf$y_var_name, ": ", round(value, 2),
              "<br>", str_to_sentence(spatial_units), ": ", region
            )),
            size  = 0.8
          )
      }
      if(str_detect(plotconf$point_and_line, "line")){
        p <- p +
          geom_line(
            aes(year, value, color = region, text = paste0(
              "Year: ", year,
              "<br>", plotconf$y_var_name, ": ", round(value, 2),
              "<br>", str_to_sentence(spatial_units), ": ", region
            )),
            size = 0.3
          )
      }
    }
    
    ## tspointlinebasin: time-series plot with points and/or line faceted by basins
    ## has points and lines (maybe rolling mean), 
    ## one plot (facetted) per basin
    
    if(plotconf$plot_type == "tspointlinebasin" | plotconf$plot_type == "tspointlineregion"){
      
      p <- ggplot(group_by(plotdf, region)) +
        labs(
          x = NULL, 
          y = plotconf$y_var_name
        ) +
        theme_bw()
      
      if(str_detect(plotconf$point_and_line, "point")){
        p <- p +
          geom_point(
            aes(year, value, text = paste0(
              "Year: ", year,
              "<br>", plotconf$y_var_name, ": ", round(value, 2)
            )),
            size  = 0.8
          )
      }
      if(str_detect(plotconf$point_and_line, "line") | !is.na(plotconf$yline_var)){
        if(!is.na(plotconf$yline_var)){
          p <- p + 
            geom_line(
              aes(year, !!sym(plotconf$yline_var), text = NULL),
              size = 0.3
            )
        } else {
          p <- p + 
            geom_line(
              aes(year, value, text = NULL),
              size = 0.3
            )
        }
      }
      if("categorytxt" %in% names(plotdf)){
        p <- p + 
          facet_grid(
            cols = vars(region), 
            rows = vars(categorytxt)
          ) +
          theme(axis.text.x = element_text(size = 7.5, angle = 90))
      } else {
        p <- p + 
          facet_wrap(~region) +
          # facet_wrap(~region, scales = "free_y") +
          theme(strip.text = element_text(size = 8)) +
          theme(axis.text.x = element_text(size = 7.5))
      }
    }
    
    ## tsboxplot: time-series plot with boxplots ----
    ## has bar-and-whister plots showing ranges for unique spatial units
    
    if(plotconf$plot_type == "tsboxplot"){
      
      p <- ggplot()
      
    }
    
    ## catbar/histogram: categorical barplot with either stat count or stat identity ----
    ## faceted by categories, and with basins rather than years on the x-axis
    if(plotconf$plot_type == "catbar" | plotconf$plot_type == "catbarcountry" | plotconf$plot_type == "histogram"){
      
      plotdf <- filter(plotdf, year == year_selected())
      
      if(str_detect(plotconf$plot_type, "catbar")){
        p <- ggplot(group_by(plotdf, categorytxt)) + 
          geom_bar(
            aes(region, value, fill = categorytxt, text = paste0(
              str_to_sentence(spatial_units), ": ", region,
              "<br>", plotconf$y_var_name, ": ", round(value, 2),
              "<br>", plotconf$cat_var_name, ": ", categorytxt
            )),
            stat = "identity"
          ) +
          labs(
            x = NULL,
            y = plotconf$y_var_name,
            fill = NULL
          ) +
          facet_wrap(~categorytxt) +
          coord_flip() +
          theme_bw() +
          theme(strip.text = element_text(size = 8))
        
      } else {
        plotdf <- distinct(plotdf, region, value, category, categorytxt)
        
        p <- ggplot(group_by(plotdf, categorytxt)) + 
          geom_bar(
            aes(region, fill = categorytxt, text = paste0(
              str_to_sentence(spatial_units), ": ", region,
              "<br>", value,
              "<br>", plotconf$cat_var_name, ": ", categorytxt
            )),
            stat = "count",
            alpha = 0.85
          ) +
          labs(
            x = NULL,
            y = plotconf$y_var_name,
            fill = NULL
          ) +
          coord_flip() +
          scale_fill_manual(values = pal[c(1, length(pal))]) +
          theme_bw() +
          theme(strip.text = element_text(size = 8))
      }
    }
    
    ## normalized plot: with horizontal reference line ----
    ## any of the first four plot types, with a y-intercept = 1 horizontal line
    ## or with horizontal reference line added using a specified column in the input data
    if(!is.na(plotconf$yint)){
      if(!is.na(as.numeric(plotconf$yint))){
        p <- p + geom_hline(aes(yintercept = as.numeric(plotconf$yint)), color = "blue")
      } else {
        p <- p + geom_hline(aes(yintercept = !!sym(plotconf$yint)), color = "blue")
      }
    }
    
    ## return the plot as an interactive plotly widget plot
    plotly::ggplotly(p, tooltip = c("text"))
    
  })
}



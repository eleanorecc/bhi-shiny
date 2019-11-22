## Libraries, Directories, Paths ----
library(here)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(DT)

gh_prep <- "https://github.com/OHI-Science/bhi-1.0-archive/blob/draft/baltic2015/prep"
gh_layers <- "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"

## Creating Shiny content Functions ----
source(here::here("dashboard", "R", "theme.R"))
source(here::here("dashboard", "R", "mapping.R"))
source(here::here("dashboard", "R", "visualization.R"))

source(here::here("dashboard", "modules", "map_card.R"))
source(here::here("dashboard", "modules", "barplot_card.R"))
source(here::here("dashboard", "modules", "flowerplot_card.R"))
source(here::here("dashboard", "modules", "scorebox_card.R"))

# setwd(here::here("dashboard"))
assess_year = 2014


## Functions for Shiny App UI ----

#' expand contract menu sidebar subitems
#'
#' ui function to expand and contract subitems in menu sidebar
#' from convertMenuItem by Jamie Afflerbach https://github.com/OHI-Northeast/ne-dashboard/tree/master/functions
#'
#' @param mi menu item as created by menuItem function, including subitems from nested menuSubItem function
#' @param tabName name of the tab that correspond to the mi menu item
#'
#' @return expanded or contracted menu item

convertMenuItem <- function(mi, tabName){
  mi$children[[1]]$attribs['data-toggle'] = "tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class) > 0 && mi$attribs$class == "treeview"){
    mi$attribs$class = NULL
  }
  mi
}

#' create text boxes with links
#'
#' @param title the text to be displayed in the box
#' @param url url the box should link to
#' @param box_width width of box, see shinydashboard::box 'width' arguement specifications
#'
#' @return

text_links <- function(title = NULL, url = NULL, box_width = 12){

  box(class = "text_link_button",
      h4(a(paste("\n", title), href = url, target = "_blank")),
      width = box_width,
      height = 65,
      background = "light-blue",
      status = "primary",
      solidHeader = TRUE)
}

## Shiny Global Data ----

full_scores_csv <- readr::read_csv(here("dashboard", "data", "scores.csv"))
goals_csv <- readr::read_csv(here("dashboard", "data", "plot_conf.csv"))

regions_df <- readr::read_csv(here("dashboard", "data", "regions.csv"))
subbasins_df <- readr::read_csv(here("dashboard", "data", "basins.csv"))

rgns_shp <- make_rgn_sf(
  bhi_rgns_shp = read_rds(here("dashboard", "data", "regions.rds")), 
  scores_csv = full_scores_csv, 
  dim = "score", 
  year = assess_year
)
subbasins_shp <- make_subbasin_sf(
  subbasins_shp = read_rds(here("dashboard", "data", "subbasins.rds")), 
  scores_csv = full_scores_csv, 
  dim = "score", 
  year = assess_year
)

## Theme for shinydash and visualizations
thm <- apply_bhi_theme()

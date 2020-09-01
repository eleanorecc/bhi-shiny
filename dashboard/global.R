## Libraries, Directories, Paths ----
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(DT)
library(stringr)


assess_year <- 2019

gh_prep <- "https://github.com/OHI-Science/bhi-1.0-archive/blob/draft/baltic2015/prep"
gh_raw_bhiprep <- "https://raw.githubusercontent.com/OHI-Science/bhi-prep/master/"
gh_layers <- "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"

## Set main App Directory ----
dir_main <- here::here()
if(length(grep("dashboard", dir_main, value = TRUE)) == 0){
  dir_main <- here::here("dashboard")
}

## Creating Shiny content Functions ----
source(file.path(dir_main, "R", "theme.R"))
source(file.path(dir_main, "R", "mapping.R"))
source(file.path(dir_main, "R", "visualization.R"))

source(file.path(dir_main, "modules", "map_card.R"))
source(file.path(dir_main, "modules", "barplot_card.R"))
source(file.path(dir_main, "modules", "flowerplot_card.R"))
source(file.path(dir_main, "modules", "scorebox_card.R"))
source(file.path(dir_main, "modules", "tsplot_card.R"))


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
  box(
    class = "text_link_button",
    h4(strong(a(paste("\n", title), href = url, target = "_blank"))),
    width = box_width,
    height = 65,
    background = "light-blue",
    status = "primary",
    solidHeader = TRUE
  )
}

## Shiny Global Data ----

full_scores_csv <- readr::read_csv(file.path(dir_main, "data", "scores.csv"))
full_scores_lst <- list()
for(g in unique(full_scores_csv$goal)){
  for(d in unique(full_scores_csv$dimension)){
    for(y in as.character(unique(full_scores_csv$year))){
      full_scores_lst[[g]][[d]][[y]] <- full_scores_csv %>% 
        filter(goal == g, dimension == d, year == y)
    }
  }
}
goals_csv <- readr::read_csv(file.path(dir_main, "data", "plot_conf.csv"))
data_info <- readr::read_csv(file.path(dir_main, "data", "data_info.csv"))

regions_df <- readr::read_csv(file.path(dir_main, "data", "regions.csv"))
subbasins_df <- readr::read_csv(file.path(dir_main, "data", "basins.csv"))


rgns_shp <- make_rgn_sf(
  bhi_rgns_shp = read_rds(file.path(dir_main, "data", "regions.rds")), 
  scores_lst = full_scores_lst, 
  goal = "Index", 
  dim = "score", 
  year = assess_year
)
subbasins_shp <- make_subbasin_sf(
  subbasins_shp = read_rds(file.path(dir_main, "data", "subbasins.rds")), 
  scores_lst = full_scores_lst, 
  dim = "score", 
  year = assess_year
)

## theme for shinydash and visualizations
thm <- apply_bhi_theme()

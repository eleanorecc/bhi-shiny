## Libraries, Directories, Paths ----
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(leaflet)
library(DT)
library(DBI)
library(dbplyr)
library(stringr)
library(ggplot2)
library(sp)
library(dplyr)


## Set main App Directory ----
dir_main <- here::here()
if(length(grep("dashboard", dir_main, value = TRUE)) == 0){
  dir_main <- here::here("dashboard")
}


## Assessment Info ----
## global variables/values to be used throughout the app
assess_year <- 2020
bhi_version <- "v2021"
## folder in bhi repo where assessment scores are located
scenario_folder <- "index"

## these urls should point to the most recent versions of everything
## note the raw github urls are invalid; these are used to construct longer, valid urls 
## eg for making data source tables for each goal page from the raw goal prep docs
gh_api_bhiprep <- "https://api.github.com/repos/OHI-Baltic/bhi-prep/git/trees/master?recursive=1"
gh_raw_bhi <- "https://raw.githubusercontent.com/OHI-Baltic/bhi/master"
gh_raw_bhi <- "https://raw.githubusercontent.com/OHI-Baltic/bhi/master"
gh_prep <- "https://github.com/OHI-Baltic/bhi-prep"


## Creating Shiny content Functions ----
source(file.path(dir_main, "theme.R"))
source(file.path(dir_main, "R", "map.R"))
source(file.path(dir_main, "modules", "scorebox_card.R"))
source(file.path(dir_main, "modules", "flowerplot_card.R"))


#' expand contract menu sidebar sub-items
#' 
#' ui function to expand and contract sub-items in menu sidebar
#' from convertMenuItem by Jamie Afflerbach https://github.com/OHI-Northeast/ne-dashboard/tree/master/functions
#' @param mi menu item as created by menuItem function, including sub-items from nested menuSubItem function
#' @param tabName name of the tab that correspond to the mi menu item
#' @return expanded or contracted menu item
convertMenuItem <- function(mi, tabName){
  mi$children[[1]]$attribs['data-toggle'] = "tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class) > 0 && mi$attribs$class == "treeview"){
    mi$attribs$class = NULL
  }
  if(tabName != "explore"){
    mi$children[[1]]$attribs$onclick = "event.stopPropagation()"
  }
  mi
}

#' create text boxes with links
#' 
#' @param title the text to be displayed in the box
#' @param url url the box should link to
#' @param box_width width of box, see shinydashboard::box 'width' argument specifications
text_links <- function(title, style, url){
  box(
    class = "text_link_button",
    list(
      h4(a(paste("\n", title), href = url, target = "_blank", style = paste(style, "font-weight:800;"))),
      p(a("Click for detailed methods, additional figures, and code.", href = url, target = "_blank", style = style))
    ),
    width = 12,
    height = 100,
    background = "light-blue",
    status = "primary",
    solidHeader = TRUE
  )
}



## Data ----
## goals, scores, spatial look ups from database
bhidbconn <- dbConnect(RSQLite::SQLite(), dbname = file.path(dir_main, "data/bhi.db"))
df_goals <- dbReadTable(bhidbconn, "Goals")
df_scores <- dbReadTable(bhidbconn, "IndexScores")
df_subbasins <- dbReadTable(bhidbconn, "Subbasins")
df_regions <- dbReadTable(bhidbconn, "Regions")
dbDisconnect(bhidbconn)

## helpful in some cases to have scores as a list...
## used in map functions currenty
lst_scores <- list()
for(g in unique(df_scores$goal)){
  for(d in unique(df_scores$dimension)){
    for(y in as.character(unique(df_scores$year))){
      lst_scores[[g]][[d]][[y]] <- dplyr::filter(df_scores, goal == g, dimension == d, year == y)
    }
  }
}

## spatial data as spatial polygons not simple features
bhi_rgn_shp <- readr::read_rds(file.path(dir_main, "data", "regions.rds"))
subbasins_shp <- readr::read_rds(file.path(dir_main, "data", "subbasins.rds"))
mpa_shp <- readr::read_rds(file.path(dir_main, "data", "mpas.rds"))


## Theme for shiny dashboard and visualizations ----
thm <- apply_bhi_theme()


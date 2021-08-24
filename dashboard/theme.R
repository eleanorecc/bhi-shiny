apply_bhi_theme <- function(plot_type = NA){
  
  
  ## COLOR PALETTES ----
  palettes <- list(
 
    ## color palette for flowerplot and score cards
    goals_pal = tibble::tibble(
      goal = c("MAR","FIS","FP","CW","CON","EUT","TRA",
               "SP","LSP","ICO","LE","ECO","LIV",
               "AO","TR","CS","NP", "BD"),
      color = c("#549dad","#4ead9d","#53b3ac","#89b181","#60a777","#7ead6d","#9aad7e",
                "#97a4ba","#9fb3d4","#7c96b4","#9a97ba","#7d7ca3","#9990b4",
                "#e2de9a","#b6859a","#d0a6a1","#ccb4be","#88b1a6")),
    
    ## matching BHI goals and shiny/bootstrap colors
    goalpal_shiny = tibble::tibble(
      goal = c("MAR","FIS","FP","CW","CON","EUT","TRA",
               "SP","LSP","ICO","LE","ECO","LIV",
               "AO","TR","CS","NP", "BD"),
      color = c("aqua","aqua","aqua","olive","olive","olive","olive",
                "blue","blue","blue","purple","purple","purple",
                "yellow","red","orange","fuchsia","green")),
    
    
    ## color ramp palette for maps
    mappal = c(
      colorRampPalette(colors = c("#8c031a", "#cc0033"), space = "Lab")(25),
      colorRampPalette(colors = c("#cc0033", "#fff78a"), space = "Lab")(20),
      colorRampPalette(colors = c("#fff78a", "#f6ffb3"), space = "Lab")(20),
      colorRampPalette(colors = c("#f6ffb3", "#009999"), space = "Lab")(15),
      colorRampPalette(colors = c("#009999", "#457da1"), space = "Lab")(5)
    )
    
  ) # end define color palettes
  
  
  ## ICONS ----
  ## these are used in the shiny sidebar 
  ## and in the scorecards in the top right
  icons <- list(
    FP = "utensils", MAR = "anchor", FIS = "fish", AO = "ship",
    CW = "burn", CON = "flask", EUT = "vial", TRA = "eraser",
    SP = "monument", LSP = "map-marked", ICO = "kiwi-bird", BD = "dna",
    LE = "landmark", ECO = "money-bill", LIV = "user-tie",
    TR = "suitcase", CS = "seedling", NP = "mortar-pestle"
  )
  
  ## PLOT ELEMENTS AND COLORS ----
  ## probably don't need all these...??
  cols <- list(
    light_grey1 = "grey95",
    light_grey2 = "grey90",
    light_greygreen = "#eef7f5",
    med_grey1 = "grey80",
    med_grey2 = "grey50",
    med_grey3 = "grey52",
    dark_grey1 = "grey30",
    dark_grey2 = "grey20",
    dark_grey3 = "grey22",
    accent_bright = "maroon",
    map_background1 = "#fcfcfd",
    map_background2 = "#f0e7d6",
    map_background3 = "aliceblue",
    map_polygon_border1 = "#acb9b6",
    map_polygon_border2 = "#b2996c",
    web_font_light1 = "#f0fcdf",
    web_font_light2 = "#f3ffe3",
    web_font_light3 = "#8db1a8",
    web_font <- "#516275",
    web_banner = "#1c3548",
    web_banner_light = "#006687",
    web_sidebar_dark = "#111b19"
  )
  
  
  ## UPDATE THEMES ----
  ## theme updates based on plot type
  theme_update(
    text = element_text(family = "Helvetica", color = cols$dark_grey3, size = 9),
    plot.title = element_text(size = ggplot2::rel(1.25), hjust = 0.5, face = "bold")
  )
  if(!is.na(plot_type)){
    if(plot_type == "flowerplot"){
      theme_update(
        axis.ticks = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(fill = "transparent", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.key = element_rect(colour = NA, fill = NA),
        legend.position = "right",
        axis.line = element_blank(),
        axis.text.y = element_blank()
      )
    }
    if(plot_type == "timeseries"){
      theme_update()
    }
  }
  
  ## RETURN LIST ----
  return(
    list(
      icons = icons,
      cols = cols,
      palettes = palettes
    )
  )
}

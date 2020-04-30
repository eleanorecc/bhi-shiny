## Setting up Dashboard
dashboardPage(
  dashboardHeader(
    title = "Ocean Health Index for the Baltic Sea",
    titleWidth = 380
  ),

  ## DASHBOARD SIDEBAR ----
  dashboardSidebar(
    width = 290,

    setSliderColor("LightSteelBlue", 1),
    chooseSliderSkin("Flat"),

    sidebarMenu(
      ## welcome ----
      menuItem("WELCOME", tabName = "welcome"),
      
      ## learn more ----
      menuItem("LEARN MORE", tabName = "learnmore"),

      ## explore goals ----
      convertMenuItem(
        menuItem(
          "EXPLORE THE GOALS",
          tabName = "explore",
          startExpanded = TRUE,

          ## AO Artisanal Fishing Opportunity
          menuSubItem("Artisanal Fishing Opportunity", tabName = "ao", icon = icon(thm$icons$AO)),

          ## BD Biodiversity
          menuSubItem("Biodiversity", tabName = "bd", icon = icon(thm$icons$BD)),

          ## CS Carbon Storage
          menuSubItem("Carbon Storage", tabName = "cs", icon = icon(thm$icons$CS)),

          ## CW Clean Water
          convertMenuItem(
            menuItem(
              icon = icon(thm$icons$CW),
              "Clean Water",
              tabName = "cw",
              startExpanded = FALSE,

              menuSubItem("Contaminants", tabName = "con"),
              menuSubItem("Eutrophication", tabName = "eut"),
              menuSubItem("Trash", tabName = "tra")
            ), # end clean water menu item
          tabName = "cw"), # end clean water collapse menu item

          ## FP Food Provision
          convertMenuItem(
            menuItem(
              icon = icon(thm$icons$FP),
              "Food Provision",
              tabName = "fp",
              startExpanded = FALSE,

              menuSubItem("Wild-Caught Fisheries", tabName = "fis"),
              menuSubItem("Mariculture", tabName = "mar")
            ), # end food provision menu item
          tabName = "fp"), # end food provision collapse menu item

          ## LE Livelihoods & Economies
          convertMenuItem(
            menuItem(
              icon = icon(thm$icons$LE),
              "Livelihoods & Economies",
              tabName = "le",
              startExpanded = FALSE,

              menuSubItem("Economies", tabName = "eco"),
              menuSubItem("Livelihoods", tabName = "liv")
            ), # end liv and econ menu item
          tabName = "le"), # end liv and econ menu item collapse menu item'

          ## SP Sense of Place
          convertMenuItem(
            menuItem(
              icon = icon(thm$icons$SP),
              "Sense of Place",
              tabName = "sp",
              startExpanded = FALSE,

              menuSubItem("Iconic Species", tabName = "ico"),
              menuSubItem("Lasting Special Places", tabName = "lsp")
            ), # end sense of place menu item
          tabName = "sp"), # end sense of place menu item collapse menu item

          ## NP Natural Products
          menuSubItem("Natural Products", tabName = "np", icon = icon(thm$icons$NP)),

          ## TR Tourism
          menuSubItem("Tourism", tabName = "tr", icon = icon(thm$icons$TR))


        ), # end explore goals menu item
      tabName = "explore"), # end explore goals collapse menu item

      ## compare and summarize ----
      menuItem(
        "COMPARE & SUMMARIZE",
        tabName = "summaries",
        startExpanded = FALSE,

        menuSubItem(
          "Likely Future versus Present",
          tabName = "futures"
        ),
        menuSubItem(
          "Pressures",
          tabName = "pressures"
        ),
        menuSubItem(
          "Scenario Exploration",
          tabName = "scenarios"
        ),
        menuSubItem(
          "Data Layers",
          tabName = "layers"
        )
      ), # end compare and summarize sidebar

      ## view options ----
      menuItem(
        "VIEW OPTIONS",
        tabName = "summaries",
        startExpanded = FALSE,

        ## input year ----
        sliderInput("view_year", "Year", 2012, 2019, 2014, step = 1, sep = ""),

        ## input spatial unit ----
        selectInput(
          "spatial_unit",
          "Spatial Units",
          choices = c(
            `Subbasins` = "subbasins",
            `BHI Regions` = "regions"
          ),
          selected = "subbasins"
        ),

        ## input dimension ----
        selectInput(
          "dimension",
          "Index Dimension",
          choices = c(
            `Score` = "score",
            `Likely Future` = "future",
            `Pressures` = "pressures",
            `Resilience` = "resilience",
            `Current Status` = "status",
            `Short Term Trend` = "trend"
          ),
          selected = "score"
        )
      ) # end view options sidebar

    ) # end sidebarMenu
  ), # end dashboardSidebar

  ## DASHBOARD BODY ----
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
    tags$script(HTML("$('body').addClass('fixed');")), # lock side and top bars

    ## color overrides ----
    ## most of these apply to goal score boxes
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "yellow",
        dplyr::filter(thm$palettes$goals_pal, goal == "AO")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "fuchsia",
        dplyr::filter(thm$palettes$goals_pal, goal == "NP")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "orange",
        dplyr::filter(thm$palettes$goals_pal, goal == "CS")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "red",
        dplyr::filter(thm$palettes$goals_pal, goal == "TR")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "purple",
        dplyr::filter(thm$palettes$goals_pal, goal == "LE")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "green",
        dplyr::filter(thm$palettes$goals_pal, goal == "BD")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "olive",
        dplyr::filter(thm$palettes$goals_pal, goal == "CW")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "blue",
        dplyr::filter(thm$palettes$goals_pal, goal == "SP")$color)
    ),
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "aqua",
        dplyr::filter(thm$palettes$goals_pal, goal == "FP")$color)
    ),
    ## this overrides to make same as dashboard background color
    tags$style(
      type = "text/css",
      sprintf(
        ".bg-%s {background-color: %s!important; }",
        "light-blue",
        "#ecf0f6"
      )
    ),

    ## PAGES ----
    tabItems(
      ## § welcome ----
      tabItem(
        tabName = "welcome",

        ## header and intro
        fluidRow(
          box(
            h1("Ocean Health Dashboard for the Baltic Sea"),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(

          ## flowerplot
          flowerplotCardUI( # flowerplotRgnCardUI(
            id = "baltic_flowerplot",
            title_text = "Flowerplot of Scores",
            sub_title_text = "Ocean Health Index scores are calculated for individual goals separately and then combined to get an overall score on a scale of 0-100. Individual goal scores are represented by the length of the petals in a flower plot below, and the overall Index score for the region is in the center."
          ),

          ## map of overall scores
          tagList(box(
            collapsible = TRUE,
            title = "Map of Index Scores",
            list(
              p("This map shows scores from the previous assessment (2014)", br(), br()), 
              list(addSpinner(leafletOutput("index_map", height = 540), spin = "rotating-plane", color = "#d7e5e8"))
            ),
            width = 7
          ))
        ),
        
        fluidRow(
          box(
            status = "primary",
            # solidHeader = TRUE,
            # title = "Measuring the Health of our Oceans",
            h2("Measuring the Health of our Oceans"),
            p("Oceans provide a diverse array of benefits to humans, often with tradeoffs between benefits. Managing these requires a method that can measure the health status in both a comprehensive and quantitative way. Establishing such a method was the motivation behind the Ocean Health Index (OHI)."),
            p("The Baltic Health Index is a regional study using the OHI method but tailored to assess the health status of the social-ecological system of the Baltic Sea. It is an independent, fully-transparent, scientific index which quantifies the status and trends of nine benefits based on inputs from scientists with expertise in each goal area, and stakeholder perspectives. The assessment of the nine benefits includes food provision, artisanal fishing opportunity, natural products, carbon storage, biodiversity, clean water, tourism, livelihood and economy, sense of place."),
            p("Our overarching aim is  to maintain and continually improve a tool that can be used by decision-makers to guide management of the Baltic Sea region towards increased sustainability. We strive to use the best open source tools available, to make our data preparation, results, calculations, reference levels and underlying data easily accessible and entirely transparent."),
            width =  12
          )
        ),
        fluidRow(
          box(
            solidHeader = TRUE,
            h4("The Baltic Health Index Project"),
            p("Funding for the BHI2.0, started January 2019 and ongoing, comes from the Johansson Family foundation and partly from the Formas-funded project “When the sum is unknown - a concrete approach to disentangle multiple driver impacts on the Baltic Sea ecosystem”(led by Thorsten Blenckner). The first phase was funded by the Johansson Family foundation and the Baltic Ecosystem Adaptive Management, BEAM, a five-year research programme (2010-2014). The project is jointly led by Stockholm Resilience Centre (SRC), at Stockholm University, Sweden together with the Ocean Health Index team. The BHI project is a purely scientific driven project, without any political narratives and no financial interest."),
            p("This trans-disciplinary project is led by Thorsten Blenckner at Stockholm Resilience Centre, Stockholm University and involves many international management organisations and researchers from around the Baltic Sea. Members of the team conducting the first assessment (started in 2015 with preliminary scores completed in 2017) additionally included Jennifer Griffiths, Ning Jiang, Julie Lowndes, Melanie Frazer, and Cornelia Ludwig. Currently, the second assessment is conducted by Eleanore Campbell, Andrea De Cervo, Susa Niiranen and Thorsten Blenckner."),
            width = 12
          )
        )
      ), # end welcome tab
      
      ## § learn more ----
      tabItem(
        tabName = "learnmore",
        
        ## header
        fluidRow(
          box(
            h3("Read and learn more about the Ocean Health Index and the Baltic Sea"),
            br(),
            width = 12
          )
        ),
        ## references list
        fluidRow(
          box(
            solidHeader = TRUE,
            h4("About the Ocean Health Index"),
            br(),
            tags$a(href="https://ohi-science.org/", "The Ocean Health Index, Science Website"),
            br(), br(),
            tags$a(href="https://twitter.com/OHIscience", "Ocean Health Index on Twitter"),
            br(), br(),
            tags$a(href="https://www.cell.com/one-earth/fulltext/S2590-3322(19)30270-2", "NCEAS director Ben Halpern reflects on a Decade of the Ocean Health Index"),
            br(), br(), br(),
            h4("Baltic Health Index Code & Calculations"),
            br(),
            tags$a(href="https://github.com/OHI-Science/bhi", "Baltic Health Index Score Calculations Repository"),
            br(), br(),
            tags$a(href="https://ohi-science.org/bhi-prep/", "Baltic Health Index Data Preparation"),
            br(), br(),
            tags$a(href="https://github.com/OHI-Science/bhi-prep", "Baltic Health Index Data Preparation Code Repository"),
            br(), br(),
            tags$a(href="https://github.com/OHI-Science/ohicore", "Ocean Health Index Core, Functions to combine Goals and Dimensions"),
            br(), br(), br(),
            h4("Other Regional OHI Assessments"),
            br(),
            tags$a(href="https://ohi-science.org/projects/ohi-assessments/", "OHI Regional Assessments, Around the Globe"),
            br(), br(),
            tags$a(href="https://ohi-northeast.shinyapps.io/ne-dashboard/", "Shiny Dashboard for the OHI Northeast, USA"),
            br(), br(), br(),
            h4("Assorted Articles about OHI Assessments & Guiding Principles"),
            br(),
            tags$a(href="https://ohi-science.org/news/transparent-trust-new-england-seas", "A case study about transparency in the Ocean Health Index"),
            br(), br(),
            tags$a(href="https://www.nature.com/articles/s41559-017-0160", "Better Science in Less Time, Lowndes et al."),
            br(), br(), br(),
            width = 12
          )
        )

      ), # end learnmore tab

## § (AO) Artisanal Fishing Opportunity ----
## Artisanal Fishing Opportunity
tabItem(
  tabName = "ao",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Artisanal Fishing Opportunity"),
      width = 8
    ),
    scoreBoxUI(id = "ao_infobox"),
    box(
      # h4(filter(goals_csv, goal == "AO")$short_def),
      h4(filter(goals_csv, goal == "AO")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "ao_map",
      title_text = "Artisanal Fishing Opportunity Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "ao_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("ao_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/AO/ao_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end AO tab item

## § (BD) Biodiversity ----
## Biodiversity
tabItem(
  tabName = "bd",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Biodiversity"),
      width = 8
    ),
    scoreBoxUI(id = "bd_infobox"),
    box(
      # h4(filter(goals_csv, goal == "BD")$short_def),
      h4(filter(goals_csv, goal == "BD")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "bd_map",
      title_text = "Biodiversity Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "bd_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("bd_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/BD/bd_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end BD tab item

## § (CS) Carbon Storage ----
## Carbon Storage
tabItem(
  tabName = "cs",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Carbon Storage"),
      width = 8
    ),
    scoreBoxUI(id = "cs_infobox"),
    box(
      # h4(filter(goals_csv, goal == "CS")$short_def),
      h4(filter(goals_csv, goal == "CS")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "cs_map",
      title_text = "Carbon Storage Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "cs_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("cs_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/CS/cs_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end CS tab item

## § (CW) Clean Waters ----
## Clean Waters
tabItem(
  tabName = "cw",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Clean Waters"),
      width = 8
    ),
    scoreBoxUI(id = "cw_infobox"),
    box(
      # h4(filter(goals_csv, goal == "CW")$short_def),
      h4(filter(goals_csv, goal == "CW")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "cw_map",
      title_text = "Clean Waters Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "cw_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("cw_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/CW/cw_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end CW tab item

## § (CON) Contaminants ----
## Contaminants
tabItem(
  tabName = "con",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Contaminants"),
      width = 8
    ),
    scoreBoxUI(id = "con_infobox"),
    box(
      # h4(filter(goals_csv, goal == "CON")$short_def),
      h4(filter(goals_csv, goal == "CON")$description),
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    box(
      title = "Key Information", 
      status = "primary", 
      solidHeader = TRUE,
      "Four indicators are combined in this subgoal: the contamination levels of three pollutants/pollutant groups (PCBs, PFOS, and Dioxins), and the proportion of persistent, bioaccumulative and toxic Substances of Very High Concern (SVHC) monitored.",
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Contamination levels of the three pollutants/pollutant groups fall below their respective thresholds. All persistent, bioaccumulative and toxic Substances of Very High Concern are monitored.",
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "con_map",
      title_text = "Contaminants Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "con_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key messages, timeseries plot, and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Messages",
      status = "primary", 
      solidHeader = TRUE,
      "Present-day concentrations of the three pollutants/pollutant groups included in the subgoal generally fall below their relative thresholds, particularly concentrations measured in biota (i.e., fish). The concentrations found in sediments (top 5cm) more often exceed their respective thresholds, reflecting the higher historic concentrations of the contaminants in the Baltic Sea mirrored in subsurface sediment. However, there are many persistent, bioaccumulative and toxic Substances of Very High Concern which are not  monitored across all regions of the Baltic Sea, which lowers the score. The level to which compounds known to be hazardous are monitored in the Baltic Sea is included as an indicator to illustrate that a proper assessment cannot be done due to lack of knowledge on occurrence of pollutants in the Baltic Sea."
    )
  ),
  fluidRow(
    tsplotCardUI(
      id = "con_tsplot",
      title_text = "Contaminants Data Layers",
      sub_title_text = "",
      ht = 340,
      select_choices = list(
        `PCBs in Biota` = "cw_con_pcb_bhi2019_bio",
`PCBs in Sediments` = "cw_con_pcb_bhi2019_sed",
`PFOS in Biota` = "cw_con_pfos_bhi2019_bio",
`Dioxins in Biota` = "cw_con_dioxin_bhi2019_bio",
`Dioxins in Sediments` = "cw_con_dioxin_bhi2019_sed"
      )
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("con_datatable")
    )
  ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      "http://ohi-science.org/bhi-prep/contaminants-clean-water-subgoal.html"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
	 tags$b("Spatial variability:"),
	 "Some of the assessment regions have many more data points upon which to base the calculation. As a result, the statistical uncertainty of the scores differs substantially across regions. Generally, there is less data on pollutants/pollutant groups from the southeast near the Baltic states and Poland and Russia. " 
	),
tags$li(
	 tags$b("Thresholds:"),
	 "The threshold values that are used to compare environmental concentrations are crucial for the assessment. Existing threshold values are generated in different ways and have different sources and thus there might be some uncertainty. " 
	),
tags$li(
	 tags$b("Substances of Very High Concern:"),
	 "The proportion of persistent, bioaccumulative and toxic Substances of Very High Concern monitored in the Baltic Sea is used as one of the indicators to highlight the general lack of knowledge on occurrence of emerging contaminants in the Baltic Sea. This indicator and how it is used to calculate the score can be developed further to better combine the two aspects of the contaminant goal: current health of the Baltic Sea, and lack of data." 
	)
      )
    )
  )
), # end CON tab item

## § (EUT) Eutrophication ----
## Eutrophication
tabItem(
  tabName = "eut",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Eutrophication"),
      width = 8
    ),
    scoreBoxUI(id = "eut_infobox"),
    box(
      # h4(filter(goals_csv, goal == "EUT")$short_def),
      h4(filter(goals_csv, goal == "EUT")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "eut_map",
      title_text = "Eutrophication Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "eut_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("eut_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/EUT/eut_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end EUT tab item

## § (TRA) Trash ----
## Trash
tabItem(
  tabName = "tra",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Trash"),
      width = 8
    ),
    scoreBoxUI(id = "tra_infobox"),
    box(
      # h4(filter(goals_csv, goal == "TRA")$short_def),
      h4(filter(goals_csv, goal == "TRA")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "tra_map",
      title_text = "Trash Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "tra_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("tra_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/TRA/tra_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end TRA tab item

## § (FP) Food Provision ----
## Food Provision
tabItem(
  tabName = "fp",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Food Provision"),
      width = 8
    ),
    scoreBoxUI(id = "fp_infobox"),
    box(
      # h4(filter(goals_csv, goal == "FP")$short_def),
      h4(filter(goals_csv, goal == "FP")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "fp_map",
      title_text = "Food Provision Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "fp_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("fp_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/FP/fp_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end FP tab item

## § (FIS) Fisheries ----
## Fisheries
tabItem(
  tabName = "fis",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Fisheries"),
      width = 8
    ),
    scoreBoxUI(id = "fis_infobox"),
    box(
      # h4(filter(goals_csv, goal == "FIS")$short_def),
      h4(filter(goals_csv, goal == "FIS")$description),
      width = 12
    )
  ),
  
  ## target info and key information
  fluidRow(
    box(
      title = "Key Information", 
      status = "primary", 
      solidHeader = TRUE,
      "Cod and herring stocks in the Baltic Sea were included as wild-caught fisheries.",
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "All harvested stocks are neither overfished nor underfished but rather fished at maximum sustainable yield.",
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "fis_map",
      title_text = "Fisheries Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "fis_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key messages, timeseries plot, and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Messages",
      status = "primary", 
      solidHeader = TRUE,
      ""
    )
  ),
  fluidRow(
    tsplotCardUI(
      id = "fis_tsplot",
      title_text = "Fisheries Data Layers",
      sub_title_text = "",
      ht = 510,
      select_choices = list(
        `Cod biomass at sea normalized by spawning stock biomass` = "fis_bbmsy_bhi2019_cod",
	`Herring biomass at sea normalized by spawning stock biomass` = "fis_bbmsy_bhi2019_herring",
	`Cod fishing mortality normalized by fishing mortality at max. sustainable yield` = "fis_ffmsy_bhi2019_cod",
	`Herring fishing mortality normalized by fishing mortality at max. sustainable yield` = "fis_ffmsy_bhi2019_herring",
	`Cod landings (tonnes)` = "fis_landings_bhi2019_cod",
	`Herring landings (tonnes)` = "fis_landings_bhi2019_herring"
      )
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("fis_datatable")
    )
  ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      "http://ohi-science.org/bhi-prep/wild-caught-fisheries-food-provision-subgoal.html"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      ## data considerations and improvements bullets
      tags$ul(
        tags$li(
	 tags$b("Different Spatial Assessment Areas:"),
	 "" 
	)
      )
    )
  )
), # end FIS tab item

## § (MAR) Mariculture ----
## Mariculture
tabItem(
  tabName = "mar",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Mariculture"),
      width = 8
    ),
    scoreBoxUI(id = "mar_infobox"),
    box(
      # h4(filter(goals_csv, goal == "MAR")$short_def),
      h4(filter(goals_csv, goal == "MAR")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "mar_map",
      title_text = "Mariculture Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "mar_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("mar_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      "http://ohi-science.org/bhi-prep/mariculture-food-provision-subgoal.html"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end MAR tab item

## § (LE) Coastal Livelihoods & Economies ----
## Coastal Livelihoods & Economies
tabItem(
  tabName = "le",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Coastal Livelihoods & Economies"),
      width = 8
    ),
    scoreBoxUI(id = "le_infobox"),
    box(
      # h4(filter(goals_csv, goal == "LE")$short_def),
      h4(filter(goals_csv, goal == "LE")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "le_map",
      title_text = "Coastal Livelihoods & Economies Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "le_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("le_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/LE/le_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end LE tab item

## § (ECO) Economies ----
## Economies
tabItem(
  tabName = "eco",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Economies"),
      width = 8
    ),
    scoreBoxUI(id = "eco_infobox"),
    box(
      # h4(filter(goals_csv, goal == "ECO")$short_def),
      h4(filter(goals_csv, goal == "ECO")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "eco_map",
      title_text = "Economies Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "eco_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("eco_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/ECO/eco_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end ECO tab item

## § (LIV) Livelihoods ----
## Livelihoods
tabItem(
  tabName = "liv",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Livelihoods"),
      width = 8
    ),
    scoreBoxUI(id = "liv_infobox"),
    box(
      # h4(filter(goals_csv, goal == "LIV")$short_def),
      h4(filter(goals_csv, goal == "LIV")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "liv_map",
      title_text = "Livelihoods Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "liv_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("liv_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/LIV/liv_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end LIV tab item

## § (SP) Sense of Place ----
## Sense of Place
tabItem(
  tabName = "sp",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Sense of Place"),
      width = 8
    ),
    scoreBoxUI(id = "sp_infobox"),
    box(
      # h4(filter(goals_csv, goal == "SP")$short_def),
      h4(filter(goals_csv, goal == "SP")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "sp_map",
      title_text = "Sense of Place Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "sp_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("sp_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/SP/sp_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end SP tab item

## § (ICO) Iconic Species ----
## Iconic Species
tabItem(
  tabName = "ico",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Iconic Species"),
      width = 8
    ),
    scoreBoxUI(id = "ico_infobox"),
    box(
      # h4(filter(goals_csv, goal == "ICO")$short_def),
      h4(filter(goals_csv, goal == "ICO")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "ico_map",
      title_text = "Iconic Species Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "ico_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("ico_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/ICO/ico_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end ICO tab item

## § (LSP) Lasting Special Places ----
## Lasting Special Places
tabItem(
  tabName = "lsp",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Lasting Special Places"),
      width = 8
    ),
    scoreBoxUI(id = "lsp_infobox"),
    box(
      # h4(filter(goals_csv, goal == "LSP")$short_def),
      h4(filter(goals_csv, goal == "LSP")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "lsp_map",
      title_text = "Lasting Special Places Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "lsp_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("lsp_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/LSP/lsp_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end LSP tab item

## § (NP) Natural Products ----
## Natural Products
tabItem(
  tabName = "np",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Natural Products"),
      width = 8
    ),
    scoreBoxUI(id = "np_infobox"),
    box(
      # h4(filter(goals_csv, goal == "NP")$short_def),
      h4(filter(goals_csv, goal == "NP")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "np_map",
      title_text = "Natural Products Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "np_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("np_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/NP/np_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end NP tab item

## § (TR) Tourism & Recreation ----
## Tourism & Recreation
tabItem(
  tabName = "tr",
  
  ## header with scorebox and goal intro
  fluidRow(
    box(
      h1("Tourism & Recreation"),
      width = 8
    ),
    scoreBoxUI(id = "tr_infobox"),
    box(
      # h4(filter(goals_csv, goal == "TR")$short_def),
      h4(filter(goals_csv, goal == "TR")$description),
      width = 12
    )
  ),
  
  ## target info and key messages
  fluidRow(
    box(
      title = "Key Messages", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 8
    ),
    box(
      title = "Target", 
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content", br(),
      width = 4
    )
  ),
  
  ## plots and maps and links
  fluidRow(
    mapCardUI(
      id = "tr_map",
      title_text = "Tourism & Recreation Scores Around the Baltic",
      sub_title_text = "This map shows scores from the previous assessment (2014)",
      br(), 
      box_width = 8,
      ht = 540
    ),
    barplotCardUI(
      id = "tr_barplot",
      title_text = "Shortfall/Headway towards Target",
      sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
      box_width = 4
    )
  ),
  
  ## key information and data layers table
  fluidRow(
    box(
      width = 12, 
      title = "Key Information",
      status = "primary", 
      solidHeader = TRUE,
      "Box content here", br(), "More box content"
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Layers", 
      DT::dataTableOutput("tr_datatable")
    )
  ),
  
  ## additional goal-specific graphs etc
  # fluidRow(
  #   box(
  #     title = "Key Information", 
  #     background = "teal", 
  #     solidHeader = TRUE,
  #     plotOutput("plotename", height = 250)
  #   )
  # ),
  
  ## methods link, plus data considerations, improvements
  fluidRow(
    align = "center",
    text_links(
      "CLICK HERE FOR DETAILED METHODS",
      sprintf("%s/TR/tr_prep.md", gh_prep)
    )
  ),
  fluidRow(
    box(
      collapsible = TRUE,
      collapsed = TRUE,
      width = 12,
      title = "Data Considerations & Potential Improvements",
      "There is always opportunity to improve data quality and availability. Below we have identifed where improving these data could improve our understanding of ocean health",
      br(),
      br(),
      tags$ul(
        tags$li(
          tags$b("Bold text:"),
          "Bullet point one."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point two."
        ),
        tags$li(
          tags$b("Bold text:"),
          "Bullet point three."
        )
      )
    )
  )
), # end TR tab item

      ## § (END) signal end of goals pages stuff for rebuild functions

      ## COMPARE AND SUMMARIZE ----
      ## compare and summarize

      ## § futures ----
      tabItem(
        tabName = "futures",
        fluidRow(
          box(
            h1("Likely Future versus Present"),
            width = 12
          ),
          box(
            p("SOMETHING ABOUT LIKELY FUTURE STATUS AND DIFFERENT DIMENSIONS OF OHI"),
            width = 12
          )
        )
      ), # end futures tab item

      ## § pressures ----
      tabItem(
        tabName = "pressures",
        fluidRow(
          box(
            h1("Pressures (Page Under Construction)", style = "color:#9b363d"),
            width = 12
          ),
          box(
            p("SOMETHING ABOUT BHI PRESSURES, WITH TIME SERIES PLOTS"),
            width = 12
          ),

          ## pressures time series plot
          box(
            width = 9,
            addSpinner(plotlyOutput("pressure_ts", height = "750px"), spin = "rotating-plane", color = "#d7e5e8")
          ),
          ## pressure timeseries plot select var
          box(
            width = 3,
            selectInput(
              "press_var",
              label = "Pressure Variables to Plot",
              choices = c(
                `Eutrophication` = "eut_time_data",
                `Contaminants PCB` = "con_pcb_time_data",
                `Contaminants Dioxin` = "con_dioxin_time_data",
                `Anoxia Pressure` = "anoxia_press",
                `Nitrogen Load Tonnes` = "N_basin_tonnes"
              )
            )
          ) # end pressure timeseries plot select var
        )
      ), # end pressures item
      
      ## § scenarios ----
      tabItem(
        tabName = "scenarios",
        fluidRow(
          box(
            h1("Scenario Exploration"),
            width = 12
          ),
          box(
            p("SOMETHING ABOUT SCENARIOS TESTING APPROACHES, TRIALS, RESULTS"),
            width = 12
          )
        )
      ), # end scenarios item

      ## § layers ----
      tabItem(
        tabName = "layers",
        fluidRow(
          box(
            h1("Data Layers (Page Under Construction)", style = "color:#9b363d"),
            width = 12
          ),
          box(
            p("SOMETHING ABOUT PROCESS OF GENERATING LAYERS, AND LAYER VS LAYER SCATTERPLOT"),
            width = 12
          )
        )
      ) # end layers item
    ) # end tabItems
  ) # end dashboardBody
) # end dashboardPage

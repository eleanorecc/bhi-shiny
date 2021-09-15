## Setting up Dashboard
dashboardPage(
  ## Dashboard Header
  dashboardHeader(
    title = "Ocean Health Index | Baltic Sea",
    titleWidth = 340
  ),
  ## SIDEBAR ----
  dashboardSidebar(
    ## width of sidebar not app title
    width = 290,
    sidebarMenu(
      menuItem("WELCOME", tabName = "welcome"),
      menuItem("MAP", tabName = "map"),
      ### explore goals sidebar ----
      convertMenuItem(
        tabName = "explore",
        menuItem(
          "EXPLORE THE GOALS",
          tabName = "explore",
          startExpanded = FALSE,
          menuSubItem("Artisanal Fishing Opportunity", tabName = "ao", icon = icon(thm$icons$AO)),
          menuSubItem("Biodiversity", tabName = "bd", icon = icon(thm$icons$BD)),
          menuSubItem("Carbon Storage", tabName = "cs", icon = icon(thm$icons$CS)),
          ## SUBMENU - CLEAN WATER
          convertMenuItem(
            menuItem(
              "Clean Water", tabName = "cw",icon = icon(thm$icons$CW),
              startExpanded = FALSE,
              menuSubItem("Contaminants", tabName = "con"),
              menuSubItem("Eutrophication", tabName = "eut"),
              menuSubItem("Trash", tabName = "tra")
            ),
            tabName = "cw"
          ),
          ## SUBMENU - FOOD PROVISION
          convertMenuItem(
            menuItem(
              "Food Provision", tabName = "fp", icon = icon(thm$icons$FP),
              startExpanded = FALSE,
              menuSubItem("Wild-Caught Fisheries", tabName = "fis"),
              menuSubItem("Mariculture", tabName = "mar")
            ),
            tabName = "fp"
          ),
          ## SUBMENU - LIVELIHOODS AND ECONOMIES
          convertMenuItem(
            menuItem(
              "Livelihoods & Economies", tabName = "le", icon = icon(thm$icons$LE),
              startExpanded = FALSE,
              menuSubItem("Economies", tabName = "eco"),
              menuSubItem("Livelihoods", tabName = "liv")
            ),
            tabName = "le"
          ),
          ## SUBMENU - SENSE OF PLACE
          convertMenuItem(
            menuItem(
              "Sense of Place", tabName = "sp", icon = icon(thm$icons$SP),
              startExpanded = FALSE,
              menuSubItem("Iconic Species", tabName = "ico"),
              menuSubItem("Lasting Special Places", tabName = "lsp")
            ),
            tabName = "sp"
          ),
          menuSubItem("Natural Products", tabName = "np", icon = icon(thm$icons$NP)),
          menuSubItem("Tourism", tabName = "tr", icon = icon(thm$icons$TR))
        )
      ),
      menuItem("INDEX CALCULATION", tabName = "indexcalculation"),
      menuItem("LEARN MORE", tabName = "learnmore"),
      menuItem("SHARE FEEDBACK", tabName = "feedback")
    )
  ),
  ## MAIN PANEL ----
  dashboardBody(
    ### additional styling ----
    ## point to stylesheet in www folder
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      ## these tags are for the text info boxes on the goal pages
      ## original colors for final (not beta) app
      # border-color: #246184;
      # background-color: #ffffff;
      # color: #c5cad3;
      tags$style(
        HTML("
          .column_eight {
             border-color: #bbc9da;
             border-width: 1px;
             border-top-width: 3px;
             border-style: solid;
             border-top-style: solid;
             margin: 15px;
             margin-right: 0px;
             margin-top: 0px;
             width: 100%;
             padding: 12px;
             background-color: #f8f9fb;
             color: #a0a9b5;
          }
          .column_four {
             border-color: #bbc9da;
             border-width: 1px;
             border-top-width: 3px;
             border-style: solid;
             border-top-style: solid;
             margin: 15px;
             margin-left: 0px;
             margin-top: 0px;
             width: 96%;
             padding: 12px;
             background-color: #f8f9fb;
             color: #a0a9b5;
          }
          .columns_container {
             display: grid;
             grid-auto-flow: column;
             grid-template-columns: 8fr 4fr;
             gap: 45px;
          } 
          .columns_container_welcome {
             display: grid;
             grid-auto-flow: column;
             grid-template-columns: 7fr 5fr;
             gap: 45px;
          } 
          .welcome_media {
             border-color: #713333;
             border-width: 3px;
             border-top-width: 10px;
             margin: 15px;
             margin-left: 0px;
             margin-top: 0px;
             width: 96%;
             padding: 12px;
             background-color: #8c3636;
          } 
        ")
      )
    ),
    tags$head(tags$style("h4 {color:#3c8dbc;}")),
    tags$script(HTML("$('body').addClass('fixed');")), # lock side and top bars
    tags$script("$(document).on('click', '.sidebar-toggle', function () {Shiny.onInputChange('sidebar_col_react', Math.random())});"), # detect sidebar collapse for map option panel position
    tags$style("@import url(https://use.fontawesome.com/releases/v5.7.2/css/all.css);"),
    
    
    ### color overrides ----
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
        "#557897"
      )
    ),
    
    ## PAGES ----
    tabItems(
      
      ### welcome ----
      tabItem(
        tabName = "welcome",
        fluidRow(tags$div(
          class = "columns_container_welcome",
          column(
            class = "column_eight",
            width = 7,
            flowerplotCardUI(id = "baltic_flowerplot")
          ),
          column(
            class = "column_four",
            width = 5,
            tagList(tags$h4("MEASURING THE HEALTH OF OUR OCEANS")),
            br(),
            status = "primary",
            p("Oceans provide a diverse array of benefits to humans, often with tradeoffs between benefits. Managing these requires a method that can measure the health status in both a comprehensive and quantitative way. Establishing such a method was the motivation behind the Ocean Health Index (OHI).", style = "color:#0c1d1f"),
            p("The Baltic Health Index is a regional study using the OHI method but tailored to assess the health status of the social-ecological system of the Baltic Sea. It is an independent, fully-transparent, scientific index which quantifies the status and trends of nine benefits based on inputs from scientists with expertise in each goal area, and stakeholder perspectives. The assessment of the nine benefits includes food provision, artisanal fishing opportunity, natural products, carbon storage, biodiversity, clean water, tourism, livelihood and economy, sense of place.", style = "color:#0c1d1f"),
            p("Our overarching aim is to maintain and continually improve a tool that can be used by decision-makers to guide management of the Baltic Sea region towards increased sustainability. We strive to use the best open source tools available, to make our data preparation, results, calculations, reference levels and underlying data easily accessible and entirely transparent.", style = "color:#0c1d1f"),
            p("Scores are calculated for individual goals, then combined to get an overall score on a scale of 0-100, where 100 indicates management thresholds are achieved (not necessarily pristine condition).", style = "color:#8c3736"),
            p("Individual goal scores are represented by the lengths of the petals. Scores under 100 indicate failure to reach the 'acceptable' levels decided upon by the relevant governing bodies, and science experts.", style = "color:#8c3736")
          )
        )),
        
        fluidRow(
          tags$div(
            class = "columns_container_welcome",
            column(
              class = "column_eight",
              width = 7,
              h4("THE BALTIC HEALTH INDEX PROJECT"),
              br(),
              p("Funding for the BHI2.0, started January 2019 and ongoing, comes from the Johansson Family foundation and partly from the Formas-funded project “When the sum is unknown - a concrete approach to disentangle multiple driver impacts on the Baltic Sea ecosystem”(led by Thorsten Blenckner). The first phase was funded by the Johansson Family foundation and the Baltic Ecosystem Adaptive Management, BEAM, a five-year research programme (2010-2014). The project is jointly led by Stockholm Resilience Centre (SRC), at Stockholm University, Sweden together with the Ocean Health Index team. The BHI project is a purely scientific driven project, without any political narratives and no financial interest."),
              p("This trans-disciplinary project is led by Thorsten Blenckner at Stockholm Resilience Centre, Stockholm University and involves many international management organisations and researchers from around the Baltic Sea. Members of the team conducting the first assessment (started in 2015 with preliminary scores completed in 2017) additionally included Jennifer Griffiths, Ning Jiang, Julie Lowndes, Melanie Frazer, and Cornelia Ludwig. Currently, the second assessment is conducted by Eleanore Campbell, Andrea De Cervo, Susa Niiranen and Thorsten Blenckner.")
            ),
            column(
              class = "welcome_media",
              solidHeader = TRUE,
              br(),
              column(htmlOutput("iframe_podcast"), width = 12),
              column(
                tags$a(
                  href="https://doi.org/10.1002/pan3.10178",
                  tags$img(src="papergraphic.png", width ="140%", height="150")
                ),
                width = 4
              ),
              column(htmlOutput("iframe_video"), width = 7),
              width = 12
            )
          )
        )
      ),
      
      ### map ----
      tabItem(
        tabName = "map",
        fluidRow(
          column(
            12, offset = 0, 
            leafletOutput("index_map", height = 580)
          )
        ),
        ## map input options in server renderUI
        ## so that its position is responsive to whether sidebar is collapsed
        uiOutput("mapcontrols_panel")
      ),
      
      ### AO ----
      tabItem(
        tabName = "ao",
        ## header with score card
        fluidRow(
          box(
            h1("ARTISANAL FISHING OPPORTUNITY"),
            solidHeader = TRUE,
            width = 8
          ),
          scoreBoxUI(id = "ao_infobox")
        ),
        fluidRow(
          text_links(
            filter(df_goals, goal == "AO")$description,
            "color:#ecebd2;", 
            "https://github.com/OHI-Science/bhi-prep/blob/master/prep/AO/v2019/ao_prep.md"
          )
        ),
        fluidRow(
          box(
            title = h4(strong("CURRENT LIMITATIONS AND WORK OBJECTIVES", style = "color:#e2de9a")),
            p("There is always opportunity to improve data quality and availability. Below we have identified where improving data and/or methods could improve our understanding:", style = "color:#b5b27c"),
            ## data considerations and improvements bullets
            tags$ul(
              tags$li(
                tags$b("Missing country data:"),
                "Missing data for Germany, Poland and Russia (and only key species data for Denmark) which is why there is no scoring for their respective basins. ",
                style = "color:#b5b27c"
              ),
              tags$li(
                tags$b("Multiple facets of opportunity:"),
                "Including ‘need’ and ‘access’ sub-components of this goal alongside the condition of coastal fisheries will give a more complete overview of artisanal fishing opportunity. ",
                style = "color:#b5b27c"
                
              ),
              tags$li(
                tags$b("Sparce Data in some areas:"),
                "In some basins there is very few monitoring stations and scaling up from monitoring station to subbasin does likely not provide a fully representative assessment.",
                style = "color:#b5b27c"
              )
            ),
            br(),
            solidHeader = TRUE,
            width = 12
          )
        ),
        ## four text boxes with background, scoring criteria, pressures, discussion
        fluidRow(
          tags$div(
            class = "columns_container",
            column(
              class = "column_eight",
              width = 8,
              h4("BACKGROUND INFORMATION"),
              p("This goal has three sub-components: stock, access, and need. For the BHI, the focus is on the coastal fish stock sub-component and will use this as a proxy for the entire goal. For this, we used two HELCOM core indicators: (1) abundance of coastal fish key functional groups (Catch-per-unit effort (CPUE) of cyprinids/mesopredators and CPUE of piscivores); (2) abundance of key coastal fish species (CPUE of perch, cod or flounder, depending on the area).")
            ),
            column(
              class = "column_four",
              width = 4,
              h4("PRESSURES ACTING ON THIS GOAL"),
              h5(strong(a(
                paste('\n\u22d9', 'Climate Change'),
                href = sprintf('%s/blob/master/prep/pressures/climate_change/v2019/climate_change_prep.md', gh_prep), 
                target = '_blank',
                style = "color:#83adc5"
              ))), 
              h5(strong(a(
                paste('\n\u22d9', 'Atmospheric Contaminants'),
                href = sprintf('%s/blob/master/prep/pressures/atmos_con/v2019/atmos_con_prep.md', gh_prep), 
                target = '_blank',
                style = "color:#83adc5"
              ))), 
              h5(strong(a(
                paste('\n\u22d9', 'Nutrients Loads'),
                href = sprintf('%s/blob/master/prep/pressures/nutrient_load/v2019/nutrient_load_prep.md', gh_prep), 
                target = '_blank',
                style = "color:#83adc5"
              )))
            )
          )
        ),
        fluidRow(
          tags$div(
            class = "columns_container",
            column(
              class = "column_eight",
              width = 8,
              h4("ADDITIONAL INSIGHTS & DISCUSSION"),
              p("The target is reached in Kattegat (Danish coast), Bornholm Basin (Swedish coast), Eastern Gotland basin (Lithuanian coast), Northern Baltic Proper (Finnish coast), Bothnian Sea (Swedish coast), The Quark (Finnish coast) and Bothnian Bay. The more northern areas, where perch is used as the key species and is more abundant, are in better status compared to more southern areas, where flounder is used as the key species, but in now in lower abudance with respect to the target. Similarly, the status of piscivores is better in more northern areas, whereas the status of cyprinids in more north-eastern areas of the Baltic Sea is not good as a result of too high abundance. In particular, the status scores are low in the Gulf of Riga (Estonian coast), Bay of Mecklenburg (Danish coast), Great Belt, The Sound (Danish coast) and Arkona Basin (Danish coast), due to low abundance of key species and piscivores, and also due to increasing abundance for cyprinids in some coastal areas.")
            ),
            column(
              class = "column_four",
              width = 4,
              h4("SCORING CRITERIA"),
              p("Target values for the status assessments are identified based on site-specific time-series data for each indicator (same as in HELCOM HOLAS II), as coastal fish generally have local population structures, limited migration, and show local responses to environmental change.")
            )
          )
        ),
        fluidRow(
          box(
            collapsible = TRUE,
            collapsed = TRUE,
            solidHeader = TRUE,
            width = 12,
            title = "Data Sources", 
            DT::dataTableOutput("ao_datatable")
          )
        ),
        fluidRow(
          box(
            collapsible = TRUE,
            collapsed = TRUE,
            solidHeader = TRUE,
            width = 12,
            title = "Experts who guided us in the Goal Calculation",
            "Jens Olsson,  ", tags$em(" Institute of Coastal Research, Department of Aquatic Resources, Swedish University of Agricultural Sciences, Öregrund, Sweden") 
          )
        )
      ),
      ### BD ----
      ### CS ----
      ### CW ----
      ### CON ----
      ### EUT ----
      ### TRA ----
      ### FP ----
      ### FIS ----
      ### MAR ----
      ### LE ----
      ### ECO ----
      ### LIV ----
      ### SP ----
      ### ICO ----
      ### LSP ----
      ### NP ----
      ### TR ----
      
      ### learn more ----
      tabItem(
        tabName = "learnmore",
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
      ),
      
      ### feedback ----
      tabItem(
        tabName = "feedback",
        fluidRow(
          box(
            htmlOutput("iframe"),
            width = 12
          )
        )
      )
    )
  )
)

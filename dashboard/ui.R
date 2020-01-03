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

        ## input region ----
        selectInput(
          "flower_rgn",
          "Select Region",
          list(
            `Baltic Sea` = 0,
            `Aland Sea` = c(
              `Aland Sea` = 514,
              `Aland Sea, Sweden` = 35,
              `Aland Sea, Finland` = 36
            ),
            `Arkona Basin` = c(
              `Arkona Basin` = 506,
              `Arkona Basin, Sweden` = 11,
              `Arkona Basin, Denmark` = 12,
              `Arkona Basin, Germany` = 13
            ),
            `Bay of Mecklenburg` = c(
              `Bay of Mecklenburg` = 505,
              `Bay of Mecklenburg, Denmark` = 9,
              `Bay of Mecklenburg, Germany` = 10
            ),
            `Bornholm Basin` = c(
              `Bornholm Basin` = 507,
              `Bornholm Basin, Sweden` = 14,
              `Bornholm Basin, Denmark` = 15,
              `Bornholm Basin, Germany` = 16,
              `Bornholm Basin, Poland` = 17
            ),
            `Bothnian Bay` = c(
              `Bothnian Bay` = 517,
              `Bothnian Bay, Sweden` = 41,
              `Bothnian Bay, Finland` = 42
            ),
            `Bothnian Sea` = c(
              `Bothnian Sea` = 515,
              `Bothnian Sea, Sweden` = 37,
              `Bothnian Sea, Finland` = 38
            ),
            `Eastern Gotland Basin` = c(
              `Eastern Gotland Basin` = 509,
              `Eastern Gotland Basin, Sweden` = 20,
              `Eastern Gotland Basin, Poland` = 21,
              `Eastern Gotland Basin, Russia` = 22,
              `Eastern Gotland Basin, Lithuania` = 23,
              `Eastern Gotland Basin, Latvia` = 24,
              `Eastern Gotland Basin, Estonia` = 25
            ),
            `Gdansk Basin` = c(
              `Gdansk Basin` = 508,
              `Gdansk Basin, Poland` = 18,
              `Gdansk Basin, Russia` = 19
            ),
            `Great Belt` = c(
              `Great Belt` = 502,
              `Great Belt, Denmark` = 3,
              `Great Belt, Germany` = 4
            ),
            `Gulf of Finland` = c(
              `Gulf of Finland` = 513,
              `Gulf of Finland, Finland` = 32,
              `Gulf of Finland, Russia` = 33,
              `Gulf of Finland, Estonia` = 34
            ),
            `Gulf of Riga` = c(
              `Gulf of Riga` = 511,
              `Gulf of Riga, Latvia` = 27,
              `Gulf of Riga, Estonia` = 28
            ),
            `Kattegat` = c(
              `Kattegat` = 501,
              `Kattegat, Sweden` = 1,
              `Kattegat, Denmark` = 2
            ),
            `Kiel Bay` = c(
              `Kiel Bay` = 504,
              `Kiel Bay, Denmark` = 7,
              `Kiel Bay, Germany` = 8
            ),
            `Northern Baltic Proper` = c(
              `Northern Baltic Proper` = 500,
              `Northern Baltic Proper, Sweden` = 29,
              `Northern Baltic Proper, Finland` = 30,
              `Northern Baltic Proper, Estonia` = 31
            ),
            `The Quark` = c(
              `The Quark` = 516,
              `The Quark, Sweden` = 39,
              `The Quark, Finland` = 40
            ),
            `The Sound` = c(
              `The Sound` = 503,
              `The Sound, Sweden` = 5,
              `The Sound, Denmark` = 6
            ),
            `Western Gotland Basin` = c(
              `Western Gotland Basin` = 510,
              `Western Gotland Basin, Sweden` = 26
            )
          )
        ),

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
        fluidRow(
          box(
            h3("How healthy are our oceans?"),
            p("The Baltic Health Index is a regional study under the global Ocean Health Index framework.
              The aim is to maintain and continually improve a tool that can be used by decision-makers to guide management of the Baltic Sea region towards increased sustainability.
              Oceans in general provide a diverse array of benefits to humans, often with tradeoffs between benefits.
              Managing these requires a method of measurement that is both comprehensive and quantitative;
              establishing such a method was the motivation behind the Ocean Health Index.
              We strive to use the best open source tools available, to make our ocean health metrics, results and underlying data easily accessible and entirely transparent."),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(

          ## flowerplot
          flowerplotCardUI( # flowerplotRgnCardUI(
            id = "baltic_flowerplot",
            title_text = "Flowerplot of Scores",
            sub_title_text = "Select region under View Options to visualize region-specific scores."
          ),

          ## map of overall scores, with barplot
          barplotCardUI(
            id = "index_barplot",
            title_text = "Proximity to Target",
            sub_title_text = "",
            box_width = 2
          ),
          mapCardUI(
            id = "index_map",
            title_text = "Map of Index Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 5
          )
        )
      ), # end welcome tab

      ## § (AO) artisanal opp. ----
      ## Artisanal Fishing Opportunity
      tabItem(
        tabName = "ao",
        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Artisanal Fishing Opportunity"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "ao_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "AO")$short_def),
            p(filter(goals_csv, goal == "AO")$description),
            width = 12
          )
        ),
        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "ao_barplot",
            title_text = "Artisanal Fishing Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "ao_map",
            title_text = "Map of Artisanal Fishing Opportunity Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),
          column(
            width = 3,
            text_links(
              "AO DATA PREP",
              sprintf("%s/AO/ao_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "http://ohi-science.org/goals/#artisanal-fishing-opportunities"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/AO/ao_data_database"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end AO tab item

      ## § (BD) biodiversity ----
      ## Biodiversity
      tabItem(
        tabName = "bd",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Biodiversity"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "bd_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "BD")$short_def),
            p(filter(goals_csv, goal == "BD")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "bd_barplot",
            title_text = "Biodiversity Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "bd_map",
            title_text = "Map of Biodiversity Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "BD DATA PREP",
              sprintf("%s/SPP/spp_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "http://ohi-science.org/goals/#biodiversity"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/SPP/spatial_data_prep"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end BD tab item

      ## § (CS) carbon storage ----
      ## Carbon Storage
      tabItem(
        tabName = "cs",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Carbon Storage"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "cs_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "CS")$short_def),
            p(filter(goals_csv, goal == "CS")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "cs_barplot",
            title_text = "",
            box_width = 3
          ),
          mapCardUI(
            id = "cs_map",
            title_text = "Carbon Storage Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6
          ),

          column(
            width = 3,
            text_links(
              "CS DATA PREP",
              sprintf("%s/CS/cs_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "http://ohi-science.org/goals/#carbon-storage"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/CS/zostera_raster"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end CS tab item

      ## § (CW) clean water ----
      ## Clean Water
      tabItem(
        tabName = "cw",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Clean Water"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "cw_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "CW")$short_def),
            p(filter(goals_csv, goal == "CW")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "cw_barplot",
            title_text = "Clean Waters Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "cw_map",
            title_text = "Map of Clean Water Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "CW DATA PREP",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/CW"
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#clean-waters"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end CW tab item

      ## § (CON) contaminants ----
      ## Contaminants
      tabItem(
        tabName = "con",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Contaminants"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "con_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "CON")$short_def),
            p(filter(goals_csv, goal == "CON")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "con_barplot",
            title_text = "Contaminants Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "con_map",
            title_text = "Map of Contaminants Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "CON DATA PREP",
              sprintf("%s/CW/contaminants/contaminants_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#clean-waters"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/CW/contaminants/contaminants_data_database"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
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
            h1("Eutrophication (Restructuring Pages, Example)", style = "color:#9b363d"),
            # h1("Eutrophication"),
            width = 8
          ),
          column(
            width = 4,
            scoreBoxUI(id = "eut_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "EUT")$short_def),
            p(filter(goals_csv, goal == "EUT")$description),
            width = 12
          )
        ),

        ## target info and key messages
        fluidRow(
          box(
            title = "Key Messages",
            status = "info",
            solidHeader = TRUE,
            "Box content here", br(), "More box content", br(),
            width = 8
          ),
          box(
            title = "Target",
            status = "info",
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
            ht = 550
          ),
          barplotCardUI(
            id = "eut_barplot",
            title_text = "Shortfall/Headway towards Eutrophication Target",
            sub_title_text = "Bar lengths represent proximity to target level of 100. Bar thickness indicates region or basin (log-transformed) area.",
            box_width = 4
          )
        ),

        ## key information and data layers table
        fluidRow(
          box(
            width = 12,
            title = "Key Information",
            status = "info",
            solidHeader = TRUE,
            "Box content here", br(), "More box content"
          )
        ),
        fluidRow(
          box(
            collapsible = TRUE,
            # collapsed = TRUE,
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
          column(
            width = 12,
            align = "center",
            text_links(
              "CLICK HERE FOR DETAILED METHODS",
              sprintf("%s/EUT/eut_prep.md", gh_prep)
            )
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

      ## § (TRA) trash ----
      ## Trash
      tabItem(
        tabName = "tra",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Trash"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "tra_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "TRA")$short_def),
            p(filter(goals_csv, goal == "TRA")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "tra_barplot",
            title_text = "Trash Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "tra_map",
            title_text = "Map of  Trash (Clean Water) Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "TRA DATA PREP",
              sprintf("%s/CW/trash/tra_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#clean-waters"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/CW/trash/raw"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end TRA tab item

      ## § (FP) food provision ----
      ## Food Provision
      tabItem(
        tabName = "fp",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Food Provision"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "fp_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "FP")$short_def),
            p(filter(goals_csv, goal == "FP")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "fp_barplot",
            title_text = "Food Provision Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "fp_map",
            title_text = "Map of Food Provision Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "FP DATA PREP",
              sprintf("%s/FP/fp_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#food-provision"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end FP tab item

      ## § (FIS) fisheries ----
      ## Wild-Caught Fisheries
      tabItem(
        tabName = "fis",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Wild-Caught Fisheries"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "fis_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "FIS")$short_def),
            p(filter(goals_csv, goal == "FIS")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "fis_barplot",
            title_text = "Fisheries Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "fis_map",
            title_text = "Map of Wild-Caught Fisheries Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "FIS DATA PREP",
              sprintf("%s/FIS/fis_np_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#food-provision"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/FIS/raw"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end FIS tab item

      ## § (MAR) mariculture ----
      ## Mariculture
      tabItem(
        tabName = "mar",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Mariculture"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "mar_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "MAR")$short_def),
            p(filter(goals_csv, goal == "MAR")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "mar_barplot",
            title_text = "Mariculture Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "mar_map",
            title_text = "Map of Mariculture Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht =  555
          ),

          column(
            width = 3,
            text_links(
              "MAR DATA PREP",
              sprintf("%s/MAR/mar_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#food-provision"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/MAR/mar_data_database"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end MAR tab item

      ## § (LE) livelihoods and econ.----
      ## Livelihoods & Economies
      tabItem(
        tabName = "le",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Livelihoods & Economies"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "le_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "LE")$short_def),
            p(filter(goals_csv, goal == "LE")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "le_barplot",
            title_text = "Livelihoods & Economies Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "le_map",
            title_text = "Map of Coastal Livelihoods & Economies Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#livelihoods-and-economies"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end LE tab item

      ## § (ECO) economies ----
      ## Economies
      tabItem(
        tabName = "eco",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Economies"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "eco_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "ECO")$short_def),
            p(filter(goals_csv, goal == "ECO")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "eco_barplot",
            title_text = "Economies Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "eco_map",
            title_text = "Map of Coastal Economies Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "ECO DATA PREP",
              sprintf("%s/ECO/eco_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#livelihoods-and-economies"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/ECO/eco_data_database"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end ECO tab item

      ## § (LIV) livelihoods ----
      ## Livelihoods
      tabItem(
        tabName = "liv",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Coastal Livelihoods"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "liv_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "LIV")$short_def),
            p(filter(goals_csv, goal == "LIV")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "liv_barplot",
            title_text = "Livelihoods Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "liv_map",
            title_text = "Map of Coastal Livelihoods Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "LIV DATA PREP",
              sprintf("%s/LIV/liv_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#livelihoods-and-economies"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/LIV/liv_data_database"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end LIV tab item

      ## § (SP) sense of place ----
      ## Sense of Place
      tabItem(
        tabName = "sp",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Sense of Place"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "sp_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "SP")$short_def),
            p(filter(goals_csv, goal == "SP")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "sp_barplot",
            title_text = "Sense of Place Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "sp_map",
            title_text = "Map of Sense of Place Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "MEANING OF THE GOAL",
              "http://ohi-science.org/goals/#sense-of-place"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end SP tab item

      ## § (ICO) iconic species ----
      ## Iconic Species
      tabItem(
        tabName = "ico",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Iconic Species"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "ico_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "ICO")$short_def),
            p(filter(goals_csv, goal == "ICO")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "ico_barplot",
            title_text = "Iconic Species Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "ico_map",
            title_text = "Map of Iconic Species Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "ICO DATA PREP",
              sprintf("%s/ICO/ico_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "http://ohi-science.org/goals/#sense-of-place"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/ICO/data_database"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end ICO tab item

      ## § (LSP) lasting special places ----
      ## Lasting Special Places
      tabItem(
        tabName = "lsp",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Lasting Special Places"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "lsp_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "LSP")$short_def),
            p(filter(goals_csv, goal == "LSP")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "lsp_barplot",
            title_text = "Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "lsp_map",
            title_text = "Map of Lasting Special Places Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "LSP DATA PREP",
              sprintf("%s/LSP/lsp_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "http://ohi-science.org/goals/#sense-of-place"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/LSP/mpa_data_database"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end LSP tab item

      ## § (NP) natrual products ----
      ## Natural Products
      tabItem(
        tabName = "np",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Natural Products"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "np_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "NP")$short_def),
            p(filter(goals_csv, goal == "NP")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "np_barplot",
            title_text = "Natural Products Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "np_map",
            title_text = "Natural Products Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "NP DATA PREP",
              sprintf("%s/NP/np_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#natural-products"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end NP tab item

      ## § (TR) tourism ----
      ## Tourism
      tabItem(
        tabName = "tr",

        ## header with scorebox and goal intro
        fluidRow(
          box(
            h1("Tourism"),
            width = 9
          ),
          column(
            width = 3,
            scoreBoxUI(id = "tr_infobox")
          ),
          box(
            h4(filter(goals_csv, goal == "TR")$short_def),
            p(filter(goals_csv, goal == "TR")$description),
            width = 12
          )
        ),

        ## plots and maps and links
        fluidRow(
          barplotCardUI(
            id = "tr_barplot",
            title_text = "Tourism Goal Headway",
            sub_title_text = "Environmental benefit versus work still to be done. Bar lengths represent proximity to target level of 100, widths are region or basin (log-transformed) area.",
            box_width = 3
          ),
          mapCardUI(
            id = "tr_map",
            title_text = "Map of Tourism Scores",
            sub_title_text = "This map shows scores from the previous assessment (2014)",
            box_width = 6,
            ht = 555
          ),

          column(
            width = 3,
            text_links(
              "TR DATA PREP",
              sprintf("%s/TR/tr_prep.md", gh_prep)
            ),
            text_links(
              "MEANING OF THE GOAL",
              "https://ohi-science.org/goals/#tourism-and-recreation"
            ),
            text_links(
              "GOAL DATA",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/prep/TR/tr_data_database"
            ),
            text_links(
              "ALL DATA LAYERS",
              "https://github.com/OHI-Science/bhi-1.0-archive/tree/draft/baltic2015/layers"
            )
          )
        )
      ), # end TR tab item

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
          ),

          ## scatterplot from selected layers
          box(
            width = 9,
            plotOutput("layers_scatter")
          )
          ## layers scatterplot select vars ----
          # box(
          #   width = 3,
          #   selectInput(
          #     "layerscatter_var_x",
          #     label = "Select Layer X",
          #     choices = c()
          #   ),
          #   selectInput(
          #     "layerscatter_var_y",
          #     label = "Select Layer Y",
          #     choices = c()
          #   ),
          #   selectizeInput(
          #     "layers_dt_vars",
          #     label = "Data Table Variables",
          #     choices = c()
          #   )
          # ) # end layers scatterplot select vars
        ),
        fluidRow(
          box(
            width = 12,
            DTOutput("layers_datatab")
          )
        )
      ) # end layers item
    ) # end tabItems
  ) # end dashboardBody
) # end dashboardPage

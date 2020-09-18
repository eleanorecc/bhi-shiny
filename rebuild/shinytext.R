## AO ----
ao_text <- c(
  ## goal
  "AO",
  ## key information
  "This goal has three sub-components: stock, access, and need. For the BHI, the focus is on the coastal fish stock sub-component and will use this as a proxy for the entire goal. For this, we used two HELCOM core indicators: (1) abundance of coastal fish key functional groups (Catch-per-unit effort (CPUE) of cyprinids/mesopredators and CPUE of piscivores); (2) abundance of key coastal fish species (CPUE of perch, cod or flounder, depending on the area).",
  ## target
  "Target values for the status assessments are identified based on site-specific time-series data for each indicator (same as in HELCOM HOLAS II), as coastal fish generally have local population structures, limited migration, and show local responses to environmental change.",
  ## key messages
  "The target is reached in Kattegat (Danish coast), Bornholm Basin (Swedish coast), Eastern Gotland basin (Lithuanian coast), Northern Baltic Proper (Finnish coast), Bothnian Sea (Swedish coast), The Quark (Finnish coast) and Bothnian Bay. The more northern areas, where perch is used as the key species and is more abundant, are in better status compared to more southern areas, where flounder is used as the key species, but in now in lower abudance with respect to the target. Similarly, the status of piscivores is better in more northern areas, whereas the status of cyprinids in more north-eastern areas of the Baltic Sea is not good as a result of too high abundance. In particular, the status scores are low in the Gulf of Riga (Estonian coast), Bay of Mecklenburg (Danish coast), Great Belt, The Sound (Danish coast) and Arkona Basin (Danish coast), due to low abundance of key species and piscivores, and also due to increasing abundance for cyprinids in some coastal areas.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Missing country data:** Missing data for Germany, Poland and Russia (and only key species data for Denmark) which is why there is no scoring for their respective basins. \n **Multiple facets of opportunity:** Including ‘need’ and ‘access’ sub-components of this goal alongside the condition of coastal fisheries will give a more complete overview of artisanal fishing opportunity. \n **Sparce Data in some areas:** In some basins there is very few monitoring stations and scaling up from monitoring station to subbasin does likely not provide a fully representative assessment.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Jens Olsson **Institute of Coastal Research, Department of Aquatic Resources, Swedish University of Agricultural Sciences, Öregrund, Sweden**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/AO/v2019/ao_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## BD ----
bd_text <- c(
  ## goal
  "BD",
  ## key information
  "This goal consists of five ecosystem components: benthic habitats, pelagic habitats, fish, mammals (seals), and water birds. It has been evaluated using the biological quality ratios and waterbird abundance, derived in the integrated biodiversity assessments from HELCOM (the HELCOM assessment tool: https://github.com/NIVA-Denmark/BalticBOOST), based on core indicators for key species and species groups, including abundance, distribution, productivity, physiological and demographic characteristics (see http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status). 
  \n 
  Statuses of the five components are aggregated first within each component, combining coastal area values with area-weighted averages, then combining the values for coastal and offshore areas of each BHI region with equal weight. A single biodiversity status score per region is calculated as geometric mean of the five components.",
  ## target
  "For the waterbirds, the HELCOM core indicator threshold of 0.75 abundance was used as good status (corresponding to a status score of 100 in BHI). For the other four components (benthic habitats, pelagic habitats, fish, and mammals), a biological quality ratio (BQR) of 0.6 represents good status and was used as here as the target.",
  ## key messages
  "Benthic habitat is not evaluated in The Sound or Kattegat for Denmark. Thus, while the Swedish side of these basins have high scores (100) in this component to counter low scores in other components (birds, The Sound: 58.5 and Kattegat: 52.7;  seals, The Sound: 50), the result is an overall lower score on the Danish side. The dramatically different scores on either side of Gdansk basin (Russia: 32.3, Poland: 69.6) are due to a score of zero for the benthic habitat component on the eastern side. Lowest scores are seen for Bornholm Basin (ranging 24.1 - 39.3) mainly due to low scores in benthic habitat (Denmark and Sweden score zero), seals and fishes components. The lowest scoring across all subbasins is the seals component, with lowest score in Bornholm and Western Gotland basins (10) and only reaching the target in Kattegat. Generally, water birds are in better condition than the other components, though collectively they reach the target only in Bothnian Sea, Bothnian Bay, and The Quark, and very nearly in Kiel Bay.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Temporal data:** The data used here consists of an integrated assessment period (2011-2016), so no trend  was calculated from the same data used in status calculations. The trend dimension included is from the global OHI assessment, which employs a different status calculation approach. \n **Varied habitats and functions:** Including a greater range of more specific habitat types and functional types (in a transparent way), could help make the goal more actionable for managers at local scales.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Andrea Belgrano **Institute of Marine Research, Department of Aquatic Resources, Swedish University of Agricultural Sciences, Lysekil, Sweden** \n Henn Ojaveer **Pärnu College, University of Tartu, Pärnu, Estonia and National Institute of Aquatic Resources, Technical University of Denmark, Lyngby, Denmark**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/BD/v2019/bd_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## CON ----
con_text <- c(
  ## goal
  "CON",
  ## key information
  "Four indicators are combined in this subgoal: the contamination levels of three pollutants/pollutant groups (PCBs, PFOS, and Dioxins), and the monitored proportion of persistent, bioaccumulative and toxic Substances of Very High Concern (SVHC).",
  ## target
  "The target is having all contamination levels of the three pollutants/pollutant groups fall below their respective thresholds, and all persistent, bioaccumulative and toxic Substances of Very High Concern monitored.",
  ## key messages
  "Present-day concentrations of the three pollutants/pollutant groups included in the subgoal generally fall below their relative thresholds, particularly concentrations measured in biota (i.e., fish). The concentrations found in sediments (top 5cm) more often exceed their respective thresholds, reflecting the higher historic concentrations of the contaminants in the Baltic Sea mirrored in subsurface sediment. However, there are many persistent, bioaccumulative and toxic Substances of Very High Concern which are not  monitored across all regions of the Baltic Sea, which lowers the score. The level to which compounds known to be hazardous are monitored in the Baltic Sea is included as an indicator to illustrate that a proper assessment cannot be done due to lack of knowledge on occurrence of pollutants in the Baltic Sea.",
 ## data considerations
 ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
 "**Substances of Very High Concern:** The proportion of persistent, bioaccumulative and toxic Substances of Very High Concern monitored in the Baltic Sea is used as one of the indicators to highlight the general lack of knowledge on occurrence of emerging contaminants in the Baltic Sea. This indicator and how it is used to calculate the score can be developed further to better combine the two aspects of the contaminant goal: current health of the Baltic Sea, and lack of data. \n **Spatial variability:** Some of the assessment regions have many more data points upon which to base the calculation. As a result, the statistical uncertainty of the scores differs substantially across regions. Generally, there is less data on pollutants/pollutant groups from the southeast near the Baltic states and Poland and Russia. \n **Thresholds:** The threshold values that are used to compare environmental concentrations are crucial for the assessment. Existing threshold values are generated in different ways and have different sources and thus there might be some uncertainty.",
 ## experts
 ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
 "Anna Sobek **Department of Environmental Science, Stockholm University, Stockholm, Sweden**",
 ## prep link
 "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CW/contaminants/v2019/con_prep.md",
 ## timeseries plot layers
 paste(
   "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
   "`PCBs in Sediments` = \"cw_con_pcb_bhi2019_sed\"",
   "`PFOS in Biota` = \"cw_con_pfos_bhi2019_bio\"",
   "`Dioxins in Biota` = \"cw_con_dioxin_bhi2019_bio\"", 
   "`Dioxins in Sediments` = \"cw_con_dioxin_bhi2019_sed\"",
   sep = ",\n\t"
 )
)
## CS ----
cs_text <- c(
  ## goal
  "CS",
  ## key information
  "Seagrass (Zostera marina) is an important macrophyte species occurring on shallow sandy bottoms in the Baltic Sea, and observations of Zostera marina were used as an indicator for carbon storage for the Baltic Sea area from HELCOM Red List species list.",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Christoffer Boström **Environmental and Marine Biology, Åbo Akademi University, Åbo, Finland** \n Markku Viitasalo **Finnish Environment Institute SYKE, Helsinki, Finland**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CS/v2019/cs_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## CW ----
cw_text <- c(
  ## goal
  "CW",
  ## key information
  "Seagrass (Zostera marina) is an important macrophyte species occurring on shallow sandy bottoms in the Baltic Sea, and observations of Zostera marina were used as an indicator for carbon storage for the Baltic Sea area from HELCOM Red List species list. ",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "",
c
  "https://github.com/OHI-Science/bhi-prep/tree/master/prep/CW",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## ECO ----
eco_text <- c(
  ## goal
  "ECO",
  ## key information
  "This goal is composed of a single component: revenue (Gross Value Added) as reported in the 2020 EU Blue economy report. Gross value added (GVA) is defined as the value of output less the value of intermediate consumption, and is used to measure the output or contribution of a particular sector. Annual growth rates between 2009 and 2018 are estimated for each of 7 sectors (Coastal tourism, Marine living resources, Marine non-living resources, Marine renewable energy, Maritime transport, Port activities, Shipbuilding and repair), compared to the 1.5% target growth rate (see below), and averaged across sectors, weighted by sectors’ proportions of the total marine economy GVA.",
  ## target
  "The target is having all marine economic sectors achieve an average annual growth rate of 1.5%, which comes the first EU Blue Growth study (https://webgate.ec.europa.eu/maritimeforum/node/3550).",
  ## key messages
  "Marine Non-living Resources is the sector with the most negative growth rate (>5% annual decrease), but only three countries have activities recorded in this category: Germany, Denmark, and Poland. This sector includes extraction and mining (and support activities for extraction) of natural gas and petroleum, salt, sand, clays and kaolin. Germany has negative growth rates also in Maritime Transport and Coastal Tourism which further decreases its score, while substantial growth in marine renewable energy for Denmark (the only country with revenue reported in this sector) largely offsets the contraction in its other sectors. Shipbuilding is a shrinking sector in Latvia, Finland, and Poland. Poland, however, has the highest growth rate in Coastal Tourism. ",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Inclusion of Sustainability Information:** Incorporating information on the sustainability of the different marine sectors and/or activities would help counterbalance penalization for negative economic growth (contraction) associated unsustainable economic activities such as natural gas, petroleum, or sediments extraction. \n **Economic Activities as Pressures:** Extractive economic activities measured in this goal could be included in the index as minor pressures on other goals, in which case the contraction of these sectors would potentially correspond to increases in scores of other goals such as biodiversity or sense of place. \n **Data timeseries:** Data only for years 2009 and 2018 were available by distinct sub-sectors and economic activities in the 2020 EU Blue Economy Report; since the status calculation uses growth rate as a target and only one annual growth rate (CAGR) could be approximated using the two years of data, the OHI trend dimension capturing short-term changes in status (i.e. changes in growth rates for this goal) short-term could not be calculated.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Wilfried Rickels **Kiel Institute for the World Economy, Kiel, Germany**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/ECO/v2019/eco_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## EUT ----
eut_text <- c(
  ## goal
  "EUT",
  ## key information
  "Five indicators are combined in the eutrophication subgoal: offshore Secchi depth, summer chlorophyll-a concentration, oxygen debt and winter concentrations of dissolved inorganic phosphorus (DIP) and nitrogen (DIN). Decreased secchi depth (i.e., increased turbidity) and increased chl-a concentration in the summer are indicators of eutrophication related increase in primary production. Oxygen debt, i.e., “missing” oxygen in relation to fully oxygenated water column in water-bodies that are poorly ventilated, results from increased consumption of oxygen in environments where organic material is decomposed. The oxygen debt indicator is calculated using information from salinity and oxygen profiles at the halocline and below in the deep basins of the Baltic Sea (Baltic Proper and Bornholm Basin) following the methodology of HELCOM (2013, 2018). Phosphorus and nitrogen, on the other hand, are the key limiting nutrients of primary production in the Baltic Sea making the winter concentrations of DIP and DIN indicators of the following summer’s production potential. These five eutrophication indicators are also HELCOM core indicators (Baltic Sea Environmental Proceedings No 143).",
  ## target
  "Winter (December-February) nutrient concentrations (dissolved inorganic phosphorus: DIP and dissolved inorganic nitrogen: DIN), summer (June-September) Chlorophyll a (chl-a) concentrations and annually averaged oxygen debt fall below, and summer secchi depth above, the threshold values defined and used by HELCOM (2013, 2018). Thresholds are basin-specific.",
  ## key messages
  "In general, the eutrophication status is better in the North, particularly in the Bay of Bothnia, and in the South close to the Danish Straits. However, the eutrophication management target is only met in waters around Kattegat. Lower status scores were calculated for the Central Baltic Sea, and the eutrophication status score was lowest in the Gulf of Riga (approx. 50).
  \n 
  The Eutrophication trend from the past 10 years indicates positive development in the areas near the Danish Sounds, where also the current status is good, but also in the Archipelago Sea, and Gulfs of Finland and Gdansk. The trend is negative elsewhere in the Baltic Sea. Based on the trend calculations, most negative development in the near future can be expected in the Gulf of Riga, which already has the lowest status score, as well as in the Quark area. That negative trends are observed in the Gulf of Bothnia, where the status score is relatively high, indicates that even in the “lower-concern” areas one needs to monitor closely the development of eutrophication.
  \n 
  For most basins the Secchi depth target is not met at present and secchi depth is lower than the threshold value, Kattegat being the only exception. Also, the future trend is negative in most basins, excluding Kattegat and the Åland Sea.
  \n 
  The chl-a target threshold was exceeded in all basins, with exception of Kattegat. The trend in chl-a was negative for management (i.e., increase in chl-a) in Central Basins of the Baltic Sea, as well as in the Gulf of Finland. Positive development was seen in the Southern parts and Gulf of Riga.
  \n 
  Present-day oxygen debt is above the threshold both in the Baltic Proper and Bornholm Basin, indicating that the management target has not been met.
  \n 
  For DIN, the management target was only met (i.e., lower DIN values) at the entrance to the Baltic Sea. DIN values highest in comparison to the target were found in Gulfs of Riga and Finland. The future trend is weak, but positive (i.e., decreasing DIN) with the exception of most of the northern Baltic Basins. For DIP, the target threshold was clearly exceeded in most of the basins, and met only in the Bothnian Bay and close to the entrance to the Baltic Sea. The future trend for DIP was clearly negative (i.e., increasing DIP) in the North, while slight positive development was identified in the South.
  ",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Spatial variability:** Some of the assessment regions have more data points upon which to base the calculation. As a result, the statistical uncertainty of the scores can differ across regions. \n **Thresholds:** The threshold values that are the same as used by HELCOM 2018. ",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Vivi Fleming **Finnish Environment Institute SYKE, Helsinki, Finland**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CW/eutrophication/v2019/eut_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## FIS ----
fis_text <- c(
  ## goal
  "FIS",
  ## key information
  "Cod and herring stocks in the Baltic Sea were included as wild-caught fisheries.",
  ## target
  "All harvested stocks are neither overfished nor underfished but rather fished at maximum sustainable yield.",
  ## key messages
  "",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Different Spatial Assessment Areas:** ",
  ### experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Christian Möllmann **Institute for Marine Ecosystem and Fisheries Science, Center for Earth System Research and Sustainability (CEN), University of Hamburg, Hamburg, Germany**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/tree/master/prep/FIS/v2019/fis_np_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "`Cod biomass at sea normalized by spawning stock biomass` = \"fis_bbmsy_bhi2019_cod\"",
    "`Herring biomass at sea normalized by spawning stock biomass` = \"fis_bbmsy_bhi2019_herring\"",
    "`Cod fishing mortality normalized by fishing mortality at max. sustainable yield` = \"fis_ffmsy_bhi2019_cod\"",
    "`Herring fishing mortality normalized by fishing mortality at max. sustainable yield` = \"fis_ffmsy_bhi2019_herring\"",
    "`Cod landings (tonnes)` = \"fis_landings_bhi2019_cod\"",
    "`Herring landings (tonnes)` = \"fis_landings_bhi2019_herring\"",
    sep = ",\n\t"
  )
)
## FP ----
fp_text <- c(
  ## goal
  "FP",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  "",
  ### experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Christian Möllmann **Institute for Marine Ecosystem and Fisheries Science, Center for Earth System Research and Sustainability (CEN), University of Hamburg, Hamburg, Germany**",
  ## prep link
  "",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## ICO ----
ico_text <- c(
  ## goal
  "ICO",
  ## key information
  "The status of iconic species was evaluated using species observational data from the HELCOM database. A subset of species identified as culturally significant in the region included eight fish (cod, flounder, herring, perch, pike, salmon, trout, and sprat), five mammals (grey seal, harbour seal, ringed seal, harbour porpoise, and European otter), and two birds (sea eagle and common eider). The status of each of these iconic species is a numeric weight corresponding to their Red List threat category (ranging from “extinct” to “least concern”) of the International Union for Conservation of Nature (IUCN).",
  ## target
  "A maximum score of 100 will be achieved in the case when all species are categorised as ’Least Concern.’",
  ## key messages
  "Status of iconic species is generally higher in southern basins of the Baltic Sea. More species from the iconic species list are present in the southern basins, including fish species such as flounder (Platichthys flesus) and sprat (Sprattus sprattus) which thrive in higher salinity and are classified on the IUCN scale as ‘least concern’. The different ranges of different seal species also contribute to the pattern of lower scores in the northern basins. Harbour seals (Phoca vitulina vitulina), which are classified as ‘least concern’, are present in the southern but not in the northern basins, while ringed seals (Pusa hispida) classified as ‘vulnerable’ are only present in the northern basins.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Species ranges:** One limitation of the observation data used is larger uncertainties in spatial ranges of rare species. Estimation of rare species could be improved to more confidently represent distributions of species around the Baltic Sea; one way to do this would be using IUCN species range maps to establish species occurrence in relation to their spatial habitat area. \n **Relation to other assessments:** Improve the link between the BHI and the future Biodiversity assessments by IPBES and use the UN Ocean Biodiversity Information System (OBIS) as national and regional assessments will be performed and linked to IPBES in the future. \n **Data consideration:** Lack of quantitative information about the level of effort involved in obtaining the species observations data, or background environmental conditions corresponding to the data points, precludes useful interpretation from observation frequencies of species; rigorous assessment of the historical conditions of all species collectively would require this data which is not readily.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/ICO/v2019/ico_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## LE ----
le_text <- c(
  ## goal
  "LE",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Wilfried Rickels **Kiel Institute for the World Economy, Kiel, Germany**",
  ## prep link
  "",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## LIV ----
liv_text <- c(
  ## goal
  "LIV",
  ## key information
  "Due to an earlier lack of sector-specific employment information, the BHI currently uses overall employment rates in the Baltic coastal regions to represent ocean-dependent livelihood. This approach is based on the e assumption that employment rates in marine sectors are proportional  to those in the coastal regions' economies overall. Subsequent iterations of the BHI will aim to use sector-specific employment data, to more accurately represent the societal value derived from marine livelihoods in the Baltic Sea.  Coastal population and employment are estimated in areas created from intersection of the Eurostat reporting regions (NUTS2) and a buffer zone within 25 km of the coastline extending the BHI region boundaries. From these values, average employment rates in BHI regions are derived to be compared with National employment rates.",
  ## target
  "The reference point is the maximum Region-to-Country employment ratio of the past five years, and highest country employment rate in the last fifteen years. The region-to-country ratio puts the value into local context, then adjusting with respect to highest country employment rate in the last fifteen years from around the Baltic Sea situates the ratio in broader geographic context.",
  ## key messages
  "Scores in the livelihoods goal are high across the entire Baltic Sea with low cross-section  variability, but still provide relevant insights, in particular if the development dimension over time is taken into account. Poland has the lowest score across the Baltic, occurring along the coast of Bornholm Basin, but has a much higher score associated with the areas around Gdansk. The Bornholm Basin region of Poland is the lowest scoring, but also the fastest growing.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Marine sector-specific employment data:** Difficulty in obtaining data on sector-specific employment at a fine enough spatial resolution (Eurostat NUTS3 which distinguishes coastal vs non-coastal regions) has prevented a more focused assessment of marine livelihoods,  beyond the current approach’s rough estimation of livelihoods in coastal areas. \n **Working conditions and Job satisfaction:** Ideally, this goal would also reflect working conditions and job satisfaction associated with livelihoods in marine sectors.",
  # experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Wilfried Rickels **Kiel Institute for the World Economy, Kiel, Germany**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/LIV/v2019/liv_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## LSP ----
lsp_text <- c(
  ## goal
  "LSP",
  ## key information
  "This sub-goal assesses the area of marine protected areas (MPAs) in each BHI region, and their management status, i.e. “designated”, “partly managed” and “managed”.",
  ## target
  "The designation of at least 10% of each BHI region as MPAs with a full implemented management plan, in order to give a fair representation of spatial coverage to the country and its respective basin.",
  ## key messages
  "The areal coverage of MPAs is quite high in almost the whole Baltic Sea,  although many MPAs still need to be enforced. The overall sub-goal score is low as many MPAs are categorized as only “designated” or “partly managed”. However, a few regions with a full implemented management plan have reached the target, such as Åland Sea (Swedish region), Gulf of Finland (Estonian region), Northern Baltic Proper (Estonian region), and Arkona Basin (Swedish region).",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Data delays:** Some of the management plans are outdated, as the data updates are delayed on the HELCOM MPAs webpage (http://mpas.helcom.fi/apex/f?p=103:5::::::). \n **Moving target:** CBD and EU are now discussing on raising the target for protection to 30% of the sea area, in which case will entail the BHI target to be updated accordingly. \n **Mapping values:** Map important conservation, social and cultural places, which people value highly.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Sofia Wikström **Baltic Sea Centre, Stockholm University, Stockholm, Sweden**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/LSP/v2019/lsp_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## MAR ----
mar_text <- c(
  ## goal
  "MAR",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/MAR/v2019/mar_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## NP ----
np_text <- c(
  ## goal
  "NP",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/tree/master/prep/FIS/v2019/fis_np_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## SP ----
sp_text <- c(
  ## goal
  "SP",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "",
  ## prep link
  "",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## TR ----
tr_text <- c(
  ## goal
  "TR",
  ## key information
  "This goal uses data on coastal accommodations (nights stayed in tourist accommodation establishments, in coastal regions) and coastal tourism revenue (gross value added) from the EU Study on Blue Growth. Economic activities categorized under either Accommodation or Transport in the Coastal Tourism sector were included. No sustainability measure of coastal tourism on the Baltic Sea scale was found, and thus this dimension was not included. ",
  ## target
  "Goal status is calculated from ratios of coastal tourism revenue versus nights stayed in tourist accommodation establishments per unit area of coastal regions. The ratios are scaled such that the maximum value corresponds to a status of 100, i.e. the target is the maximum revenue-to-accommodations ratio achieved between 2012 and 2018.",
  ## key messages
  "Tourism potential as measured by this approach is fulfilled to a high degree in Sweden and Finland. The lowest values are associated with Lithuania and Poland, though Poland is catching up in the tourism sector – its economic growth rate in the Coastal Tourism sector is highest of any country around the Baltic Sea. Nights stayed in tourist accommodations per area in Germany is higher on average than for other countries, including Sweden and Finland, but the ratio of the national revenue from coastal tourism activities relative to this value is lower. While this metric reflects to a degree how much people value experiencing different coastal and ocean areas, the unexpectedly low values associated with the German coast could indicate saturation and greater competition driving down marginal returns from tourist accommodations . More research will be needed to evaluate such patterns and underlying causes and subsequently improve the Tourism goal model.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Lack of Sustainability Dimensions or Ecotourism:** no metric of sustainability of coastal tourism on the Baltic Sea scale was found, and thus this dimension was not included. However,  these are important considerations for the BHI as tool for ecosystem-based management, and therefore a priority for inclusion in future iterations of the Index. \n **Connection between Tourism  and Ocean Health:** how dimensions of ocean health affect people’s perceptions and value for spending time in coastal and ocean areas could be explored further, to better model how tourism potential is fulfilled across the Baltic Sea and how it may  respond to management actions or changing environmental conditions. \n **Spatial units:** Data by Eurostat NUTS (Nomenclature of Territorial Units for Statistics) level 3 regions are used to estimate accommodations densities for areas within 25 kilometers of the coastline; coastal tourism revenue is reported by country, presumably derived from data with the same Eurostat NUTS3 spatial assessment units. Better harmonization between datasets of spatial assessment units could improve confidence in results.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/tree/master/prep/TR/v2019/tr_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)
## TRA ----
tra_text <- c(
  ## goal
  "TRA",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CW/trash/v2019/tra_prep.md",
  ## timeseries plot layers
  paste(
    # "`PCBs in Biota` = \"cw_con_pcb_bhi2019_bio\"",
    "",
    sep = ",\n\t"
  )
)

shinytext <- as.data.frame(t(cbind(
  ao_text, bd_text, cs_text,
  cw_text, con_text, eut_text, tra_text,
  fp_text, fis_text, mar_text,
  le_text, eco_text, liv_text,
  sp_text, lsp_text, ico_text,
  np_text, tr_text
)))
colnames(shinytext) <- c("goal", "key_information", "target", "key_messages", "data_considerations", "experts", "prep_link", "tsplot_layers")

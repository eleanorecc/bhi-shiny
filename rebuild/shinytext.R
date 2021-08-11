## AO ----
ao_text <- c(
  ## goal
  "AO",
  ## key information
  "This goal focuses on the coastal fish stock as a proxy for the entire goal and for this, we used two HELCOM core indicators: (1) abundance of coastal fish key functional groups (Catch-per-unit effort (CPUE) of cyprinids/mesopredators); (2) abundance of key coastal fish species (CPUE of perch, cod or flounder, depending on the area).",
  ## target
  "Target values for the status assessments are set based on site-specific time-series data for each indicator (same as in HELCOM HOLAS II), as coastal fish generally have local population structures, limited migration, and show local responses to environmental change.",
  ## key messages
  "There is a clear north-to-south pattern. The status in more northern areas, where perch is used as the key species, is generally better compared to more southern areas, where flounder is used as the key species. Also, the status of cyprinids in more north-eastern areas of the Baltic Sea is not good as a result of too high abundance. The target is reached in the Bothnian Bay and southern Gulf of Riga and Lithuanian coast. Along the Finnish coast the target is close to be reached, except for the Gulf of Finland. The status is poorer and more patchy along the Swedish coast and in the Gulf of Riga. In the Danish waters, the status is generally poor. The status scores are low in the Kattegat, Great Belt, Arkona Basin (Denmark), the Quark (Sweden), Gulf of Finland (Finland) and the Bay of Mecklenburg, due to low abundance of key species, and also due to increasing abundance for cyprinids in some coastal areas. Negative trend in the Eastern Gotland Basin, in the Southern Gulf of Riga and Lithuanian coast. Positive along the Finnish Bothnian Sea coast and Swedish Hanö Bigt coast. No trend in the other areas.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Missing country data:** Missing data for Germany, Poland and Russia (and only key species data for Denmark) which is why there is no scoring for their respective basins. \n **Multiple facets of opportunity:** Including ‘need’ and ‘access’ sub-components of this goal alongside the condition of coastal fisheries will give a more complete overview of artisanal fishing opportunity. \n **Sparce Data in some areas:** In some basins there is very few monitoring stations and scaling up from monitoring station to subbasin does likely not provide a fully representative assessment.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Jens Olsson **Institute of Coastal Research, Department of Aquatic Resources, Swedish University of Agricultural Sciences, Öregrund, Sweden**",
  ## prep link
  "https://github.com/OHI-Baltic/bhi-prep/blob/master/prep/AO/v2021/ao_prep.md",
  ## timeseries plot layers
  paste(
    "`Pressure associated with sea surface temperature` = \"cc_sst_bhi2019\"", 
    "`Pressure associated with salinity of the surface layer` = \"cc_sal_surf_bhi2019\"",
    sep = ",\n\t"
  )
)
## BD ----
bd_text <- c(
  ## goal
  "BD",
  ## key information
  "This goal consists of five components: benthic habitats, pelagic habitats, fish, mammals (seals), and seabirds. It has been evaluated using the biological quality ratios and seabird abundance, derived in the integrated biodiversity assessments from HELCOM (the HELCOM assessment tool: https://github.com/NIVA-Denmark/BalticBOOST). These are based on core indicators for key species and species groups, including abundance, distribution, productivity, physiological and demographic characteristics. 
  \n 
  Statuses of these five biodiversity components are aggregated first within each component, combining coastal area values with area-weighted averages, then combining the values for coastal and offshore areas of each BHI region with equal weight. A single biodiversity status score per region is calculated as geometric mean of the five components. More detailed information on the indicators and the biodiversity assessment can be found at HELCOM (http://stateofthebalticsea.helcom.fi/biodiversity-and-its-status/).",
  ## target
  "For the seabirds, the HELCOM core indicator threshold of 0.75 abundance, decided by HELCOM, was used as good status (corresponding to a status score of 100 in BHI). For the other four components (benthic habitats, pelagic habitats, fish, and mammals), a biological quality ratio (BQR) of 0.6 was developed by HELCOM with the aim to represent good status and was used as here as the target.",
  ## key messages
  "In general, the northern Baltic Sea obtained relatively high biodiversity status scores (variability range 90-92) with the highest record in Bothnian Sea (92). Lowest scores were obtained for the Bornholm Basin (variability range 24 - 39) mainly due to low scores in benthic habitat, seals and fish. Central and eastern Baltic Sea is generally characterised by intermediate scores with the biological components often being above the target values of individual components. The lowest scoring across all subbasins was recorded for marine mammals, with the lowest values in the Bornholm and Western Gotland basins (10) and only reaching the target level in Kattegat. Generally, seabirds are in better condition than the other biodiversity components, though collectively they reach the target levels only in Bothnian Sea, Bothnian Bay, and The Quark, and very nearly in Kiel Bay. Benthic habitats score low in the south to central Baltic Sea and Gulf of Finland and the pelagic habitat score low in Gulf of Riga and Finland.",
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
    "`Perfluorooctanesulfonic acid (PFOS) average concentrations (ug/kg)` = \"cw_con_pfos_bhi2019_bio\"", 
    "`Perfluorooctanesulfonic acid (PFOS) average concentrations (ug/kg)` = \"cw_con_pfos_bhi2019_sed\"", 
    "`Proportions of monitored Substances of Very High Concern (from European Chemical Agency Candidate List)` = \"cw_con_penalty_bhi2019\"", 
    "`Average PCBs concentrations (ug/kg, six congeners: CB28, CB52, CB101, CB138, CB153, CB180, a d CB118 in sediments)` = \"cw_con_pcb_bhi2019_bio\"", 
    "`Average PCBs concentrations (ug/kg, six congeners: CB28, CB52, CB101, CB138, CB153, CB180, a d CB118 in sediments)` = \"cw_con_pcb_bhi2019_sed\"", 
    "`Average Dioxin concentrations (ug/kg, includes dioxin-like PCBs)` = \"cw_con_dioxin_bhi2019_bio\"", 
    "`Average Dioxin concentrations (ug/kg, includes dioxin-like PCBs)` = \"cw_con_dioxin_bhi2019_sed\"",
    sep = ",\n\t"
  )
)
## CS ----
cs_text <- c(
  ## goal
  "CS",
  ## key information
  "Highly productive coastal wetland ecosystems, like coastal lagoons, shallow bays and salt marshes, play a significant role in mitigating carbon levels in the Baltic Sea, and observations of coastal lagoons and shallow inlets and bays were used as indicators for carbon storage for the Baltic Sea area from Natura 2000 database.",
  ## target
  "The target follows the conservation objectives that have the following conservation categories: •	A = excellent conservation; •	B = good conservation; •	C = average or reduced conservation. The target is set as ‘B (good conservation) = 100’, while ‘C (average or reduced conservation) = 0.05’.",
  ## key messages
  "The conspicuous salinity gradient influences the seagrass distribution in the Baltic Sea, and there is a decreasing seagrass abundance along with decreasing salinity towards the North-eastern Baltic areas. Hence, regions identified to be unsuitable for seagrass growth (north of the Åland Sea and the Archipelago Sea) have been assigned to no status score. A higher abundance of seagrass was observed in the Southern Baltic basins, especially in The Sound, where the score is higher compared to other areas. Our assessment of the carbon storage goal is hence likely an underestimation of the actual carbon storage potential which may have artificially decreased the overall BHI score in many sub-areas. Better data on distribution (depth limits and areal extent) and function (sequestration rates, transport and burial processes) of marine vegetation are required to accurately assess this goal in the future.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Missing data:** Limited availability of seagrass extent data, only spatial distribution models. \n **Spatial data:** Include spatial data from remote sensing for saltmarshes, sheltered shallow bays, lagoons and reed belts. \n **Inclusion of other indicators:** Include freshwater macrophyte distribution and monitoring data for the northern Baltic areas.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Christoffer Boström **Environmental and Marine Biology, Åbo Akademi University, Åbo, Finland**",
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
  "Three sub-goals for the Clean Waters goal were deemed important for the Baltic Sea: Contaminants, Eutrophication, and Trash. Each of these sub-goals has a status calculated that is geometrically averaged with the others for an overall goal status, and each sub-goal has a unique set of resilience and pressures (more detailed information can be found under the ‘Index calculation’ tab).",
  ## target
  "Each sub-goal has its own set of targets, which are specific to different areas of the Sea and/or monitored substances.",
  ## key messages
  "The overall score for the Clean Waters goal is low (37), especially in south-eastern Baltic basins, where both the Contaminants (34) and Trash sub-goals (25) have low status scores.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Missing aspects:** Including data on macro litter and sea floor litter would result in a more complete assessment for the Trash sub-goal, but these data are not currently available or at least not in a harmonized way. Harmonized data and standardized indicators for marine litter are currently under development, and their inclusion will also help give a more complete picture of Clean Waters in the Baltic Sea. \n **Substances of Very High Concern:** The proportion of persistent, bioaccumulative and toxic Substances of Very High Concern monitored in the Baltic Sea which is used as one of the indicators in the Contaminants sub-goal to highlight the general lack of knowledge on occurrence of emerging contaminants in the Baltic Sea, can be developed further to better combine aspects of current health and lack of monitoring data in the Index. \n **Spatial variability:** Some of the assessment regions have many more data points upon which to base the calculation. As a result, the statistical uncertainty and therefore the confidence of the scores differs substantially across regions. \n **Target:** The threshold values that are used to compare environmental concentrations are crucial for the assessment. Existing threshold values are generated in different ways and have different sources and thus there might be some uncertainty.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Anna Sobek (Contaminants) **Department of Environmental Science, Stockholm University, Stockholm, Sweden** \n Vivi Fleming (Eutrophication) **Finnish Environment Institute SYKE, Helsinki, Finland** \n Gerald Schernewski (Trash) **Leibniz-Institute for Baltic Sea Research, Warnemünde, Germany**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/tree/master/prep/CW",
  ## timeseries plot layers
  paste(
    "`Secchi depth indicator scores` = \"secchi_indicator_status\"", 
    "`Secchi depth indicator scores` = \"secchi_indicator_trend\"", 
    "`PFOS indicator scores` = \"pfos_indicator_status\"", 
    "`PFOS indicator scores` = \"pfos_indicator_trend\"", 
    "`PCBs indicator scores` = \"pcb_indicator_status\"", 
    "`PCBs indicator scores` = \"pcb_indicator_trend\"", 
    "`Oxygen debt indicator scores` = \"oxyg_indicator_status\"", 
    "`Oxygen debt indicator scores` = \"oxyg_indicator_trend\"", 
    "`Dissolved Inorganic Phosphorus indicator scores` = \"dip_indicator_status\"", 
    "`Dissolved Inorganic Phosphorus indicator scores` = \"dip_indicator_trend\"", 
    "`Dioxin indicator scores` = \"dioxin_indicator_status\"", 
    "`Dioxin indicator scores` = \"dioxin_indicator_trend\"", 
    "`Dissolved Inorganic Nitrogen indicator scores` = \"din_indicator_status\"", 
    "`Dissolved Inorganic Nitrogen indicator scores` = \"din_indicator_trend\"", 
    "`Chlorophyll a indicator scores` = \"chla_indicator_status\"", 
    "`Chlorophyll a indicator scores` = \"chla_indicator_trend\"",
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
    "`Gross Value Added (GVA, M€) from Blue Economy sectors` = \"le_eco_yearly_gva_bhi2019_Coastal tourism\"", 
    "`Gross Value Added (GVA, M€) from Blue Economy sectors` = \"le_eco_yearly_gva_bhi2019_Marine living resources\"", 
    "`Gross Value Added (GVA, M€) from Blue Economy sectors` = \"le_eco_yearly_gva_bhi2019_Marine non-living resources\"", 
    "`Gross Value Added (GVA, M€) from Blue Economy sectors` = \"le_eco_yearly_gva_bhi2019_Marine renewable energy\"", 
    "`Gross Value Added (GVA, M€) from Blue Economy sectors` = \"le_eco_yearly_gva_bhi2019_Maritime transport\"", 
    "`Gross Value Added (GVA, M€) from Blue Economy sectors` = \"le_eco_yearly_gva_bhi2019_Port activities\"", 
    "`Gross Value Added (GVA, M€ from Blue Economy sectors` = \"le_eco_yearly_gva_bhi2019_Shipbuilding and repair\"",
    sep = ",\n\t"
  )
)
## EUT ----
eut_text <- c(
  ## goal
  "EUT",
  ## key information
  "Five indicators are combined in the eutrophication subgoal:  Secchi depth and surface chlorophyll-a concentration in the summer period, surface dissolved inorganic phosphorus (DIP) and nitrogen (DIN) concentrations in the winter period and bottom oxygen debt, all measured in open-sea areas with chlorophyll-a measured in coastal areas also. Decreased secchi depth (i.e., decreased water clarity) and increased chl-a concentration in the summer are indicators of eutrophication related increase in primary production. Oxygen debt, i.e., “missing” oxygen in relation to fully oxygenated water column in water-bodies that are poorly ventilated, results from increased consumption of oxygen in environments where organic material is decomposed. The oxygen debt indicator is calculated using information from salinity and oxygen profiles at the halocline and below in the deep basins of the Baltic Sea (Baltic Proper and Bornholm Basin) following the methodology of HELCOM (2013, 2018). Phosphorus and nitrogen, on the other hand, are the key limiting nutrients of primary production in the Baltic Sea making the winter concentrations of DIP and DIN indicators of the following summer’s production potential. These five eutrophication indicators are also HELCOM core indicators (Baltic Sea Environmental Proceedings No 143).",
  ## target
  "Winter (December-February) nutrient concentrations (dissolved inorganic phosphorus: DIP and dissolved inorganic nitrogen: DIN), summer (June-September) Chlorophyll a (chl-a) concentrations, summer Secchi depth and annually averaged oxygen debt do not reach the threshold values of good environmental status, defined and used by HELCOM (2013, 2018). Thresholds are specific to WFD areas and HELCOM subbasin open sea areas.",
  ## key messages
  "In general, the eutrophication status is better in the North, particularly in the Bay of Bothnia, and in the South close to the Danish Straits. However, the eutrophication management targets are only met in waters around Kattegat and Danish Straits for some indicators. Lower status scores were calculated for the Central Baltic Sea, and the eutrophication status score was lowest in the Gulf of Riga (approx. 50).
  \n 
  The Eutrophication trend from the past 10 years indicates positive development in the areas near the Kattegat and Kiel Bay, where the current status is already nearer the management target, but also in the Gulfs of Finland and Gdansk. The trend is negative in the Central Baltic. Based on the current trajectories, most negative development in the near future would be expected in the Gulf of Riga. The Quark area also receives a negative trend, but there is much less data from this area, so confidence in this result is lower than for other areas.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Spatial variability:** : Some of the assessment regions have more data points upon which to base the calculation. As a result, the statistical uncertainty of the scores can differ across regions.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Vivi Fleming **Finnish Environment Institute SYKE, Helsinki, Finland**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/CW/eutrophication/v2019/eut_prep.md",
  ## timeseries plot layers
  paste(
    "`Pressure due to Phosphorus loading` = \"po_pload_bhi2019\"", 
    "`Pressure due to Nitrogen loading` = \"po_nload_bhi2019\"", 
    "`Secchi depth (meters, June-September) measurements` = \"cw_eut_secchi_bhi2019\"", 
    "`Oxygen debt` = \"cw_eut_oxydebt_bhi2019\"",
    sep = ",\n\t"
  )
)
## FIS ----
fis_text <- c(
  ## goal
  "FIS",
  ## key information
  "The data used for this subgoal are based on the two most important commercial important fish species that are used as a food source: cod (two cod stocks) and herring (four herring stocks). As data we used their spawning stock biomasses (SSB) and fishing mortalities (F), derived from stock assessments performed by the International Council for the Exploration of the Sea (ICES) Baltic Fisheries Assessment Working Group (WGBFAS). The current status of the fish stocks is calculated as a function of the ratios between the single species’ current biomasses at sea (B) and the reference biomasses at maximum sustainable yield (BMSY), as well as the ratios between the single species’ current fishing mortalities (F) and the fishing mortalities at maximum sustainable yield (FMSY). These ratios (B/BMSY and F/FMSY) are converted to scores between 0 and 1 using as one component this general relationship.",
  ## target
  "The reference points used for the computation are based on the MSY principle and are described based on a functional relationship between spawning stock biomass and recruitment. MSY means the highest theoretical equilibrium yield that can be continuously taken on average from a stock under existing average environmental conditions without significantly affecting the reproduction process (European Union 2013, World Ocean Review 2013). ",
  ## key messages
  "The overall fisheries status is in general very low and only the Gulf of Riga herring stock is moderate. Therefore, all of the fish species have failed to reach the sustainable fishery target. In particular, Eastern Baltic cod as well as Western Baltic cod and herring stocks are presently depleted and fisheries are restricted or even closed. The results need to be taken with caution because of uncertainties in stock size and fishing mortality estimates at low population sizes. Furthermore, an actual FMSY value for Eastern Baltic cod is presently lacking and the applied value might not reflect the actual low productivity of the stock, because recruitment seems decoupled from spawning stock biomass due to several environmental pressures on Eastern Baltic cod, such as hypoxia, seal predation and liver worm infections.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Additional data:** In the future, we aim to aim to develop an approach that better reflects economic aspects of food provisioning by the Baltic fisheries. Furthermore, we intend to add more fish stocks that maybe more important in the future such as stocks of flatfishes.",
  ### experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Christian Möllmann **Institute for Marine Ecosystem and Fisheries Science, Center for Earth System Research and Sustainability (CEN), University of Hamburg, Hamburg, Germany** \n Stefan Neuenfeldt **National Institute of Aquatic Resources (DTU Aqua), Lyngby, Denmark**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/tree/master/prep/FIS/v2019/fis_np_prep.md",
  ## timeseries plot layers
  paste(
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
  "The Food Provision goal is divided into two sub-goals: Wild-Caught Fisheries and Mariculture. The more seafood harvested or farmed sustainably, the higher the goal score. Due to limited information and data the Mariculture sub-goal could not be assessed.",
  ## target
  "The target used for the Wild-Caught Fisheries sub-goal is based on the Maximum Sustainable Yield (MSY) principle. For the Mariculture sub-goal the aim was to use the maximum nutrient discharge for both phosphorus (P) and nitrogen (N), but due to limited information this could not be assessed.",
  ## key messages
  "The overall score for the Food Provision goal is very low (38). More detailed information is found in the Fisheries sub-goal description.",
  ## data considerations
  "**Complementary Data:** In the future, we aim to aim to develop an approach that better reflects economic aspects of food provisioning by the Baltic fisheries. Furthermore, we intend to add more fish species, such as stocks of flatfishes. \n **Targets and status** In the future we will further test more appropriate targets and status calculations to better reflect the fisheries status situation in the Baltic Sea.",
  ### experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Christian Möllmann **Institute for Marine Ecosystem and Fisheries Science, Center for Earth System Research and Sustainability (CEN), University of Hamburg, Hamburg, Germany** \n Stefan Neuenfeldt **National Institute of Aquatic Resources (DTU Aqua), Lyngby, Denmark**",
  ## prep link
  "",
  ## timeseries plot layers
  paste(
    "`Proportion seafood production from wildcaught fisheries vs. Mariculture production` = \"wildcaught_weight\"",
    sep = ",\n\t"
  )
)
## ICO ----
ico_text <- c(
  ## goal
  "ICO",
  ## key information
  "The status of iconic species was evaluated using species observational data from the HELCOM database. A new international survey in 2021, directed to scientists, stakeholders and general public from all Baltic countries using a questionnaire, identified a subset of species as culturally significant in the region and included eight fish (cod, flounder, herring, perch, pike, salmon, trout, and sprat), four benthic invertebrates (Norway lobster, common shore crab, blue mussel, and the crustacean Saduria entomon), five mammals (grey seal, harbour seal, ringed seal, harbour porpoise, and European otter), three water plants (bladder wrack, eelgrass, and the red seaweed Furcellaria lumbricalis) and ten birds (sea eagle, common eider, long-tailed duck, common tern, common gull, red- and black-throated diver, swan, goose and common merganser). The status for each of these iconic species is based on their Red List threat category (ranging from “extinct” to “least concern”) of the International Union for Conservation of Nature (IUCN).",
  ## target
  "The HELCOM Red List species list, which follows the Red List criteria of the International Union for Conservation of Nature (IUCN 2001, 2003), was used (HELCOM, 2013). A maximum score of 100 will be achieved in case all species are categorised as of ’Least Concern’.",
  ## key messages
  "Status of a number of the iconic species has not reached the management target of the IUCN least concern criteria. This includes three of the mammal species (ringed seal, harbour porpoise, and European otter), four of the bird species (common eider, red- and black-throated loon, long-tailed duck), and one fish species (cod). The number of iconic species differ between the areas, and so does the fraction of species that are not of least concern. Most of the iconic species are present in the southern basins, including fish species such as flounder (Platichthys flesus) and sprat (Sprattus sprattus), which thrive in higher salinity and are classified on the IUCN scale as ‘Least Concern’.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Species ranges:** One limitation of the observation data used is larger uncertainties in spatial ranges of rare species. Estimation of rare species could be improved to more confidently represent distributions of species around the Baltic Sea; one way to do this would be using IUCN species range maps to establish species occurrence in relation to their spatial habitat area. \n **Relation to other assessments:** Improve the link between the BHI and the future Biodiversity assessments by IPBES and use the UN Ocean Biodiversity Information System (OBIS) as national and regional assessments will be performed and linked to IPBES in the future. \n **Data consideration:** Lack of quantitative information about the level of effort involved in obtaining the species observations data, or background environmental conditions corresponding to the data points, precludes useful interpretation from observation frequencies of species; rigorous assessment of the historical conditions of all species collectively would require this data which is not readily.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Sofia Wikström **Baltic Sea Centre, Stockholm University, Stockholm, Sweden** \n Markku Viitasalo **Finnish Environment Institute SYKE, Helsinki, Finland**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/ICO/v2019/ico_prep.md",
  ## timeseries plot layers
  paste(
    "`IUCN Categories for Iconic species of the Baltic Sea` = \"sp_ico_assessments_bhi2019_Fish and Lamprey\"", 
    "`IUCN Categories for Iconic species of the Baltic Sea` = \"sp_ico_assessments_bhi2019_Mammals\"", 
    "`IUCN Categories for Iconic species of the Baltic Sea` = \"sp_ico_assessments_bhi2019_Birds\"",
    sep = ",\n\t"
  )
)
## LE ----
le_text <- c(
  ## goal
  "LE",
  ## key information
  "The jobs and revenue produced from marine-related industries directly benefit those who are employed, but also have important indirect value for community identity, tax revenue, and other related economic and social aspects of a stable coastal economy. The Livelihoods and Economies goal is divided into two sub-goals: **Livelihoods** and **Economies**. Each is measured separately as the number and quality of jobs and the amount of revenue produced are both of considerable interest to stakeholders and governments, and can have different patterns in some cases.",
  ## target
  "The target used for **Livelihoods** sub-goal is the maximum Region-to-Country employment ratio of the past five years, and highest country employment rate in the last fifteen years, whereas for the **Economies** sub-goal is having all marine economic sectors achieve an average annual growth rate of 1.5%.",
  ## key messages
  "The overall score for the Livelihoods and Economies goal is quite high across the entire Baltic Sea, especially along the Swedish basins, where the scores from both the **Livelihoods** and **Economies** sub-goals are quite high. However, the status is generally lower along German basins, where the **Economies** sub-goal scores are lower.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Marine sector-specific employment data:** Difficulty in obtaining data on sector-specific employment at a fine enough spatial resolution (Eurostat NUTS3 which distinguishes coastal vs non-coastal regions) has prevented a more focused assessment of marine livelihoods, beyond the current approach’s rough estimation of livelihoods in coastal areas. \n **Working conditions and Job satisfaction:** Ideally, this goal would also reflect working conditions and job satisfaction associated with livelihoods in marine sectors. \n **•	Inclusion of Sustainability Information:** Incorporating information on the sustainability of the different marine sectors and/or activities would help counterbalance penalization for negative economic growth (contraction) associated unsustainable economic activities such as natural gas, petroleum, or sediments extraction. \n **Economic Activities as Pressures:** Extractive economic activities measured in this goal could be included in the index as minor pressures on other goals, in which case the contraction of these sectors would potentially correspond to increases in scores of other goals such as biodiversity or sense of place. \n **Data timeseries:** Data only for years 2009 and 2018 were available by distinct sub-sectors and economic activities in the 2020 EU Blue Economy Report; since the status calculation uses growth rate as a target and only one annual growth rate (CAGR) could be approximated using the two years of data, the OHI trend dimension capturing short-term changes in status (i.e. changes in growth rates for this goal) short-term could not be calculated.",
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
    "`Estimates of average regional employment rates in the coastal zone, within 25km of the coast` = \"le_liv_regional_employ_bhi2019\"", 
    "`National employment rates in countries bordering the Baltic Sea` = \"le_liv_national_employ_bhi2019\"",
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
  "The areal coverage of MPAs is quite high in almost the whole Baltic Sea, although many MPAs still need to be enforced. The overall sub-goal score is low as many MPAs are categorized as only “designated” or “partly managed”. However, a few regions with a full implemented management plan have reached the target, such as Åland Sea (Swedish region), Gulf of Finland (Estonian region), Northern Baltic Proper (Estonian region), and Arkona Basin (Swedish region).",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Data delays:** Some of the management plans are outdated, as the data updates are delayed on the HELCOM MPAs webpage (http://mpas.helcom.fi/apex/f?p=103:5::::::). \n **Moving target:** The international Convention of Biodiversity (CBD), that is signed by all states around the Baltic Sea, is now discussing on raising the target for protection to 30% of the sea area and EU has already decided on this target in the biodiversity strategy to 2030. This means that the BHI target will likely need to be updated accordingly. \n **Mapping values:** Map important conservation, social and cultural places, which people value highly.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Sofia Wikström **Baltic Sea Centre, Stockholm University, Stockholm, Sweden** \n Markku Viitasalo **Finnish Environment Institute SYKE, Helsinki, Finland**",
  ## prep link
  "https://github.com/OHI-Baltic/bhi-prep/blob/master/prep/LSP/v2021/lsp_prep.md",
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
  "Sustainable mariculture represents a good supplementary opportunity that can support food provisioning needs, especially when considering not compromising the water quality in the farmed area and not relying on wild populations to feed or replenish the cultivated species. However, assessing the sustainable production of farmed fish can be difficult, as information is limited (location of the fish farms, species produced, nutrient and antibiotic release from these farms). Overall, in terms of total fish production, mariculture is at the moment not a large industry in the Baltic Sea, and dominated by rainbow trout production, which was included using available national data.",
  ## target
  "The maximum nutrient discharge for both phosphorus (P) and nitrogen (N) could be used as target for this sub-goal, if information is available. The HELCOM Recommendation, provides a management target that existing and new marine fish farms should not exceed the annual average of 7g of P (total-P) and 50g of N (total-N) per 1kg fish (living weight) produced.",
  ## key messages
  "Despite the production of rainbow trouts in some Baltic countries (Denmark, Germany, Sweden and Finland), there is currently very limited data on nutrient discharge, and therefore the Mariculture sub-goal was not assessed and will not contribute to the overall Food Provision goal score.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Data consistency:** Collect more consistent information and data on mariculture and its sustainable production.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "**No expert for this particular sub-goal**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/blob/master/prep/MAR/v2019/mar_prep.md",
  ## timeseries plot layers
  paste(
    "`Tonnes of seafood (rainbow trout and finfish) produced in Mariculture operations` = \"mar_harvest_bhi2019\"",
    sep = ",\n\t"
  )
)
## NP ----
np_text <- c(
  ## goal
  "NP",
  ## key information
  "This goal was calculated based on data from the pelagic fish sprat (Sprattus sprattus) as this fish is mainly used for fish meal production or animal food. The goal was assessed using spawning stock biomass (SSB) and fishing mortality (F) derived from stock assessments performed by the International Council for the Exploration of the Sea (ICES) Baltic Fisheries Assessment Working Group (WGBFAS). The current status of the sprat stock is calculated as a function of the ratio between the single species current biomass at sea (B) and the reference biomass at maximum sustainable yield (BMSY), as well as the ratio between the single species current fishing mortality (F) and the fishing mortality at maximum sustainable yield (FMSY). In EU fisheries management BMSY is defined as the lower bound to SSB when the stock is fished at FMSY, called MSYBtrigger. These ratios (B/BMSY and F/FMSY) are converted to scores between 0 and 1 using as one component this general relationship. The spatial assessment unit is the whole Baltic Sea. No data for other natural products were readily available at the time of the assessment.",
  ## target
  "The reference points used for the computation are based on the MSY principle and are described as a functional relationship. MSY means the highest theoretical equilibrium yield that can be continuously taken on average from a stock under existing average environmental conditions without significantly affecting the reproduction process (European Union 2013, World Ocean Review 2013).",
  ## key messages
  "The Natural Product score is high (85-94) and has a very low spatial variability, because the ICES sprat assessment unit is the whole Baltic Sea, so the small spatial variability is due to the different pressure and resilience scores in the different regions.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Additional data:** The data used here consists only of one species. In the future we aim to add other species such as blue mussels and macroalgae, to provide a more comprehensive picture of the status of natural products in the Baltic Sea.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "**No expert for this particular goal (some advisement from fisheries goal expert, as used similar models)**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/tree/master/prep/FIS/v2019/fis_np_prep.md",
  ## timeseries plot layers
  paste(
    "`Sprat landings, tonnes` = \"np_landings_bhi2019_sprat\"", 
    "`Fishing mortality normalized by fishing mortality at max. sustainable yield` = \"np_ffmsy_bhi2019_sprat\"", 
    "`Biomass at sea normalized by spawning stock biomass` = \"np_bbmsy_bhi2019_sprat\"",
    sep = ",\n\t"
  )
)
## SP ----
sp_text <- c(
  ## goal
  "SP",
  ## key information
  "The Sense of Place goal is divided into two sub-goals: Iconic Species and Lasting Special Places. The status of Iconic Species was evaluated using species observational data from the HELCOM database, while the Lasting Special Places sub-goal assesses the status of MPAs in the Baltic Sea.",
  ## target
  "The target used for the Iconic Species sub-goal is achieved in case all iconic species (collected based on an international stakeholder survey) are categorised as of ’least concern’ based on IUCN criteria. For the Lasting Special Places sub-goal, the designation of at least 10% of each BHI region as MPAs with a full implemented management plan is used as the target.",
  ## key messages
  "The overall score for the Sense of Place goal is moderately high (73), mainly due to the overall good status of iconic species (88), although the overall status of MPAs is generally low (58), as areal coverage is quite high yet many need to be enforced through fully implemented management plans.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Species ranges:** One limitation of the observation data used is larger uncertainties in spatial ranges of rare species. Estimation of rare species could be improved to more confidently represent distributions of species around the Baltic Sea; one way to do this would be using IUCN species range maps to establish species occurrence in relation to their spatial habitat area. \n **Relation to other assessments:** Improve the link between the BHI and the future Biodiversity assessments by IPBES and use the UN Ocean Biodiversity Information System (OBIS) as national and regional assessments will be performed and linked to IPBES in the future. \n **Data consideration:** Lack of quantitative information about the level of effort involved in obtaining the species observations data, or background environmental conditions corresponding to the data points, precludes useful interpretation from observation frequencies of species; rigorous assessment of the historical conditions of all species collectively would require this data which is not readily. Also, some of the management plans are outdated, as the data updates are delayed on the HELCOM MPAs webpage (http://mpas.helcom.fi/apex/f?p=103:5::::::). \n **Moving target:** CBD and EU are now discussing on raising the target for protection to 30% of the sea area, in which case will entail the BHI target to be updated accordingly. \n **Mapping values:** Map important conservation, social and cultural places, which people value highly.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Sofia Wikström **Baltic Sea Centre, Stockholm University, Stockholm, Sweden**",
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
  "Wilfried Rickels **Kiel Institute for the World Economy, Kiel, Germany**",
  ## prep link
  "https://github.com/OHI-Science/bhi-prep/tree/master/prep/TR/v2019/tr_prep.md",
  ## timeseries plot layers
  paste(
    "`Gross Value Added (GVA, M€) from coastal tourism sectors, accommodations and transport activities` = \"tr_coastal_tourism_gva_bhi2019\"", 
    "`Nights spent in coastal tourist accomodations per square kilometer, from Eurostat NUTS3 reporting regions` = \"tr_accommodations_bhi2019\"", 
    "`Pressure due to lack of water transparency or clarity` = \"po_inverse_secchi_bhi2019\"",
    sep = ",\n\t"
  )
)
## TRA ----
tra_text <- c(
  ## goal
  "TRA",
  ## key information
  "Marine litter (trash) is commonly separated into macro- (> 25 mm), meso- (5-25 mm) and micro-litter (< 5 mm). This sub-goal assesses a region's ability to manage micro-litter as a proxy for litter in order to prevent it from entering the ocean and causing harm to the coastal and marine environments. Marine litter is a large global concern, impacting all marine environments of the world and, therefore, needs to be monitored.",
  ## target
  "The target (good status) for microplastics is defined similar to the MSFD Macro-litter beach monitoring, which corresponds to the 15% of the present state). The Baltic Sea integrated average corresponds to 0.09 particles per m³, therefore the 15% target value for the Baltic Sea is set to 0.0135.",
  ## key messages
  "Trash is a significant issue for the Baltic Sea, as waste in urban areas can find its way to the sea and becomes marine litter, where the extent and impacts are beginning to be understood/well-documented (see http://stateofthebalticsea.helcom.fi/pressures-and-their-status/marine-litter/). The status of microplastics is not good in most of the Baltic Sea basins. In western and northern Baltic Sea countries, a well-developed waste water treatment technology and the high connect degree ensure an efficient removal of microplastics from treated wastewater. Here, high microplastics emissions result from stormwater and sewer overflow events. In eastern Baltic Sea countries, the higher share of untreated wastewater and a lower retention of microplastics in wastewater treatment plants are responsible for high emissions. In general, the microplastic pollution pattern in the Baltic Sea reflects the population number and density of the adjacent coastal and river catchments. Especially in eastern Baltic Sea countries, the ongoing improvement of wastewater treatment causes a positive trend. However, the reduction of microplastic emissions via stormwater and sewer overflow remains a major challenge.",
  ## data considerations
  ## note: each bullet point is separated by \n and each bullet heading is framed in double asterisks
  "**Monitoring:** :** A consistent, harmonized marine micro-, mesolitter does not exist in the Baltic Sea region. A consequence is that pollution assessments are based on model simulations and the results are not validated by field data. \n **Macrolitter:** A standardized monitoring approach for macrolitter at beaches exists and is being implemented in most of the Baltic Sea countries. The time series are still short and a joint Baltic database is only under development. In future, macrolitter might be a suitable additional indicator to assess trash within the BHI. \n **Work-in-progress:** Marine Litter is a descriptor for the Good Environmental Status in the European Marine Strategy Framework Directive (MSFD).  The MSFD requires EU Member States to ensure that properties and quantities of marine litter do not cause harm to the coastal and marine environment.  EU guidance documents for the implementation of beach, floating, seafloor litter, as well as a biota and microlitter monitoring exist. Thresholds and evaluation systems are under discussion and can possibly be used in the next BHI iteration.",
  ## experts
  ## note: each expert on a new line, separate entries with \n and each institution framed in single asterisks
  "Gerald Schernewski **Leibniz-Institute for Baltic Sea Research, Warnemünde, Germany**",
  ## prep link
  "https://github.com/OHI-Baltic/bhi-prep/blob/master/prep/TRA/v2021/tra_prep.md",
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

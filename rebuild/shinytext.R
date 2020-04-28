
ao_text <- c(
  ## goal
  "AO",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
bd_text <- c(
  ## goal
  "BD",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
con_text <- c(
  ## goal
  "CON",
  ## key information
  "Four indicators are combined in this subgoal: the contamination levels of three pollutants/pollutant groups (PCBs, PFOS, and Dioxins), and the proportion of persistent, bioaccumulative and toxic Substances of Very High Concern (SVHC) monitored.",
  ## target
  "Contamination levels of the three pollutants/pollutant groups fall below their respective thresholds. All persistent, bioaccumulative and toxic Substances of Very High Concern are monitored.",
  ## key messages
  "Present-day concentrations of the three pollutants/pollutant groups included in the subgoal generally fall below their relative thresholds, particularly concentrations measured in biota (i.e., fish). The concentrations found in sediments (top 5cm) more often exceed their respective thresholds, reflecting the higher historic concentrations of the contaminants in the Baltic Sea mirrored in subsurface sediment. However, there are many persistent, bioaccumulative and toxic Substances of Very High Concern which are not  monitored across all regions of the Baltic Sea, which lowers the score. The level to which compounds known to be hazardous are monitored in the Baltic Sea is included as an indicator to illustrate that a proper assessment cannot be done due to lack of knowledge on occurrence of pollutants in the Baltic Sea.",
 ## data considerations
 "**Spatial variability:** Some of the assessment regions have many more data points upon which to base the calculation. As a result, the statistical uncertainty of the scores differs substantially across regions. Generally, there is less data on pollutants/pollutant groups from the southeast near the Baltic states and Poland and Russia. \n **Thresholds:** The threshold values that are used to compare environmental concentrations are crucial for the assessment. Existing threshold values are generated in different ways and have different sources and thus there might be some uncertainty. \n **Substances of Very High Concern:** The proportion of persistent, bioaccumulative and toxic Substances of Very High Concern monitored in the Baltic Sea is used as one of the indicators to highlight the general lack of knowledge on occurrence of emerging contaminants in the Baltic Sea. This indicator and how it is used to calculate the score can be developed further to better combine the two aspects of the contaminant goal: current health of the Baltic Sea, and lack of data."
)
cs_text <- c(
  ## goal
  "CS",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
cw_text <- c(
  ## goal
  "CW",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
eco_text <- c(
  ## goal
  "ECO",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
eut_text <- c(
  ## goal
  "EUT",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
fis_text <- c(
  ## goal
  "FIS",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
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
  ""
)
ico_text <- c(
  ## goal
  "ICO",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
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
  ""
)
liv_text <- c(
  ## goal
  "LIV",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
lsp_text <- c(
  ## goal
  "LSP",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
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
  ""
)
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
  ""
)
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
  ""
)
tr_text <- c(
  ## goal
  "TR",
  ## key information
  "",
  ## target
  "",
  ## key messages
  "",
  ## data considerations
  ""
)
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
  ""
)

shinytext <- as.data.frame(t(cbind(
  ao_text, bd_text, cs_text,
  cw_text, con_text, eut_text, tra_text,
  fp_text, fis_text, mar_text,
  le_text, eco_text, liv_text,
  sp_text, lsp_text, ico_text,
  np_text, tr_text
)))
colnames(shinytext) <- c("goal", "key_information", "target", "key_messages", "data_considerations")

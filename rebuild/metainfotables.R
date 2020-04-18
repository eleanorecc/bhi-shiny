

make_data_table <- function(gh_raw_bhiprep, bhi_version){
  
  ## list goal data.rmd files in bhi-prep
  ## read lines in rmds starting at '### 2.1 Datasets' and end at '### 2.2'
  ## identify 4th level headings and bolded lines and linked items
  
  rmds <- sprintf(c(
    "CW/contaminants/%s/con_data", 
    "FIS/%s/fis_np_data",
    "MAR/v2019/mar_data",
    "FIS/%s/fis_np_data"
  ), bhi_version)
  
  goals <- data.frame(
    c("CW", "FP", "FP", "NP"), 
    c("CON", "FIS", "MAR", NA), 
    rmds, 
    stringsAsFactors = FALSE
  )
  colnames(goals) <- c("goal", "subgoal", "rmdlink")
  
  datalyrs_metainfo <- data.frame(
    goal = character(), 
    subgoal = character(), 
    layer = character(), 
    description = character(), 
    source = character(), 
    sourcelink = character(),
    stringsAsFactors = FALSE
  )

  for(g in 1:nrow(goals)){
    
    txt <- readr::read_lines(sprintf("%sdata/%s.rmd", gh_raw_bhiprep, goals[g, "rmdlink"]))
    txt <- txt[grep("^### 2.1 ", txt):grep("^### 2.2 ", txt)]
    
    headers <- c(grep("^#### .*[0-9] ", txt), length(txt))
    boldheaders <- grep("^\\*\\*", txt)
    srclnk <- grep("\\[.*\\]\\(.*\\)|http", txt)
    
    lyr <- c()
    src <- c()
    lnk <- c()
    for(h in 2:length(headers)){
      subheaders <- txt[boldheaders[boldheaders %in% headers[h-1]:(headers[h])]]
      newlyr <- gsub(", $", "", paste(
        gsub("#### .*[0-9] ", "", txt[headers[h-1]]),
        gsub("\\[.*\\]\\(.*\\)", "", gsub("\\*\\*", "", subheaders)),
        sep = ", "
      ))
      lyr <- c(lyr, newlyr)
      
      lyrsrc <- srclnk[srclnk %in% headers[h-1]:headers[h]]
      if(length(lyrsrc) > length(newlyr)){
        lyrsrc <- lyrsrc[grep("eference point .* \\[.*\\]\\(.*\\)|eference point .* http", txt[lyrsrc])]
      }
      for(l in lyrsrc){
        chk <- gsub(".*\\[", "", stringr::str_split(txt[l], "\\]")[[1]][1])
        src <- c(src, ifelse(stringr::str_detect(chk, "http"), "Reference", chk))
        lnk <- c(lnk, gsub("\\)|\\):", "", stringr::str_split(stringr::str_extract(txt[l], "http.*"), " ")[[1]][1]))
      }
    }
    datalyrs_metainfo <- dplyr::bind_cols(
      goal = rep(goals[g, "goal"], length(lyr)),
      subgoal = rep(goals[g, "subgoal"], length(lyr)),
      layer = lyr, 
      description = rep("", length(lyr)), 
      source = src,
      sourcelink = lnk
    ) %>% dplyr::bind_rows(datalyrs_metainfo)
  }
  
  datalyrs_metainfo <- datalyrs_metainfo %>% 
    dplyr::mutate(Source = sprintf(
      "<a href=\"%s\" target = \"_blank\">%s</a>", 
      sourcelink, source
    )) %>%
    mutate(`Goal/Subgoal` = ifelse(is.na(subgoal), goal, subgoal)) %>% 
    rowwise() %>% 
    mutate(goal = list(c(goal, subgoal))) %>% 
    tidyr::unnest(cols = c(goal)) %>% 
    dplyr::filter(!is.na(goal)) %>% 
    dplyr::select(goal, `Goal/Subgoal`, Layer = layer, Description = description, Source)
  
  return(datalyrs_metainfo)
}


gather_key_info <- function(){
  
  
  key_info_table <- data.frame(goal, subgoal, key_messages, target, key_information)
  
  
  return(key_info_table)
}
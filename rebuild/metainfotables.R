

make_data_table <- function(gh_raw_bhiprep){
  
  ## list goal data.rmd files in bhi-prep
  ## read lines in rmds starting at '### 2.1 Datasets' and end at '### 2.2'
  ## identify 4th level headings and bolded lines and linked items
  
  goals <- data.frame(
    goal = c("CW"),
    subgoal = c("CON"),
    datarmdlink = c("CW/contaminants/v2019/con_data"),
    stringsAsFactors = FALSE
  )
  datalyrs_metainfo <- data.frame(
    goal = character(), 
    subgoal = character(), 
    layer = character(), 
    description = character(), 
    source = character(), 
    sourcelink = character(),
    stringsAsFactors = FALSE
  )

  for(g in nrow(goals)){
    
    txt <- readr::read_lines(sprintf("%sdata/%s.rmd", gh_raw_bhiprep, goals[g, "datarmdlink"]))
    txt <- txt[grep("^### 2.1 ", txt):grep("^### 2.2 ", txt)]
    
    headers <- c(grep("^#### ", txt), length(txt))
    boldheaders <- grep("^\\*\\*", txt)
    srclnk <- grep("\\[.*\\]\\(.*\\)|http", txt)
    
    lyr <- c()
    for(h in 2:length(headers)){
      lyr <- c(lyr, gsub(", $", "", paste(
        gsub("####.*[0-9] ", "", txt[headers[h-1]]),
        gsub("\\*\\*", "", txt[boldheaders[boldheaders %in% headers[h-1]:(headers[h])]]),
        sep = ", "
      )))
    }
    src <- c()
    lnk <- c()
    for(l in srclnk){
      chk <- gsub(".*\\[", "", stringr::str_split(txt[l], "\\]")[[1]][1])
      src <- c(src, ifelse(stringr::str_detect(chk, "http"), "Reference", chk))
      lnk <- c(lnk, gsub("\\)", "", stringr::str_split(stringr::str_extract(txt[l], "http.*"), " ")[[1]][1]))
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
  
  return(datalyrs_metainfo)
}


gather_key_info <- function(){
  
  
  key_info_table <- data.frame(goal, subgoal, key_messages, target, key_information)
  
  
  return(key_info_table)
}
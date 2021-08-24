#' make data layers table
#'
#' @param gh_raw_bhiprep raw.githubusercontent url directing to bhi prep github repository
#' @param bhi_version assessment year
make_data_table <- function(gh_raw_bhiprep, bhi_version){
  
  rmds <- sprintf(c(
    "CON/%s/con_prep", 
    "EUT/%s/eut_prep", 
    "FIS/%s/fis_prep",
    "MAR/v2019/mar_prep",
    "NP/%s/np_prep",
    "ECO/%s/eco_prep",
    "LIV/%s/liv_prep",
    "BD/%s/bd_prep",
    "AO/%s/ao_prep",
    "ICO/%s/ico_prep",
    "LSP/%s/lsp_prep",
    "TR/%s/tr_prep",
    "CS/%s/cs_prep",
    "TRA/%s/tra_prep"
  ), bhi_version)
  
  goals <- data.frame(
    c("CW", "CW", "FP", "FP", "NP", "LE", "LE", "BD", "AO", "SP", "SP", "TR", "CS", "CW"), 
    c("CON", "EUT", "FIS", "MAR", NA, "ECO", "LIV", NA, NA, "ICO", "LSP", NA, NA, "TRA"), 
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
    
    txt <- readr::read_lines(sprintf("%s/prep/%s.Rmd", gh_raw_bhiprep, goals[g, "rmdlink"]))
    txt <- txt[grep("^### 2.1 ", txt):ifelse(length(grep("^### 2.2 ", txt)) > 0, grep("^### 2.2 ", txt), grep("^## 3. ", txt))]
    
    headers <- c(grep("^#### .*[0-9] ", txt), length(txt))
    boldheaders <- grep("^\\*\\*", txt)
    srclnk <- grep("Source.*\\]\\(http.*\\)", txt)
    
    lyr <- c()
    src <- c()
    lnk <- c()
    for(h in 2:length(headers)){
      subheaders <- txt[boldheaders[boldheaders %in% headers[h-1]:(headers[h])]]
      newlyr <- gsub(", $", "", paste(
        gsub("#### .*[0-9] ", "", gsub(" \\{-\\}", "", txt[headers[h-1]])),
        gsub("\\[.*\\]\\(.*\\)", "", gsub("\\*\\*", "", subheaders)),
        sep = ", "
      ))
      lyr <- c(lyr, newlyr)
      
      lyrsrc <- srclnk[srclnk %in% headers[h-1]:headers[h]]
      if(length(lyrsrc) == 0){
        src <- c(src, NA)
        lnk <- c(lnk, NA)
      }
      if(length(lyrsrc) > length(newlyr)){
        ## likely a section with reference point information
        lyrsrctmp <- lyrsrc[grep("eference point .* \\[.*\\]\\(.*\\)|arget .* \\[.*\\]\\(.*\\)|eference point .* http|arget .* http|heshold .* http", txt[lyrsrc])]
        if(length(lyrsrctmp) == 0){
          ## or a link with additional information...
          lyrsrctmp <- lyrsrc[grep("more information|additional information|learn more|for details|supplement to paper|detailed info|has been compiled from", txt[lyrsrc], invert = TRUE)]
          if(length(lyrsrctmp) == 0){
            lyrsrc <- lyrsrc[1]
          } else {
            lyrsrc <- lyrsrctmp
          }
        } else {
          lyrsrc <- lyrsrctmp
        }
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
      layer = stringr::str_remove(lyr, " \\{\\-\\}"),
      description = rep("", length(lyr)), 
      source = src,
      sourcelink = lnk
    ) %>% filter(!is.na(source) & !is.na(sourcelink)) %>% dplyr::bind_rows(datalyrs_metainfo) 
  }
  
  datalyrs_metainfo <- datalyrs_metainfo %>% 
    dplyr::mutate(reflink = sprintf(
      "<a href=\"%s\" target = \"_blank\">%s</a>", 
      sourcelink, source
    )) %>%
    mutate(goal_subgoal = ifelse(is.na(subgoal), goal, subgoal)) %>% 
    rowwise() %>% 
    mutate(goal = list(c(goal, subgoal))) %>% 
    tidyr::unnest(cols = c(goal)) %>% 
    dplyr::filter(!is.na(goal)) %>% 
    dplyr::select(goal = goal_subgoal, dataset = layer, source, reflink)

  
  return(datalyrs_metainfo)
}

#' list all layers in bhi prep repository
#'
#' @param gh_api_bhiprep github api url directing to bhi prep github repository
#' @return list of scenario layers files found in the bhi prep repositorys
list_prep_layers <- function(gh_api_bhiprep){
  req <- httr::GET(gh_api_bhiprep)
  httr::stop_for_status(req)
  
  filelist <- unlist(lapply(httr::content(req)$tree, "[", "path"), use.names = FALSE) %>% 
    grep(pattern = "layers/", value = TRUE) %>% 
    stringr::str_extract("/[a-zA-Z0-9_-]+.csv|/[a-zA-Z0-9_-]+$") %>% 
    stringr::str_remove_all(".csv") %>% 
    stringr::str_remove_all("/")
  
  return(filelist)
}

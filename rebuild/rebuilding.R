library(httr)
library(magrittr)
library(stringr)
library(here)
library(readr)
library(dplyr)


#' list all layers in bhi prep repository
#'
#' @param gh_api_bhiprep github api url directing to bhi prep github repository
#'
#' @return list of scenario layers files found in the bhi prep repository

list_prep_layers <- function(gh_api_bhiprep){
  req <- httr::GET(gh_api_bhiprep)
  httr::stop_for_status(req)
  
  filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = FALSE) %>% 
    grep(pattern = "/layers/", value = TRUE) %>% 
    stringr::str_extract("/[a-zA-Z0-9_-]+.csv|/[a-zA-Z0-9_-]+$") %>% 
    stringr::str_remove_all(".csv") %>% 
    stringr::str_remove_all("/")
  
  return(filelist)
}

#' extract from functions.R layers associated with a specific goal function
#'
#' @param functionsR_path location of functions.R to extract goal from
#' @param goal_code the two or three letter code indicating the goal or subgoal
#'
#' @return character vector naming layers

#' returns layers and functions in functions.R for requested goals
#'
#' @param gh_raw_bhi raw.githubusercontent url directing to bhi github repository
#' @param scenario_folder folder within the bhi repo containing the functions.R to extract goal info from
#' @param goal_code goal or goals for which to identify layers and functions
#'
#' @return list by goal code with layers and function text identified for each

goal_info <- function(gh_raw_bhi, scenario_folder, goal_code = "all"){
  
  functions_txt <- readLines(paste0(gh_raw_bhi, scenario_folder, "/conf/functions.R"))
  
  breaks_str <- "^[A-Z]{2,3}\\s<-\\sfunction\\(|^[A-Z]{2,3}\\s=\\sfunction\\("
  funs_goals <- stringr::str_extract(grep(breaks_str, functions_txt, value = TRUE), "^[A-Z]{2,3}")
  funs_breaks <- grep(breaks_str, functions_txt)
  
  goal_code <- stringr::str_to_upper(goal_code) %>% unlist()
  if("ALL" %in% stringr::str_to_upper(goal_code)){
    goal_code <- funs_goals
  }
  if(any(!goal_code %in% funs_goals)){
    print("note: no function for some of the given goals")
  }
  goal_code <- intersect(goal_code, funs_goals)
  
  goalinfo <- list()
  for(gc in goal_code){
    
    fun_start <- grep(pattern = sprintf("^%s\\s<-\\sfunction\\(|^%s\\s=\\sfunction\\(", gc, gc), functions_txt)
    fun_end <- ifelse(
      1 + which.min(abs(fun_start - funs_breaks)) > length(funs_breaks),
      length(functions_txt),
      funs_breaks[1 + which.min(abs(fun_start - funs_breaks))] - 1
    )
    txt <- functions_txt[fun_start:fun_end]
    if(fun_end != length(functions_txt)){
      txt <- grep(pattern = "\\s*#{1,}.*", x = txt, value = TRUE, invert = TRUE)
    }
    goalinfo[[gc]]["function"] <- list(txt)
    
    ## extract names of layers specified in functions.R (i.e. which do functions.R require)
    goalinfo[[gc]]["layers"]  <- txt %>%
      gsub(pattern = "layer_nm\\s{1,}=\\s{1,}", replacement = "layer_nm=") %>%
      # gsub(pattern = "", replacement = "layer_nm=") %>% # to catch pressure + resilience layers given with a different pattern
      stringr::str_split(" ") %>%
      unlist() %>%
      stringr::str_subset("layer_nm.*") %>% # pattern to ID layer fed into a function within fuctions.R
      stringr::str_extract("\"[a-z0-9_]*\"|\'[a-z0-9_]*\'") %>%
      stringr::str_sort() %>%
      stringr::str_remove_all("\"|\'") %>% # remove any quotation marks around
      list()
    
  }
  
  return(goalinfo)
}

#' make data layers table
#'
#' @param gh_raw_bhiprep raw.githubusercontent url directing to bhi prep github repository
#' @param bhi_version assessment year
#'
#' @return
#' @export
#'
#' @examples
make_data_table <- function(gh_raw_bhiprep, bhi_version){
  
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

#' layers scatterplot variables selection menu
#'
#' @param str_match string or patial string to match in layers, to be included in result
#' @param print boolean indicating whether to print copy-and-pasteable text in console
#'
#' @return no returned object; prints helpful info in console

make_lyrs_menu <- function(str_match = "_bhi2015", print = FALSE){
  
  lyrs <- read_csv(file.path(dir_main, "data", "layers_data.csv"))$layer %>% 
    unique() %>% 
    grep(pattern = str_match, value = TRUE) %>%
    grep(pattern = "_trend", value = TRUE, invert = TRUE) %>%
    grep(pattern = "_scores", value = TRUE, invert = TRUE) %>%
    sort()
  
  cat("\n\n")
  for(f in lyrs){
    cat(
      sprintf(
        "`%s` = \"%s\"",
        f %>%
          str_remove(pattern  = paste0(str_match,"+")) %>%
          str_to_upper(),
        f
      ),
      sep = ", \n"
    )
  }
  
  vec <- lyrs
  names(vec) <- lyrs %>%
    str_remove(pattern  = "_bhi2015.csv+") %>%
    str_to_upper()
  return(vec)
}

#' make goal-pages ui and server code from template	
#'	
#' helper/timesaver function, could maybe be a module but thats another layer of complexity...	
#'	
#' @param goal_code the goal for which to input information/create code chunk	
#' @param replace_current logical indicating whether to overwrite current code chunks for the given goal	
#'	
#' @return	

goalpage_from_template <- function(goal_code, replace_current = FALSE){	
  
  ## replacement info	
  # goalinfo <- tbl(bhi_db_con, "plot_conf") %>%	
  goalinfo <- read_csv(file.path(dir_main, "data", "plot_conf.csv"), col_types = cols()) %>%	
    select(name, goal, parent) %>%	
    collect() %>% 	
    filter(goal == goal_code)	
  
  ## template text	
  txt <- scan(	
    here::here("rebuild", "goalpage.R"),	
    what = "character",	
    sep = "\n",	
    blank.lines.skip = FALSE	
  )	
  
  ## make replacements	
  for(p in c("\"%s\"", " %s ", "\"%s_", " %s_", "%s\\)")){	
    pttn <- sprintf(p, "goalcode")	
    repl <- sprintf(p, str_to_lower(goal_code))	
    txt <- str_replace_all(txt, pattern = pttn, replacement = repl)	
  }	
  for(p in c("\"%s\"", " %s ", "\"%s ", " %s\"", "/%s/", "%s\\)")){	
    pttn <- sprintf(p, "GOALCODE")	
    repl <- sprintf(p, str_to_upper(goal_code)) 	
    txt <- str_replace_all(txt, pattern = pttn, replacement = repl)	
  }	
  for(p in c("\"%s\"", " %s ", "%s ", " %s", "\"%s ", " %s\"", "/%s/", "%s\\)")){	
    pttn <- sprintf(p, "goalname")	
    repl <- sprintf(p, str_to_lower(goalinfo$name)) 	
    txt <- str_replace_all(txt, pattern = pttn, replacement = repl)	
  }	
  for(p in c("\"%s\"", " %s ", "%s ", " %s", "\"%s ", " %s\"", "/%s/", "%s\\)")){	
    pttn <- sprintf(p, "GOALNAME")	
    repl <- sprintf(p, goalinfo$name) 	
    txt <- str_replace_all(txt, pattern = pttn, replacement = repl)	
  }	
  # if(any(!is.na(goalinfo$parent))){"?"}	
  
  ## for the urls	
  txt <- txt %>%	
    str_replace_all(	
      pattern = "/goalcode_",	
      replacement = sprintf("/%s_", str_to_lower(goal_code))	
    ) %>%	
    str_replace_all(	
      pattern = "/#goalname",	
      replacement = sprintf(	
        "/#%s",	
        goalinfo$name %>%	
          str_to_lower() %>%	
          str_replace_all(pattern = " ", replacement = "-")	
      )	
    ) %>% 	
    str_replace_all(	
      pattern = "\\$goalcode_",	
      replacement = sprintf("$%s_", str_to_lower(goal_code))	
    )	
  
  ## where have paragraphs of text, replace with empty paragraph html	
  txt <- str_replace_all(txt, pattern = "p\\(\"[A-Za-z0-9 ]+\"\\)", replacement = "p(\"\")")	
  
  ## return or save results	
  if(!replace_current){	
    
    ## just print result in console	
    cat(txt, sep = "\n")	
    
  } else {	
    
    ## directly replace current goal page code in ui and server scripts	
    
    ## original ui and server text	
    txtUI <- scan(	
      file.path(dir_main, "ui.R"),	
      what = "character",	
      sep = "\n",	
      blank.lines.skip = FALSE	
    )	
    txtServer <- scan(	
      file.path(dir_main, "server.R"),	
      what = "character",	
      sep = "\n",	
      blank.lines.skip = FALSE	
    )	
    
    ## identify breaks between goals	
    ui_breaks <- txtUI %>% grep(pattern = "##\\s§\\s\\([A-Z]{2,3}\\)")	
    ui_breakstart <- txtUI %>% grep(pattern = sprintf("##\\s§\\s\\(%s\\)", str_to_upper(goal_code)))	
    
    serv_breaks <- txtServer %>% grep(pattern = "##\\s[A-Z]{2,3}\\s----")	
    serv_breakstart <- txtServer %>% grep(pattern = sprintf("##\\s%s\\s----", str_to_upper(goal_code)))	
    
    ## replace goal chunks and save i.e. overwrite	
    txtUI_updated <- c(	
      txtUI[1:(ui_breakstart - 1)], 	
      txt[(grep(pattern = "## UI code ----", txt) + 2):(grep(pattern = "## Server code ----", txt) - 1)], 	
      txtUI[min(ui_breaks[which(ui_breaks > ui_breakstart)]):length(txtUI)]
    )	
    txtServer_updated <- c(	
      txtServer[1:(serv_breakstart - 1)], 	
      txt[(grep(pattern = "## Server code ----", txt) + 1):length(txt)], 	
      txtServer[min(serv_breaks[which(serv_breaks > serv_breakstart)]):length(txtServer)]	
    )	
    write_lines(txtUI_updated, file.path(dir_main, "ui.R"))	
    write_lines(txtServer_updated, file.path(dir_main, "server.R"))	
  }	
}

#' print in console pieces to create region menu code
#'
#' @param rgn_tab_con
#'
#' @return no returned object; prints helpful info in console

make_rgn_menu <- function(rgn_tab_con = bhi_db_con){
  
  rgn <- tbl(rgn_tab_con, "regions") %>%
    select(region_id, subbasin, region_name) %>%
    collect() %>%
    arrange(subbasin) %>%
    mutate(print_col = sprintf("`%s` = %s", region_name, region_id))
  
  cat(paste0("`", unique(rgn$subbasin), "` = c(`", unique(rgn$subbasin), "` = )", sep =  "\n"))
  
  cat("\n\n")
  for(s in unique(rgn$subbasin)){
    cat(filter(rgn, subbasin  == s)$print_col, sep = ", \n")
  }
}

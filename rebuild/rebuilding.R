library(httr)
library(magrittr)
library(stringr)
library(here)
library(readr)
library(dplyr)


#' list all layers in bhi prep repository
#'
#' @param gh_api_bhiprep raw.githubusercontent url directing to bhi prep github repository
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

#' download layers from bhi prep repository and bind into one table
#'
#' @param gh_raw_bhiprep raw.githubusercontent url directing to bhi prep github repository
#' @param layers names of files in layers folder to download, without .csv extension
#' @param default_year value to assign as the year where layer have no year column
#'
#' @return merged layer datatable

get_layers <- function(gh_raw_bhiprep, layers, default_year){
  ## create data folder if needed
  if(!file.exists(here::here("dashboard", "data"))){
    dir.create(here::here("dashboard", "data"))
  }
  
  ## initialize dataframe for all layers
  all_lyrs_df <- data.frame(
    year = double(), 
    region_id = double(), 
    category = character(), 
    layer = character(), 
    value = numeric()
  )
  matchcols <- c("rgn_id", "year", "value", "category", "layer")
  
  ## download and reformat data layers
  for(lyr in layers){
    lyr_df <- readr::read_csv(paste0(gh_raw_bhiprep, "layers/", unlist(lyr),  ".csv"), col_types = cols()) %>% 
      dplyr::mutate(layer = unlist(lyr))
    
    if(any(1:2 %in% dim(lyr_df))){
      message(sprintf("excluding layer %s, insufficient rows of data", unlist(lyr)))
    } else {
      
      ## reshape columns into a consistent format...
      if(!"year" %in% names(lyr_df)){
        lyr_df <- dplyr::mutate(lyr_df, year = default_year)
      }
      if("dimension" %in% names(lyr_df)){
        lyr_df <- dplyr::rename(lyr_df, category = dimension)
      } else if(any(str_detect(names(lyr_df), "pressure")) | str_detect(lyr, "pressure")){
        lyr_df <- dplyr::mutate(lyr_df, category = "pressure")
      } else if(any(str_detect(names(lyr_df), "resilience")) | str_detect(lyr, "resilience")){
        lyr_df <- dplyr::mutate(lyr_df, category = "resilience")
      } else if(any(str_detect(names(lyr_df), "trend")) | str_detect(lyr, "trend")){
        lyr_df <- dplyr::mutate(lyr_df, category = "trend")
      } else {
        lyr_df <- dplyr::mutate(lyr_df, category = "status")
      }
      colnames(lyr_df) <- gsub("::score$", "value", colnames(lyr_df))
      colnames(lyr_df) <- gsub("score$", "value", colnames(lyr_df))
      
      ## ugh why are there such random column names
      ## if missing value columns still
      ## if after all this there are columns other than region_id, year, category...
      extracol <- setdiff(names(lyr_df), matchcols)
      
      if(!"value" %in% names(lyr_df) & length(extracol) == 1){
        if(class(dplyr::select(lyr_df, !!sym(extracol))[[1]]) == "numeric"){
          lyr_df <- dplyr::rename(lyr_df, value = !!sym(extracol))
        }
      }
      ## have value column already, so extra column must be a categorical variable...
      else if("value" %in% names(lyr_df) & length(extracol) == 1){
        if(class(dplyr::select(lyr_df, !!sym(extracol))[[1]]) %in% c("character", "factor")){
          lyr_df <- lyr_df %>% 
            mutate(category = paste(ifelse(
              !"category" %in% names(lyr_df), "score", category),
              !!sym(extracol), 
              sep = ", ")
            ) %>% 
            dplyr::select(-!!sym(extracol))
        }
      }
      ## if two cols left over, assume one with more unique vals is score and other is a categorical var
      else if(!"value" %in% names(lyr_df) & length(extracol) == 2){
        if(length(unique(lyr_df[[sym(extracol[1])]])) > length(unique(lyr_df[[sym(extracol[2])]]))){
          
          lyr_df <- lyr_df %>% 
            mutate(category = paste(ifelse(
              !"category" %in% names(lyr_df), "score", category),
              !!sym(extracol[2]), 
              sep = ", ")
            ) %>% 
            dplyr::select(-!!sym(extracol[2])) %>% 
            dplyr::rename(value = !!sym(extracol[1]))
          
        } else {
          lyr_df <- lyr_df %>% 
            mutate(category = paste(ifelse(
              !"category" %in% names(lyr_df), "score", category),
              !!sym(extracol[1]), 
              sep = ", ")
            ) %>% 
            dplyr::select(-!!sym(extracol[1])) %>% 
            dplyr::rename(value = !!sym(extracol[2]))
        }
      }
      ## row bind to complete layers dataframe
      ## unless there are still undetermined columns, in which case just exclude the file from the table...
      if(all(names(lyr_df) %in% matchcols) & all(matchcols %in% names(lyr_df))){
        all_lyrs_df <- rbind(
          all_lyrs_df, 
          dplyr::select(lyr_df, year, region_id = rgn_id, category, layer, value)
        )
        message(sprintf("successfully added layer %s to merged layers_data table", lyr))
        
      } else {
        message(sprintf("excluding layer %s because of column names mismatch...", lyr))
      }
    }
  }
  
  return(all_lyrs_df)
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

#' layers scatterplot variables selection menu
#'
#' @param str_match string or patial string to match in layers, to be included in result
#' @param print boolean indicating whether to print copy-and-pasteable text in console
#'
#' @return no returned object; prints helpful info in console

make_lyrs_menu <- function(str_match = "_bhi2015", print = FALSE){
  
  lyrs <- read_csv(here("dashboard", "data", "layers_data.csv"))$layer %>% 
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
  goalinfo <- read_csv(here("dashboard", "data", "plot_conf.csv"), col_types = cols()) %>%	
    select(name, goal, parent) %>%	
    collect() %>% 	
    filter(goal == goal_code)	
  
  ## template text	
  txt <- scan(	
    here("rebuild", "goalpage.R"),	
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
      here("dashboard", "ui.R"),	
      what = "character",	
      sep = "\n",	
      blank.lines.skip = FALSE	
    )	
    txtServer <- scan(	
      here("dashboard", "server.R"),	
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
      txt[(grep(pattern = "## UI code ----", txt) + 1):(grep(pattern = "## Server code ----", txt) - 1)], 	
      txtUI[min(ui_breaks[which(ui_breaks > ui_breakstart)]):length(txtUI)]	
    )	
    txtServer_updated <- c(	
      txtServer[1:(serv_breakstart - 1)], 	
      txt[grep(pattern = "## Server code ----", txt):length(txt)], 	
      txtServer[min(serv_breaks[which(serv_breaks > serv_breakstart)]):length(txtServer)]	
    )	
    write_lines(txtUI_updated, here("dashboard", "ui2.R"))	
    write_lines(txtServer_updated, here("dashboard", "server2.R"))	
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

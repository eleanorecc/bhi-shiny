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
  if(!file.exists(here::here("data"))){dir.create(here::here("data"))}
  
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
  ## to download all individual files to data folder...
  # lapply(
  #   paste0(layers, ".csv"),
  #   function(x){
  #     read_csv(paste0(gh_raw_bhiprep, "layers/", unlist(x))) %>% 
  #       write_csv(here("data", unlist(x)))
  #   }
  # )
  return(all_lyrs_df)
}

#' extract from functions.R layers associated with a specific goal function
#'
#' @param functionsR_path location of functions.R to extract goal from
#' @param goal_code the two or three letter code indicating the goal or subgoal
#'
#' @return character vector naming layers

#' list functions.R goals
#'
#' @param functionsR_path location of functions.R to extract goal from
#' @param functionsR_text list of funcitons.R lines read eg using scan (if functionsR_path is not provided)
#'
#' @return goal codes character vector for goals having functions defined in functions.R

goal_layers <- function(gh_raw_bhi, scenario_folder, goal_code = "all"){
  
  functions_txt <- readLines(paste0(gh_raw_bhi, scenario_folder, "/conf/functions.R"))
  
  breaks_str <- "^[A-Z]{2,3}\\s<-\\sfunction\\(|^[A-Z]{2,3}\\s=\\sfunction\\("
  funs_goals <- stringr::str_extract(grep(breaks_str, functions_txt, value = TRUE), "^[A-Z]{2,3}")
  funs_breaks <- grep(breaks_str, functions_txt)
  
  goal_code <- stringr::str_to_upper(goal_code) %>% unlist()
  if(goal_code != "ALL" & any(!goal_code %in% funs_goals)){
    print("note: no function for some of the given goals")
  }
  if(stringr::str_to_upper(goal_code) == "ALL"){
    txt <- grep(pattern = "\\s*#{1,}.*", functions_txt, value = TRUE, invert = TRUE)
  } else {
    
    txt <- vector()
    for(gc in goal_code){
      
      fun_start <- grep(pattern = sprintf("^%s\\s<-\\sfunction\\(|^%s\\s=\\sfunction\\(", gc, gc), functions_txt)
      fun_end <- funs_breaks[1 + which.min(abs(fun_start - funs_breaks))] - 1
      
      goal_fun <- functions_txt[fun_start:fun_end] %>% 
        grep(pattern = "\\s*#{1,}.*", value = TRUE, invert = TRUE)
      txt <- c(txt, goal_fun)
    }
  }
  
  ## extract names of layers specified in functions.R (i.e. which do functions.R require)
  functionsR_layers <- txt %>%
    gsub(pattern = "layer_nm\\s{1,}=\\s{1,}", replacement = "layer_nm=") %>%
    # gsub(pattern = "", replacement = "layer_nm=") %>% # to catch pressure + resilience layers given with a different pattern
    stringr::str_split(" ") %>%
    unlist() %>%
    stringr::str_subset("layer_nm.*") %>% # pattern to ID layer fed into a function within fuctions.R
    stringr::str_extract("\"[a-z0-9_]*\"|\'[a-z0-9_]*\'") %>%
    stringr::str_sort() %>%
    stringr::str_remove_all("\"|\'") # remove any quotation marks around
  
  return(functionsR_layers)
}

#' layers scatterplot variables selection menu
#'
#' @param layers_dir directory containing the layers
#' @param print boolean indicating whether to print copy-and-pasteable text in console
#'
#' @return no returned object; prints helpful info in console

make_lyrs_menu <- function(layers_dir, print = FALSE){
  
  lyrs <- list.files(layers_dir) %>%
    grep(pattern = "_bhi2015.csv", value = TRUE) %>%
    grep(pattern = "_trend", value = TRUE, invert = TRUE) %>%
    grep(pattern = "_scores", value = TRUE, invert = TRUE) %>%
    sort()
  
  cat("\n\n")
  for(f in lyrs){
    cat(
      sprintf(
        "`%s` = \"%s\"",
        f %>%
          str_remove(pattern  = "_bhi2015.csv+") %>%
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

#' print in console goal-pages ui and server code
#'
#' helper/timesaver function, could maybe be a module but thats another layer of complexity...
#'
#' @param goal_code the goal for which to input information /create code chunk
#' @param goal_code_templatize the goal to use as a template
#' @param ui_server one of either ui or server, whichever code is to be generated for
#'
#' @return

templatize_goalpage <- function(goal_code, goal_code_templatize, ui_server){
  
  if(ui_server  ==  "ui"){
    ## ui template, read then parse to goal to copy/templatize
    templatetxt <- scan(file.path(getwd(), "ui.R"),
                        what = "character",
                        sep = "\n")
    breaks <- templatetxt %>% grep(pattern = "##\\s>>\\s[a-z]{2,3}\\s----")
    breakstart <- templatetxt %>% grep(pattern = sprintf("## >> %s ----", str_to_lower(goal_code_templatize)))
    breakend <- min(breaks[which(breaks > breakstart)]) - 1
    templatetxt <- templatetxt[breakstart:breakend]
    
  } else if(ui_server  ==  "server"){
    ## server template, read then parse to goal to copy/templatize
    templatetxt <- scan(file.path(getwd(), "server.R"),
                        what = "character",
                        sep = "\n")
    breaks <- templatetxt %>% grep(pattern = "##\\s[A-Z]{2,3}\\s----")
    breakstart <- templatetxt %>%
      grep(
        pattern = sprintf(
          "##\\s%s\\s----",
          str_to_upper(goal_code_templatize)
        )
      )
    breakend <- min(breaks[which(breaks > breakstart)]) - 1
    templatetxt <- templatetxt[breakstart:breakend]
    
  } else {
    message("ui_server argument must be one of 'ui' or 'server'")
  }
  
  ## replacement info
  goalinfo <- tbl(bhi_db_con, "plot_conf") %>%
    select(name, goal, parent) %>%
    collect() %>%
    filter(goal %in% c(str_to_upper(goal_code), str_to_upper(goal_code_templatize)))
  
  ## inject info for new goal
  txt <- templatetxt
  for(p in c("\"%s\"", " %s ", "\"%s_", " %s_")){
    pttn <- sprintf(p, str_to_lower(goal_code_templatize))
    repl <- sprintf(p, str_to_lower(goal_code)) # print(paste(pttn, "-->", repl))
    txt <- str_replace_all(txt, pattern = pttn, replacement = repl)
  }
  for(p in c("\"%s\"", " %s ", "\"%s ", " %s\"", "/%s/", "%s\\)")){
    pttn <- sprintf(p, str_to_upper(goal_code_templatize))
    repl <- sprintf(p, str_to_upper(goal_code)) # print(paste(pttn, "-->", repl))
    txt <- str_replace_all(txt, pattern = pttn, replacement = repl)
  }
  # if(any(!is.na(goalinfo$parent))){"?"}
  for(p in c("\"%s\"", " %s ", "%s ", " %s", "\"%s ", " %s\"", "/%s/", "%s\\)")){
    pttn <- sprintf(p, filter(goalinfo, goal == goal_code_templatize)$name)
    repl <- sprintf(p, filter(goalinfo, goal == goal_code)$name) # print(paste(pttn, "-->", repl))
    txt <- str_replace_all(txt , pattern = pttn, replacement = repl)
  }
  #biodiversity --> #artisanal-fishing-opportunities
  
  txt <- txt %>%
    str_replace_all(
      pattern = sprintf(
        "#%s",
        filter(goalinfo, goal == goal_code_templatize)$name %>%
          str_to_lower() %>%
          str_replace_all(pattern = " ", replacement = "-")
      ),
      replacement = sprintf(
        "#%s",
        filter(goalinfo, goal == goal_code)$name %>%
          str_to_lower() %>%
          str_replace_all(pattern = " ", replacement = "-")
      )) %>%
    str_replace_all(pattern = "p\\(\"[A-Za-z0-9 ]+\"\\)", replacement = "p(\"\")")
  
  ## print result in console
  cat(txt, sep = "\n")
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

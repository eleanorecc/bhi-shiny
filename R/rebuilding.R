

list_prep_layers <- function(gh_api_bhiprep){
  req <- GET(gh_api_bhiprep)
  stop_for_status(req)
  
  filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = FALSE) %>% 
    grep(pattern = "/layers/", value = TRUE) %>% 
    str_extract("/[a-zA-Z0-9_-]+.csv|/[a-zA-Z0-9_-]+$") %>% 
    str_remove_all(".csv") %>% 
    str_remove_all("/")
  
  return(filelist)
}

get_layers <- function(gh_raw_bhiprep, layers){
  if(!file.exists(file.path(here::here(), "data"))){dir.create(file.path(here::here(), "data"))}
  
  lapply(
    layers %>% paste0(".csv"),
    function(x){
      readfile <- paste0(gh_raw_bhiprep, unlist(x))
      read_csv(readfile) %>% 
        write_csv(file.path("data", unlist(x)))
    }
  )
}


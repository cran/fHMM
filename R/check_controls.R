#' @title Controls check
#' @description Checks specification of \code{controls}. 
#' @param controls A list of controls.
#' @return Checked version of \code{controls}. 

check_controls = function(controls){
  
  all_controls = c("path",    ### a character, setting the path of the data and the model results
                   "id",      ### a character, identifying the model
                   "states",  ### a numeric vector of length 2, determining the model type and the number of states
                   "sdds",    ### a character vector of length 2, specifying the state-dependent distributions
                   "horizon", ### a vector of length 2, determining the time dimensions
                   "data",    ### a list, containing "source" (source of data), 
                              ###                    "col" (column of data), 
                              ###                    "truncate" (truncation of data), 
                              ###                    "cs_type" (coarse-scale type of data)
                   "fit",     ### a list, containing "runs" (number of optimizations), 
                              ###                    "at_true" (optimization at true values), 
                              ###                    "seed" (seed for the simulation and the optimization), 
                              ###                    "accept" (acceptable exit codes of the optimization)
                              ###                    "print.level" (passed on to nlm), 
                              ###                    "gradtol" (passed on to nlm),
                              ###                    "stepmax" (passed on to nlm),
                              ###                    "steptol" (passed on to nlm),
                              ###                    "iterlim" (passed on to nlm),
                              ###                    "scale_par" (scale of parameters), 
                   "results"  ### a list, containing "overwrite" (overwriting of existing model results)
                              ###                    "ci_level" (confidence interval level)
                  )
  
  ### check required controls
  required_controls = c("path","id","states","sdds")
  missing_required_controls = setdiff(required_controls,names(controls))
  if(length(missing_required_controls)>0){
    stop(sprintf("%s (%s)",exception("C.2")[2],exception("C.2")[1])) 
  }
  
  ### check redundant controls
  redundant_controls = setdiff(names(controls),all_controls)
  if(length(redundant_controls)>=1){
    warning(sprintf("%s (%s)",exception("C.4")[2],exception("C.4")[1]),call.=FALSE,immediate.=TRUE)
  }
  
  ### set default control values
  if(!"horizon" %in% names(controls))               controls[["horizon"]] = c(NA,NA)
  if(!"source" %in% names(controls[["data"]]))      controls[["data"]][["source"]] = c(NA,NA)
  if(!"col" %in% names(controls[["data"]]))         controls[["data"]][["col"]] = c(NA,NA)
  if(!"truncate" %in% names(controls[["data"]]))    controls[["data"]][["truncate"]] = c(NA,NA)
  if(!"cs_type" %in% names(controls[["data"]]))     controls[["data"]][["cs_type"]] = NA
  if(!"runs" %in% names(controls[["fit"]]))         controls[["fit"]][["runs"]] = 100
  if(!"at_true" %in% names(controls[["fit"]]))      controls[["fit"]][["at_true"]] = FALSE
  if(!"accept" %in% names(controls[["fit"]]))       controls[["fit"]][["accept"]] = c(1,2)
  if(!"print.level" %in% names(controls[["fit"]]))  controls[["fit"]][["print.level"]] = 0
  if(!"gradtol" %in% names(controls[["fit"]]))      controls[["fit"]][["gradtol"]] = 1e-3
  if(!"stepmax" %in% names(controls[["fit"]]))      controls[["fit"]][["stepmax"]] = 1
  if(!"steptol" %in% names(controls[["fit"]]))      controls[["fit"]][["steptol"]] = 1e-3
  if(!"iterlim" %in% names(controls[["fit"]]))      controls[["fit"]][["iterlim"]] = 200
  if(!"scale_par" %in% names(controls[["fit"]]))    controls[["fit"]][["scale_par"]] = c(1,1)
  if(!"overwrite" %in% names(controls[["data"]]))   controls[["results"]][["overwrite"]] = FALSE
  if(!"ci_level" %in% names(controls[["results"]])) controls[["results"]][["ci_level"]] = 0.95
  
  ### check model type
  controls[["model"]] = if(controls[["states"]][2] %in% c(0,NA)) "HMM" else "HHMM"
  controls[["sim"]]   = if(is.na(controls[["data"]][["source"]][ifelse(controls[["model"]] == "HMM",1,2)])) TRUE else FALSE
  
  ### check state-dependent distributions
  all_sdds = c("gamma","t")
  extract_dfs = function(x) grepl("^[t][\\(]([1-9][0-9]*|Inf)[\\)]$",x)
  controls[["fixed_dfs"]] = c(NA,NA)
  controls[["fixed_dfs"]][extract_dfs(controls[["sdds"]])] = as.numeric(sub("\\).*", "", sub(".*\\(", "", controls[["sdds"]][extract_dfs(controls[["sdds"]])])))
  controls[["sdds"]][extract_dfs(controls[["sdds"]])] = "t"
  
  ### check single controls
  if(controls[["model"]]=="HMM"){
    if(controls[["states"]][1]%%1!=0 || controls[["states"]][1]<2){
      stop("first entry of states must be an integer greater or equal 2")
    }
  }
  if(controls[["model"]]=="HHMM"){
    if(any(controls[["states"]]%%1!=0) || any(controls[["states"]]<2)){
      stop("both entries of states must be an integer greater or equal 2")
    }
  }
  if(controls[["model"]]=="HMM"){
    if(!controls[["sdds"]][1] %in% all_sdds){
      stop(paste0("first entry of sdds must be 't' or 'gamma'"))
    }
    if(!is.na(controls[["sdds"]][2])){
      warning("second entry of sdds is ignored",call.=FALSE,immediate.=TRUE)
      controls[["sdds"]][2] = NA
    }
  }
  if(controls[["model"]]=="HHMM"){
    if(any(!controls[["sdds"]] %in% all_sdds)){
      stop(paste0("both entries of sdds must be 't' or 'gamma'"))
    }
  }
  if(controls[["model"]]=="HMM"){
    if(controls[["sim"]] & is.na(controls[["horizon"]][1])){
      stop("either first entry of source in data or horizon has to be specified")
    }
    if(!controls[["sim"]] & !is.na(controls[["horizon"]][1])){
      warning("first entry of horizon is ignored",call.=FALSE,immediate.=TRUE)
      controls[["time_horizon"]][1] = NA
    }
    if(!is.na(controls[["horizon"]][2])){
      warning("second entry of horizon is ignored",call.=FALSE,immediate.=TRUE)
      controls[["horizon"]][2] = NA    
    }
  }
  if(controls[["model"]]=="HHMM"){
    if(controls[["sim"]] & any(is.na(controls[["horizon"]]))){
      stop("either source in data or horizon has to be fully specified")
    }
    if(!controls[["sim"]] & !is.na(controls[["horizon"]][1])){
      warning("first entry of horizon is ignored",call.=FALSE,immediate.=TRUE)
      controls[["horizon"]][1] = NA
    }
    if(!is.numeric(controls[["horizon"]][2]) & !controls[["horizon"]][2] %in% c("w","m","q","y")){
      stop("second entry of horizon has to be an integer or one of 'w', 'm', 'q', 'y'")
    }
  }
  
  ### check data controls
  if(controls[["model"]]=="HMM"){
    if(!is.na(controls[["data"]][["source"]][2])){
      warning("second entry of source in data is ignored",call.=FALSE,immediate.=TRUE)
      controls[["data"]][["source"]][2] = NA
    }
  }
  if(controls[["model"]]=="HHMM"){
    if(controls[["sim"]] & any(!is.na(controls[["data"]][["source"]]))){
      warning("entries of source in data are ignored",call.=FALSE,immediate.=TRUE)
      controls[["data"]][["source"]] = c(NA,NA)
    }
  }
  if(controls[["model"]]=="HMM"){
    if(!controls[["sim"]] & is.na(controls[["data"]][["col"]][1])){
      stop("first entry of col in data has to be specified")
    }
  }
  if(controls[["model"]]=="HHMM"){
    if(!controls[["sim"]] & any(is.na(controls[["data"]][["col"]]))){
      stop("entries of col in data have to be specified")
    }
  }
  if(controls[["sim"]] & any(!is.na(controls[["data"]][["col"]]))){
    warning("entries of col in data are ignored",call.=FALSE,immediate.=TRUE)
    controls[["data"]][["col"]] = c(NA,NA)
  }
  if(controls[["sim"]] & any(!is.na(controls[["data"]][["truncate"]]))){
    warning("entries of truncate in data are ignored",call.=FALSE,immediate.=TRUE)
    controls[["data"]][["truncate"]] = c(NA,NA)
  }
  if(controls[["model"]]=="HMM"){
    if(!is.na(controls[["data"]][["cs_type"]])){
      warning("cs_type in data is ignored",call.=FALSE,immediate.=TRUE)
      controls[["data"]][["_cs_type"]] = NA
    }
  }
  if(controls[["model"]]=="HHMM"){
    if(!is.na(controls[["data"]][["cs_type"]]) & !controls[["data"]][["cs_type"]] %in% c("mean","mean_abs","sum_abs")){
      stop(paste0("cs_type in data must be one of '",paste(c("mean","mean_abs","sum_abs"),collapse="', '"),"'"))
    }
    if(!controls[["sim"]] & is.na(controls[["data"]][["cs_type"]])){
      stop("cs_type in data has to be specified")
    }
    if(!is.na(controls[["data"]][["cs_type"]]) & controls[["sim"]]){
      warning("cs_type in data is ignored",call.=FALSE,immediate.=TRUE)
      controls[["data"]][["cs_type"]] = NA
    }
  }

  ### check fit controls
  if(!controls[["sim"]] & controls[["fit"]][["at_true"]]){
    warning("at_true is ignored",call.=FALSE,immediate.=TRUE)
    controls[["at_true"]] = FALSE
  }
  if(controls[["sim"]] & controls[["fit"]][["at_true"]] & controls[["fit"]][["runs"]]!=1){
    controls[["fit"]][["runs"]] = 1
  }
  if(any(controls[["fit"]][["accept"]]=="all")){
    controls[["fit"]][["accept"]] = 1:5
  }
  
  ### check results controls
  if(controls[["id"]]=="test" & !controls[["results"]][["overwrite"]]){
    warning("allow overwriting because id equals 'test'",call.=FALSE,immediate.=TRUE)
    controls[["results"]][["overwrite"]] = TRUE
  }
  
  ### check if data paths are correct
  for(i in c(1,2)){
    if(!is.na(controls[["data"]][["source"]][i])){
      if(!grepl(".csv$",controls[["data"]][["source"]][i])){
        controls[["data"]][["source"]][i] = paste0(controls[["data"]][["source"]][i],".csv")
      }
      if(!file.exists(paste0(controls[["path"]],"/data/",controls[["data"]][["source"]][i]))){
        stop(paste0("file '",controls[["path"]],"/data/",controls[["data"]][["source"]][i],"' not found"))
      }
      if(!controls[["data"]][["col"]][i] %in% colnames(read.csv(file=paste0("data/",controls[["data"]][["source"]][i])))){
        stop(paste0("column '",controls[["data"]][["col"]][i],"' not found in the file '",controls[["path"]],"data/",controls[["data"]][["source"]][i],"'"))
      }
    }
  }
  
  ### end of checks
  message("Controls checked")
  controls[["controls_checked"]] = TRUE
  
  ### print model specification
  writeLines(sprintf("%13-s %s","model id:",controls[["id"]]))
  writeLines(sprintf("%13-s %s","model type:",controls[["model"]]))
  if(controls[["sim"]]){
    writeLines(sprintf("%13-s %s","data type:","simulated"))
  }
  if(!controls[["sim"]]){
    writeLines(sprintf("%13-s %s","data type:","empirical"))
  }
  if(controls[["model"]]=="HMM") {
    writeLines(sprintf("%13-s %s","states:",controls[["states"]][1]))
    writeLines(sprintf("%13-s %s","SDDs:",paste0(controls[["sdds"]][1],ifelse(!is.na(controls[["fixed_dfs"]][1]),paste0("(",controls[["fixed_dfs"]][1],")"),""))))
  }
  if(controls[["model"]]=="HHMM") {
    writeLines(sprintf("%13-s %s / %s","states:",controls[["states"]][1],controls[["states"]][2]))
    writeLines(sprintf("%13-s %s / %s","SDDs:",paste0(controls[["sdds"]][1],ifelse(!is.na(controls[["fixed_dfs"]][1]),paste0("(",controls[["fixed_dfs"]][1],")"),"")),paste0(controls[["sdds"]][2],ifelse(!is.na(controls[["fixed_dfs"]][2]),paste0("(",controls[["fixed_dfs"]][2],")"),""))))
  }
  writeLines(sprintf("%13-s %s %s","runs:",controls[["fit"]][["runs"]],ifelse(controls[["fit"]][["at_true"]],"(initialised at true values)","")))
  if(!is.null(controls[["fit"]][["seed"]])) writeLines(sprintf("%13-s %s","seed:",controls[["fit"]][["seed"]]))
  
  ### save controls
  check_saving(object = controls, filetype = "rds", controls = controls)
  
  ### return controls
  return(controls)
}
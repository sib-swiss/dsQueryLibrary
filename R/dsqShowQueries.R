#' @title  Show all available queries 
#' @description Return all the available queries explained and grouped by domain.
#' @param force.download a logical, default FALSE. The normal behaviour of this function is to connect to the remote nodes only at the first invocation and cache the results.
#' All subsequent invocations will only access the cache. To force re-donwload of the queries from the remote nodes set this parameter to TRUE.
#' @param query_type a character, one of "Assign" or "Aggregate".  Assign: queries whose results cannot be retrieved due to disclosure controls.
#' Their results are loaded in the remote session(s) and made availablle for further processing. Aggregate: queries that retrieve aggregate data, their 
#' results are directly returned to the caller.
#' @param domain a character, used to restrict the retrieved queries by domain (a list of all available domains is shown when invoking with domain = NULL)
#' @param query_name a character, restricts  the result to one specific query
#' @param async same as in datashield.assign
#' @param datasources same as in datashield.assign. Unlike in datashield.assign, only the first datasource will be used (as the queries are the same on all nodes).
#' @return a list containing all the available queries with documentation
#' @export
dsqShowQueries <- function (force.download = FALSE, query_type = c("Assign", "Aggregate"),domain = NULL, query_name = NULL, async = TRUE, datasources = NULL){

  if(force.download || !exists('.queryCache', where = .GlobalEnv)){
    if (is.null(datasources)) {
      datasources <- datashield.connections_find()
    }
    myexpr <- paste0('loadAllQueries()')
    # run only on one datasource:
    queryList <- datashield.aggregate(datasources[1], as.symbol(myexpr), async = async)[[1]]
    newfunc <- function(query_type = c("Assign", "Aggregate"), domain = NULL, query_name = NULL, datasources = NULL){
      return(.readQueryList(query_type,queryList, domain, query_name, datasources))
    }
    assign('.queryCache', newfunc, envir = parent.frame())
    return(.readQueryList(query_type, queryList, domain, query_name, datasources))
  } else {
    return(.queryCache(query_type, domain, query_name))
  }
  
}


.readQueryList <- function(qType, queryList, domain= NULL, query_name = NULL, datasources = NULL){

  if(is.null(qType) || length(qType) > 1){
    qType <- select.list(names(queryList), title = 'Assign for loading in the remote sessions; Aggregate for returning results')
    if(qType==''){
      return()
    }

    return(.readQueryList(qType, queryList, domain, query_name))
  }
  
  if(is.null(domain)){
    domain <- select.list(names(queryList[[qType]]), title = 'Query domain (0 to exit)')
    if(domain==''){
      return()
    }
    return(.readQueryList(qType, queryList, domain, query_name))
  }
  if(is.null(query_name)){
    query_name <- select.list(names(queryList[[qType]][[domain]]), title = 'Available queries(0 to go back)') 
    if(query_name==''){
      return(.readQueryList(qType,queryList))
    } else (
      return(.readQueryList(qType, queryList, domain, query_name))
    )
  }
  
  #print(queryList[[domain]][[query_name]], quote = FALSE)
  sapply(names(queryList[[qType]][[domain]][[query_name]]), function(x){
    cat(paste0(x, ': '), sep="\n")
    if(x %in% c('Query', 'Description')){
      cat(queryList[[qType]][[domain]][[query_name]][[x]], sep = "\n")
    } else {
      print(queryList[[qType]][[domain]][[query_name]][[x]])
    }
    cat("\n")
  })
  run <-  select.list(c('yes', 'no'), title = 'Do you want to run it on the nodes?')
  if(run=='yes'){
    if (is.null(datasources)) {
      datasources <- datashield.connections_find()
    }
    nodes <- select.list(names(datasources), multiple = TRUE, title = 'Please input the opal nodes where you want to execute this query:  ')

    datasources <- datasources[nodes]
    
    input <- NULL
    parms <-  queryList[[qType]][[domain]][[query_name]]$Input
    if(!is.vector(parms) || !grepl('none', parms, ignore.case = TRUE)){
      cat("This query has the folowing parameters:", "\n")
      print(format(parms))

      input <-unlist(lapply(parms$Parameter, function(x) readline(paste0('Value for "', x, '": '))))

    }
    if(qType == 'Aggregate'){
      dsqRun(domain,query_name, input, async = TRUE, datasources = datasources )
    } else if(qType == 'Assign'){
      lim <- readline('Please enter the desired row limit here (press return for all rows):')
      if(lim == ''){
        lim <- NULL
      }
      dsqLoad(NULL, domain,query_name, input, lim, async = TRUE, datasources = datasources )
    }
  }
}




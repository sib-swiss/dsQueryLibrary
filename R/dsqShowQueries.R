#' @title  Show all available queries 
#' @description Return all the available queries explained and grouped by domain.
#' @param async same as in datashield.assign
#' @param datasources same as in datashield.assign
#' @return a list containing all the available queries with documentation
#' @export
dsqShowQueries <- function (queryList = NULL, domain = NULL, query_name = NULL, async = TRUE, datasources = NULL){

  if(is.null(queryList)){
    if (is.null(datasources)) {
      datasources <- datashield.connections_find()
    }
    myexpr <- paste0('loadAllQueries()')
    # run only on one datasource:
    queryList <- datashield.aggregate(datasources[1], as.symbol(myexpr), async = async)[[1]]
    newfunc <- function(force.download = FALSE, domain = NULL, query_name = NULL){
      if(force.download){
        return(dsQueryLibrary::dsqShowQueries(NULL,domain=domain, async=async, datasources=datasources))
      } else {
        return(.readQueryList(queryList, domain, query_name))
      }
    }
    assign('dsqShowQueries', newfunc, envir = parent.frame())
  }
  return(.readQueryList(queryList, domain, query_name))

}


.readQueryList <- function(queryList, domain= NULL, query_name = NULL){

  if(is.null(domain)){
    domain <- select.list(names(queryList), title = 'Query domain (0 to exit)')
    if(domain==''){
      return()
    }
    return(.readQueryList(queryList, domain, query_name))
  }
  if(is.null(query_name)){
    query_name <- select.list(names(queryList[[domain]]), title = 'Available queries(0 to go back)') 
    if(query_name==''){
      return(.readQueryList(queryList))
    } else (
      return(.readQueryList(queryList, domain, query_name))
    )
  }
  
  #print(queryList[[domain]][[query_name]], quote = FALSE)
  sapply(names(queryList[[domain]][[query_name]]), function(x){
    cat(paste0(x, ': '), sep="\n")
    if(x %in% c('Query', 'Description')){
      cat(queryList[[domain]][[query_name]][[x]], sep = "\n")
    } else {
      print(queryList[[domain]][[query_name]][[x]])
    }
    cat("\n")
  })
  run <-  select.list(c('yes', 'no'), title = 'Do you want to run it on the nodes?')
  if(run=='yes'){
    datasources <- readline('Please input the opal nodes where you want to execute this query (press return for all):  ')
    if (datasources==''){
      datasources <- NULL
    }
    input <- NULL
    parms <-  queryList[[domain]][[query_name]]$Input
    if(!is.vector(parms) || !grepl('none', parms, ignore.case = TRUE)){
      cat("This query has the folowing parameters:", "\n")
      print(format(parms))

      input <-unlist(lapply(parms$Parameter, function(x) readline(paste0('Value for "', x, '": '))))

    }
    dsqRun(domain,query_name, input, async = TRUE, datasources = datasources )
  }
}




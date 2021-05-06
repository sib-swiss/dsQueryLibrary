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
        return(dsQueryLibrary::dsqShowQueries(NULL, async, datasources))
      } else {
        return(.readQueryList(queryList, domain, query_name))
      }
    }
    assign('dsqShowQueries', newfunc, envir = parent.frame())
  }
  return(.readQueryList(queryList, domain, query_name))

}


.readQueryList <- function(querylist, domain= NULL, query_name = NULL){
  if(is.null(domain)){
    domain <- select.list(names(queryList), title = 'Query domain')
    return(.readQueryList(querylist, domain, query_name))
  }
  if(is.null(query_name)){
    query_name <- select.list(c(names(queryList[[domain]],'Back to domains')), title = 'Available queries') 
    if(query_name=='Back to domains'){
      return(.readQueryList(querylist))
    } else (
      return(.readQueryList(querylist, domain, query_name))
    )
  }
  print(querylist[[domain]][[query_name]])
  run <-  select.list(c('yes', 'no'), title = 'Do you want to run it on the nodes?')
  if(run=='yes'){
    datasources <- readline('Please input the opal nodes where you want to execute this query (press return for all): ')
    if (datasources==''){
      datasources <- NULL
    }
    input <- NULL
    parms <-  queryList[[domain]][[query_name]]$Input
    if(parms != 'None'){
      print('This query has the folowing parameters:')
      print(parms)
      input <- readline('Please input a vector of values for each parameter in the same order they appear above.')
    }
    dsqRun(domain,query_name, input, async = TRUE, datasources = datasources )
  }
}
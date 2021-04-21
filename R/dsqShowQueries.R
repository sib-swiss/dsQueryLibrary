#' @title  Show all available queries 
#' @description Return all the available queries explained and grouped by domain.
#' @param async same as in datashield.assign
#' @param datasources same as in datashield.assign
#' @return a list containing all the available queries with documentation
#' @export
dsqShowQueries <- function (async = TRUE, datasources = NULL){
  if (is.null(datasources)) {
    datasources <- datashield.connections_find()
  }
  # make it agnostic to table name or sql:
  myexpr <- paste0('loadAllQueries()')
  datashield.aggregate(datasources, as.symbol(myexpr), async = async)
}

#' @title Run a OMOP dictionary query 
#' @description Run one of the preset queries (previously retrieved with dsqShowQueries)
#' @param domain a character, the query domain (ex. 'care_site')
#' @param query_name the query name as it appears in the result of dsqShowQueries
#' @param input a list of the form {param_name = param_value} - input parameters for the query, available in the result of dsqShowQueries
#' @param db_connection a character, the name of the connection to the database. This must exist in the remote session(s) - it can be created with datashield.assign.resource().
#' @param async same as in datashield.assign
#' @param datasources same as in datashield.assign
#' @return a list containing all the available queries with documentation
#' @export
dsqRun <- function (domain, query_name, db_connection, input = NULL, async = TRUE, datasources = NULL){
  if (is.null(datasources)) {
    datasources <- datashield.connections_find()
  }
  expr <- list(as.symbol('execQuery'), domain, query_name, dsSwissKnifeClient:::.encode.arg(input), db_connection)
  
  datashield.aggregate(datasources,as.call(expr), async=async)
  
}

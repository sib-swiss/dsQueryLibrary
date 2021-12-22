#' @title Run a OMOP dictionary aggregate query 
#' @description Run one of the preset queries (previously retrieved with dsqShowQueries)
#' @param domain a character, the query domain (ex. 'care_site')
#' @param query_name the query name as it appears in the result of dsqShowQueries
#' @param input a vector of input parameters, in the same order as they appear in the text of the query. Information is available in dsqShowQueries() for each case.
#' @param db_connection a character, the name of the connection to the database. This must exist in the remote session(s) - it can be created with datashield.assign.resource().
#' If no db_connection is provided, the first connection found in the renote session (alphabetically) will be used.
#' @param async same as in datashield.assign
#' @param datasources same as in datashield.assign
#' @return the query result
#' @export
dsqRun <- function (domain = NULL, query_name = NULL, input = NULL, db_connection = NULL, async = TRUE, datasources = NULL){
 
  
  if (is.null(datasources)) {
    datasources <- datashield.connections_find()
  }
  expr <- list(as.symbol('execQuery'), domain, query_name, dsSwissKnifeClient:::.encode.arg(input), NULL, NULL, NULL, db_connection)
  
  datashield.aggregate(datasources,as.call(expr), async=async)

}
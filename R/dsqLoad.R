#' @title Load the result of an OMOP query in the remobe session(s)
#' @description Load remotely one of the preset queries (previously retrieved with dsqShowQueries)
#' @param symbol a character, the name of the dataframe where the resultset will be loaded. It defaults to the query_name.
#' @param domain a character, the query domain (ex. 'care_site')
#' @param query_name the query name as it appears in the result of dsqShowQueries
#' @param where_clause an optional where clause that can be appended to the query (without the 'where' keyword)
#' @param row_limit maximum number of row retrieved
#' @param db_connection a character, the name of the connection to the database. This must exist in the remote session(s) - it can be created with datashield.assign.resource().
#' If no db_connection is provided, the first connection found in the renote session (alphabetically) will be used.
#' @param async same as in datashield.assign
#' @param datasources same as in datashield.assign
#' @return the query result
#' @export
dsqLoad <- function (symbol = NULL, domain = NULL, query_name = NULL, where_clause = NULL, row_limit = NULL, db_connection = NULL, async = TRUE, datasources = NULL){
 
  
  if (is.null(datasources)) {
    datasources <- datashield.connections_find()
  }
  expr <- list(as.symbol('execQuery'),  domain, query_name, NULL, symbol, dsSwissKnifeClient:::.encode.arg(where_clause), row_limit, db_connection)
  
  datashield.aggregate(datasources,as.call(expr), async=async)
  
}
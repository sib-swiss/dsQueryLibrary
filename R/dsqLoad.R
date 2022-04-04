#' @title Load the result of an OMOP query in the remobe session(s)
#' @description Load remotely one of the preset queries (previously retrieved with dsqShowQueries)
#' @param symbol a character, the name of the data frame where the resultset will be loaded. It defaults to the query_name.
#' @param domain a character, the query domain (ex. 'care_site')
#' @param query_name the query name as it appears in the result of dsqShowQueries
#' @param where_clause an optional where clause that can be appended to the query (without the 'where' keyword)
#' @param row_limit maximum number of row retrieved
#' @param db_connections a vector, the name of the connection(s) to the database. They must exist in the remote session(s) - it can be created with datashield.assign.resource().
#' If no db_connection is provided, all the connections found in the renote session will be used. One more column called "database"
#' will be added to the query results and it will be populated with the respective connection names. The next argument (union)
#' will goevern further behaviour.
#' @param union a logical, if TRUE (the default), the resultsets across the multiple connections will be concatenated in one single data frame.
#' If FALSE, one data frame will be created for each connection (with the connection name concatenated to the original name)
#' @param async same as in datashield.assign
#' @param datasources same as in datashield.assign
#' @return the query result
#' @export
dsqLoad <- function (symbol = NULL, domain = NULL, query_name = NULL, where_clause = NULL, row_limit = NULL, row_offset = NULL, db_connections = NULL, union = TRUE, async = TRUE, datasources = NULL){
 
  if (is.null(datasources)) {
    datasources <- datashield.connections_find()
  }
  if (!is.null(db_connections)){
    db_connections <- dsSwissKnifeClient:::.encode.arg(db_connections)
  }
  
  expr <- list(as.symbol('execQuery'),  domain, query_name, NULL, symbol, dsSwissKnifeClient:::.encode.arg(where_clause), row_limit, row_offset, db_connections, union)
  datashield.aggregate(datasources,as.call(expr), async=async)
  
}
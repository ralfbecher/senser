#' Retrieves a dataframe containing timeline data with a date vector from a Qlik
#' Sense HyperCube
#'
#' This function makes a REST POST call to q-risotto (the Qlik Sense REST API
#' wrapper service) to retrieve data out of a Qlik Sense application. You will
#' find more details about q-risotto here:
#' https://github.com/ralfbecher/q-risotto
#'
#' In the parameters, you define the Qlik Sense HyperCube by giving a set of
#' dimensions and measure expressions (Qlik syntax). The HyperCube will then be
#' created in the specified Qlik Sense application and the resulting data are
#' retrieved completely by paging calls.
#'
#' @param host a URL where the q-risotto service runs, usually the Qlik Sense
#'   Desktop (localhost) or Server IP addresss
#' @param port a port number where to connect q-risotto,
#' @param app a Qlik Sense application name to connect, usually a GUID for
#'   applications on a Qlik Sense Server
#' @param hyperCubeDef a list of dimensions (field names) and measure
#'   expressions (starting with '='), see q-risotto README for more details; the
#'   1st field needs to contain the date/timestamp values
#' @param fields a list of field names which will be assigned to the resulting
#'   vectors
#' @param tz a timezone to convert the date/timestamp to  (default "UTC")
#'
#' @return a dataframe with timelines containing the resulting HyperCube data
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' \dontrun{
#' host <- "http://localhost"
#' port <- 3000
#' app <- "Helpdesk Management.qvf"
#' hyperCubeDef <- c("Date.autoCalendar.Date", "=Count( {$<[Case Is Closed] ={'True'} >} Distinct %CaseId )", "=Count( {$<[Status]={'New'} >} Distinct %CaseId )")
#' fields <- c("Date", "Closed Cases", "New Cases")
#' senser_data(host=host,port=port,app=app,hyperCubeDef=hyperCubeDef,fields=fields)}
senser_timeline <- function(host,
                            port,
                            app,
                            hyperCubeDef,
                            fields,
                            tz = "UTC") {

  # get the data from Qlik Sense
  senser_data(host, port, app, hyperCubeDef, fields) %>%
    # convert date/timestamp result into POSIXct vector
    dplyr::mutate_at(1, lubridate::ymd_hms, tz = tz) %>%
    # order by date/timestamp field
    dplyr::arrange_at(1:2) %>%
    # add a row number field (now used for DataRobot integration)
    dplyr::mutate(rowno = dplyr::row_number())
}

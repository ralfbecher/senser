#' Retrieves a dataframe containing data from a Qlik Sense HyperCube
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
#'   Desktop (localhost) or Server IP address
#' @param port a port number where to connect q-risotto,
#' @param app a Qlik Sense application name to connect, usually a GUID for
#'   applications on a Qlik Sense Server
#' @param hyperCubeDef a list of dimensions (field names) and measure
#'   expressions (starting with '='), see q-risotto README for more details
#' @param fields a list of field names which will be assigned to the resulting
#'   vectors
#'
#' @return a dataframe containing the resulting HyperCube data
#'
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
senser_data <- function(host,
                        port,
                        app,
                        hyperCubeDef,
                        fields) {

  if (missing(host))
    stop("q-risotto host not specified")

  if (missing(port))
    stop("q-risotto port not specified")

  if (missing(app))
    stop("app id not specified")

  if (missing(hyperCubeDef))
    stop("hyperCubeDef not specified")

  if (missing(fields))
    stop("fields not specified")

  app <- utils::URLencode(app)

  cat("host = ", host, "\n",
      "port = ", port, "\n",
      "app = ", app, "\n",
      "hyperCubeDef = ", hyperCubeDef, "\n",
      "fields = ", fields, "\n",
      sep = "")

  urlRoot <- "/v1/doc/"
  enc <- "json"
  conf <- httr::config(ssl_verifypeer = FALSE)

  urlSize <- paste0(host, ":", port, urlRoot, app, "/hypercube/size")
  url <- paste0(host, ":", port, urlRoot, app, "/hypercube/json")

  r <- httr::POST(
    urlSize,
    body = jsonlite::toJSON(hyperCubeDef),
    encode = enc,
    config = conf
  )

  size <- jsonlite::fromJSON(httr::content(r, "text"))

  if (size$pages > 1) {

    pages <- size$pages[1]

    d <- vector(mode = "list", length = pages)

    for (i in 1:pages) {

      url <- paste0(host, ":", port, urlRoot, app, "/hypercube/json/", i)

      r <-
        httr::POST(
          url,
          body = jsonlite::toJSON(hyperCubeDef),
          encode = enc,
          config = conf
        )

      d[[i]] <- jsonlite::fromJSON(httr::content(r, "text"))
    }

    d <- dplyr::bind_rows(d)

  } else {

    r <-
      httr::POST(
        url,
        body = jsonlite::toJSON(hyperCubeDef),
        encode = enc,
        config = conf
      )
    d <- jsonlite::fromJSON(httr::content(r, "text"))
  }

  names(d) <- fields

  d
}

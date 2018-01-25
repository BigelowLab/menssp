#' Get the URI for past P90 data by year
#'
#' @export
#' @param year string or numerc year
#' @param base_uri the base MapServer uri
#' @return the uri as string
uri_P90 <- function(year = '2016',
    base_uri = file.path(uri_base(),
        "DMR_Public_Health_Historical_Bacteria_Data/MapServer")){

    switch(year[1],
        '2016' = file.path(base_uri,0),
        '2015' = file.path(base_uri,1),
        '2014' = file.path(base_uri,2),
        '2013' = file.path(base_uri,3)
        )
}

#' Get the URI for past nssp by year
#'
#' @export
#' @param year string or numerc year
#' @param base_uri the base MapServer uri
#' @return the uri as string
uri_nssp <- function(year = '2016',
    base_uri = file.path(uri_base(),
        "DMR_Public_Health_Historical_Bacteria_Data/MapServer")){

    switch(year[1],
        '2016' = file.path(base_uri,4),
        '2015' = file.path(base_uri,5),
        '2014' = file.path(base_uri,6),
        '2013' = file.path(base_uri,7)
        )
}


#' Get the uri of the current NSSP areas
#'
#' @export
#' @return the uri as string
uri_current <- function(){
    file.path(uri_base(),
    "/DMR_Public_Health_NSSP_current/MapServer/0")
}

#' Get the base uri
#'
#' @export
#' @return the base uri for DMR's map services
uri_base <- function(){
    "https://gis2.maine.gov/arcgis/rest/services/dmr"
}

#' Launch URI for browsing if possible
#'
#' @export
#' @param what string, 'mapserver' or 'info'
#' @return integer flag, 0 means success
browse_dmr <- function(what = c("mapserver", "info")[1]){
    uri <- switch(tolower(what[1]),
        'info' = 'http://www.maine.gov/dmr/shellfish-sanitation-management/closures/pollution.html',
        uri_base())
    httr::BROWSE(uri)
}

#' Read locally stored P90 data
#'
#' @export
#' @param year numeric or string year to read
#' @param path local path to files
#' @return sf of Points
read_P90 <- function(year = 2016,
    path = '/Users/ben/Dropbox/shellfish/data/dmr/P90'){
        
    f = file.path(path, paste0("P90-", year[1], ".geojson"))
    sf::st_read(f)
}

#' Read locally stored NSSP annual data
#'
#' @export
#' @param year numeric or string year to read
#' @param path local path to files
#' @return sf of Points
read_nssp <- function(year = 2016,
    path = '/Users/ben/Dropbox/shellfish/data/dmr/nssp'){
        
    f = file.path(path, paste0("NSSP-", year[1], ".geojson"))
    sf::st_read(f)
}



#' Convert ESRI datetime (ms since 1970-01-01) to POSIXct
#' @export
#' @param x the input numeric ESRI timestamp
#' @param origin character - epoch origin as string
#' @param fact numeric scaling factor to convert from ms to s
to_POSIXct <- function(x, origin = '1970-01-01 00:00.00 UTC', fact = 1000.0){
    as.POSIXct(x/1000,
               origin = '1970-01-01 00:00.00 UTC')
}

#' Fetch the current NSSP closures as geojson
#'
#' @export
#' @param uri string the uri to fetch
#' @param dst_path string, the path to write to
fetch_current <- function(uri = uri_current(),
    dst_path = "/Users/ben/Dropbox/shellfish/data/dmr/current"){
    
    
    df = try(esri2sf::esri2sf(uri))
    if (inherits(df, 'try-error')) stop("error fetching current")
    
    # convert from esritime to POSIXct 
    nm = names(df)
    if ('D_EFFECTIVE' %in% nm)
        df$D_EFFECTIVE = to_POSIXct(df$D_EFFECTIVE)
    if ('D_REPEAL' %in% nm)
        df$D_REPEAL = to_POSIXct(df$D_REPEAL)
    oname = sprintf("NSSP-%s.geojson", format(as.Date(Sys.time()),"%Y-%m-%d"))
    sf::st_write(df, file.path(dst_path, oname), delete_dsn = TRUE)
    invisible(df)
}

#' Read the current NSSP (either from disk or online)
#'
#' @export
#' @param what string, either 'local' or 'live'
#' @param local_path string, if local look here for the NSSP data
#' @param ... further arguments for fetch_current if required
#' @return sf
read_current <- function(what = c("local", "live")[1],
    local_path = "/Users/ben/Dropbox/shellfish/data/dmr/current",
    ...){
     
    if (tolower(what[1]) == 'local'){
        ff <- list.files(local_path, pattern = '^NSSP.*\\.geojson$',
              full.names = TRUE)
        x <- sf::st_read(ff[length(ff)])  
    } else {
        x <- fetch_current()
    }   
    invisible(x)
} 

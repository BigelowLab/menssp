
#' Return the default path, possible stored as an R option "MENSSP_PATH"
#'
#' The function attempts to retrieve this from option("MENSSP_PATH") which can be
#' set at the begging of the R session or placed in the users .Rprofile
#'
#' @export
#' @param x subdirectory (ala "current" or "nssp" or "P90")
#' @param root the path to the various NSSP datasets
#' @return named logical, TRUE if the path exists
has_menssp <- function(x, root = options("MENSSP_PATH")[[1]]){
    if (is.null(root)) {
        warning("root path to MENSSP data is NULL")
        return(FALSE)
    }
    path <- if(!missing(x)) file.path(root, x) else root
    x <- sapply(path[1], dir.exists)
    if (!x[1]){
        warning("path to MENSSP data not found:", path[1])
    }
    x
}

#' Retrieve the MENSSP path
#'
#' @export
#' @param ... further arguments for \code{has_nsspme}
#' @return the known MENSSP path
menssp_path <- function(...){
    names(has_menssp(...))
}

#' Retrieve sets of PA_NUMBERs by regional name.
#'
#' @seealso \url{http://www.maine.gov/dmr/shellfish-sanitation-management/closures/pollution.html}
#' @export
#' @param region string, defaults to 'Casco Bay'
#' @return a string vector, possibly empty
PA_ID <- function(region = 'Casco Bay'){
    switch(tolower(region[1]),
        'casco bay' = c("13","14","15","16", "17-A", "17-B","17-C",
                        "18", "19-A", "19-B", "19-C"),
        'yarmouth'  = "14",
        "")
}

#' Read locally stored NSSP current data
#'
#' @export
#' @param filename string filename with path or 'most_recent' (default) or 'online'
#'  If 'online' then the current data is downloaded (and saved) before returning.
#' @param path local path to NSSP files
#' @param pa_number  values to search for in the PA_NUMBER column or NA,
#'      by default it is the value of \code{PA_ID(region = "casco bay")}.
#' @return sf of NSSP pollution areas
read_nssp <- function(filename = c('most_recent', "online")[1],
    pa_number = list(PA_ID("casco bay"), NA)[[1]],
    path = menssp_path()){

    if (tolower(filename[1]) == 'online'){
        x = fetch_current()
    } else {
        if (tolower(filename[1]) == 'most_recent'){
            path <- file.path(path, 'current')
            ff <- list.files(path, pattern = utils::glob2rx("*.geojson"), full.names = TRUE)
            filename = ff[1]
        }
        x <- sf::read_sf(filename[1])
    }
    if (!is.na(pa_number[1])) x <- x %>% dplyr::filter(PA_NUMBER %in% pa_number)
    x
}

#' Read locally stored archived NSSP data
#'
#' @export
#' @param year numeric or string year to read
#' @param path local path to files
#' @return sf of MULTIPOLYGON or NULL
read_archived <- function(year = '2013',
    path = menssp_path("nssp")){
    f = file.path(path, paste0("NSSP-", year[1], ".geojson"))
    if (file.exists(f)){
        sf::st_read(f)
    } else {
        warning("file not found:", f)
        x = NULL
    }
}

#' Read locally stored P90 data
#'
#' @export
#' @param year numeric or string year to read
#' @param path local path to files
#' @return sf of Points
read_P90 <- function(year = 2016,
    path = menssp_path('P90')){

    f = file.path(path, paste0("P90-", year[1], ".geojson"))
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

#' Fetch the current NSSP closures as sf with the option to save
#'
#' @export
#' @param uri string the uri to fetch
#' @param dst_path string, the path to write to depending upon save_current.
#'  Output file is saved with filename 'NSSP-YYYY-mm-dd.geojson'
#' @param save_current character, if 'yes' then save and possible
#' @return sf_MULTIPOLYGON
fetch_current <- function(uri = uri_current(),
    pa_number = PA_ID("Casco Bay"),
    save_current = c("yes", "if_different", "no")[2]){


    df = try(esri2sf::esri2sf(uri))
    if (inherits(df, 'try-error')) stop("error fetching current")

    if (!is.na(pa_number[1])) x <- x %>% dplyr::filter(PA_NUMBER %in% pa_number)

    # convert from esritime to POSIXct
    nm = names(df)
    if ('D_EFFECTIVE' %in% nm)
        df$D_EFFECTIVE = to_POSIXct(df$D_EFFECTIVE)
    if ('D_REPEAL' %in% nm)
        df$D_REPEAL = to_POSIXct(df$D_REPEAL)
    oname = sprintf("NSSP-%s.geojson", format(as.Date(Sys.Date()),"%Y-%m-%d"))
    ofile = file.path(dst_path, "current", oname)
    #if (file.exists(ofile)) ok <- file.remove(ofile)
    if (tolower(save_current) != 'no'){
        if (tolower(save_current) == "if_different"){
            x <- read_nssp(pa_number = pa_number)
            save_it = !identical(df, x)
            if (save_it) sf::write_sf(df, ofile, quiet = TRUE, delete_layer = TRUE)
        } else {
            sf::write_sf(df, ofile, quiet = TRUE, delete_layer = TRUE)
        }
    }
    invisible(df)
}



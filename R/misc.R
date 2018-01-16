#' Returns the  NSSP codes
#'
#' @export
#' @return named character vector
NSSP_LUT <- function(){
    c(
        P = "Prohibited",
        R = "Restricted",
        CR = "Conditionally Restricted",
        CA = "Conditionally Approved",
        CRR = "Conditionally Restricted for Relay"
    )

}

#' Return the P90 breaks as numeric break points
#'
#' @export
#' @return named numeric vector
P90_breaks <- function(){
    c(
        "<2 - 15" = 15,
        "15.1 - 25" = 25,
        "25.1 - 30.9" = 30.999999,
        "31-163" = 163,
        ">163" = 1600
    )
}

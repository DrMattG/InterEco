#' @title Simulated data for use with the InterEcol project
#' @description A simulated dataset of abundance for two different species/taxa. The data were simulated using the data.fr() function from the AHMbook.
#' @format A data frame with 200 rows and 4 variables:
#' \describe{
#'   \item{\code{forest}}{double Percentage forest cover}
#'   \item{\code{elev}}{double Elevation above sea level}
#'   \item{\code{abun}}{integer Number of individuals }
#'   \item{\code{taxon}}{character Species/taxon identifier}
#'}
#' @details  data were simulated using AMHbook::data.fn(M = 100, J = 1, mean.lambda = 12, beta1 = 0, beta2 = -1, beta3 = -1,mean.detection = 1, alpha1 = 0, alpha2 = 0, alpha3 = 0) for taxonA and AMHbook::data.fn(M = 100, J = 1, mean.lambda = 12, beta1 = 0, beta2 = -1, beta3 = -2,mean.detection = 1, alpha1 = 0, alpha2 = 0, alpha3 = 0)
"fake_data"

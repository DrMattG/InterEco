#' custom_function for plotting
#'
#' @param data data to be plotted
#' @param mapping mapping of aes
#' @param method method to be used defaults to loess
#' @param ...
#'
#' @return smoothed loess line
#' @export
#'

custom_function = function(data, mapping, method = "loess", ...){
  p = ggplot(data = data, mapping = mapping) +
    geom_point() +
    geom_smooth(method=method, ...)

  p
}

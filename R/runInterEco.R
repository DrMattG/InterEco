#' runInterEco
#' Run the shinyApp associated with interEco
#' @return launches the interEco ShinyApp
#' @importFrom shiny runApp
#' @export

runInterEco <- function() {
  appDir <- system.file("shiny-examples", "interEco", package = "InterEco")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `InterEco`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}

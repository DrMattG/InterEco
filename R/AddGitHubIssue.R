#' AddGitHubIssue
#'
#' @param endpoint The repo where you want the issue to be written (default is InterEco)
#' @param title Title of the issue
#' @param body The description of the issue
#' @return Adds GitHub issue to the package repository
#' @importFrom gh gh
#' @export
#'
#'@examples
#'\dontrun{
#'AddGitHubIssue(title="Test issue", body="Test automatic issue")
#'}
AddGitHubIssue<-function(endpoint="POST /repos/DrMattG/InterEco/issues", title, body){

  gh::gh(
    endpoint = endpoint ,
    title = title,
    body = body )

}


#' Check_model
#'
#' @param modelObj glm model object
#'
#' @return model diagnostics
#' @export
#'
check_model<-function(modelObj){
performance::check_model(modelObj)
}


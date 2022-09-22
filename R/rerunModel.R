# create a general for working with different model types

# Include the model and the data in an object

#' Rerun the model for use with some plot types
#'
#' @param input model and data list object
#'
#' @return rerun model object
#' @export
#'

rerunModel<-function(input){
  if(is.null(input$method)){
  input
  }else{
    if(input$method=="glm.fit"){
      glm(as.formula(input$formula), family =input$family$family, data = input$data )

    }else{
      print("Model type not supported yet")
    }
  }
  }


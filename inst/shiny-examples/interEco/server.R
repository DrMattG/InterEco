#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {


  #start_text <- read_file("C:/Users/matthew.grainger/Documents/Projects_in_development/InterEco/inst/shiny-examples/interEco/www/AboutinterEco.html")
  #how_cite_text <- read_file("C:/Users/matthew.grainger/Documents/Projects_in_development/InterEco/inst/shiny-examples/interEco/www/HowCiteinterEco.html")
  #how_works_text <- read_file("C:/Users/matthew.grainger/Documents/Projects_in_development/InterEco/inst/shiny-examples/interEco/www/HowinterEcoworks.html")

   start_text <- read_file("www/AboutinterEco.html")
   how_cite_text <- read_file("www/HowCiteinterEco.html")
   how_works_text <- read_file("www/HowinterEcoworks.html")

   data_internal <- reactiveValues(
     raw = NULL
   )


  output$start_text <- renderPrint({
    cat(start_text)
  })
  output$about_sysmap_text <- renderPrint({
    cat(about_sysmap_text)
  })
  output$how_works_text <- renderPrint({
    cat(how_works_text)
  })
  output$how_cite_text <- renderPrint({
    cat(how_cite_text)
  })

  observeEvent(input$model_upload, {
    data_internal$raw <- readRDS(
      file = input$model_upload$datapath)

  })

  observeEvent(input$sample_or_real, {
    if(input$sample_or_real == "sample"){
      data_internal$raw <- InterEco::internal_model
      #data_internal$filtered <- data_internal$raw #instantiate filtered table with raw values
    } else {
      data_internal$raw <- NULL
      #data_internal$filtered <- NULL
    }
  })

  data_active <- reactive({
    req(data_internal$raw)
      d_out <-data_internal$raw

  })

  output$model_summary <- renderPrint({
    if(!is.null(data_internal$raw)){
      jtools::summ(data_internal$raw)
    }
  })

  output$VIFplot<-renderPlot(
    tidyVIF(data_internal$raw)
  )

})

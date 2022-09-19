#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#options(repos = c("CRAN" = "https://cran.rstudio.com/", "InterEco"="https://github.com/DrMattG/InterEco"))
# TODO find out why App will not deploy to ShinyApps.io - something to do with the build of InterEco


library(shiny)
library(InterEco)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {



   start_text <- readr::read_file("www/AboutinterEco.html")
   how_cite_text <- readr::read_file("www/HowCiteinterEco.html")
   how_works_text <- readr::read_file("www/HowinterEcoworks.html")

   data_internal <- reactiveValues(
     raw1 = NULL
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
      data_internal$raw1 <- internal_model
       } else {
      data_internal$raw1 <- NULL

    }
  })

  data_active <- reactive({
    req(data_internal$raw1)
      d_out <-data_internal$raw1

  })

  output$model_summary <- renderTable({
    if(!is.null(data_internal$raw1)){
      coefdat <- jtools::summ(data_active())
      coefdat <- round(data.frame(coefdat$coeftable),3)
      coefdat
      }
  }, rownames = TRUE)

  output$VIFplot<-renderPlot(
    tidyVIF(data_internal$raw1)
  )

})

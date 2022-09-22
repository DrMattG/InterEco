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
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$inCond <- renderUI({
   fluidPage(
    sidebarPanel(
    selectInput("VAR1",
              label = "Variable 1",
              choices = names(eval(data_active()$model))),
   selectInput("VAR2",
                label = "Variable 2",
                choices = names(eval(data_active()$model))),
   selectInput("SCALE_RESPONSE",
                label = "Scale of response variable",
                choices = c("Log", "Original"))
   #,
  #sliderInput("LUI",
  #              label = "LUI_sel",
   #            min = min(data_active()$data$lui, na.rm = TRUE), max = max(data_active()$data$lui, na.rm = TRUE),
    #           value = median(data_active()$data$lui, na.rm = TRUE), step = 1),
  #
  #  sliderInput("perc.Clay_sel",
  #              label = "Percentage clay, %",
  #            min = min(data_active()$data$perc_clay, na.rm = TRUE), max = max(data_active()$data$perc_clay, na.rm = TRUE),
  #            value = median( data_active()$data$perc_clay, na.rm = TRUE), step = 10),
  # sliderInput("Bare_sel",
  #              label = "Percentage bare ground, %",
  #              min = min(data_active()$data$bare, na.rm = TRUE), max = max(data_active()$data$bare, na.rm = TRUE),
  #              value = median(data_active()$data$bare, na.rm = TRUE), step = 10),
  #  sliderInput("Exotic_grnd_sel",
  #              label = "Percentage cover of exotic species",
  #              min =  min(data_active()$data$exotic_grnd, na.rm = TRUE), max = max( data_active()$data$exotic_grnd, na.rm = TRUE),
  #              value = median(data_active()$data$exotic_grnd, na.rm = TRUE), step = 10)
   ),
   mainPanel(plotOutput("cond.plots")))
    })


  output$inPred<-renderUI({
    fluidPage(
      sidebarPanel(
        selectInput("Predictor",
                    label="Choose the predictor variable",
                    choices = names(eval(data_active()$model))),
        selectInput("Interaction",
                    label="Choose the variable that interacts with the predictor",
                    choices=names(eval(data_active()$model))),
        selectInput("Conditional",
                    label="Choose the conditional variable",
                    choices=names(eval(data_active()$model)))),
    mainPanel(
      plotOutput("pred.plots")))
  })

   data_internal <- reactiveValues(
     model = NULL
   )



  observeEvent(input$model_upload, {
    data_internal$model <- readRDS(
      file = input$model_upload$datapath)

  })

  observeEvent(input$sample_or_real, {
    if(input$sample_or_real == "sample"){
      data_internal$model <- InterEco::mod
      } else {
      data_internal$model <- NULL
         }
  })

  data_active <- reactive({
    req(data_internal$model)
      data_active<-data_internal$model

  })



  output$cond.plots <- renderPlot({
    condPlot(fit=fit, xvar=xvar, by=by, cond=cond, VAR1 = VAR1, VAR2=VAR2)

  })

  output$pred.plots<-renderPlot({

    x.mult=visreg::visreg(data_active(), input$Predictor, input$Interaction,  overlay=T, partial=F, cond=list(taxon="A"))
    x.mult=visreg::visreg(data_active(), input$Predictor, input$Interaction,  overlay=T, partial=F, cond=list(taxon="B"))

    x.add <- visreg::visreg(data_active(),input$Predictor, input$Interaction, scale="response", cond=list(taxon="A"))
    x.add <- visreg::visreg(data_active(), input$Predictor, input$Interaction, scale="response", cond=list(taxon="B"))

    plot1<-x.add$fit%>%ggplot(aes(x=input$Predictor))+geom_ribbon(aes(ymin=visregLwr,ymax=visregUpr, fill=as.factor(round(elev))),alpha=0.2)+geom_line(aes(y=visregFit, col=as.factor(round(elev))), lwd=2)+scale_color_viridis_d("ELEV")+theme_bw()+ylab("Predicted abundance")+xlab("forest (%)")+scale_fill_viridis_d("ELEV")

    plot2<-x.mult$fit%>%ggplot(aes(x=input$Predictor))+geom_ribbon(aes(ymin=visregLwr,ymax=visregUpr, fill=as.factor(round(elev))),alpha=0.2)+geom_line(aes(y=visregFit, col=as.factor(round(elev))), lwd=2)+scale_color_viridis_d("ELEV")+theme_bw()+ylab("Predicted abundance")+xlab("forest (%)")+scale_fill_viridis_d("ELEV")
    gridExtra::grid.arrange(plot1,plot2)
  })


})

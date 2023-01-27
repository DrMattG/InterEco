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

#bestmod
dat<-InterEco::ants
dat<-dat%>%na.omit()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  start_text <- readr::read_file("www/AboutinterEco.html")
  how_cite_text <- readr::read_file("www/HowCiteinterEco.html")
  how_works_text <- readr::read_file("www/HowinterEcoworks.html")



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

  output$RDtext<-renderPrint({
    cat("Here, we provide plots of residuals (standardised) to demonstrate that model assumptions are verified.
        Following Zuur & Ieno (2016) [https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.12577]
        and Zuur et al. (2009), we have plotted[https://doi.org/10.1017/CBO9781107415324.004]
        residuals versus fitted values (fig A), versus each covariate in the model (panel B)
        and versus covariates not in the model (panel C).
        We have also assessed the residuals for temporal and spatial dependency, by plotting residuals versus
        the x and y spatial coordinates (panel D).")
  })

  output$VIFtext<-renderPrint({
    cat("To evaluate whether coefficient variances were inflated by any multicollinearity,
    we computed generalised variance inflation factors GIF(1/(2×df)),
    following Fox & Monette (1992) [https://www.jstor.org/stable/2290467#metadata_info_tab_contents].
    All values are <2, suggesting collinearity is not an issue.")
  })

  output$RDPlot<-renderPlot({
    resDHARMa = simulateResiduals(bestmod, n=200, plot=T, integerResponse = T)

     dat$resid <- resDHARMa$scaledResiduals
     dat$predicted <- resDHARMa$fittedPredictedResponse
     dat$observed <- resDHARMa$observedResponse
    #residuals vs spatial variables
    st <- dat%>%dplyr::select(richness,resid, predicted, observed,  x,y,site_id)%>%
       pivot_longer(cols=-c("richness","site_id", "resid"), names_to = "VAR")%>%
       ggplot()+geom_jitter(aes(x=value, y=resid), alpha=0.2,width=0.1)+facet_wrap(~VAR, scales = "free_x")+theme_bw()+ylab("Scaled residuals")+xlab("Variable")+scale_color_discrete(guide=F)+ggtitle("spatial and temporal variables")+geom_smooth(aes(x=value, y=resid)) #residuals vs predictors in model
    im <- dat%>%dplyr::select(resid, site_id, lt_clim, woody, perc_clay, bare, lui, exotic_grnd)%>%
     pivot_longer(cols=-c("site_id", "resid"), names_to = "VAR")%>%
     ggplot()+geom_jitter(aes(x=value, y=resid), alpha=0.2,width=0.1)+facet_wrap(~VAR, scales = "free_x")+theme_bw()+ylab("Scaled residuals")+xlab("Variable")+scale_color_discrete(guide=F)+ggtitle("variables in model")+geom_smooth(aes(x=value, y=resid)) #residuals vs predictors not in model
     nm <- dat%>%dplyr::select(resid, site_id, elev, grnd_cvr, litter, logs, c_n )%>%
     pivot_longer(cols=-c("site_id", "resid"), names_to = "VAR")%>%
     ggplot()+geom_jitter(aes(x=value, y=resid), alpha=0.2,width=0.1)+facet_wrap(~VAR, scales = "free_x")+theme_bw()+ylab("Scaled residuals")+xlab("Variable")+scale_color_continuous(guide=F)+ggtitle("omitted variables")

    gridExtra::grid.arrange(im,st, nrow=2)

  })

  output$VIFPlot<-renderPlot({
    vifs <- data.frame(car::vif(bestmod))
    vifs%>%
      mutate(VAR=row.names(vifs))%>%#next consider cleaning the variable names, as they include the 'scaled' text.
      mutate(VAR= stringr::str_extract(string=VAR, pattern = "(?<=\\().*(?=\\))"))%>%# get rid of the scale text
      mutate(VAR= recode_factor(VAR,"lt_clim):scale(woody"="lt_clim:woody", "lt_clim):scale(perc.Clay"="lt_clim:perc.Clay", "lt_clim):scale(bare"="lt_clim:bare"), VIFs=car..vif.bestmod.)%>%
      ggplot()+geom_point(aes(x=VAR, y=VIFs))+geom_hline(yintercept = 2, linetype="dashed", col="red")+theme_bw()+ylab("VIF")+xlab("Variable")+ theme(axis.text.x = element_text(angle = 90))

  })


#   cond_level<-data.frame("Factors"=unlist(strsplit(unique(mod$data[names(mod$xlevels)])[,],split = " ")))
#
#   output$inEffect <- renderUI({
#    fluidPage(
#      sidebarPanel(
#        selectInput("pred",
#                    label="Choose the predictor variable",
#                    choices = names(eval(data_active()$model))),
#        selectInput("modx",
#                    label="Choose the moderator variable",
#                    choices = names(eval(data_active()$model))),
#                    ),
#      mainPanel(plotOutput("effect.plot"),
#                plotOutput("jn.plot")))
#     })
#
#
#   output$inPred<-renderUI({
#     fluidPage(
#       sidebarPanel(
#         selectInput("Predictor",
#                     label="Choose the predictor variable",
#                     choices = names(eval(data_active()$data))),
#         selectInput("Interaction",
#                     label="Choose the variable that interacts with the predictor",
#                     choices=names(eval(data_active()$data))),
#         selectInput("Conditional",
#                      label="Choose the condition",
#                     choices=cond_level$Factors)),
#
#     mainPanel(
#       plotOutput("pred.plots")))
#   })
#
#    data_internal <- reactiveValues(
#      model = NULL
#    )
#
#
#
#   observeEvent(input$model_upload, {
#     data_internal$model <- readRDS(
#       file = input$model_upload$datapath)
#
#   })
#
#   observeEvent(input$sample_or_real, {
#     if(input$sample_or_real == "sample"){
#       data_internal$model <- InterEco::input
#       } else {
#       data_internal$model <- NULL
#          }
#   })
#
#   data_active <- reactive({
#     req(data_internal$model)
#       data_active<-data_internal$model
#
#   })
#
#
#
#   output$cond.plots <- renderPlot({
#     condPlot(fit=fit, xvar=xvar, by=by, cond=cond, VAR1 = VAR1, VAR2=VAR2)
#
#   })
#
#   output$pred.plots<-renderPlot({
# mod=InterEco::rerunModel(data_active())
#
#     x.mult=visreg::visreg(mod, input$Predictor, input$Interaction,  overlay=T, partial=F, cond=list(taxon="B"),data = data_active()$data)
#     #x.mult=visreg::visreg(mod, input$Predictor, input$Interaction,  overlay=T, partial=F, cond=list(taxon="B"), data = data_active()$data)
#
#     x.add <- visreg::visreg(mod,input$Predictor, input$Interaction, scale="response", cond=list(taxon="B"), data = data_active()$data)
#     #x.add <- visreg::visreg(mod, input$Predictor, input$Interaction, scale="response", cond=list(taxon="B"),data = data_active()$data)
#
#     plot1<-x.add$fit%>%ggplot(aes(x=input$Predictor))+geom_ribbon(aes(ymin=visregLwr,ymax=visregUpr, fill=as.factor(round(elev))),alpha=0.2)+geom_line(aes(y=visregFit, col=as.factor(round(elev))), lwd=2)+scale_color_viridis_d("ELEV")+theme_bw()+ylab("Predicted abundance")+xlab("forest (%)")+scale_fill_viridis_d("ELEV")
#
#     #plot2<-x.mult$fit%>%ggplot(aes(x=input$Predictor))+geom_ribbon(aes(ymin=visregLwr,ymax=visregUpr, fill=as.factor(round(elev))),alpha=0.2)+geom_line(aes(y=visregFit, col=as.factor(round(elev))), lwd=2)+scale_color_viridis_d("ELEV")+theme_bw()+ylab("Predicted abundance")+xlab("forest (%)")+scale_fill_viridis_d("ELEV")
#     #gridExtra::grid.arrange(plot1,plot2)
#   })
#
#   output$effect.plot<-renderPlot({
#     mod=InterEco::rerunModel(data_active())
#     plot(effects::allEffects(mod))
#   })
#
#   output$jn.plot<-renderPlot({
#     mod=InterEco::rerunModel(data_active())
#     interactions::johnson_neyman(mod, pred =
#                                    input$pred, modx = input$modx,
#                                  plot = T)
#   })

})

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

options(repos = c("CRAN" = "https://cran.rstudio.com/", "InterEco"="https://github.com/DrMattG/InterEco"))

library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyWidgets)
library(InterEco)
easyprint_js_file <- "https://rawgit.com/rowanwins/leaflet-easyPrint/gh-pages/dist/bundle.js"

sidebar <- dashboardSidebar(

   sidebarMenu(id = "main_sidebar",
              menuItem("About interEco", tabName = "about",
                       icon = icon("question")),
              menuItem("interEco", tabName = "home",
                       icon = icon("map")),
              menuItem("View Code",
                       href = "https://github.com/DrMattG/InterEco",
                       icon = icon("github")),
              menuItem("Upload model",
                       radioButtons(
                         "sample_or_real",
                         label = h4("Which Model to Use?"),
                         choices = list(
                           "Sample Model" = "sample",
                           "Upload model object" = "user"),
                         selected = "sample"
                       ),
                       bsTooltip("sample_or_real",
                                 title = "Select whether you want to try interEco using the sample model, or whether you wish to upload your own model object in the correct format",
                                 placement = "left",
                                 trigger = "hover"
                       ),
                       conditionalPanel(
                         condition = "input.sample_or_real == 'user'",

                         # Input: Select a file ----
                         menuItem(
                           fileInput(
                             "model_upload",
                             label = "Choose model object",
                             multiple = FALSE,
                             accept = c(
                               ".RDS"),
                             placeholder = ".RDS file"))
                         )
              )
                       )
  )

home <- tags$html(
  tags$head(
    #includeHTML("www/google-analytics.html"),
    tags$title('interEco'),
    tags$script(src=easyprint_js_file)
  ),
  tags$style(type="text/css",
             "#map {height: calc(100vh - 240px) !important;}"),

)




body <- dashboardBody(

    tag("style", HTML("
                    .right-side {
                    background-color: #dbf0ee;
                    }
                    .skin-blue .main-header .logo {
                    background-color: #4FB3A9;
                    color: #ffffff;
                    }
                    .skin-blue .main-header .logo:hover {
                    background-color: #2d6c66;
                    }
                    .skin-blue .main-header .navbar {
                    background-color: #4FB3A9;
                    }
                    .skin-blue .main-header .sidebar-toggle {
                    background-color: #2d6c66;
                    }
                    ")),

    mainPanel(
      tabsetPanel(
        tabPanel("Conditional plots",
                 uiOutput("inCond")),
        tabPanel("tab2", plotOutput("plot2")),
        tabPanel("Prediction", uiOutput("inPred")),
        tabPanel("tab4", plotOutput("plot4"))
      )
    )
    )

shinyUI(
  dashboardPage(
    dashboardHeader(title = "interEco"),
    sidebar,
    body
  ))

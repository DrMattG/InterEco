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
                       icon = icon("github"))
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
         # tabItem(tabName = "about",
         #         fluidRow(
         #           mainPanel(wellPanel(
         #             tabsetPanel(
         #               tabPanel(title = 'About interEco', htmlOutput("start_text")),
         #               tabPanel(title = 'How to Use interEco', htmlOutput("how_works_text")),
         #               tabPanel(title = 'How to Cite interEco', htmlOutput("how_cite_text"))
         #             ))
         #           ))
         # ),

         tabPanel("Landing page"),
         tabPanel("Study summary",
                  htmltools::includeMarkdown("www/About_this_study.md")),
         tabPanel("Interpretation tab",
                  tabsetPanel(
                    tabPanel("multiplicative scale"),
                    tabPanel("additive scale")
                  )),
         tabPanel("Generality"),
         tabPanel("Validity",
                  #Text intro
                  tabsetPanel(
                    tabPanel("Data exploration",
                             tabsetPanel(
                               tabPanel(
                               "Character variables",
                             DT::dataTableOutput("descript1")),
                             tabPanel(
                               "Numeric variables",
                               DT::dataTableOutput("descript2")),
                             tabPanel(
                               "Pairs plot",
                               uiOutput("pairs_plot"),
                               plotOutput("pairs")
                             )
                             )),
                    tabPanel("Residual diagnostics",
                             textOutput("RDtext"),
                             plotOutput("RDPlot"),
                             textOutput("DHARMa")
                             #Residuals were estimated using the DHARMa package [https://cran.r-project.org/web/packages/DHARMa/vignettes/DHARMa.html]
                             #Add citations to used packages Zuur & Ieno (2016) https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.12577),
                    ),
                    tabPanel("Variance inflation factors",
                             textOutput("VIFtext"),
                             plotOutput("VIFPlot"))
                    #To evaluate whether coefficient variances were inflated by any multicollinearity,  we computed generalised variance inflation factors GIF(1/(2×df)) , following Fox & Monette (1992) [https://www.jstor.org/stable/2290467#metadata_info_tab_contents]. All values are <2, suggesting collinearity is not an issue.)
                    #Plot
                    #VIFs were computed using the car package [https://cran.r-project.org/web/packages/car/index.html] and visualised using ggplot2 [d].

                    )
     )
    )))

shinyUI(
  dashboardPage(
    dashboardHeader(title = "interEco"),
    sidebar,
    body
  ))

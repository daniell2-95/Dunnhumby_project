#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#setwd("C://Users//Eunsang//Documents//Dunnhumby//dunnhumby_Carbo-Loading//dunnhumby - Carbo-Loading CSV")

library(shiny)
library(shinydashboard)


dashboardPage(
  dashboardHeader(title = "Dashboard"),
  dashboardSidebar(),
  dashboardBody(fluidRow(
    box(title = "Dollar Sales for Each Commodity", plotlyOutput("plot1")),
    box(title = "Top 5 Brands for Each Commodity", plotlyOutput("plot2")),
    box(br(), sliderInput("slider", "Week Range:", min(weeks), max(weeks), 
                          c(min(weeks), max(weeks))),
      checkboxInput("checkbox", label = "Show Coupon?", value = TRUE),
      selectizeInput("selectize", 
                     label = "Choose Geography:", 
                     choices = geos , 
                     selected = c(1,2), 
                     multiple = TRUE,
                     options = NULL)),
    box(br(),
      selectInput("variable", "Commodity:", coms)
    )
  )
  )
)


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
  dashboardSidebar(sidebarMenu(
    menuItem("README", tabName = "readme", icon = icon("th")),
    menuItem("Line Plot", icon = icon("line"), tabName = "line"),
    menuItem("Dashboard", icon = icon("dashboard"), tabName = "dashboard")
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "readme",
              h2("This is a data project for Dunnhumby. 
                 It is a dashboard created to explore the effects 
                 certain variables have on sales for different commodities.")
      ),
      
      tabItem(tabName = "line",
              fluidRow(
                box(title = "Number of Transactions Over Time", 
                    plotlyOutput("plot3")),
                box(title = "Percent Change of Transactions in the Presence of Coupons Over Time", 
                    plotlyOutput("plot4")),
                box(br(), sliderInput("slider2", "Week Range:", min(weeks), 
                                      max(weeks), 
                                      c(min(weeks), max(weeks))),
                    selectizeInput("selectize2", 
                                   label = "Choose Geography:", 
                                   choices = geos , 
                                   selected = c(1,2), 
                                   multiple = TRUE,
                                   options = NULL),
                    selectizeInput("variable2",
                                   label = "Choose commodity:", 
                                   choices = coms , 
                                   selected = coms, 
                                   multiple = TRUE,
                                   options = NULL))
              )
      ),
      
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "Dollar Sales for Each Commodity", 
                    plotlyOutput("plot1")),
                box(title = "Top 5 Brands for Each Commodity by Dollar Sales", 
                    plotlyOutput("plot2")),
                box(br(), sliderInput("slider", "Week Range:", min(weeks), 
                                      max(weeks), 
                                      c(min(weeks), max(weeks))),
                    checkboxInput("checkbox", label = "Show Coupon?", 
                                  value = TRUE),
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
  )
)


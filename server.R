#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)
library(plotly)
library(data.table)
library(rsconnect)
library(bit64)



shinyServer(function(input, output) {
  
  
  
  output$plot1 <- renderPlotly({
    
    #select data based on weeks chosen
    data <- data[data$geography %in% input$selectize & 
                   (data$week >= input$slider[1] & 
                      data$week <= input$slider[2]), ]

    coms <- unique(data$commodity)
    
    sales <- data.frame(matrix(ncol = length(coms), nrow = 2))
    colnames(sales) <- coms
    
    
    #explore effect coupons have on sales 
    for (com in coms){
      sales[1, com] <- sum(data$dollar_sales[data$commodity == com &
                                               data$coupon == 1])
      sales[2, com] <- sum(data$dollar_sales[data$commodity == com &
                                               data$coupon == 0])
    }
    
    if (input$checkbox){
      plot_ly(x = ~colnames(sales), y = ~as.numeric(sales[1, ]), type = 'bar', 
              name = 'Yes Coupon', orientation = 'v') %>%
        add_trace(y = ~as.numeric(sales[2 ,]), 
                  name = 'No Coupon') %>%
        layout(yaxis = list(title = 'Dollar Sales'), barmode = 'stack', 
               xaxis = list(title = 'Commodities'))
    }
    else{
      plot_ly(x = ~colnames(sales), y = ~as.numeric(sales[1, ] + sales[2, ]), 
              type = 'bar', name = "No Coupon", orientation = 'v') %>%
        layout(yaxis = list(title = 'Dollar Sales'), barmode = 'stack',
               xaxis = list(title = 'Commodities'))
    }
  })
  
  
  output$plot2 <- renderPlotly({
    
    data <- data[data$geography %in% input$selectize & 
                   (data$week >= input$slider[1] & 
                      data$week <= input$slider[2]), ]
    
    coms <- unique(data$commodity)
    b_names <- unique(data$brand)
    
    sales <- data.frame(matrix(ncol = length(coms), nrow = 2))
    colnames(sales) <- coms
    
    #explore top 5 brands including coupon effects on them
    brands0 <- data.frame(matrix(nrow = length(coms), ncol = length(b_names)))
    brands1 <- data.frame(matrix(nrow = length(coms), ncol = length(b_names)))
    rownames(brands0) <- coms
    colnames(brands0) <- b_names
    rownames(brands1) <- coms
    colnames(brands1) <- b_names
    
    for (com in coms){
      sales[1, com] <- sum(data$dollar_sales[data$commodity == com &
                                               data$coupon == 1])
      sales[2, com] <- sum(data$dollar_sales[data$commodity == com &
                                               data$coupon == 0])
      for (b in b_names) {
        brands0[com, b] <- sum(data$dollar_sales[data$commodity == com &
                                            data$brand == b & data$coupon == 0])
        brands1[com, b] <- sum(data$dollar_sales[data$commodity == com &
                                            data$brand == b & data$coupon == 1])
      }
    }
    
    top5 <- sort(brands0[input$variable, ] + brands1[input$variable, ], 
                 decreasing = TRUE)[1:5]
    coupon <- data.frame(matrix(nrow = 2, ncol = 5))
    colnames(coupon) <- colnames(top5)
    for (t in colnames(top5)){
      coupon[1,t] <- brands0[input$variable, t]
      coupon[2,t] <- brands1[input$variable, t]
    }
    if (input$checkbox) {
      plot_ly(x = ~as.numeric(coupon[2,]), y = ~colnames(top5), type = 'bar', 
              name = "Yes Coupon", orientation = 'h') %>%
        add_trace(x = ~as.numeric(coupon[1 ,]), 
                  name = 'No Coupon') %>%
        layout(yaxis = list(title = 'Brands'), barmode = 'stack',
               xaxis = list(title = 'Dollar Sales'))
    }
    else {
      plot_ly(x = ~as.numeric(top5), y = ~colnames(top5), type = 'bar', 
              orientation = 'h') %>%
        layout(yaxis = list(title = 'Brands'), barmode = 'stack',
               xaxis = list(title = 'Dollar Sales'))
    }
  })
  
  output$plot3 <- renderPlotly({
    
    
    data <- data[data$geography %in% input$selectize2 & 
                   (data$week >= input$slider2[1] & 
                      data$week <= input$slider2[2]) &
                   data$commodity %in% input$variable2, ]
    
    
    weeks <- unique(data$week)
    
    trips <- c()
    
    for (w in weeks) {
      trips[w] <- nrow(data[data$week == w, ])
    }
    
    
    plot_ly(x = ~seq(input$slider2[1], input$slider2[2], by = 1), 
            y = ~trips[input$slider2[1] : input$slider2[2]], mode = 'line') %>%
      layout(yaxis = list(title = 'Number of Transactions'),
             xaxis = list(title = 'Weeks'))
  })
  
  output$plot4 <- renderPlotly({
    
    data <- data[data$geography %in% input$selectize2 & 
                   (data$week >= input$slider2[1] & 
                      data$week <= input$slider2[2]) &
                   data$commodity %in% input$variable2, ]
    
    data1 <- data[data$coupon == 1, ]
    data0 <- data[data$coupon == 0, ]
    
    weeks <- unique(data$week)
    
    trips <- c()
    
    for (w in weeks) {
      trips[w] <- (nrow(data1[data1$week == w, ]) / 
                     nrow(data0[data0$week == w, ])) + 1
    }
    
    
    plot_ly(x = ~seq(input$slider2[1], input$slider2[2], by = 1), 
            y = ~trips[input$slider2[1] : input$slider2[2]], mode = 'line') %>%
      layout(yaxis = list(title = 'Percent Change in Number of Transactions'),
             xaxis = list(title = 'Weeks'))
  })
  
    
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
  
})

library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)
library(plotly)
library(data.table)


trans <- fread("dh_transactions.csv", select = 
                     c("upc", "dollar_sales", "geography", "week", "coupon"), 
                   header = TRUE)
product <- read.csv("dh_product_lookup.csv", header = TRUE)

data <- sample_n(as.data.frame(merge(x=trans,y=product,by="upc")), 1000)

geos <- unique(data$geography)

coms <- unique(data$commodity)

weeks <- unique(data$week)
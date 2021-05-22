#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

setwd(file.path('github', 'decision_intuition_support'))

library(shiny)
library(rsconnect)

source(file.path('utils', 'get_packages.R'))
source('ui.R')
source('server.R', encoding="utf-8")

get_packages(c('data.table',
               'tidyverse',
               'dplyr',
               'rsconnect',
               'ggplot2',
               'pins',
               'readxl',
               'rio',
               'rintrojs',
               'riskyr',
               'shiny',
               'shinythemes',
               'shinyWidgets',
               'sjmisc'))

# Define UI for application that draws a histogram

# Run the application 
shinyApp(ui = ui, server = server)

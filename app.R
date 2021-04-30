#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rsconnect)

source(file.path('utils', 'get_packages.R'))
source('ui.R')
source('server.R')

get_packages(c('tidyverse',
               'dplyr',
               'rsconnect',
               'ggplot2',
               'rintrojs',
               'riskyr',
               'shiny',
               'shinythemes',
               'sjmisc'))

# Define UI for application that draws a histogram

# Run the application 
shinyApp(ui = ui, server = server)

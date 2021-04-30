# Title     : Diagnostic Intuition Support
# Objective : Help medical practicioners interpreting diagnostic test outcomes
# Created by: Tim Schneegans (tim.schneegans@simplyrational.de)
# Created on: 28.04.2021

source('get_packages.R')
source('server.R')
source('ui.R')

get_packages(c('tidyverse',
               'dplyr',
               'rsconnect',
               'ggplot2',
               'rintrojs',
               'riskyr',
               'shiny',
               'shinythemes',
               'sjmisc'))

shinyApp(ui=user_interface, server=server)

# rsconnect::deployApp('path/to/your/app')
# runApp()

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
               'shiny',
               'shinythemes',
               'sjmisc'))

# rsconnect::setAccountInfo(name='simplyrational',
#                           token='D34C5E5E357A63B92E43FD11304A633C',
#                           secret='TbB7n3cq9yme9uiPERqXqWR0++iTcinYuk8/qBTj')


shinyApp(ui=user_interface, server=server)

# runApp()

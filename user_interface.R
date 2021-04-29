library(shiny)
library(ggplot2)
library(shinythemes)

source(file='about.R')
source(file=file.path('tests', 'main.R'))

user_interface <- fluidPage(theme = shinytheme('cerulean'),
                            navbarPage(
        title = "Simply Diagnostic Intuition Support",
        tabPanel(
            title = 'Input',
            sidebarPanel(
                h3('Test Library'),
                numericInput(inputId = "prevalence",
                             label = "Prevalence in %",
                             value = 0.1), # will be sent to the server
                selectInput(inputId = "hersteller",
                            label = "Choose a producer:",
                            choices = as.list(unique(data$hersteller))),
                selectInput(inputId = "test",
                            label = "Test",
                            choices = as.list(data$handelsname)),
                numericInput(inputId = "sensitivity",
                             label = "Sensitivity",
                             value = 0.8), # will be sent to the server
                numericInput(inputId = "specifity",
                             label = "Specifity",
                             value = 0.8), # will be sent to the server
            ), # sidebarPanel
            mainPanel(
                h1('Positive and Negative Predictive Value vs. Prevalence'),
                verbatimTextOutput(outputId = 'txt_output'),
                plotOutput(outputId = 'plot')
            ), # mainPanel
        ), # Input, tabPanel
        tabPanel(title = 'About', about_txt),
        tabPanel(title = 'More Products', 'So much more you can get from us')
    ) # navbarPage
) # fluidPage

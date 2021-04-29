library(shiny)
library(ggplot2)
library(shinythemes)

source(file = 'about.R')

dataset <- diamonds

user_interface = fluidPage(theme = shinytheme('cerulean'),
    navbarPage(
        title = "Simply Diagnostic Intuition Support",
        tabPanel(
            title = 'Input',
            sidebarPanel(
                numericInput(inputId = "prevalence",
                             h3("Prevalence"),
                             value = 0.3), # will be sent to the server
                numericInput(inputId = "population",
                             h3("Population"),
                             value = 10000), # will be sent to the server
                selectInput(inputId = "test",
                            label = h3("Choose a test:"),
                            choices = all_tests ,
                numericInput(inputId = "sensitivity",
                             label = "Sensitivity",
                             value = 0.8), # will be sent to the server
                numericInput(inputId = "specifity",
                             label = "Specifity",
                             value = 0.8), # will be sent to the server
                submitButton("Update")
            ), # sidebarPanel
            mainPanel(
                h1('Header 1'),
                verbatimTextOutput(outputId = 'txt_output'),
                h1('Test'),
                verbatimTextOutput(outputId = 'selected_test'),
                h1('Sensitivity'),
                verbatimTextOutput(outputId = 'sensitivity'),
                h1('Specifity'),
                verbatimTextOutput(outputId = 'specifity'),
                plotOutput(outputId = 'plot')
            ), # mainPanel
        ), # Input, tabPanel
        tabPanel(title = 'About', about_txt),
        tabPanel(title = 'More Products', 'So much more you can get from us')
    ) # navbarPage
) # fluidPage

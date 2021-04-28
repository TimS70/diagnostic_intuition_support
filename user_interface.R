library(shiny)
library(ggplot2)
library(shinythemes)

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
                            h3("Choose a test:"),
                            list(`Test Category 1` = list("Test 1",
                                                          "Test 2",
                                                          "Test 3"),
                                 `Test Category 2` = list("Test 4",
                                                          "Test 5",
                                                          "Test 6"),
                                 `Test Category 3` = list("Test 7",
                                                          "Test 8",
                                                          "Test 9"))),
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
        tabPanel(title = 'About', 'We are Simply Rational'),
        tabPanel(title = 'More Products', 'So much more you can get from us')
    ) # navbarPage
) # fluidPage

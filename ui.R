library(shiny)
library(ggplot2)
library(shinythemes)

source(file='about.R')
source(file=file.path('tests', 'main.R'))

user_interface <- fluidPage(theme = shinytheme('cerulean'),
                            navbarPage(
        title = "Simply Diagnostic Intuition Support",
        tabPanel(title='Input',
            tabsetPanel(
                id = "inTabset",
                tabPanel(
                    title = 'Test Library',
                    sidebarPanel(
                        h3('Test Library'),
                        selectInput(inputId = "hersteller",
                                    label = "Choose a producer:",
                                    choices = as.list(unique(data$hersteller))),
                        selectInput(inputId = "test",
                                                label = "Test",
                                                choices = as.list(data$handelsname)),
                        htmlOutput(outputId='test_out'),
                        hr(),
                        numericInput(inputId = "prevalence",
                                     label = h3("Prevalence"),
                                     value = 0.1), # will be sent to the server

                    ), # sidebarPanel
                    mainPanel(
                        h1('Positive and Negative Predictive Value vs. Prevalence'),
                        plotOutput(outputId = 'plot')
                    ), # mainPanel
                ), # Test Library, tabPanel
                tabPanel(
                    title='Manual settings',
                    sidebarPanel(
                        sliderInput(inputId="sensitivity", label='Sensitivity',
                                    min = 0, max = 100, value = 80),
                        sliderInput(inputId="specifity", label='Specifity',
                                    min = 0, max = 100, value = 80),
                    ),
                    mainPanel(
                        h1('Positive and Negative Predictive Value vs. Prevalence'),
                        plotOutput(outputId = 'plot_2')
                    ), # mainPanel
                ) # Input, tabPanel
            ) # tabPanel
        ), # tabsetPanel
        tabPanel(title = 'About',
            mainPanel(
            uiOutput("simply_homepage"),
            uiOutput("about_us"),
            uiOutput("about_the_test"),
            img(src='https://simplyrational.de/assets/img/banner/main_kontakt.jpg',
                height=200, width=500),
            htmlOutput(outputId="contact_us"))),
        tabPanel(title = 'More Products', 'So much more you can get from us')
    ) # navbarPage
) # fluidPage

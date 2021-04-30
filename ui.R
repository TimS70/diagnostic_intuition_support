library(shiny)
library(ggplot2)
library(shinythemes)
library(rintrojs)


source(file= 'txt_content/about.R')
source(file=file.path('tests', 'main.R'))

user_interface <- fluidPage(
    theme = shinytheme('cerulean'),
    introjsUI(),
    navbarPage(
        title = "Simply Diagnostic Intuition Support",
        tabPanel(
            title='Input',
            tabsetPanel(id = "inTabset",
                tabPanel(
                    title = 'Test Library',
                    sidebarPanel(
                        introBox(
                            h3('Test Library'),
                            selectInput(inputId = "hersteller",
                                        label = "Choose a producer:",
                                        choices = as.list(unique(data$hersteller))),
                            selectInput(inputId = "test",
                                                    label = "Test",
                                                    choices = as.list(data$handelsname)),
                            htmlOutput(outputId='test_out'),
                            data.step = 1,
                            data.intro = "Choose the test you want to know more about,
                                First, choose the manufacturer, then the test. "),
                        introBox(
                            hr(),
                            numericInput(inputId = "prevalence",
                                         label = h3("Prevalence"),
                                         value = 0.1), # will be sent to the server
                            data.step = 2,
                            data.intro = "The prevalence only serves as an orientation")
                    ), # sidebarPanel
                    mainPanel(
                        introBox(
                            introBox(
                                introBox(
                                    h1('Positive and Negative Predictive Value vs. Prevalence'),
                                    plotOutput(outputId = 'plot'),
                                    data.step = 5,
                                    data.intro = "No measure is absolutely exact. Therefore,
                                        the light red and light blue areas cover the range
                                        of the PPV and NPV curves within a 95% Confidence Interval.
                                        For 95 of 100 random samples, we would expect the ppv and npv values
                                        to be within the range of these intervals"),
                                data.step = 4,
                                data.intro = "The Negative Predictive Value (NPV)
                                    is the probability that the patient does not have the disease when the
                                    tests shows a negative result"),
                            data.step = 3,
                            data.intro = "What do we see here? The Positive Predictive Value (PPV)
                                is the probability that the patient actually has a disease when the
                                tests shows a positive result"),
                    ), # mainPanel
                ), # Test Library, tabPanel
                tabPanel(
                    title=introBox('Manual settings',
                                   data.step = 6,
                                   data.intro = 'Define different Sensitivity and Specifity values by
                                        yourself to get a feeling the interdependencies between diagnostic
                                        validity and prevalence'), # introBox
                    sidebarPanel(
                       sliderInput(inputId="sensitivity", label='Sensitivity',
                                   min = 0, max = 100, value = 80),
                       sliderInput(inputId="specifity", label='Specifity',
                                   min = 0, max = 100, value = 80),
                       ),
                    mainPanel(
                        h1('Positive and Negative Predictive Value vs. Prevalence'),
                        plotOutput(outputId = 'plot_2'),
                    ) # mainPanel
                ) # Manual Settings, tabPanel
            ) # tabset Panel
        ), # Input, tabPanel
         # introBox(
        tabPanel(
            title= introBox('PPV & NPV',
                            data.step = 7,
                            data.intro = 'Here, you find a visual explanation about what a PPV and NPV is
                                                and why you should care'),
            mainPanel(
                uiOutput("explain_ppv_npv"),
                uiOutput(outputId='ppv_formula'),
                uiOutput(outputId='npv_formula'),
                plotOutput(outputId='tree')
            )
        ), # tabPanel
        tabPanel(title = 'About',
            mainPanel(
                uiOutput("simply_homepage"),
                uiOutput("about_us"),
                uiOutput("about_the_test"),
                img(src='https://simplyrational.de/assets/img/banner/main_kontakt.jpg',
                    width=480, height=200),

                htmlOutput(outputId="contact_us")
            )
        ),
        tabPanel(title = 'More Products',
                 'Contact us for more products: kontakt@simplyrational.de')
    ) # navbarPage
) # fluidPage

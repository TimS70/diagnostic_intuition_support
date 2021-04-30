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
        title="Simply Diagnostic Intuition Support",
        tabPanel(
            title=introBox('Input',
                           data.step=1,
                           data.intro="Welcome to the Diagnostic Intuition Support (DIS)
                                by Simply Rational. This intuitive tool should help you understand the test properties
                                of COVID-19 Antigen Rapid Tests and correctly interpret specific test result.
                                We will guide you through this tool. Let's start!"),
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
                            data.step = 2,
                            data.intro = "First, choose the test manufacturer, then the specific test. All tests have
                                specific sensitivity and specifity properties based on scores provided by the manufacturer.
                                The sensitivity is the probability that an individual who has COVID-19 has a positive test.
                                The specifity is the probability that a healthy individual has a negative test."),
                        introBox(
                            hr(),
                            sliderInput(inputId="prevalence", label='Prevalence in %',
                                        min = 0, max = 100, value = 10),
                            data.step = 6,
                            data.intro = "Adjust the prevalence to show specific PPV and NPV values")
                    ), # sidebarPanel
                    mainPanel(
                        introBox(
                            introBox(
                                introBox(
                                    h1('Positive and Negative Predictive Value vs. Prevalence'),
                                    plotOutput(outputId = 'plot'),
                                    data.step = 5,
                                    data.intro = 'With these curves you should be able to interpret the
                                        test result based on the test properties and the prevalence in
                                        the respective population. The plot should also give you the freedom
                                        to consider additional factors that an algorith cannot account for.
                                        Use your professional experience and your intuition!'),
                                data.step = 4,
                                data.intro = "No measure is absolutely exact. Therefore,
                                    the light red and light blue areas cover the possible PPV and NPV values
                                    for specifity and sensitivity scores within a 95% Confidence Interval
                                    (based on manufacturer information).
                                    This means that for 95 out of 100 random samples,
                                    we would expect the ppv and npv values
                                    to be within the range of these intervals."),
                            data.step = 3,
                            data.intro = "This plot shows the Positive Predictive Value (PPV) and the
                                Negative Predictive Value (NPV) of a test based on a range of possible prevalence scores.
                                The PPV is the probability that the patient has COVID when the
                                tests shows a negative result.
                                The NPV is the probability that the patient does not have COVID when the
                                tests shows a negative result. You can find a more detailed explanation
                                in the Navigation bar, we will show it to you later. "),
                    ), # mainPanel
                ), # Test Library, tabPanel
                tabPanel(
                    title=introBox('Manual settings',
                                   data.step = 7,
                                   data.intro = 'Manually define some sensitivity and specifity values
                                        to get a feeling the interdependencies between diagnostic
                                        validity and prevalence'), # introBox
                    sidebarPanel(
                        h3('Manually define the test properties'),
                        sliderInput(inputId="sensitivity", label='Sensitivity',
                                    min = 0, max = 100, value = 80),
                        sliderInput(inputId="specifity", label='Specifity',
                                   min = 0, max = 100, value = 80),
                        hr(),
                        sliderInput(inputId="prevalence_2", label='Prevalence in %',
                                    min = 0, max = 100, value = 10),
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
                            data.step = 8,
                            data.intro = 'Here, you find a visual explanation about what a PPV and NPV is
                                              and why you should care. '),
            mainPanel(
                uiOutput("explain_ppv_npv"),
                uiOutput(outputId='ppv_formula'),
                uiOutput(outputId='npv_formula'),
                uiOutput(outputId='plot_legend'),
                plotOutput(outputId='tree'),
            )
        ), # tabPanel
        tabPanel(title = introBox('About',
                                  data.step=9,
                                  data.intro='Thank you very much for your interest in our work.
                                    Here, you can read more about us. Do not hesitate to contact us
                                    for any questions. Have fun with the tool and stay healthy!'),
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

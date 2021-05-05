library(shiny)
library(ggplot2)
library(shinythemes)
library(rintrojs)

source(file.path('utils', 'load.R'))
source('txt_content/intro.R')

data <- load_test_data(file= file.path('data', 'antigentests.csv'))

ui <- fluidPage(

	theme = shinytheme('cerulean'),
    introjsUI(),
    navbarPage(
        title="Simply Diagnostic Intuition Support",
        tabPanel(
            title=introBox(
            	'Input',
				data.step=1,
				data.intro=intro_txt_1),
            h2('Wie wahrscheinlich ist eine COVID-19 Erkrankung basierend auf einem Testergebnis?'),
            sidebarPanel(
                introBox(
                    h3('Test Bibliothek'),
                    selectInput(inputId = "hersteller",
                                label = "Hersteller:",
                                choices = as.list(unique(data$hersteller))),
                    selectInput(inputId = "test",
                                            label = "Test",
                                            choices = as.list(data$handelsname)),
                    htmlOutput(outputId='test_out'),
                    data.step = 2,
                    data.intro = intro_txt_2),
                checkboxGroupInput(inputId = "show_ci",
                                   label = '',
                                   choices = c("Confidence Intervals" = "show_ci")),
                htmlOutput(outputId='ci_out'),
                introBox(
                    hr(),
                    sliderInput(inputId="prevalence", label='Pr\u00e4valenz in %',
                                min = 0, max = 100, value = 10),
                    data.step = 5,
                    data.intro = intro_txt_5)
            ), # sidebarPanel
            mainPanel(
                introBox(
                    introBox(
                        plotOutput(outputId = 'plot'),
                        data.step = 4,
                        data.intro = intro_txt_4),
                data.step = 3,
                data.intro = intro_txt_3)
            ) # mainPanel
        ), # Input, tabPanel
         # introBox(
        tabPanel(
            title= introBox('PPW & NPW',
                            data.step = 6,
                            data.intro = intro_txt_6),
            mainPanel(
                uiOutput("explain_ppv_npv"),
                uiOutput(outputId='ppv_formula'),
                uiOutput(outputId='npv_formula'),
                uiOutput(outputId='plot_legend'),
                plotOutput(outputId='tree')
            )
        ), # tabPanel
        tabPanel(title = 'Simply Rational',
            mainPanel(
                uiOutput("simply_homepage"),
                uiOutput("about_us"),
                uiOutput("about_the_test"),
                img(src='https://simplyrational.de/assets/img/banner/main_kontakt.jpg',
                    width=480, height=200),
                htmlOutput(outputId="contact_us")
            )
        )
    ) # navbarPage
)
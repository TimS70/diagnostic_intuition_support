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
            tabsetPanel(id = "inTabset",
                tabPanel(
                    title = 'Test Bibliothek',
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
                ), # Test Library, tabPanel
                tabPanel(
                    title='Manuelle Einstellungen', # introBox
                    sidebarPanel(
                        h3('Definiere eigene Sensitivit\u00e4ts- und Spezifit\u00e4t-Werte'),
                        sliderInput(inputId="sensitivity", label='Sensitivit\u00e4t',
                                    min = 0, max = 100, value = 80),
                        sliderInput(inputId="specifity", label='Spezifit\u00e4t',
                                   min = 0, max = 100, value = 80),
                        hr(),
                        sliderInput(inputId="prevalence_2", label='Pr\u00e4valenz in %',
                                    min = 0, max = 100, value = 10)
                        ),
                    mainPanel(
                        h1('Positiver und Negativer Pr\u00e4diktiver Wert vs. Pr\u00e4valenz'),
                        plotOutput(outputId = 'plot_2')
                    ) # mainPanel
                ) # Manual Settings, tabPanel
            ) # tabset Panel
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
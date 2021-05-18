library(shiny)
library(ggplot2)
library(shinythemes)
library(shinyWidgets)
library(readxl)
library(rio)
library(rintrojs)

source(file.path('utils', 'load_test_data.R'))
source(file.path('utils', 'incidence.R'))
source(file='txt_content/intro.R')
source(file='utils/estimate_prevalence.R')

data <- load_test_data(file= file.path('data', 'antigentests.csv'))

ui <- fluidPage(
	theme = shinytheme('cerulean'),
    introjsUI(),
    navbarPage(
        title="Simply Diagnostic Intuition Support",
        tabPanel(
            title=introBox(
            	'Das Tool',
				data.step=1,
				data.intro=intro_txt_1),
            h2('Wie verl\u00e4sslich ist das SARS-Cov-2 Antigen Schnelltest Ergebnis?'),
            sidebarPanel(
                introBox(
                    p('W\u00e4hlen Sie den Hersteller, Test, und den regionsspezifischen Inzidenzwert'),
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
                                   choices = c("Konfidenzintervalle anzeigen" = "show_ci")),
                introBox(
                    introBox(
                        introBox(
                            selectInput(inputId = "region",
                                label = "Inzidenzwert f\u00fcr Bundesland, Land- oder Stadtkreis",
                                choices = region_names()),
                            introBox(
                                numericInput(
                                      inputId="prevalence",
                                      label='Pr\u00e4valenz in Prozent:
                                      Wie wahrscheinlich ist es, dass diese Person vor dem Test mit
                                      SARS-CoV-2 zu infizieren ist?',
                                      choices = c(10000, 5000, 10:1*100, 9:1*10, 2),
                                      selected = 100,
                                      width = "100%",
                                      post = " Personen",
                                      grid = TRUE,
                                      force_edges=TRUE),
                                data.step = 8,
                                data.intro = intro_txt_8),
                            htmlOutput(outputId="regional_incidence_prevalence"),
                            helpText('*Antigen-Schnelltests weisen eine Sensitivit\u00e4tsl\u00fccke bei
                                    asymptomatischen Personen und pr\u00e4symptomatischen Personen
                                    mit einer SARS-CoV-2 Infektion auf. Dies bedeutet, dass
                                    diese Tests Personen mit einer Infektion aber ohne Symptome
                                    nur sehr schlecht identifizieren k\u00f6nnen. Somit besteht das
                                    erh\u00f6hte Risiko eines falsch-negativen Testergebnisses.'),
                            data.step = 7,
                            data.intro = intro_txt_7),
                        data.step = 6,
                        data.intro = intro_txt_6),
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
        tabPanel(title= 'PPW & NPW',
            mainPanel(
                uiOutput("explain_ppv_npv"),
                uiOutput(outputId='ppv_formula'),
                uiOutput(outputId='npv_formula'),
                uiOutput(outputId='prevalence_estimation_formula'),
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
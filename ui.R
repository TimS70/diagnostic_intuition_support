library(shiny)
library(ggplot2)
library(shinythemes)
library(shinyWidgets)
library(readxl)
library(rio)
library(rintrojs)

source(file.path('utils', 'load.R'))
source(file.path('utils', 'incidence.R'))
source('txt_content/intro.R')

data <- load_test_data(file= file.path('data', 'antigentests.csv'))

infection_risk <- obtain_incidence()
infection_risk_range <- c(10:1 * 1000, 9:1 * 100)
select_risk <- infection_risk_range[
    which.min(abs(infection_risk_range - infection_risk))]

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
            h2('Wie wahrscheinlich ist eine SARS-CoV-2 Infektion basierend auf einem Testergebnis?'),
            sidebarPanel(
                introBox(
                    h3('Testbibliothek'),
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
                                   choices = c("Konfidenzintervalle" = "show_ci")),
                htmlOutput(outputId='ci_out'),
                introBox(
                    introBox(
                        introBox(
                            hr(),
                            sliderTextInput(
                                  inputId="prevalence",
                                  label='Infektionsrisiko: \nEine Person unter wie vielen anderen Personen hat sich infiziert?',
                                  choices = infection_risk_range,
                                  selected = select_risk,
                                  width = "100%",
                                  post = " Personen",
                                  grid = TRUE,
                                  force_edges=TRUE
                                ),
                                helpText(paste0("Die aktuelle 7-Tage Inzidenz (Quelle Robert Koch Institut) liegt bei ",
                                               round(100000/infection_risk, 2), ".",
                                                "Innerhalb von 7 Tagen, haben sich ca. ",
                                                round(100000/infection_risk), " von 100.000 Personen ",
                                                "mit SARS-CoV-2 infiziert. Das ist umgerechnet eine von ca. ",
                                                round(infection_risk),
                                                " Personen.")),
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
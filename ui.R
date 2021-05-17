library(shiny)
library(ggplot2)
library(shinythemes)
library(shinyWidgets)
library(readxl)
library(rio)
library(rintrojs)

source(file.path('utils', 'load.R'))
source(file.path('utils', 'incidence.R'))
source(file='txt_content/intro.R')
source(file='utils/estimate_prevalence.R')

data <- load_test_data(file= file.path('data', 'antigentests.csv'))

current_incidence <- obtain_incidence()
estimated_current_prevalence <- estimate_prevalence(
    incidence=current_incidence,
    fraction_cases = 0.33)
infection_prevalence_range <- c(10000, 10:1*100, 9:1*10, 2)
select_prevalence <- infection_prevalence_range[
    which.min(abs(infection_prevalence_range - estimated_current_prevalence))]

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
                                   choices = c("Konfidenzintervalle anzeigen" = "show_ci")),
                introBox(
                    introBox(
                        introBox(
                            hr(),
                            introBox(
                                sliderTextInput(
                                      inputId="prevalence",
                                      label='Pr\u00e4valenz:
                                      Die Wahrscheinlichkeit f\u00fcr diese Person, sich mit
                                      SARS-CoV-2 zu infizieren ist eins zu
                                      (eine unter wie vielen Personen hat sich mit SARS-CoV-2 infiziert)?',
                                      choices = infection_prevalence_range,
                                      selected = select_prevalence,
                                      width = "100%",
                                      post = " Personen",
                                      grid = TRUE,
                                      force_edges=TRUE),
                                data.step = 8,
                                data.intro = intro_txt_8),
                            helpText(paste0("Die aktuelle 7-Tage-Inzidenz (Quelle Robert Koch Institut) liegt bei ",
                                            round(current_incidence, 1), ". ",
                                            "Innerhalb von 7 Tagen, haben sich ca. ",
                                            round(current_incidence), " von 100.000 Personen ",
                                            "mit SARS-CoV-2 infiziert.",
                                            "Das entspricht einer gesch\u00e4tzten Pr\u00e4valenz von eine unter ",
                                            round(select_prevalence), " Personen.")),
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
library(shiny)
library(ggplot2)
library(htmltools)
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
            sidebarPanel(width=4,
                introBox(
                    HTML(text='W\u00e4hlen Sie den... <br>
                        <b> &nbsp 1) Test-Hersteller,</b> dann den <br>
                        <b> &nbsp 2) Test,</b> und sch\u00e4tzen Sie die Pr\u00e4valenz durch den <br>
                        <b> &nbsp 3a) regionalen Inzidenzwert</b> oder das <br>
                        <b> &nbsp 3b) personenspezifische Risiko</b>
                    '),
                    br(),
                    br(),
                    selectInput(
                        inputId = "hersteller",
                        label = "1) Hersteller*",
                        choices = as.list(unique(data$hersteller)),
                    ),
                    selectInput(inputId = "test",
                                label = "2) Test",
                                choices = as.list(data$handelsname)
                    ),
                    helpText('Beachten Sie das erh\u00f6hte Risiko eines falsch-negativen Testergebnisses
                        bei Antigen-Schnelltests aufgrund einer Sensitivit\u00e4tsl\u00fccke
                        (Siehe Reiter PPW & NPW)!'),
                    fluidRow(
                        column(6,
                               htmlOutput(outputId='sensitivity_out')
                               ),
                        column(6,
                               htmlOutput(outputId='specifity_out')
                               ),
                    ),
                    checkboxGroupInput(
                        inputId = "show_ci",
                        label = '',
                        choices = c("Konfidenzintervalle anzeigen" = "show_ci")
                    ),
                    data.step = 2,
                    data.intro = intro_txt_2
                ),
                introBox(
                    introBox(
                        introBox(
                            HTML(text="<b>3a) 7-Tage-Inzidenz (Bundesland, Land-/Stadtkreis**</b>"),
                            tags$table(style = "width: 100%",
                                 tags$tr(
                                     tags$td(
                                         style = "width: 50%",
                                         align = "left",
                                         valign="center",
                                         selectInput(inputId = "region",
                                                     label = NULL,
                                                     choices = region_names()
                                         )
                                     ),
                                     tags$td(
                                         align = "right",
                                         valign="center",
                                         htmlOutput(outputId="regional_incidence_prevalence"),
                                     )
                                 )
                            ),
                            introBox(
                                HTML(text="<b>3b) 14-Tage Pr\u00e4valenz***</b><br>
                                            <i>Wie wahrscheinlich ist es vor dem Test, dass diese Person
                                            infiziert ist (wie viele von 100.000 Personen)?</i>"),
                                tags$table(style = "width: 100%",
                                     tags$tr(
                                         tags$td(
                                             style = "width: 50%",
                                             align = "left",
                                             valign="center",
                                             numericInput(
                                                inputId="prevalence",
                                                label=NULL,
                                                min=1,
                                                max=5000,
                                                step=1,
                                                value = 100)
                                             ),
                                         tags$td(
                                             align = "right",
                                             valign="center",
                                             p("von 100.000 Personen")
                                         )
                                     )
                                ),
                                data.step = 8,
                                data.intro = intro_txt_8
                            ),
                            data.step = 7,
                            data.intro = intro_txt_7
                        ),
                        data.step = 6,
                        data.intro = intro_txt_6
                    ),
                    data.step = 5,
                    data.intro = intro_txt_5
                ),
                helpText('*Herstellerangeben wochenaktuell bezogen vom Bundesinstitut für Arzneimittel und Medizinprodukte (BfArM)'),
                helpText(paste('**Quelle Robert-Koch-Institut.', incidence_date())),
                helpText('***Aus der Inzidenz gesch\u00e4tzt (siehe Reiter PPW & NPW), wenn nicht
                    manuell eingegeben.'),
            ), # sidebarPanel
            mainPanel(
                h1('Wie verl\u00e4sslich ist das SARS-Cov-2 Antigen Schnelltest Ergebnis?',
                   style = "font-size:25px;"),
                introBox(
                    introBox(
                        plotOutput(outputId = 'plot'),
                        data.step = 4,
                        data.intro = intro_txt_4),
                data.step = 3,
                data.intro = intro_txt_3)
            ), # mainPanel

        ), # Input, tabPanel
        tabPanel(title= 'PPW & NPW',
            mainPanel(
                uiOutput("sensitivity_gap"),
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
library(shiny)
library(ggplot2)
library(shinydashboard)
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

incidence_section <- tags$table(
    style = "width: 100%; height: 70px;",
    tags$th(
         style = "height: 50%",
         valign='center',
         colspan="2",
         h2("3a) 7-Tage-Inzidenz (Bundesland, Land-/Stadtkreis)**")
    ),
    tags$tr(
         style = "height: 50%",
         valign="center",
         tags$td(
             style = "width: 50%",
             align = "left",
             selectInput(inputId = "region",
                         label = NULL,
                         choices = region_names()
             )
         ),
         tags$td(
             align = "right",
             htmlOutput(outputId="regional_incidence_prevalence"),
         )
    )
)

prevalence_section <- tags$table(
     style = "width: 100%; height: 70px;",
     tags$th(
         style = "height: 50%",
         valign='center',
         colspan="2",
         h2("3b) 14-Tage Pr\u00e4valenz***"),
         p("
            Wie wahrscheinlich ist es vor dem Test, dass diese Person
            infiziert ist (wie viele von 100.000 Personen)?")
     ),
     tags$tr(
         height='35',
         valign="center",
         style = "height: 50%",
         tags$td(
             style = "width: 50%",
             align = "left",
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
             p("von 100.000 Personen")
         )
     )
)

ui <- fluidPage(
	theme = shinytheme('flatly'),
    introjsUI(),
    navbarPage(
        title="Simply Diagnostic Intuition Support",
        tabPanel(
            title=introBox(
            	'Das Tool',
				data.step=1,
				data.intro=intro_txt_1),
            sidebarPanel(width=4,
                tags$head(
                    tags$style(
                        HTML('
                            #prevalence{height: 30px}
                            #region{height: 30px}
                            h2 { font-size: 15px;
                                  margin-top: 4px;
                                  margin-bottom: 4px;
                                  margin-left: 0;
                                  margin-right: 0;
                                  font-weight: bolder}

                        ')
                    )
                ),
                introBox(
                    HTML(text='
                        <p>
                        W\u00e4hlen Sie den... <br>
                        <b> &nbsp 1) Test-Hersteller,</b> dann den <br>
                        <b> &nbsp 2) Test,</b> und sch\u00e4tzen Sie die Pr\u00e4valenz durch den <br>
                        <b> &nbsp 3a) regionalen Inzidenzwert</b> oder das <br>
                        <b> &nbsp 3b) personenspezifische Risiko</b>
                        </p>
                    '),
                    selectInput(
                        inputId = "hersteller",
                        label = h2("1) Hersteller*"),
                        choices = as.list(unique(data$hersteller))
                    ),
                    selectInput(inputId = "test",
                                label = h2("2) Test"),
                                choices = as.list(data$handelsname)
                    ),
                    helpText('Beachten Sie das erh\u00f6hte Risiko eines falsch-negativen Testergebnisses
                        bei Antigen-Schnelltests aufgrund einer Sensitivit\u00e4tsl\u00fccke
                        (Siehe Reiter PPW & NPW)!'),
                    fluidRow(
                        column(
                            width=6,
                            htmlOutput(outputId='sensitivity_out')
                               ),
                        column(
                            width=6,
                            htmlOutput(outputId='specifity_out')
                        )
                    ),
                    checkboxGroupInput(
                        inputId = "show_ci",
                        label = h2('', style = "font-size:5px;"),
                        choices = c("Konfidenzintervalle anzeigen" = "show_ci")
                    ),
                    data.step = 2,
                    data.intro = intro_txt_2
                ),
                introBox(
                    introBox(
                        introBox(
                            incidence_section,
                            introBox(
                                prevalence_section,
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
                helpText('*Herstellerangaben wochenaktuell bezogen vom
                    Bundesinstitut f\u00fcr Arzneimittel und Medizinprodukte (BfArM)'),
                helpText(paste('**Quelle Robert-Koch-Institut.', incidence_date())),
                helpText('***Aus der Inzidenz gesch\u00e4tzt (siehe Reiter PPW & NPW), wenn nicht
                         manuell eingegeben.')
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
            ) # mainPanel
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
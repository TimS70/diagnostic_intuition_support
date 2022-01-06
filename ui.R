library(shiny)
library(ggplot2)
library(shinydashboard)
library(htmltools)
library(shinythemes)
library(shinyWidgets)
library(readxl)
library(rio)
library(rintrojs)
library(shinyjs)

source(file.path('utils', 'load_test_data.R'))
source(file.path('utils', 'incidence.R'))
source(file.path('txt_content/intro.R'))
source(file.path('utils/estimate_prevalence.R'))

data <- load_test_data(file= file.path('data', 'antigentests.csv'))

data %>% 
    filter_all(any_vars(is.na(.)))

incidence_section <- tags$table(
    style = "width: 100%; height: 70px;",
    tags$th(
         style = "height: 50%",
         valign='center',
         colspan="2",
         h2("3) 7-Tage-Inzidenz (Bundesland, Land-/Stadtkreis)**")
    ),
    tags$tr(
         style = "height: 50%",
         valign="center",
         tags$td(
             style = "width: 45%",
             align = "left",
             selectInput(inputId = "region",
                         label = NULL,
                         choices = region_names()
             )
         ),
         tags$td(
             align = "right",
             htmlOutput(outputId="regional_incidence_prevalence")
         )
    )
)

prevalence_section <- tags$table(
     style = "width: 100%; height: 70px;",
     tags$th(
         style = "height: 50%",
         valign='center',
         colspan="2",
         h2("4) 14-Tage Pr\u00e4valenz bzw. Infektionsrisiko***"),
         p("Wie wahrscheinlich ist es vor dem Test, dass diese Person
            infiziert ist (wie viele von 100.000 Personen)?",
           style="font-size: 14px; font-weight: normal;"
         )
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
                min=10,
                max=100000,
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
	useShinyjs(),
    navbarPage(
        title="Simply Diagnostic Intuition Support",
        tabPanel(
            title=introBox(
                    introBox(
                	'Das Tool',
    				data.step=2,
    				data.intro=intro_txt_2),
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
                            .introjs-tooltip {
                                 max-width: 100%;
                                min-width: 500px;
                             }
                             
                        ')
                    )
                ),
                
                HTML(text='
                    <p style="font-size: 14px;">
                    W\u00e4hlen Sie den
                    <b> 1) Test-Hersteller</b> und den <b> 2) Test.</b>
                    Sch\u00e4tzen Sie die Wahrscheinlichkeit einer Infektion anhand des
                    <b> 3) regionalen Inzidenzwertes</b> (und der daraus gesch\u00e4tzten Pr\u00e4valenz) und
                    <b> 4) passen Sie die Wahrscheinlichkeit situationsbedingt an.</b>
                    </p>
                '),
                introBox(
                    selectInput(
                        inputId = "hersteller",
                        label = h2("1) Hersteller*"),
                        choices = as.list(unique(data$hersteller))
                    ),
                    selectInput(inputId = "test",
                                label = h2("2) Test"),
                                choices = as.list(data$handelsname)
                    ),
                    p(
                        id='pei_eval_info', 
                        style='color: red; font-size: 12px;',
                        'Dieser Test wurde nicht von dem Paul-Ehrlich Institut evaluiert! 
                         Die Herstellerangaben k\u00f6nnen von der tats\u00e4chlichen 
                         Testg\u00fcte stark abweichen!'
                    ),
                    p(
                        'Beachten Sie das erh\u00f6hte Risiko eines falsch-negativen Testergebnisses
                        bei Antigen-Schnelltests aufgrund einer Sensitivit\u00e4tsl\u00fccke bei 
                        einer pr\u00e4- oder asymptomatischen Infektion 
                        (Siehe Reiter PPW & NPW)!',
                        style='color: red; font-size: 12px;'
                    ),
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
                        label = NULL,
                        choices = c("Konfidenzintervalle anzeigen" = "show_ci")
                    ),
                    data.step = 3,
                    data.intro = intro_txt_3
                ),
                introBox(
                    introBox(
                        introBox(
                            incidence_section,
                            data.step = 7,
                            data.intro = intro_txt_7
                        ),
                    data.step = 8,
                    data.intro = intro_txt_8
                    ),
                    introBox(
                        prevalence_section,
                        data.step = 9,
                        data.intro = intro_txt_9
                    ),
                    data.step = 6,
                    data.intro = intro_txt_6
                ),
                HTML(paste(
                    '<div style="color: grey; font-size:12px">',
                    '<p>*Herstellerangaben wochenaktuell bezogen vom
                    Bundesinstitut f\u00fcr Arzneimittel und Medizinprodukte (BfArM)</p>',
                    paste('<p>**Quelle Robert-Koch-Institut.', incidence_date(), '</p>'),
                    '<p>***Aus der 7-Tage-Inzidenz gesch\u00e4tzt (siehe Reiter Erkl\u00e4rung) 
                    <u>oder</u> manuell eingegeben.</p>',
                    '</div>')
                )
            ), # sidebarPanel
            mainPanel(
                h1('Wie verl\u00e4sslich ist das SARS-Cov-2 Antigen Schnelltest Ergebnis?',
                   style = "font-size:25px;"),
                introBox(
                    introBox(
                        plotOutput(outputId = 'plot'),
                        data.step = 5,
                        data.intro = intro_txt_5),
                data.step = 4,
                data.intro = intro_txt_4)
            ) # mainPanel
        ), # Input, tabPanel
        tabPanel(title= 'Erkl\u00e4rung',
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
        ),
				tabPanel(title = 'Geben Sie uns Feedback!',
				        uiOutput("contact_us_2")
				)
    ) # navbarPage
)
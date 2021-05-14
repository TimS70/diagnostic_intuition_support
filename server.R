library(shiny)
library(ggplot2)
library(dplyr)
library(riskyr)

source(file='utils/load.R')
source(file='utils/estimate_prevalence.R')
source(file='txt_content/about.R')
source(file='txt_content/ppv_npv.R')
source(file= 'visualize/load_data.R')
source(file='visualize/adjust_text_pos.R')
source(file='visualize/generate_plot.R')

server <- function(input, output, session) {

	data <- load_test_data(file= file.path('data', 'antigentests.csv'))

    introjs(session, options = list("nextLabel"="Weiter",
                                    "prevLabel"="Zur\u00FCck",
                                    "skipLabel"="Schlie\u00DFen",
                                    'doneLabel'='Fertig'))

    # Take the first test from the list, when Hersteller changes
    observeEvent(input$hersteller, {
        hersteller_tests <- reactive({
            data %>% filter(hersteller == input$hersteller)})

        proposed_test <- reactive({data %>%
            filter(hersteller == input$hersteller) %>%
            slice(1) %>%
            dplyr::pull(handelsname)})

            updateSelectInput(session, inputId="test",
                  label = paste0('Alle Tests von ', input$hersteller),
                  choices = as.list(hersteller_tests()$handelsname),
                  selected = proposed_test())
        })

    observeEvent(input$test, {

        selected_test <- reactive({
            data %>% filter(handelsname == input$test)})

        output$test_out <- renderUI({
            HTML(paste(
                paste0('Sensitivit\u00e4t* = ',
                       selected_test()$sensitivity, '%'),
                paste0('Spezifit\u00e4t   = ',
                       selected_test()$specifity, '%'),
                paste0(''),
                sep="<br/>"))
            })
        })

    observe({
        incidence <- reactive({incidence <- input$incidence/100000})

        selected_test <- reactive({
            data %>% filter(hersteller == input$hersteller &
                            handelsname == input$test)})

        # Plot
        risk_data <- reactive({
            get_risk_data(test_data=selected_test())})

        ppv_intersect <- reactive({
            out <- 100 * calculate_ppv(incidence(),
                                 selected_test()$sensitivity / 100,
                                 selected_test()$specifity / 100)
            round(out, 1)})

        npv_intersect <- reactive({
            out <- 100 * calculate_npv(incidence(),
                                 selected_test()$sensitivity / 100,
                                 selected_test()$specifity / 100)
            round(out, 1)})


        show_ci  <- reactive({
            if (length(input$show_ci) > 0) {
                 TRUE
            } else {
                 FALSE
            }})

        output$plot <- renderPlot({

            p <- generate_plot(
                data=risk_data(),
                incidence = incidence(),
                ppv_intersect=ppv_intersect(),
                npv_intersect=npv_intersect(),
                confidence_intervals=show_ci()
            )

            print(p)

        }, height=500)

        # About
        output$about_us <- renderUI({HTML(about_us)})
        output$about_the_test <- renderUI({HTML(about_the_tool)})
        output$contact_us <- renderUI({HTML(contact_us)})

        # PPV & NPV
        output$explain_ppv_npv <- renderUI({HTML(explain_ppv_npv)})
        output$ppv_formula <- renderUI({ppv_formula})
        output$npv_formula <- renderUI({npv_formula})
        output$prevalence_estimation_formula <- renderUI({prevalence_estimation_formula})
        output$plot_legend <- renderUI({HTML(plot_legend)})
        output$tree <- renderPlot({

            my_txt <- init_txt(
                cond_lbl = "True SARS-CoV-2 Infection",
                cond_true_lbl = "True", cond_false_lbl = "False",
                hi_lbl = "True Pos.", mi_lbl = "False Neg.",
                fa_lbl = "False Pos.", cr_lbl = "True Neg.")

            p <- plot_prism(
                 N = 1000, prev = .1, sens = .950, spec = .97,
                 by='cd',
                 area = "no",
                 f_lbl = "namnum", # namnum
                 p_lbl = "mix",
                 f_lwd = 1,
                 lbl_txt = my_txt,
                 title_lbl = '',
                 col_pal = pal_kn)
                  #plot(covid_tree, by = 'cd')

             print(p)
         }, height=300)
    })
}
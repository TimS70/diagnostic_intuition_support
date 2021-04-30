library(shiny)
library(ggplot2)
library(dplyr)
library(riskyr)

source(file='plot_data.R')
source(file=file.path('tests', 'main.R'))
source(file=file.path('txt_content/about.R'))
source(file=file.path('txt_content/ppv_npv.R'))

server <- function(input, output, session) {
    introjs(session)
    data <- load_test_data(file=file.path('tests', 'antigentests.csv'))

    # Take the first test from the list, when Hersteller changes
    observeEvent(input$hersteller, {
        hersteller_tests <- reactive({
            data %>% filter(hersteller == input$hersteller)})

        proposed_test <- reactive({data %>%
            filter(hersteller == input$hersteller) %>%
            slice(1) %>%
            dplyr::pull(handelsname)})

            updateSelectInput(session, inputId="test",
                  label = paste0('All tests available by ', input$hersteller),
                  choices = as.list(hersteller_tests()$handelsname),
                  selected = proposed_test())
        })

    observeEvent(input$test, {

        selected_test <- reactive({
            data %>% filter(handelsname == input$test)})

        output$test_out <- renderUI({
            HTML(paste(
                paste0('Sensitivity = ',
                       selected_test()$sensitivity, '%',
                       '95% CI: [', selected_test()$sensitivity_ci_95_ll, ' - ',
                       selected_test()$sensitivity_ci_95_ul, ']'
                ),
                paste0('Specifity = ',
                       selected_test()$specifity, '%',
                       '95% CI: [', selected_test()$specifity_ci_95_ll, ' - ',
                       selected_test()$specifity_ci_95_ul, ']'
                ),
                paste0(''),
                sep="<br/>"))
            })
        })

    observe({
        prevalence <- reactive({input$prevalence})

        selected_test <- reactive({
            data %>% filter(hersteller == input$hersteller &
                            handelsname == input$test)})

        # Plot
        prevalence_data <- reactive({
            get_prevalence_data(test_data=selected_test())})

        ppv_intersect <- reactive({
            out <- 100 * calculate_ppv(prevalence() / 100 ,
                                 selected_test()$sensitivity / 100,
                                 selected_test()$specifity / 100)
            out <- round(out, 2)})

        npv_intersect <- reactive({
            out <- 100 * calculate_npv(prevalence() / 100 ,
                                 selected_test()$sensitivity / 100,
                                 selected_test()$specifity / 100)
            out <- round(out, 2)})

        output$plot <- renderPlot({
            p <- ggplot(data=prevalence_data(), aes(x=prevalence)) +
                geom_line(aes(y=ppv, color = '#D72F20'), size=1) +
                geom_ribbon(data=prevalence_data(), fill='#EF6547',
                                aes(ymin=ppv_ll,ymax=ppv_ul), alpha=0.3) +
                geom_line(aes(y=npv, color = "#0C70B0"), size=1) +
                geom_ribbon(data=prevalence_data(), fill='#73A9CF',
                            aes(ymin=npv_ll,ymax=npv_ul), alpha=0.3) +
                geom_vline(xintercept = prevalence(), linetype="dotted",
                           color = "black", size=1.5) +
                geom_text(x = prevalence() + 2,
                          y = ppv_intersect() - 2,
                          size=5,
                          hjust = 0,
                          label=paste0("PPV: ", ppv_intersect(), '%')) +
                annotate("point", x = prevalence(), y = ppv_intersect(),
                             colour = "red", size=5) +
                geom_text(x = prevalence() + 2,
                          y = npv_intersect() - 2,
                          size=5,
                          hjust = 0,
                          label=paste0("NPV: ", npv_intersect(), '%')) +
                annotate("point", x = prevalence(), y = npv_intersect(),
                             colour = "blue", size=5) +
                scale_x_continuous(name="Prevalence [%]",
                                   breaks= 1:10 *10) +
                theme_bw() +
                ylab(label = 'PPV / NPV [%]') +
                xlab(label = 'Prevalence [%]') +
                theme(legend.position="bottom",
                      text = element_text(size=20, face='bold')) +
                labs(color='Legend: ') +
                scale_color_manual(labels = c("PPV", "NPV"),
                                   values = c("#0C70B0", '#D72F20'))

            print(p)

        }, height=400)

        prevalence_data_manual <- reactive({get_prevalence_data(
            sensitivity = input$sensitivity,
            specifity = input$specifity)})

        print(head(prevalence_data_manual()))

        prevalence_2 <- reactive({input$prevalence_2})

        ppv_intersect_2 <- reactive({
            out <- 100 * calculate_ppv(prevalence_2() / 100 ,
                                 input$sensitivity / 100,
                                 input$specifity / 100)
            out <- round(out, 2)})

        npv_intersect_2 <- reactive({
            out <- 100 * calculate_npv(prevalence_2() / 100 ,
                                 input$sensitivity / 100,
                                 input$specifity / 100)
            out <- round(out, 2)})

        output$plot_2 <- renderPlot({
            p <- ggplot(data=prevalence_data_manual(), aes(x=prevalence)) +
                geom_line(aes(y=ppv, color = '#D72F20'), size=1) +
                geom_line(aes(y=npv, color = "#0C70B0"), size=1) +
                geom_vline(xintercept = prevalence_2(), linetype="dotted",
                           color = "black", size=1.5) +
                geom_text(x = prevalence_2() + 2,
                          y = ppv_intersect_2() - 2,
                          size=5,
                          hjust = 0,
                          label=paste0("PPV: ", ppv_intersect_2(), '%')) +
                annotate("point", x = prevalence_2(), y = ppv_intersect_2(),
                             colour = "red", size=5) +
                geom_text(x = prevalence_2() + 2,
                          y = npv_intersect_2() - 2,
                          size=5,
                          hjust = 0,
                          label=paste0("NPV: ", npv_intersect_2(), '%')) +
                annotate("point", x = prevalence_2(), y = npv_intersect_2(),
                             colour = "blue", size=5) +
                scale_x_continuous(name="Prevalence [%]",
                                   breaks= 1:10 * 10) +
                theme_bw() +
                ylab(label = 'PPV / NPV [%]') +
                xlab(label = 'Prevalence [%]') +
                theme(legend.position="bottom",
                      text = element_text(size=20, face='bold')) +
                labs(color='Legend: ') +
                scale_color_manual(labels = c("PPV", "NPV"),
                                   values = c("#0C70B0", '#D72F20'))

            print(p)

        }, height=400)

        # About
        output$about_us <- renderUI({HTML(about_us)})
        output$about_the_test <- renderUI({HTML(about_the_tool)})
        output$contact_us <- renderUI({HTML(contact_us)})

        # PPV & NPV
        output$explain_ppv_npv <- renderUI({HTML(explain_ppv_npv)})
        output$ppv_formula <- renderUI({ppv_formula})
        output$npv_formula <- renderUI({npv_formula})
        output$plot_legend <- renderUI({HTML(plot_legend)})
        output$tree <- renderPlot({

            my_txt <- init_txt(
                cond_lbl = "True COVID Infection",
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
library(shiny)
library(ggplot2)
library(dplyr)

source(file='plot_data.R')
source(file=file.path('tests', 'main.R'))
source(file=file.path('about.R'))

server <- function(input, output, session) {

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
                paste0('Sensitivity = ', selected_test()$sensitivity, '%'),
                paste0('Specifity = ', selected_test()$specifity, '%'),
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
                geom_text(x=prevalence() + 0.01,
                          y=0.3,
                          size=7,
                          hjust = 0,
                          label=paste("Exemplary \nPrevalence =", prevalence())) +
                scale_x_continuous(name="Prevalence",
                                   breaks=c(1:10)*0.1) +
                theme_bw() +
                ylab(label = 'PPV / NPV') +
                xlab(label = 'Prevalence') +
                theme(legend.position="bottom",
                      text = element_text(size=20, face='bold')) +
                labs(color='Legend: ') +
                scale_color_manual(labels = c("PPV", "NPV"),
                                   values = c("#0C70B0", '#D72F20'))

            print(p)

        }, height=700)

        prevalence_data_manual <- reactive({get_prevalence_data(
            sensitivity = input$sensitivity,
            specifity = input$specifity)})

        output$plot_2 <- renderPlot({
            p <- ggplot(data=prevalence_data_manual(), aes(x=prevalence)) +
                geom_line(aes(y=ppv, color = '#D72F20'), size=1) +
                geom_line(aes(y=npv, color = "#0C70B0"), size=1) +
                geom_vline(xintercept = prevalence(), linetype="dotted",
                           color = "black", size=1.5) +
                geom_text(x=prevalence() + 0.01,
                          y=0.3,
                          size=7,
                          hjust = 0,
                          label=paste("Exemplary \nPrevalence =", prevalence())) +
                scale_x_continuous(name="Prevalence",
                                   breaks=c(1:10)*0.1) +
                theme_bw() +
                ylab(label = 'PPV / NPV') +
                xlab(label = 'Prevalence') +
                theme(legend.position="bottom",
                      text = element_text(size=20, face='bold')) +
                labs(color='Legend: ') +
                scale_color_manual(labels = c("PPV", "NPV"),
                                   values = c("#0C70B0", '#D72F20'))

            print(p)

        }, height=700)

         output$about_us <- renderUI({HTML(about_us)})
         output$about_the_test <- renderUI({HTML(about_the_tool)})
         output$contact_us <- renderUI({HTML(contact_us)})
    })


}
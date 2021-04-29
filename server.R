library(shiny)
library(ggplot2)
library(dplyr)

source(file= 'plot_data.R')
source(file=file.path('tests', 'main.R'))

server <- function(input, output, session) {

    data <- load_test_data(file=file.path('tests', 'antigentests.csv'))

    # Take the first test from the list, when Hersteller changes
    observeEvent(input$hersteller, {
        print('Hersteller event')

        hersteller_tests <- reactive({
            data %>% filter(hersteller == input$hersteller)})

        proposed_test <- reactive({data %>%
            filter(hersteller == input$hersteller) %>%
            slice(1) %>%
            dplyr::pull(handelsname)})

            updateSelectInput(session, inputId="test",
                  choices = as.list(hersteller_tests()$handelsname),
                  selected = proposed_test())
        })

    observe({
        updateTextInput(session, inputId="test",
                        label = paste0('All tests available by ',
                                       input$hersteller),
                        value = paste("New text"))

        hersteller_tests <- reactive({
            data %>% filter(hersteller == input$hersteller)})

        updateSelectInput(session, inputId="test",
                          choices = as.list(hersteller_tests()$handelsname),
                          selected = input$test)

        selected_test <- reactive({
            data %>% filter(handelsname == input$test)})

        updateNumericInput(session, inputId="sensitivity",
              label = paste0('Sensitivity'),
              value = paste(selected_test()$sensitivity))

        updateNumericInput(session, inputId="specifity",
              label = paste0('Specifity'),
              value = paste(selected_test()$specifity))

        # Plot
        prevalence_data <- reactive({
            get_prevalence_data(test_data=selected_test())})

        output$plot <- renderPlot({
            p <- ggplot(data=prevalence_data(), aes(x=prevalence)) +
                geom_line(aes(y=ppv, color = "darkred")) +
                geom_ribbon(data=prevalence_data(),
                                aes(ymin=ppv_ll,ymax=ppv_ul), alpha=0.3) +
                geom_line(aes(y=npv, color = "steelblue")) +
                geom_ribbon(data=prevalence_data(),
                            aes(ymin=npv_ll,ymax=npv_ul), alpha=0.3) +
                theme_bw() +
                ylab(label = 'PPV / NPV') +
                xlab(label = 'Prevalence') +
                theme(legend.position="bottom") +
                labs(color='Legend: ') +
                scale_color_manual(labels = c("ppv", "npv"),
                                   values = c("blue", "red"))

            print(p)

        }, height=700)

    })


}
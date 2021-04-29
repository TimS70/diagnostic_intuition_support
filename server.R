library(shiny)
library(ggplot2)
library(dplyr)

source(file= 'plot_data.R')
source(file=file.path('tests', 'main.R'))

server <- function(input, output, session) {

    data <- load_test_data(file=file.path('tests', 'antigentests.csv'))

    observe({
        # We'll use these multiple times, so use short var names for
        # convenience.
        hersteller <- input$hersteller
        test <- input$test

        hersteller_tests <- reactive({
            data %>% filter(hersteller == input$hersteller)})

        updateTextInput(session, inputId="test",
                        label = paste0('All tests available by ', input$hersteller),
                        value = paste("New text"))

        selected_test <- reactive({
            data %>% filter(handelsname == test)})

        updateSelectInput(session, inputId="test",
              choices = as.list(hersteller_tests()$handelsname),
              selected = input$test)

        updateNumericInput(session, inputId="sensitivity",
              label = paste0("Sensitivity of ", test, 'in %'),
              value = paste(selected_test()$sensitivity))

        updateNumericInput(session, inputId="specifity",
              label = paste0("Specifity of ", test, 'in %'),
              value = paste(selected_test()$specifity))

        # Plot
        prevalence_data <- reactive({
            get_prevalence_data(test_data=selected_test())})

        print(head(prevalence_data()))

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
library(shiny)
library(ggplot2)
library(dplyr)

source(file = 'data.R')

server <- function(input, output) {

    output$txt_output <- renderText({paste(input$prevalence,
                                           input$population,
                                           input$test,
                                           sep = ' ')})

    database_tests <- get_test_data()

    selected_test <- reactive({database_tests %>% filter(name == input$test)})

    output$selected_test <- renderText({paste(names(selected_test()))})
    output$sensitivity <- renderText({paste(selected_test()$sensitivity)})
    output$specifity <- renderText({paste(selected_test()$specifity)})

    prevalence_data <- reactive({get_prevalence_data(
        sensitivity=selected_test()$sensitivity,
        specifity=selected_test()$specifity)})


    output$plot <- renderPlot({
      p <- ggplot(data=prevalence_data(), aes(x=prevalence)) +
            geom_line(aes(y=ppv), color = "darkred") +
            geom_line(aes(y=npv), color = "steelblue") +
            theme_bw() +
            ylab(label = 'PPV / NPV') +
            xlab(label = 'Prevalence')

        print(p)

    }, height=700)
}
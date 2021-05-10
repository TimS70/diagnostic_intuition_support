generate_plot <- function(
    data,
    prevalence,
    ppv_intersect,
    npv_intersect,
    confidence_intervals=FALSE) {

    ppv_x_pos <- reactive({adjust_x_pos(
        prevalence = prevalence
    )})

    npv_x_pos <- reactive({adjust_x_pos(
        prevalence = prevalence
    )})

    npv_y_pos <- reactive({adjust_y_pos(
        y_target = npv_intersect,
        y_other = ppv_intersect
    )})

    ppv_y_pos <- reactive({adjust_y_pos(
        y_target = ppv_intersect,
        y_other = npv_intersect
    )})


    p <- ggplot(data=data, aes(x=data$prevalence)) +
        geom_line(aes(y=ppv, color = "#0C70B0"), size=1) +
        geom_line(aes(y=npv, color = '#D72F20'), size=1) +
        geom_vline(xintercept = prevalence, linetype="dotted",
                   color = "black", size=1.5) +
        geom_text(x = ppv_x_pos(),
                  y = ppv_y_pos() - 2,
                  size=5,
                  hjust = 0,
                  label=paste0(" PPW: ", ppv_intersect, '%')) +
        annotate(geom="point", x = prevalence, y = ppv_intersect,
                     colour = "blue", size=5) +
        geom_text(x = npv_x_pos(),
                  y = npv_y_pos() - 2,
                  size=5,
                  hjust = 0,
                  label=paste0(" NPW: ", npv_intersect, '%')) +
        annotate("point", x = prevalence, y = npv_intersect,
                     colour = "red", size=5) +
        scale_x_continuous(name="Infektionsrisiko",
                           minor_breaks=c(1/10000,
                                    1/1000,
                                    1/500,
                                    1/250,
                                    1/200,
                                    1/150,
                                    1/100),
                           breaks=c(1/10000,
                                    1/1000,
                                    1/500,
                                    1/250,
                                    1/200,
                                    1/150,
                                    1/100),
                           labels = c('1/10.000',
                                      '1/1.000',
                                      '1/500',
                                      '1/250',
                                      '1/200',
                                      '1/150',
                                      '1/100')) +
        scale_y_continuous(name = 'Positiver / Negativer Pr\u00e4diktiver Wert [%]',
                           breaks=seq(0, 100, 10)) +
        theme_bw() +
        ylab(label = 'Positiver / Negativer Pr\u00e4diktiver Wert [%]') +
        xlab(label = 'Infektionsrisiko [%]') +
        theme(legend.position="bottom",
              text = element_text(size=17, face='bold')) +
        labs(color='Legende: ') +
        scale_color_manual(labels = c("PPW", "NPW"),
                           values = c("#0C70B0", '#D72F20'))

    if (confidence_intervals == TRUE) {
        p <- p + geom_ribbon(data=data, fill='#73A9CF',
                             aes(ymin=data$ppv_ll,ymax=data$ppv_ul), alpha=0.3)

        p <- p + geom_ribbon(data=data, fill='#EF6547',
                             aes(ymin=data$npv_ll,ymax=data$npv_ul), alpha=0.3)
    }

    return(p)
}
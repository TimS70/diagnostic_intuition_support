generate_plot <- function(data,
                          incidence,
                          ppv_intersect,
                          npv_intersect,
                          confidence_intervals=FALSE) {

    x_incidence <- reactive({log10(1/incidence)})
    ppv_x_pos <- reactive({log10(1/incidence)})
    npv_x_pos <- reactive({log10(1/incidence)})

    npv_y_pos <- reactive({adjust_y_pos(y_target = npv_intersect,
                                        y_other = ppv_intersect)})

    ppv_y_pos <- reactive({adjust_y_pos(y_target = ppv_intersect,
                                        y_other = npv_intersect)})

    p <- ggplot(data=data, aes(x=data$x)) +
        geom_line(aes(y=ppv, color = "#0C70B0"), size=1) +
        geom_line(aes(y=npv, color = '#D72F20'), size=1) +
        geom_vline(xintercept = x_incidence(), linetype="dotted",
                   color = "black", size=1.5) +
        # geom_text(aes(y=ppv_y_pos(), x=x_incidence(),
        #               label=paste0(" PPW: ", ppv_intersect, '%'), # PPW ", , '%'),
        #               size=1.5), hjust=0, parse=FALSE, color='blue') +

        annotate(geom="point", x = x_incidence(), y = ppv_intersect,
                     colour = "blue", size=5) +
        annotate("point", x = x_incidence(), y = npv_intersect,
                     colour = "red", size=5) +
        scale_x_reverse(name="Infektionsrisiko",
                           minor_breaks=4:1,
                           breaks=4:1,
                           labels = c('1/10.000',
                                      '1/1.000',
                                      '1/100',
                                      '1/10')) +
        scale_y_continuous(name = 'Positiver / Negativer Pr\u00e4diktiver Wert [%]',
                           breaks=seq(0, 100, 10), limits=c(0, 100)) +
        theme_bw() +
        ylab(label = 'Positiver / Negativer Pr\u00e4diktiver Wert [%]') +
        xlab(label = 'Infektionsrisiko [%]') +
        theme(legend.position="bottom",
              text = element_text(size=17, face='bold')) +
        labs(color='Legende: ') +
        scale_color_manual(labels = c("PPW", "NPW"),
                           values = c("#0C70B0", '#D72F20'))

    if (x_incidence() > 1) {
        p <- p +
            geom_text(aes(x = x_incidence(),
                      y = ppv_y_pos() - 2,
                      size=5,
                      label=paste0("   PPW: ", ppv_intersect, '%   ')),
                  hjust = 0, parse=FALSE) +
            geom_text(aes(x = x_incidence(),
                      y = npv_y_pos() - 2,
                      size=5,
                      label=paste0("   NPW: ", npv_intersect, '%   ')),
                  hjust = 0, parse=FALSE)
    } else {
        p <- p +
            geom_text(aes(x = x_incidence(),
                      y = ppv_y_pos() - 2,
                      size=5,
                      label=paste0(" PPW: ", ppv_intersect, '%')),
                  hjust = 1, parse=FALSE) +
            geom_text(aes(x = x_incidence(),
                      y = npv_y_pos() - 2,
                      size=5,
                      label=paste0(" NPW: ", npv_intersect, '%')),
                  hjust = 1, parse=FALSE)
    }


    if (confidence_intervals == TRUE) {
        p <- p + geom_ribbon(data=data, fill='#73A9CF',
                             aes(ymin=data$ppv_ll,ymax=data$ppv_ul), alpha=0.3)

        p <- p + geom_ribbon(data=data, fill='#EF6547',
                             aes(ymin=data$npv_ll,ymax=data$npv_ul), alpha=0.3)
    }

    return(p)
}
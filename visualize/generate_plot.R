generate_plot <- function(data,
                          prevalence,
                          ppv_intersect,
                          npv_intersect,
                          confidence_intervals=FALSE) {

    x_incidence <- reactive({log10(1/prevalence)})
    ppv_x_pos <- reactive({log10(1/prevalence)})
    npv_x_pos <- reactive({log10(1/prevalence)})

    npv_y_pos <- reactive({adjust_y_pos(y_target = npv_intersect,
                                        y_other = ppv_intersect)})

    ppv_y_pos <- reactive({adjust_y_pos(y_target = ppv_intersect,
                                        y_other = npv_intersect)})

    p <- ggplot(data=data, aes(x=x)) +
        geom_line(aes(y=ppv, color = "#0C70B0"), size=1) +
        geom_line(aes(y=npv, color = '#D72F20'), size=1) +
        geom_vline(xintercept = x_incidence(), linetype="dotted",
                   color = "black", size=1.5) +
        annotate(geom="point", x = x_incidence(), y = ppv_intersect,
                     colour = "blue", size=5) +
        annotate("point", x = x_incidence(), y = npv_intersect,
                     colour = "red", size=5) +
        scale_x_reverse(name="Wahrscheinlichkeit, dass eine SARS-CoV-2 Infektion vorliegt (vor dem Test)",
                        minor_breaks=c(4:1, abs(log10(0.5))),
                        breaks=c(4:1, abs(log10(0.5))),
                        labels = c('10/100.000',
                                   '100/100.000',
                                   '1.000/100.000',
                                   '10.000/100.000',
                                   '50.000/100.000')) +
        scale_y_continuous(name = 'Positiver/Negativer Pr\u00e4diktiver Wert [%]',
                           breaks=seq(0, 100, 10), limits=c(0, 100)) +
        theme_bw() +
        theme(legend.position="bottom",
              text = element_text(size=17, face='bold')) +
        labs(color='Legende: ') +
        scale_color_manual(labels = c("PPW", "NPW"),
                           values = c("#0C70B0", '#D72F20'))

    if (x_incidence() > 1) {
        p <- p +
            geom_text(aes(x = x_incidence(),
                      y = ppv_y_pos() - 2,
                      label=paste0("   PPW: ", ppv_intersect, '%   ')),
                  hjust = 0, parse=FALSE) +
            geom_text(aes(x = x_incidence(),
                      y = npv_y_pos() - 2,
                      label=paste0("   NPW: ", npv_intersect, '%   ')),
                  hjust = 0, parse=FALSE)
    } else {
        p <- p +
            geom_text(aes(x = x_incidence(),
                      y = ppv_y_pos() - 2,
                      label=paste0(" PPW: ", ppv_intersect, '%')),
                  hjust = 1, parse=FALSE) +
            geom_text(aes(x = x_incidence(),
                      y = npv_y_pos() - 2,
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
calculate_ppv <- function(prevalence, sensitivity, specifity) {
    ppv <- sensitivity * prevalence /
        (sensitivity * prevalence + (1-prevalence) * (1-specifity))
    return(ppv)
}

calculate_npv <- function(prevalence, sensitivity, specifity) {
    npv <- sensitivity * (1-prevalence) /
        (specifity * (1-prevalence) + prevalence * (1-sensitivity))
    return(npv)
}

get_prevalence_data <- function(test_data=FALSE,
                                sensitivity=FALSE, specifity=FALSE){

    data <- data.frame(prevalence = c(1:100) * 0.01)

    if (sensitivity==FALSE) {
        sensitivity <- test_data$sensitivity
        sensitivity_ci_95_ll <- test_data$sensitivity_ci_95_ll
        sensitivity_ci_95_ul <- test_data$sensitivity_ci_95_ul
    }

    if (specifity==FALSE) {
        specifity <- test_data$specifity
        specifity_ci_95_ll <- test_data$specifity_ci_95_ll
        specifity_ci_95_ul <- test_data$specifity_ci_95_ul
    }

    data$ppv <- calculate_ppv(data$prevalence,
                              sensitivity / 100,
                              specifity / 100)

    data$npv <- calculate_npv(data$prevalence,
                              sensitivity / 100,
                              specifity / 100)

    if (test_data!=FALSE) {
        data$ppv_ll <- calculate_ppv(data$prevalence,
                                     sensitivity_ci_95_ll / 100,
                                     specifity_ci_95_ll / 100)

        data$ppv_ul <- calculate_ppv(data$prevalence,
                                     sensitivity_ci_95_ul / 100,
                                     specifity_ci_95_ul / 100)

        data$npv_ll <- calculate_npv(data$prevalence,
                                     sensitivity_ci_95_ll / 100,
                                     specifity_ci_95_ll / 100)

        data$npv_ul <- calculate_npv(data$prevalence,
                                     sensitivity_ci_95_ul / 100,
                                     specifity_ci_95_ul / 100)
    }

    return(data)
}
source('utils/estimate_prevalence.R')

calculate_ppv <- function(incidence, sensitivity, specifity) {

    prevalence <- estimate_prevalence(incidence, fraction_cases = 0.33)

    ppv <- sensitivity * prevalence /
        (sensitivity * prevalence + (1-prevalence) * (1-specifity))
    return(ppv)
}

calculate_npv <- function(incidence, sensitivity, specifity) {

    prevalence <- estimate_prevalence(incidence, fraction_cases = 0.33)

    npv <- sensitivity * (1-prevalence) /
        (specifity * (1-prevalence) + prevalence * (1-sensitivity))
    return(npv)
}

get_risk_data <- function(test_data=FALSE,
                          sensitivity=FALSE, specifity=FALSE){

    data <- data.frame(x=c(40:10/10, 9:3/10))
    data$incidence <- 1/10^data$x
    data$prevalence <- estimate_prevalence(data$incidence,
                                           fraction_cases = 0.33)

    if (sensitivity==FALSE) {
        sensitivity <- test_data$sensitivity / 100
        sensitivity_ci_95_ll <- test_data$sensitivity_ci_95_ll / 100
        sensitivity_ci_95_ul <- test_data$sensitivity_ci_95_ul / 100
    } else {
        sensitivity <- sensitivity / 100
    }

    if (specifity==FALSE) {
        specifity <- test_data$specifity / 100
        specifity_ci_95_ll <- test_data$specifity_ci_95_ll / 100
        specifity_ci_95_ul <- test_data$specifity_ci_95_ul / 100
    } else {
        specifity <- specifity / 100
    }

    data$ppv <- calculate_ppv(data$incidence,
                              sensitivity,
                              specifity)

    data$npv <- calculate_npv(data$incidence,
                              sensitivity,
                              specifity)

    if (test_data!=FALSE) {
        data$ppv_ll <- calculate_ppv(data$incidence,
                                     sensitivity_ci_95_ll,
                                     specifity_ci_95_ll)

        data$ppv_ul <- calculate_ppv(data$incidence,
                                     sensitivity_ci_95_ul,
                                     specifity_ci_95_ul)

        data$npv_ll <- calculate_npv(data$incidence,
                                     sensitivity_ci_95_ll,
                                     specifity_ci_95_ll)

        data$npv_ul <- calculate_npv(data$incidence,
                                     sensitivity_ci_95_ul,
                                     specifity_ci_95_ul)
    }

    data <- data * 100
    data$incidence <- data$incidence / 100
    data$x <- data$x / 100

    print(tail(data, 15))
    return(data)
}
get_test_data = function() {
    data <- data.frame(
      # For each subject
        name = c('Test 1',
                 'Test 2',
                 'Test 3',
                 'Test 4',
                 'Test 5',
                 'Test 6',
                 'Test 7',
                 'Test 8',
                 'Test 9'),
        sensitivity = c(0.8,
                        0.2,
                        0.3,
                        0.4,
                        0.5,
                        0.6,
                        0.7,
                        0.8,
                        0.9),
        specifity = c(0.97,
                      0.2,
                      0.3,
                      0.4,
                      0.5,
                      0.6,
                      0.7,
                      0.8,
                      0.9))
    return(data)
}

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

get_prevalence_data <- function(test_data){

    data <- data.frame(prevalence = c(1:100) * 0.01)

    data$ppv <- calculate_ppv(data$prevalence,
                              test_data$sensitivity / 100,
                              test_data$specifity / 100)

    data$ppv_ll <- calculate_ppv(data$prevalence,
                          test_data$sensitivity_ci_95_ll / 100,
                          test_data$specifity_ci_95_ll / 100)

    data$ppv_ul <- calculate_ppv(data$prevalence,
                          test_data$sensitivity_ci_95_ul / 100,
                          test_data$specifity_ci_95_ul / 100)

    data$npv <- calculate_npv(data$prevalence,
                              test_data$sensitivity / 100,
                              test_data$specifity / 100)

    data$npv_ll <- calculate_npv(data$prevalence,
                          test_data$sensitivity_ci_95_ll / 100,
                          test_data$specifity_ci_95_ll / 100)

    data$npv_ul <- calculate_npv(data$prevalence,
                          test_data$sensitivity_ci_95_ul / 100,
                          test_data$specifity_ci_95_ul / 100)

    return(data)
}
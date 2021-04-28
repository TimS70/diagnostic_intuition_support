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

get_prevalence_data <- function(sensitivity, specifity){

    data <- data.frame(prevalence = c(0:10) * 0.1)
    data$ppv = sensitivity * data$prevalence /
        (sensitivity * data$prevalence + (1-data$prevalence) * (1-specifity))
    data$npv = sensitivity * (1-data$prevalence) /
        (specifity * (1-data$prevalence) + data$prevalence * (1-sensitivity))

    print('Sensitivity')
    print(sensitivity)
    print('Specifity')
    print(specifity)
    print(data)
    return(data)
}
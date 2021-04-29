library(dplyr)
library(tidyr)
library(stringr)

clean_test_data <- function(data) {
    names(data) <- c('id',
                          'handelsname',
                          'evaluierung',
                          'hersteller_name',
                          'hersteller_stadt',
                          'hersteller_land',
                          'eu_bevollmächtigter_name',
                          'eu_bevollmächtigter_stadt',
                          'eu_bevollmächtigter_land',
                          'test_ort',
                          'sensitivity',
                          'sensitivity_ci_95',
                          'specifity',
                          'specifity_ci_95')

    data <- data %>%
        mutate(sensitivity_ci_95 = sensitivity_ci_95 %>%
                   str_replace(pattern = "[~;–]", replacement = "-") %>%
                   str_replace(pattern = "--", replacement = '-') %>%
                   str_replace(pattern = ", ", replacement = '-'),
               specifity_ci_95 = specifity_ci_95 %>%
                   str_replace(pattern = "[~;–]", replacement = "-") %>%
                   str_replace(pattern = "--", replacement = '-') %>%
                   str_replace(pattern = ", ", replacement = '-')) %>%
        separate(col=sensitivity_ci_95,
                 into=c('sensitivity_ci_95_ll', 'sensitivity_ci_95_ul'),
                 sep='-',
                 remove=FALSE) %>%
        separate(col=specifity_ci_95,
                 into=c('specifity_ci_95_ll', 'specifity_ci_95_ul'),
                 sep='-',
                 remove=FALSE)

    for (col in c('sensitivity_ci_95_ll',
                  'sensitivity_ci_95_ul',
                  'specifity_ci_95_ll',
                  'specifity_ci_95_ul')) {
        data[, col] <- data[, col] %>%
            str_replace(pattern = ",", replacement = ".") %>%
            str_replace(pattern = " ", replacement = "") %>%
            str_replace(pattern = "%", replacement = "") %>%
            str_replace(pattern = "\\(", replacement = "") %>%
            str_replace(pattern = "\\)", replacement = "") %>%
            str_replace(pattern = "\\]", replacement = "") %>%
            str_replace(pattern = "\\[", replacement = "")

        data[, col] <- iconv(data[, col], from='utf-8', to='ascii', sub='')
        data[, col] <- as.numeric(data[, col])
    }

    return(data)
}

load_test_data <- function(file) {
    data <- read.csv(file=file, sep = ';', dec=',')
    data <- clean_test_data(data = data)
    return(data)
}

data <- load_test_data(file='antigentests.csv')

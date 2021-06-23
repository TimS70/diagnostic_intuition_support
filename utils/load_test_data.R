library(dplyr)
library(tidyr)
library(stringr)
library(sjmisc)
library(pins)


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

    data[data[, 'id']=='AT586/21', 'specifity_ci_95'] = '97,7 - 99,9'
    data[data[, 'id']=='AT550/21', 'sensitivity_ci_95'] = '80,84 - 99,30'
    data[data[, 'id']=='AT550/21', 'specifity_ci_95'] = '96,84 - 100,0'
    data[data[, 'id']=='AT656/21', 'sensitivity_ci_95'] = '80,8 - 92,7'
    data[data[, 'id']=='AT673/21', 'specifity_ci_95'] = '96,9 - 99,9'
    data[data[, 'id']=='AT892/21', 'sensitivity_ci_95'] = '95,82 - 98,51'
    data[data[, 'id']=='AT892/21', 'specifity_ci_95'] = '97,81 - 99,69'
    data[data[, 'id']=='AT656/21', 'sensitivity_ci_95'] = '80,8 - 92,7'
    data[data[, 'id']=='AT656/21', 'specifity_ci_95'] = '96,3 - 99,6'
    
    
    for (txt in '%') {
        data <- data %>%
            mutate(sensitivity_ci_95 = sensitivity_ci_95 %>%
                    str_replace(regex(txt, dotall = TRUE),
                                replacement = ""),
               specifity_ci_95 = specifity_ci_95 %>%
                    str_replace(regex(txt, dotall = TRUE),
                                replacement = ""))
    }

    for (txt in c("[~; A-Za-z%]",
                  ", ",
                  ",-"
    )) {

        data <- data %>%
            mutate(sensitivity_ci_95 = sensitivity_ci_95 %>%
                    str_replace(pattern = txt, replacement = "-"),
               specifity_ci_95 = specifity_ci_95 %>%
                    str_replace(pattern = txt, replacement = "-"))
    }

    for (txt in c("- - ",
                  "- - ",
                  "--",
                  "-–",
                  ", ",
                  ",-"
    )) {

        data <- data %>%
            mutate(sensitivity_ci_95 = sensitivity_ci_95 %>%
                    str_replace(pattern = txt, replacement = "-"),
               specifity_ci_95 = specifity_ci_95 %>%
                    str_replace(pattern = txt, replacement = "-"))
    }

    data <- data %>%
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
            str_replace(pattern = ",", replacement = ".")

        data[, col] <- iconv(data[, col], from='utf-8', to='ascii', sub='')
        data[, col] <- as.numeric(data[, col])
    }

    data$hersteller <- data$hersteller_name %>%
        word(end=1) %>%
        str_replace(pattern = ",", replacement = "") %>%
        tolower() %>%
        str_to_title()

    # Remove duplicate tests (remove the one with the lower ID)
    data <- data[!duplicated(data[c('hersteller', 'handelsname')]),]
    
    # Dichotomize evaluierung
    data$evaluierung = factor(data$evaluierung)
    
    data$evaluierung = recode(data$evaluierung, "Ja" = 1, "Nein" = 0)
        
    return(data)
}

load_test_data <- function(file) {
    data <- read.csv(file=file, sep = ';', dec=',',
                     fileEncoding='windows-1252')
    data <- clean_test_data(data = data)

    return(data)
}

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

    data <- data %>%
        mutate(sensitivity_ci_95 = sensitivity_ci_95 %>%
                    str_replace(pattern = "[~;– ]", replacement = "-") %>%
                    str_replace(pattern = "--", replacement = '-') %>%
                    str_replace(pattern = ", ", replacement = '-') %>%
                    str_replace(pattern = ",-", replacement = '-'),
               specifity_ci_95 = specifity_ci_95 %>%
                    str_replace(pattern = "[~;– ]", replacement = "-") %>%
                    str_replace(pattern = "--", replacement = '-') %>%
                    str_replace(pattern = ", ", replacement = '-') %>%
                    str_replace(pattern = ",-", replacement = '-')) %>%
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
            str_replace(pattern = "-", replacement = "") %>%
            str_replace(pattern = "–", replacement = "") %>%
            str_replace(pattern = "%", replacement = "") %>%
            str_replace(pattern = "\\(", replacement = "") %>%
            str_replace(pattern = "\\)", replacement = "") %>%
            str_replace(pattern = "\\]", replacement = "") %>%
            str_replace(pattern = "\\[", replacement = "")

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

    return(data)
}

load_test_data <- function(file) {
#     link <- 'https://antigentest.bfarm.de/ords/wwv_flow.ajax?p_flow_id=110&p_flow_step_id=100&p_instance=15359458084502&p_debug=&p_json=%7B%22regions%22%3A%5B%7B%22id%22%3A%2288500488737603332%22%2C%22reportId%22%3A%2288808822859644913%22%2C%22ajaxIdentifier%22%3A%22EMuu7CyLWa5dWZgdfpQ6lI1yxyFfdU29Lpo1ZMnnZWc%22%2C%22downloadFileId%22%3A%22250415674117865674%22%7D%5D%2C%22salt%22%3A%2277076691586332798101117057462003301300%22%7D'
#     link_2 <- 'https://antigentest.bfarm.de/ords/f?p=110:100:14588237856972:::::&tz=2:00'
# # example <- EN.ATM.CO2E.PC
# # NY.GDP.PCAP.CD
#     test <- fread(link_2)
#     test
    data <- read.csv(file=file, sep = ';', dec=',',
                     fileEncoding='windows-1252')
    data <- clean_test_data(data = data)

    print(head(data))

    return(data)
}

# dir.create(path='data')
# write.csv(data, file.path('data', "test_data.csv"),fileEncoding = 'UTF-8')

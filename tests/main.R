# Title     : TODO
# Objective : TODO
# Created by: User
# Created on: 29.04.2021

library(sjmisc)
source(file.path('tests', 'load.R'))

data <- load_test_data(file= file.path('tests', 'antigentests.csv'))

names(data)
head(data)
unique(data$hersteller_name)

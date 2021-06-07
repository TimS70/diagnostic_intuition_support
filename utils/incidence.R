library(dplyr)
library(openxlsx)
library(janitor)
library(stringr)


region_names <- function() {
    url <- 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab.xlsx?__blob=publicationFile'
    names_bundesland <- read.xlsx(url, rows=2:22, cols=1, sheet=2)
    names(names_bundesland) <- 'bundesland'
        
    data_landkreis <- read.xlsx(url, rows=3:1000, cols=1:2, sheet=3) 

    names_landkreis <- with(data_landkreis,
                            paste0(Landkreis, ' (', LKNR, ')'))

    selection_list <- list(
        Deutschland = 'Deutschland',
        Bundesland = names_bundesland[1:16, 1],
        'Land-/Stadtkreis' = names_landkreis
    )

    return(selection_list)
}


region_incidence_data <- function() {
    url <- 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab.xlsx?__blob=publicationFile'
    data_bundesland <- read.xlsx(url, rows=3:22, sheet=2, colNames=TRUE, 
                                 detectDates=TRUE) 
    data_bundesland <- data_bundesland[,c(1, ncol(data_bundesland))]
    names(data_bundesland) <- c('region', 'incidence')

    data_bundesland[data_bundesland$'region'=='Gesamt', 'region'] <- 'Deutschland'
    
    data_landkreis <- read.xlsx(url, rows=3:1000, cols=1:4, sheet=3, colNames=TRUE, 
                                detectDates=TRUE) 
    
    # For wide format
    # data_landkreis <- data_landkreis[,c(1:2, ncol(data_landkreis))]
    names(data_landkreis) <- c('Landkreis', 'LKNR', 'count', 'incidence')
    
    data_landkreis$region <- with(data_landkreis, paste0(Landkreis, ' (', LKNR, ')'))
    
    data_landkreis <- data_landkreis %>% dplyr::select(region, incidence)

    data <- rbind(data_bundesland,
                  data_landkreis)

    return(data)
}


incidence_date <- function() {
    url <- 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab.xlsx?__blob=publicationFile'
    date_txt <- read.xlsx(url, rows=2, sheet=2, colNames=FALSE)[1, ]

    return(date_txt)
}

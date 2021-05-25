library(dplyr)
library(openxlsx)
library(janitor)
library(stringr)


region_names <- function() {
    url <- 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab.xlsx?__blob=publicationFile'
    names_bundesland <- read.xlsx(url, rows=2:22, cols=1, sheet=3)
    names(names_bundesland) <- 'bundesland'
        
    data_landkreis <- read.xlsx(url, rows=3:1000, cols=2:3, sheet=5) 

    names_landkreis <- with(data_landkreis,
                            paste0(LK, ' (', LKNR, ')'))

    selection_list <- list(
        Deutschland = 'Deutschland',
        Bundesland = names_bundesland[1:16, 1],
        'Land-/Stadtkreis' = names_landkreis
    )

    return(selection_list)
}


region_incidence_data <- function() {
    url <- 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab.xlsx?__blob=publicationFile'
    data_bundesland <- read.xlsx(url, rows=3:22) %>%
        clean_names() %>%
        rename(region = bundesland,
               incidence = x7_tage_inzidenz) %>%
        dplyr::select(region, incidence)

    data_bundesland[data_bundesland$'region'=='Gesamt', 'region'] <- 'Deutschland'

    data_landkreis <- read.xlsx(url, rows=3:1000, colNames=TRUE, sheet=2) %>%
        clean_names()
    data_landkreis$landkreis_nr <- with(data_landkreis,
                                        paste0(landkreis, ' (', lknr, ')'))
    data_landkreis <- data_landkreis %>%
        rename(region=landkreis_nr, incidence=inzidenz) %>%
        dplyr::select(region, incidence)

    data <- rbind(data_bundesland,
                  data_landkreis)

    return(data)
}


incidence_date <- function() {
    url <- 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab.xlsx?__blob=publicationFile'
    date_txt <- read.xlsx(url, rows=2, colNames=FALSE)[1, ]

    return(date_txt)
}

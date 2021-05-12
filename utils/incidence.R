obtain_incidence <- function() {
    url <- 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab.xlsx?__blob=publicationFile'
    data_incidence <- rio::import(url)
    total_incidence <- incidence <- data_incidence[data_incidence[, 1] == 'Gesamt', 3]
    total_incidence <- as.numeric(total_incidence[!is.na(total_incidence)])
    infection_risk <- 100000/total_incidence

    return(infection_risk)
}

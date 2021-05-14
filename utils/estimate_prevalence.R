estimate_prevalence <- function(incidence, fraction_cases) {

    # if incidence too large, no prevalence estimation possible
    # max_incidence <- 0.025
    # prevalence <- (incidence < max_incidence) * 2*incidence/fraction_cases +
    #     (1-(incidence < max_incidence)) * incidence

    prevalence <- 2*incidence/fraction_cases

    return(prevalence)
}
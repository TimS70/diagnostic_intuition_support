estimate_prevalence <- function(incidence, fraction_cases) {

    prevalence <- 2*incidence/fraction_cases

    return(prevalence)
}
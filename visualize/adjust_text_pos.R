adjust_x_pos <- function(prevalence) {
    pos <- prevalence

    if (prevalence > 90) {
        pos <- prevalence - 14
    }

    return(pos)
}


adjust_y_pos <- function(y_other, y_target) {

    distance <- 4
    pos <- y_target

    if (abs(y_target - y_other) < distance) {
        if (y_target < y_other) {
            pos <- y_target - distance
        }
    }

    return(pos)
}


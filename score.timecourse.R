require("plyr")

score.timecourse <- function(data, score_name, score_f){
# Score the timecourse in the <data> object, from read.timecourse

    # Use the score_f to create the scores
    # considering each condition in each roi separatly
    scores <- ddply(data, .(roi, condition), score_f)
    colnames(scores) <- c("roi", "condition", score_name)
    scores
}

# ------------------------------------
# Define the atomic scoring functions
# used by score.timecourse()
score.var <- function(data) { var(data$timecourse) }

score.mean <- function(data) { mean(data$timecourse) }

score.peak <- function(data) { max(data$timecourse) }

score.absdiff <- function(data) {
    rr <- range(data$timecourse)
    abs(rr[1] - rr[2])
}

score.lag <- function(data) {
    r_data <- data$timecourse
    maxval <- max(r_data)
    (1:length(r_data))[maxval == r_data]
        ## Return the location of the maxval
        ## by filtering the dereferenced
        ## index 1:length(...)
}

score.halfmax <- function(data) {
    r_data <- data$timecourse
    halfmax <- max(r_data) / 2
    (1:length(r_data))[r_data >= halfmax][1]
        ## Return the nearest location to the halfmax
        ## by filtering the dereferenced
        ## index 1:length(...), then grabbing the
        ## first element
}




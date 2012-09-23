library("plyr")

rank.timecourse <- function(data, ranks, rank_means=TRUE){
# Append ranks, and return the timecourse <data>

    # Now use the ranks to rank rows in the data_obj,
    # i.e. the timecourses
    compare_basis <- "condition"
    if(rank_means){ compare_basis <- "roi" }
    
    data_ranks <- rep(0, nrow(data))
    for(ii in 1:nrow(ranks)){
        # Get the current rank and compare_basis
        r_ii <- ranks[ii, "rank"]
        cmp <- ranks[ii, compare_basis]

        # and use them to build a mask
        mask <- data[[compare_basis]] == cmp

        # which is used to add r_ii to data_ranks
        data_ranks[mask] <- r_ii
    }

    # Append data_ranks to data
    data <- cbind(data, data_ranks)
    data$data_ranks <- factor(data$data_ranks)

    #EOF
    data
}

rank.score <- function(scores, rank_means=TRUE){
# Ranks the scores in scores, assuming scores are in 
# column 3.  Adds a col/factor for the ranksm returning the modified
# scores.

    if(rank_means){
        # Now mean across the conditions 
        # in the scores?
        mean.score <- function(scores) { mean(scores[[3]]) }
        scores <- ddply(scores, .(roi), mean.score)
    }
    
    # Sort scores
    scores <- scores[with(scores,
                        order(scores[[2]],
                        decreasing = TRUE)), ]

    if(rank_means){
        ranks <- data.frame(roi=scores$roi, 
                            rank=factor(1:nrow(scores))) 
    } else {
        ranks <- data.frame(roi=scores$roi, 
                            condition=scores$condition,
                            rank=factor(1:nrow(scores)))
    }
    
    #EOF
    ranks
}


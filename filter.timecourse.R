filter.timecourse <- function(data, crit, score_f, filter_f){
	# Use the provided filter_f function (which returns a boolean value) 
	# and crit(ertion) to filter the timecourse data
	
    scores <- ddply(data, .(roi, condition), score_f)
	data[filter_f(scores, crit), ]
}

# ------------------------------------
# Define the atomic filtering functions
# used by filter.timecourse()
# - Filter functions return TRUE/FALSE based on crit.
filter.leq <- function(scores, crit){
	# Return TRUE if score is less than or equal to crit
	# otherwise FALSE
	scores[[3]] <= crit
}

filter.geq <- function(scores, crit){
	# Return TRUE if score is greater than or equal to crit
	# otherwise FALSE
	scores[[3]] >= crit
}
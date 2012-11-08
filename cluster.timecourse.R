cluster.timecourse.reformat.for.cluster <- function(data){
	# Reformat the data form the internal format to something appropriate for
	# spatio-temporal PCA.
	
	# For each roi, each row of timecourse becomes a column,
	# concatenating conditions as needed
	roi_and_cond_as_row <- function(data){ timecourse_data <- data$timecourse }
	reformated <- ddply(data, .(roi), roi_and_cond_as_row)
	colnames(reformated) <- c("roi", (1:(ncol(reformated)-1)))

	reformated
}


cluster.timecourse.pca <- function(data, tol){
	# Reduce the dimensionality by <tol> using PCA.
	
	# Reduce, using tol, to the components
	reformated <- cluster.timecourse.reformat.for.cluster(data)
	asmat <- t(reformated[ ,2:ncol(reformated)])
	pcs <- prcomp(asmat, scale=TRUE, center=TRUE, tol=tol)
	
	# Convert the components back to the
	# the timecourse data format.
	
}

.process.row <- function(row, roicols, condcols, timecols){
	
	# ----
	# Process roi
	# If we are working with voxel-level
	# data there is no roi_name,
	# so roicols should be NULL
	# and roi_name should be NA.
	if(is.null(roicols)){
		roi_name <- NA
	} else if(length(roicols) > 1){
		# If there is more than one
		# cobmined them in . 
		# seperated string.
		roi_name <- paste(row[roicols], collapse=".")
	} else {
		roi_name <- row[roicols]
	}

	# ----
	# Process cond
	if(is.null(condcols)){
		condition <- NA
	} else {
		condition <- row[condcols]
	}
		
	# ----
	# Process timecourse
	timecourse <- t(row[timecols])
		## No need to special processing, 
		## there must always be timecourse data
	
	list(roi_name=roi_name, 
		condition=condition, 
		timecourse=timecourse)
}


.skip.timecourse <- function(timecourse){
	# Skip is TRUE if rows/timecourse has NaNs
	# or is full of zeros.
	skip <- FALSE
	if(sum(is.nan(timecourse)) > 0){
		skip <- TRUE
	} else if((sum(timecourse) < 0.0001) && 
			(sum(timecourse) > -0.0001) &&
			(var(timecourse) < 0.0001)) { 
		skip <- TRUE
	}
	skip
}

# TODO want to have 2 strcutures for the data, instead of the one used here.
# The first, for scoring, ranking and clustering should be
# <roi> <cond> <data> (or similar)
# Where data is a scalar or a timecourse
# The second should match the format used for plotting of timecourse
# data.
# <TR_index> <cond> <roi> <data>
# the difference is the data is explicitily indexed by TR_index
# rather that each bieng its own column as above.
# NEED TO WITE A EFFICIENT (TRANSPOSE BASED?) WAY TO CONVERT BETWEEN
# THESE.
# Almost all the real work will be done in the first, the later is to satisfy
# ggplot2.

read.timecourse <- function(name, roicols=2:4, condcols=1, timecols=5:20, header=FALSE){
# Read in the <name>ed data file.
    
    # Get the data
	print("Initial read.")
	data <- read.table(name, sep="\t", header=header, stringsAsFactors=FALSE)
    
    # Now transform it to something that pylr and ggplot
    # can handle easily, i.e a data.frame
	print("Starting transform.")
    transformed <- NULL
    for(ii in 1:nrow(data)){
        # Put in a row, for clarity
        row <- array(data[ii, ])

		# Process the row 
		prow <- .process.row(row, roicols, condcols, timecols)
		roi_name = prow$roi_name
		condition = prow$condition
		timecourse = prow$timecourse
		
		# Skip rows/timecourse with NaNs
		# or full of zeros.
		if(.skip.timecourse(timecourse)){ 
			print("Skipping:")
			print(timecourse)
			next
		}

        # Recombined them, into a col-oriented, df-like, structure
        l <- length(timecourse)
        df_columns <- cbind(
                      rep(as.character(roi_name), l),
                      rep(as.character(condition), l),
                      1:l,
                      timecourse)

        transformed <- rbind(transformed, df_columns)
    }

    # Make a df, give the cols nice names,
	print("Cleaning up the data.")
	transformed <- as.data.frame(transformed, 
                                 row.names=NULL, stringsAsFactors=FALSE)
    
    # and setup the factors manually.
    colnames(transformed) <- c("roi","condition","index","timecourse")
    transformed$roi <- factor(transformed$roi)
    transformed$condition <- factor(transformed$condition)
    transformed$index <- as.numeric(transformed$index)
    transformed$timecourse <- as.numeric(transformed$timecourse)
        ## This manual shit should not have been needed but R is
        ## is being weird

    # EOF
    transformed
}


read.timecourses.par <-function(names, roicols=2:4, condcols=1, timecols=5:20, header=FALSE) {
	# Read in each ofthe names, each in parallel if possible.
	# Returns all the named data in a list
	library("plyr")
	library("doMC")
	
	# Init the parallalization backend
	# from doMC
	registerDoMC()
	
	# Closure on read.timecourse()
	reader <- function(name){
		read.timecourse(name, roicols, condcols, timecourse, header)
	}

	# Now read in, in parallel.
	nameddata <- alply(
		names, 
		.fun=reader, 
		.parallel=TRUE, 
		.progress="text")

	namedata
}


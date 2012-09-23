read.timecourse.rowformat <- function(name){
# Read in the <name>ed data file.
    
    # Get the data
    data <- read.table(name, sep="\t", header=TRUE, stringsAsFactors=FALSE)
    
    # Now transform it to something that pylr and ggplot
    # can handle easily, i.e a data.frame
    transformed <- NULL
    for(ii in 1:nrow(data)){
        # Put in a row, for clarity
        row <- array(data[ii, ])

        # Get the parts of row
        roi_name <- row[1]
        condition <- row[2]
        timecourse <- t(row[3:length(row)])

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

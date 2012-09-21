read.timecourse.rowformat <- function(name){
# Read in the <name>ed data file.
    
    # Get the data
    data <- read.table(name, sep="\t", header=TRUE, stringsAsFactors=FALSE)
    print(str(data))
    
    # Now transform it to something that pylr and ggplot
    # can handle easily, i.e a data.frame
    transformed <- NULL
    for(ii in 1:nrow(data)){
        # Put in a row, for clarity
        row <- array(data[ii, ])

        # Get the parts of row
        roi_name <- row[1]
        event <- row[2]
        timecourse <- t(row[3:length(row)])
        print(timecourse)
        # Recombined them, into a col-oriented, df-like, structure
        l <- length(timecourse)
        df_columns <- cbind(
                      rep(as.character(roi_name), l),
                      rep(as.character(event), l),
                      1:l,
                      timecourse)

        transformed <- rbind(transformed, df_columns)
    }

    # Make a df, give the cols nice names,
    transformed <- as.data.frame(transformed, 
                                 row.names=NULL, stringsAsFactors=FALSE)
    
    # and setup the factors manually.
    colnames(transformed) <- c("roi","event","index","timecourse")
    transformed$roi <- factor(transformed$roi)
    transformed$event <- factor(transformed$event)
    transformed$index <- factor(transformed$index)
    transformed$timecourse <- as.numeric(transformed$timecourse)
        ## This manual shit should not have been needed but R is
        ## is being weird

    # EOF
    transformed
}

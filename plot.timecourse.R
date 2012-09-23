library("ggplot2")

plot.timecourse.magic <- function(data){
    p
# TODO
}

plot.timecourse.combinedconds <- function(ranked_data, name, height=0, width=0){
# Plot the supplied ranked_data; height and width are in inches, unless
# their 0 in which case R makes a guess.

    # Init the graphics device
    if((height > 0) && (width > 0)){
        pdf(height=height, width=width)
    } else {
        pdf()    
    }

    # Build up the plot
    p <- ggplot(data=ranked_data,
                aes(x=index, y=timecourse, colour=condition))
    p <- p + geom_line() 
    p <- p + facet_wrap(~data_ranks)
    p <- p + scale_fill_brewer(palette="Dark2")
    p <- p + ylab("% Signal Change") + xlab("TR")
    p <- p + theme_bw()

    # Plot, save, and clear the device
    plot(p)
    ggsave(paste(name, ".pdf", sep=""))
    graphics.off()
}

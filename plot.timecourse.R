library("ggplot2")

plot.timecourse.magic <- function(data, criterion=1, height=0, width=0){
# Plot all all scores.

    score_names <- c("var", "mean", "peak", "absdiff",
                     "lag", "halfmax") 
    score_fs <- c(score.var, score.mean, score.peak, score.absdiff,
                  score.lag, score.halfmax)

    for(ii in 1:length(score_names)){
        print(score_names[[ii]])
        
        scored <- score.timecourse(data, score_names[[ii]], score_fs[[ii]])
        ranked <- rank.score(scored, TRUE)
        data_ranked <- rank.timecourse(data, ranked, TRUE)
        
        if(criterion < 1){
            data_ranked <- filter.ranked(data_ranked, criterion)
        }
        
        plot_name <- paste("timecourse", score_names[[ii]], sep="_")
        plot.timecourse.combinedconds(data_ranked, plot_name,
                                      height, width)
    }
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
    p <- p + facet_wrap(~ data_ranks + roi)
    p <- p + scale_fill_brewer(palette="Dark2")
    p <- p + ylab("% Signal Change") + xlab("TR") + opts(title=name)
    p <- p + theme_bw()

    # Plot, save, and clear the device
    plot(p)
    ggsave(paste(name, ".pdf", sep=""))
    graphics.off()
}

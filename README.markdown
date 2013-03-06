# TODO 

* Implement filter.rank and filter.score ...
* Several of the scores need inverting
* There are still no plot titles; WTF ggplot, WTF.
* Correct errors in this doc

# Install
A set of R functions for sorting, filtering, and plotting of fMRI HRF timecourses.  The goal is make visualizing various properties of the timecourses simple, while producing clean, yet dense, displays.

The functions require plyr (http://plyr.had.co.nz/) and ggplot2 (http://ggplot2.org/), and have only been tested on R >= v2.15.1 (http://www.r-project.org/) on MacOS 10.7.4.

To use download this code, executing the following in the directory where you want the code installed.

	git clone https://github.com/andsoandso/timecourse

Or you can manually go to https://github.com/andsoandso/timecourse and click on the ZIP button to get the most recent version of the code.  Using git though will simplify updating the code in the future.
	
Then open an R console and, assuming your working directory is ./timecourse, type

	source("timecourse.R")

...In the future perhaps this will become a proper package, but for now you'll have to load everything manually.

# Magic

If you just want to plot your data using all available scores and plot kinds, run:

	# read in the data, then plot it (assumeing we started in ./timecourse)
	setwd("./test")  ## Move to the test folder
	tc <- read.timecourse.rowformat('roi_data_1.txt')
	plot.timecourse.magic(tc,1,18,14)  # e.g. criterion=1,height=12, width=12)
	
Where roi\_data\_1.txt is a text file of the form:

	roi		condition	1 	2 	 	...	n
	1		fast 		0.1	0.3			-.1


Where the first row is a header, and each subsequent row matches the corresponding data.  Thanks to plyr, very very large datasets can be handled relatively easily.

Or if you want to exclude some of the timecourse data prior to plotting use the filter.timecourse() function, for example:

	# Filter (remove) timecourses if their max value (found using score.peak) 
	# is less than or equal to (leq) the crit.
	crit <- 0.1
	ftc <- filter.timecourse(tc, crit, score.peak, filter.leq)

As you can see filter.timecourse takes 4 arguments - some timecourse data, a criterion, a scoring function (see score.timecourse.R), a filtering function (filter.timecourse.R; Filter functions return TRUE/FALSE based on crit).

Each of the magic plots is saved as pdf in the current working directory.  If you wish to keep only the top fraction of scores (which are described below), criterion can be set 0-1.  For example, if criterion=0.3 the top 30% of scores are plotted.

To see how magic works keep reading.

# Details

If the magic is too much or too little, here are the details on the worker functions.  They can, mostly, be used alone just fine.

After the loads above, a ls() will then reveal several useful functions; keep reading for the details.  The plotting functions are listed below.
	
1. plot.timecourse.combinedconds
2. [TODO] plot.timecourse.separateconds

Each plotting function expects, one timecourse data_object, which is created as below.  The file in quotes is the test data set.

	data_obj <- read.timecourse.rowformat('./test/roi_data_1.txt')

Note: at current read.timecourse.rowformat.* takes one data format, matching the format found in './test/roi\_data\_1.txt'.  This may change, if needed.

They also expect one score_object, created using score.timecourse(...).  As an example, if you wanted to score using the peak height, this would work:

	score_obj <- score.timecourse(data_obj, "peak", score.peak)

As you can score.timecourse takes three arguments, a data_obj (from read.timecourse.rowformat), a name (i.e. "peak"), and a scoring function (making score.timecourse a metafunction).  

The available scoring functions are:

1. score.peak - the max value
2. score.mean - the mean value
3. score.var - the variance
4. score.absdiff - the absolute difference between the range value
5. score.lag - time to max value
6. score.halfmax - time to half the maximum (larger values imply steeper slopes)

Note: If you have other scores in mind, ones not listed above, do share them. This code is designed to allow new scores to be added easily.

Once you have scores, they need to be ranked.  This is accomplished with

	rank_object <- rank.score(scores, rank_means=TRUE)
	
And these ranks are then applied to the timecourse data

	data_ranked <- rank.timecourse(data_obj, rank_object, rank_means=TRUE)

In both cases above, rank_means is set to TRUE, as such the scores for any conditions (for each ROI) are averaged prior to ranking.

If there are too many ROIs, so you want to drop some based on rank do the below.  The criterion is between 0-1 (inclusive) and represents the top fraction of scores to keep, e.g. 0.1 would keep the top 10%.

	criterion <- 0.1
	keepers <- filter.rank(data_ranked, criterion)

	# Or as any rank-containing object will work
	keepers <- filter.rank(ranked, criterion)

Or you can filter the scores.  However unlike the rank filter you must specify the real valued threshold you want to use.

	# Assuming were working with peak scores, 0.5 (% signal change)
	# might be a reasonable choice
	threshold <- 0.5

Now explain how to use these and the direct plot methods in general
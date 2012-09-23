# TODO 
* Implement magic
* Implement keep...
* Find a way to add roi names to the plot facets
* Correct errors in this doc

# Install
A set of R functions for sorting, filtering, and plotting of fMRI HRF timecourses.  The goal is make visualizing various properties of the timecourses simple, while producing clean, yet dense, displays.

It requires plyr (http://plyr.had.co.nz/) and ggplot2 (http://ggplot2.org/), and has only been tested on R >= v2.15.1 (http://www.r-project.org/) on MacOS 10.7.4.

To use download this code, executing the following in the directory where you want the code installed.

	git ...
	
Then open an R console and, assuming your working directory is ./timecourses, type

    load("plot.timecourse.R")
	load("read.timecourse.R")
	load("score.timecourse.R")

# Magic

Below are the details for the functions that make the magic work.  However if you just want to plot the data using all available scores and plot kinds, run:

	plot.timecourse.magic('data.txt')

Where data.txt is a text file of the form:

	....

Each of the magic plots is saved as pdf in the current working directory.  As an alternative, if there are many many ROIs you can plot only the top N percent using
	
	N <- 0.5 # The top 50%, for example; N should be between 0-1
	plot.timecourse.limitedmagic('data.txt', N)

For magical details, see details.

# Details

If magic is too much or too little, here are the details on the worker functions.  They can be used alone just fine.

After the laods above, a ls() will then reveal several useful functions; keep reading for the details.  The plotting functions are listed below.
	
1. plot.timecourse.combinedconds
2. plot.timecourse.separateconds

Each plotting function expects, one timecourse data_object, which is created as below.  The file in quotes is the test data set.

	data_obj <- read.timecourse.rowformat('./test/roi_data_1.txt')

Note: at current read.timecourse.* takes one data format, matching the format found in './test/roi\_data\_1.txt'.  This may change, if needed.

They also expect one score_object, created using one of the score.timecourse.* functions. The * represents:

1. peak - the max value
2. mean - the mean value
3. var - the variance
4. absdiff - the absolute difference between the range value
5. lag - time to max value
6. halfmax - time to half the maximum (larger values imply steeper slopes)


For example, if you wanted to score using the peak height, this would work:

	score_obj <- score.timecourse.peak(data_obj, score_obj)

If you have other scores in mind, ones not listed above, do share them....

If there are too many ROIs, so you want to drop some rows from data\_obj and score\_obj after scoring, run

	criterion <- 0.1
	keepers <- keep.timecourse(data_obj, score_obj, criterion)

Where criterion is between 0-1 (inclusive) and represents the top fraction of scores to keep, e.g. 0.1 would keep the top 10%.  However as R only allows one return variable, e.g. 'keepers', so we return a list.  We need to split it up.  This is awkward, sorry.

	kept_data_obj <- keepers[[1]]
	kept_score_obj <- keepers[[2]]
	
So to then plot our (optionally) filtered data, we:

	plot.timecourse.combinedconds(data_obj, score_obj)
	
Which produces, for example, 'combined_time.pdf'; see ./test
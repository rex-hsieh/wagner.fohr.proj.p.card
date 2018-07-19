# NYU Wagner, FOHR: P-Card Reporting System

A working project for a (fairly) automated reporting system, done for NYU Wagner, FOHR department. The project is done entirely in R.

Some instructions on how to use the "program" as follows (followed, first, by installation of R and other ancillary items):

* Download R [here](https://cran.r-project.org/). Choose the one for your operating system.
* My favourite IDE for R is [RStudio](https://www.rstudio.com/) (linked to the official website). It is *far* simpler to use compared to the native interpreter in R, and it suffices for our purposes. The decision on using RStudio vs other more versatile IDEs (that can simultaneously process commands in other languages, such as C++, Python, LaTeX, and so on) is completely yours.
* For instance, one could also use [Eclipse](http://www.eclipse.org/) in conjunction with R; the choice is up to you. To use Eclipse, one must download Java Runtime Environment (JRE), install Eclipse, then R. From within Eclipse, install the Statet plugin. From within R, install packages rj and rj.gd from Walhbrink’s site. Launch Eclipse and configure for use with R and LaTeX (the latter is completely optional; I personally would use it in conjunction with PostScript files from the program).

1. Download the .r scripts into a folder of your choice. Note the directory of this folder, as all the work will need to be done in this folder.
2. Initialise the process by correcting the *working directory*: write setwd("*the directory from step 1*"). This tells R where to write.
3. Make sure you create **four** folders in your working directory, named **exactly** like the following: "acct_dept_expenses", "months_aggr", "yoy_comp", and "ytd_comp".
4. Rename your data sets if necessary (as you see fit): by default, they are set to "cta_card_data", "p_card_data", "p_card_historical". CTA card historical omitted; *mutatis mutandis*, such a report can be altered by changing specific command in the program.

Now, here are descriptions of each script:
1. "monthly_summary.r": outputs graphs and .csv tables for the designated month's transactions data. Files are saved to "/acct_dept_expenses".
2. "ytd_summary.r": outputs graph and .csv table for year-to-date summary (up to designated month). Files are saved to "/ytd_comp".
3. "yoy_summary.r": outputs graph and .csv table for year-on-year summary (up to designated month). Files are saved to "/yoy_comp".
4. "monthly_aggr_summary.r": outputs graphs for monthly transactions since previous fiscal year (up to designated month). Files are saved to "/months_aggr".


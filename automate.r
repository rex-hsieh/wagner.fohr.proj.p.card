library(tictoc)
tic("The Automation")

source("monthly_summary.r")
rm(list=ls())
source("monthly_summary_cta.r")
rm(list=ls())


source("yoy_summary.r")
rm(list=ls())
source("yoy_summary_cta.r")
rm(list=ls())

source("ytd_summary.r")
rm(list=ls())
source("ytd_summary_cta.r")
rm(list=ls())

source("monthly_aggr_summary.r")
rm(list=ls())
source("monthly_aggr_summary_cta.r")
rm(list=ls())

toc()


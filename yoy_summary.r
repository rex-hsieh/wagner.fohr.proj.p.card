## Testing the time required by the code below--- install.packages("tictoc") if necessary
library(tictoc)

tic("everything runtime")

tic("preliminary setup")

rm(list=ls())
setwd("C:/Users/mhh357/Desktop/P card reporting project")
# copy and paste the following command to the console: install.packages("readr")
# setwd("~/Documents/Random R/p card")
library(readr)
data <- read.csv("p_card_historical.csv")
data$FIN.TRANSACTION.AMOUNT <- parse_number(data$FIN.TRANSACTION.AMOUNT)
data$ACC.LAST.NAME <- as.character(data$ACC.LAST.NAME)
data$FIN.POSTING.DATE <- as.Date(data$FIN.POSTING.DATE, format = "%m/%d/%Y")
data$FIN.TRANSACTION.DATE <- as.Date(data$FIN.TRANSACTION.DATE, format = "%m/%d/%Y")

toc()

tic("data transformations")
# test drive
data_may_18 <- subset(data, data$FIN.POSTING.DATE >= as.Date('2018-05-01') &
                      data$FIN.POSTING.DATE <= as.Date('2018-05-31'))  ## SUCCESS!!
sum_by_people_18 <- c()
( lnames <- c(unique(data_may_18$ACC.LAST.NAME)) )
for (x in lnames){
  new_data <- subset(data_may_18, data_may_18$ACC.LAST.NAME == x)
  new_sum <- new_data$FIN.TRANSACTION.AMOUNT
  sum_by_people_18[x] <- new_sum
}
(sum_by_people_18 <- as.data.frame(sum_by_people_18))


data_may_17 <- subset(data, data$FIN.POSTING.DATE >= as.Date('2017-05-01') &
                        data$FIN.POSTING.DATE <= as.Date('2017-05-31'))  ## SUCCESS!!
sum_by_people_17 <- c()
( lnames <- c(unique(data_may_17$ACC.LAST.NAME)) )
for (x in lnames){
  new_data <- subset(data_may_17, data_may_17$ACC.LAST.NAME == x)
  new_sum <- new_data$FIN.TRANSACTION.AMOUNT
  sum_by_people_17[x] <- new_sum
}
(sum_by_people_17 <- as.data.frame(sum_by_people_17))

toc("")

tic("final transformations and output")

together <- data.frame(FY18 = numeric(), FY17 = numeric())
together_names <- c( c(data_may_18$ACC.LAST.NAME), c(data_may_17$ACC.LAST.NAME) )
(unique_together_names <- unique(together_names))

for (x in unique_together_names){
  
  if (any(rownames(sum_by_people_18) == x)){
    lnames_sum_18 <- sum_by_people_18[x,]
  } else {
    lnames_sum_18 <- 0
  }
  
  if (any(rownames(sum_by_people_17) == x)) {
    lnames_sum_17 <- sum_by_people_17[x,]
  } else {
    lnames_sum_17 <- 0
  }
  
  together[x,] <- c(lnames_sum_18,lnames_sum_17)
}

png("yoy_comp/YoY_comparisons.png", width = 800, height = 600, units = 'px', res=110)
op <- par(mar=c(9,4,4,2)) 
ylim <- c(0, 1.2*max( max(together$FY18),max(together$FY17) ))
yoy_comparisons_plot <- barplot(t(together),names.arg = row.names(together),
                                horiz = FALSE,las=2, ylim = ylim, main = "YoY Comparisons for P-Cards in May",
                                col=c("light blue","yellow"), beside = TRUE, legend = colnames(together))
rm(op)
# text(x = yoy_comparisons_plot, y = rbind((together$FY18), (together$FY17)), 
#     srt = 25, label = rbind(t(together$FY18), t(together$FY17)), pos = 3, cex = 0.8, col = "blue")
dev.off()

write.csv(together, file = "yoy_comp/YoY_comparisons_tables.csv")

toc()

toc()
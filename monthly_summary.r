tic("Everything")

rm(list=ls())
setwd("C:/Users/mhh357/Desktop/P card reporting project")
# copy and paste the following command to the console: install.packages("readr")
# setwd("~/Documents/Random R/p card")
library(readr)
data <- read.csv("p_card_data.csv")
data$FIN.TRANSACTION.AMOUNT <- parse_number(data$FIN.TRANSACTION.AMOUNT)
data$ACC.LAST.NAME <- as.character(data$ACC.LAST.NAME)
(tot_sum <- sum(data$FIN.TRANSACTION.AMOUNT, na.rm = TRUE))

lnames <- unique(data$ACC.LAST.NAME)
(lnames <- as.character(lnames))
spending <- vector("list", length = length(lnames))

# Total spending by unique last names (P-card data for now)--------
net_sum = data.frame(cbind("ln" = lnames, "final" = spending))
# (netsum <- net_sum[data$lnames == as.character(lnames[1])] )
final_sum <- c()
for (x in lnames){
  new_data <- subset(data, data$ACC.LAST.NAME == x)
  new_sum <- sum(new_data$FIN.TRANSACTION.AMOUNT)
  final_sum[x] <- new_sum
}

(net_sum <- data.frame(sort(final_sum, decreasing = TRUE) ) )
(colnames(net_sum) <- c("Total"))
(net_sum$"% of Total" <- paste(round( (net_sum$Total / tot_sum) * 100, digits = 2), "%", sep ="") )

png("acct_dept_expenses/last_names_net_sum_plot.png", width = 800, height = 600, units = 'px', res=110)
op <- par(mar=c(6,4,3,2)) 
ylim <- c(0, 1.2*max(net_sum$Total))
op <- par(mar=c(9,4,4,2)) 
net_sum_last_name_plot <- barplot(net_sum$Total,names.arg = row.names(net_sum),
                             horiz = FALSE,las=2,main = "P-Card Spending by Cardholder",
                             ylim=ylim, col="light blue")
rm(op)
text(x = net_sum_last_name_plot, y = net_sum$Total,
     label = net_sum$Total, pos = 3,
     srt = 30, cex = 0.8, col = "blue")
dev.off()


# Total spending by unique account codes----
data$FIN.ACCOUNTING.CODE.02.VALUE <- as.character(data$FIN.ACCOUNTING.CODE.02.VALUE)
(acct_codes <- unique(na.omit(data$FIN.ACCOUNTING.CODE.02.VALUE)) )
final_sum_acct_codes <- c()
for (x in acct_codes){
  new_data <- subset(data, data$FIN.ACCOUNTING.CODE.02.VALUE == x)
  new_sum <- sum(new_data$FIN.TRANSACTION.AMOUNT)
  final_sum_acct_codes[x] <- new_sum
}
(net_sum_acct_codes <- data.frame(final_sum_acct_codes) )
(net_sum_acct_codes <- data.frame(sort(final_sum_acct_codes, decreasing = TRUE) ) )
(colnames(net_sum_acct_codes) <- c("Total"))

png("acct_dept_expenses/acct_codes_net_sum_plot.png", width = 800, height = 600, units = 'px', res=110)
op <- par(mar=c(6,4,3,2)) 
ylim <- c(0, 1.2*max(net_sum_acct_codes$Total))
net_sum_acct_plot <- barplot(net_sum_acct_codes$Total,names.arg = row.names(net_sum_acct_codes), 
        horiz = FALSE,las=2,main = "P-Card Spending by Account Codes",
        ylim = ylim, col="light blue") # Data labels, $ amounts
rm(op)
text(x = net_sum_acct_plot, y = net_sum_acct_codes$Total,
     label = net_sum_acct_codes$Total, pos = 3,
     srt = 30, cex = 0.8, col = "blue")
dev.off()

# Now, by counts of unique account codes----
(net_counts_acct_codes <- table(data$FIN.ACCOUNTING.CODE.02.VALUE))
(net_counts_acct_codes <- as.data.frame(net_counts_acct_codes))
(row.names(net_counts_acct_codes) <- net_counts_acct_codes$Var1)
(net_counts_acct_codes <- subset(net_counts_acct_codes, select = Freq))

final_counts_acct_codes <- c()
for(x in row.names(net_counts_acct_codes)){
  final_counts_acct_codes[x] = net_counts_acct_codes[x,]
}
( final_counts_acct_codes <- data.frame(sort(final_counts_acct_codes, decreasing = TRUE)) )

(colnames(final_counts_acct_codes) <- c("Frequency") )

png("acct_dept_expenses/acct_codes_counts_plot.png", width = 800, height = 600, units = 'px', res=110)
op <- par(mar=c(6,4,4,2)) 
ylim <- c(0, 1.2*max(final_counts_acct_codes$Frequency))
acct_codes_counts_plot <- barplot(final_counts_acct_codes$Frequency, names.arg = row.names(net_counts_acct_codes),
        horiz = FALSE,las=2,main = "P-Card Counts by Account Codes",
        ylim = ylim, col="light blue")
rm(op)
text(x = acct_codes_counts_plot, y = final_counts_acct_codes$Frequency,
     label = final_counts_acct_codes$Frequency, pos = 3, cex = 0.8, col = "blue")
dev.off()

# Big account codes table----

acct_codes_table <- data.frame(Final.Count = numeric(), Final.Sum= numeric() )
for(x in acct_codes){
  final_count <- final_counts_acct_codes[x,]
  final_sum <- net_sum_acct_codes[x,]
  acct_codes_table[x,] <- c(final_count,final_sum)
}
(acct_codes_table <- as.data.frame(acct_codes_table) )
write.csv(acct_codes_table, file = "acct_dept_expenses/acct_codes_count_sum_table.csv")

# By department codes----
(net_counts_dept_codes <- table(data$FIN.ACCOUNTING.CODE.04.VALUE))
(net_counts_dept_codes <- as.data.frame(net_counts_dept_codes))
(row.names(net_counts_dept_codes) <- net_counts_dept_codes$Var1)
(net_counts_dept_codes <- subset(net_counts_dept_codes, select = Freq))

final_counts_dept_codes <- c()
for(x in row.names(net_counts_dept_codes)){
  final_counts_dept_codes[x] = net_counts_dept_codes[x,]
}
(final_counts_dept_codes <- data.frame(sort(final_counts_dept_codes, decreasing = TRUE)) )
(colnames(final_counts_dept_codes) <- c("Frequency") )
write.csv(final_counts_dept_codes, file = "acct_dept_expenses/dept_codes_count_table.csv")

png("acct_dept_expenses/dept_codes_counts_plot.png", width = 800, height = 600, units = 'px', res=110)
op <- par(mar=c(6,4,4,2)) 
ylim <- c(0, 1.2*max(final_counts_dept_codes$Frequency))
dept_codes_plot <- barplot(final_counts_dept_codes$Frequency, names.arg = row.names(final_counts_dept_codes),
        horiz = FALSE,las=2, ylim = ylim, main = "P-Card Counts by Department",
        col="light blue")
rm(op)
text(x = dept_codes_plot, y = final_counts_dept_codes$Frequency,
     label = final_counts_dept_codes$Frequency, pos = 3, cex = 0.8, col = "blue")
dev.off()

toc()
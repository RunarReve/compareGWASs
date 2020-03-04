#Simple manhattan plot with lables to top SNPs 
#Will output a png plot 

#'qqman' package needs to be installed
#(install.packages("qqman")
library(qqman)

#Able to read given arguments
#args[1]:Title name for the plot
args <- commandArgs(trailing = TRUE)
if (is.na(args[1]) ){
  "you forgot it"
}

"DONE"

q()
location <- "temp/DEL"

location

#Tell R that output should be .png 
png(paste(location, ".png", sep=""), width = 900 , height = 900,  res = 90)

#Load in the table to
#theTable <- read.table(location, header = TRUE, sep = '\t') 
theTable <- read.table(location, header = TRUE) 
head(theTable[, 1 , drop=FALSE], 5)
#Plot the table into (X=Chromosone possition, Y=log P value)
#manhattan(theTable, annotatePval = 0.01, main = title,highlight = highli, ylim = c(0, y))
#manhattan(theTable, annotatePval = 0.01, main = title, ylim = c(0, y))

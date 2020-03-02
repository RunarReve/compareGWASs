#Simple manhattan plot with lables to top SNPs 
#Will output a png plot 

#'qqman' package needs to be installed
#(install.packages("qqman")
library(qqman)

#Able to read given arguments
#args[1]:Title name for the plot
args <- commandArgs(trailing = TRUE)

title <- args[1]
location <- args[2]
loclist <- args[4]  #The location of the SNP list of what we want to highlight

listOfSNPs <- read.csv(loclist, sep='\n', header = FALSE)

highli <- as.character(listOfSNPs$V1)



#Tell R that output should be .png 
png(paste(location, ".png", sep=""), width = 900 , height = 900,  res = 90)

#Setting the y so no error of exeeding the ylim
y <-round(-log10(as.double(args[3]))) + 1

#Load in the table to
theTable <- read.table(location, header = TRUE, sep = '\t') 

#Plot the table into (X=Chromosone possition, Y=log P value)
manhattan(theTable, annotatePval = 0.01, main = title,highlight = highli, ylim = c(0, y))
#manhattan(theTable, annotatePval = 0.01, main = title,highlight = "rs2743922", ylim = c(0, y))

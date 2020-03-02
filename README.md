# compareGWASs
Attempt to try to compare two or more assow GWAS files

Methods this directory is going to try to execute:
   Merge Pheno files and run GWAS with them
   Top N variants compare
   All variants under P
   Merge assoc based on P value (high/avr/low)


mergegwas.py
   Program to take in two or more .assoc files from GWAS made by Plink
   mergegwas.py has 3 merge settings: high, avr, low
   will take the wanted P value for each node
   NB. only focuses on P value 
   
mergegwas.sh
   Is to automatically run merge with all settings
   Also makes manhattan plots of new assoc files
     with manPlot.r 

manPlot.r
   R script that makes manhattan plot from a assoc file 


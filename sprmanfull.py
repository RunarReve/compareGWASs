#!/usr/bin/env/python
#Takes in two GWASs and outputs the spearman correlation between them
#Both GWASs has to be in the same format
#argv[1] list 1
#argv[2] list 2
#argv[3] column to run spearman on
import sys
from scipy import stats

def main():
   #Check for inputs is correct 
   if (len(sys.argv) <= 3):
      print("Please give input:")
      print("List1, List2, and Column of value to compare")
      sys.exit()
   col=int(sys.argv[3])
   

   #Load into array
   head = 0
   G1 = []
   for line in open(sys.argv[1], 'r'):
      sline = line.split()
      if head == 0:
         head = 1
         continue
      G1.append(float(sline[col]))
   
   head = 0
   G2 = []
   for line in open(sys.argv[2], 'r'):
      sline = line.split()
      if head == 0:
         head =1 
         continue
      G2.append(float(sline[col]))

   corr = stats.spearmanr(G1, G2)
   print(corr)

   #Output file
   sG1 = sys.argv[1].split('/')[-1].split('.')[0]
   out = "sprmanfull/" + sG1 + ".corr"
   sG2 = sys.argv[2].split('/')[-1].split('.')[0]
   print(sys.argv[2] + ' ' + sG2)

   outfile = open(out, 'a')
   outfile.write(sG1 + '_' + sG2 + '\tcorrelation: ' + str(corr[0])  + '\tPval: ' + str(corr[1])+ '\n')      
   print(sG1 + '_' + sG2 + '\tcorrelation: ' + str(corr[0])  + '\tPval: ' + str(corr[1])+ '\n')

if __name__ == "__main__":
   main()

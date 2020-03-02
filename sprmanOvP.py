#!/usr/bin/env/python
#Takes in two GWASs and outputs the spearman correlation between them
#Both GWASs has to be in the same format
#argv[1] assoc file 1
#argv[2] assoc file 2 
#argv[3] column to run spearman on
#argv[4] P val to filter by
import sys
from scipy import stats

def main():
   if(len(sys.argv) <= 4):
      print("Please give input:")
      print("List1, List2, Column of value to compare, and exponent P-value")
      sys.exit()
   if(sys.argv[1] == sys.argv[2]):#Check if ICDs are the same
      outPrint(1,0,0,0,1)
      sys.exit()
  
   col = int(sys.argv[3])
   P = float(('9.9999e-' + sys.argv[4])) #Convert to real P value

   #Load into array
   head = 0
   G1 = []
   G1C = 0 #counting the amount of var over P 
   for line in open(sys.argv[1], 'r'):
      sline = line.split()
      if head == 0:
         head = 1
         continue
      x = float(sline[col])
      if (x > P):
         x = 0
      else:
         G1C += 1 
      G1.append([sline[1], x])

   head = 0
   G2 = []
   G2C = 0
   for line in open(sys.argv[2], 'r'):
      sline = line.split()
      if head == 0:
         head = 1
         continue
      x = float(sline[8])
      if (x > P):
         x = 0;
      else:
         G2C += 1 
      G2.append([sline[1], x])

   if(G1C == 0 or G2C == 0): #If one of the diseases do not have any variants over P...
      outPrint(0,0,G1C+G2C,0,0) #...print as no simmilarity...
      sys.exit() # .. then quit

   G1N = []
   G2N = []
   overlap=0
   #Filter out all vars where both are set to 0 
   for i in range(0, len(G1)):
      if(G1[i][1] != 0 or G2[i][1] != 0):
         G1N.append(G1[i][1])
         G2N.append(G2[i][1])
         if(G1[i][1] != 0 and G2[i][1] != 0):
            overlap += 1 #count where both are over P

   jaccard = overlap/len(G1N)  
   corr = stats.spearmanr(G1N, G2N)
   outPrint(corr[0], corr[1], len(G1N), overlap, jaccard)

def outPrint(corr, Pv, lengt,  overlap, jac):
   sG1 = sys.argv[1].split('/')[-1].split('.')[0]
   sG2 = sys.argv[2].split('/')[-1].split('.')[0] 
   out = "sprmanOvP/"+sys.argv[4] + '/' + sG1
   outfile = open(out, 'a')
   out = sG1+'_'+sG2+' Corr: '+str(corr)+' P: '+str(Pv)+' overlap: '+str(overlap)+' numb: '+str(lengt)+' jaccard: '+str(jac)+'\n'
   #outfile.write(sG1+'_'+sG2+'\tCorr: '+str(corr)+'\tP: '+str(Pv)+'\toverlap:\t'+overlap + 'numb:\t'+str(lengt)+'\tjaccard: \t'+jacc+'\n')      
   outfile.write(out)      
   print(out)      

if __name__ == "__main__":
   main()

#!/usr/bin/env/python
#Takes in two GWASs and outputs the spearman correlation between them
#Both GWASs has to be in the same format
#argv[1] assoc file 1
#argv[2] assoc file 2 
#argv[3] column to run spearman on
#argv[4] N top variant extracted 
import sys
from scipy import stats

def main():
   if(len(sys.argv) <= 3):
      print("Please give input:")
      print("List1, List2, and column of value to compare")
      sys.exit()
   if(sys.argv[1] == sys.argv[2]):#Check if ICDs are the same
      outPrint(1,0,0,0,1)
      sys.exit()
   N   = int(sys.argv[4])*2
   col = int(sys.argv[3])

   #Load into array
   G1 = []
   for line in open(sys.argv[1], 'r'):
      sline = line.split()
      G1.append( float(sline[col]))

   G2 = []
   for line in open(sys.argv[2], 'r'):
      sline = line.split()
      G2.append(float(sline[col]))

   jaccard = (N-len(G1))/N  
   corr = stats.spearmanr(G1, G2)
   outPrint(corr[0], corr[1], N, (N-len(G1)), jaccard)


def outPrint(corr, Pv, lengt,  overlap, jac):
   sG1 = sys.argv[1].split('/')[-1].split('.')[0]
   sG2 = sys.argv[2].split('/')[-1].split('.')[0] 
   out = "sprmanTopN/"+sys.argv[4] + '/' + sG1
   outfile = open(out, 'a')
   out = sG1+'_'+sG2+' Corr: '+str(corr)+' P: '+str(Pv)+' overlap: '+str(overlap)+' numb: '+str(lengt)+' jaccard: '+str(jac)+'\n'
   outfile.write(out)      
   print(out)      

if __name__ == "__main__":
   main()

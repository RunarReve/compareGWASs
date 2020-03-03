#!/usr/bin/env/python 
#Program that takes in a list of GWAS to merge
#Merging styleof p-val:avrage, lowest, highest (standard: lowest)
#argv[1] = output
#argv[2] = merging type
#argv[3=<] = list of merging GWASs 
import sys
import os.path
import time 

short="_--geno_0.1_--maf_0.01"
SNP= 640100

def main():
   if (len(sys.argv) < 3):
      sys.exit()
   table =[[] for _ in range(SNP)]
   ID = sys.argv[3]
   infile = open(ID , 'r')
   for line in infile: #First GWAS
      sline = line.split()
      if sline[0] == 'CHR': #Header
         continue 
      insert(table, line, ID)
 
   #Loop through the rest of the GWAS
   for i in range(4, len(sys.argv)):
      ID = sys.argv[i]
      if (os.path.exists(ID))==False:
         print("File: "+ID+" does not exist")
         continue
      infile = open(ID, 'r')
      print (sys.argv[i] + ' ' + str(i-1) + ' out of ' + str(len(sys.argv)-2))
      for line in infile:
         sline = line.split()
         if sline[0] == 'CHR':
            continue
         merge(table, line, ID)
      infile.close()

   #Loop through one last time to extract in the same format              
   infile  = open(ID, 'r')
   outfile = open(sys.argv[1],'w')
   outlog  = open(sys.argv[1]+".log",'w')
   for line in infile:
      sline = line.split()
      if sline[0] == 'CHR':
         outfile.write("\t".join(sline) + '\tInflue_HPO \tInflu_P' +  '\n') 
         continue
      oline = extract(table, line)
      outfile.write(oline + '\n')
      soline = oline.split()
      outlog.write(soline[1] + "\t" + soline[-2] + "\t" + soline[-1] + "\n")


#----FUNC----
def operator(val1, val2):
   if sys.argv[2] == 'high':
      if val1 > val2 : return val1  
      else: return val2
   if sys.argv[2] == 'low':    
      if val1 > val2 : return val2   
      else: return val1  
   if sys.argv[2] == 'avr':
      return val1+val2

#----HASH----
def insert(table, line, HPO):
   sline = line.split()
   key = hash_fun(int(sline[2]))
   sline.append(HPO)
   sline.append(sline[8])
   table[key].append((sline))
   #print(str(table[key][-2]) +" " +  str(table[key][-1]))

def merge(table, line, HPO):
   sline = line.split()
   key = hash_fun(sline[2])
   hashlist = table[key]
   for i in range(len(hashlist)): #Loop through everything at that key
      if hashlist[i][2] == sline[2]:  #If the location match 
         if hashlist[i][0] == sline[0]: #If the chromosone match
            #table[key][i][8] = str(operator(float(sline[8]), float(table[key][i][8])))
            temp = float(table[key][i][8])
            table[key][i][8] = str(operator(float(sline[8]),temp))

            #Now check if the most affected HPO has to be changed for this SNP
            if sys.argv[2] == 'avr':
               if float(table[key][i][-1]) >  float(sline[8]):
                  table[key][i][-2] = HPO
                  table[key][i][-1] = sline[8]
            elif float(table[key][i][8]) != temp: #Change the most affective SNP, if changed
               table[key][i][-2] = HPO
               table[key][i][-1] = sline[8]
           

def extract(table, line):
   sline = line.split()
   key = hash_fun(sline[2])
   hashlist = table[key]
   for each in hashlist: #Loop through the linked list 
      if each[2] == sline[2]: #Check that location is the same
         if each[0] == sline[0]: #Check if its the same chromosone 
            if sys.argv[2] == 'avr':
               numPuts = len(sys.argv) - 3
               each[8] = str(float(each[8])/numPuts)
            return "\t".join(each)
   return 2


def hash_fun(x):
   return int(x)%SNP


if __name__ == "__main__":
   main()

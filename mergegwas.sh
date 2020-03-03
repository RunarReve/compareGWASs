#!/bin/bash
#Script to take in a ICD code, extract HPO for that ICD, and then merge these together
#For now it will merge HPO with highest, lowest, and some sort of avarege P value
#argv[1]   output
#argv[2++] the files to all we want to merge 

#TODO func
manhat(){
	echo "---${1}---"
        sort -k3 -g ${1}.log > ${1}.loga
	mv ${1}.loga ${1}.log

 	lowestPVal=$(awk '{if(m== nulll || m > $9 && $9 != 0) {m = $9}} END{print m}' $1)
	echo "${lowestPVal}"
	typeTitle="MergedHPO"

 	hi=$(cat $1 | sort -k9 -g | head -2 | tail -1 | awk '{print $11}'| sed -e 's/\// /g' | awk '{print $NF}'  | sed -e 's/\./ /g' | awk '{print $1}')
	echo "${hi}"
	grep "${hi}" ${1} | awk '{print $2}' > ${1}.list
	
 	#Rscript manPlot.r "${typeTitle}_AVR:${1}      Highest affect child: ${hi}" ${1} ${lowestPVal} ${1}.list
}

list=""
for each in "$@"; do
   if [ "${each}" == "${1}" ]; then
      continue
   fi
   list="${list} ${each}"
done

#AVR setting 
python mergegwas.py ${1}av  avr  ${list}
manhat ${1}av 

#HIGH setting
python mergegwas.py ${1}hi high ${list}
manhat ${1}hi

#LOW setting
python mergegwas.py ${1}lo  low  ${list}
manhat ${1}lo


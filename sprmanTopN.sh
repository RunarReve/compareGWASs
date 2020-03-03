#!/bin/bash 
#script that will extract top N for two assoc files and then run spearman correlation between them
#argv[1] file 1
#argv[2] file 2 
#argv[3] column of value to test
#argv[4] N amount of variants to extract 

mkdir -p sprmanTopN/${4}

#Get top N for each assoc
N1=$(expr $4 + 1)
col=$(expr $3 + 1)
cat $1 | sort -k${col} -g | head -${N1} | tail -${4} > ${1}.temp
cat $2 | sort -k${col} -g | head -${N1} | tail -${4} > ${2}.temp

#Fill out empties TODO set $9 to $col
cat ${2}.temp | awk '{$9=0; print $0}' >> ${1}.temp
cat ${1}.temp | awk '{$9=0; print $0}' >> ${2}.temp

#Reformat, make tab seperated
cat ${1}.temp|awk '{$1=$1; print $0}'|sed -e 's/ /\t/g'|sort -k1,1 -k3,3 -k${col},${col}r |awk '!seen[$2]++'>${1}.t
cat ${2}.temp|awk '{$1=$1; print $0}'|sed -e 's/ /\t/g'|sort -k1,1 -k3,3 -k${col},${col}r |awk '!seen[$2]++'> ${2}.t
rm ${1}.temp ${2}.temp

#Run correlation
python sprmanTopN.py ${1}.t ${2}.t $3 $4
rm ${1}.t ${2}.t


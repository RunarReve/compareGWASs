#!/bin/sh
#Scripts that runs all the comparisons with given inputs
#argv[1] main comparison to
#argv[2+] files to merge and compare to $1 

child=""
for each in "$@"; do
   if [ "${each}" == "${1}" ]; then  
      continue
   fi
   child="${child} ${each}"
done
echo "${child}"

#./mergegwas.sh ${1}.me ${child}

for i in av hi lo; do
   python sprmanfull.py ${1} ${1}.me${i} 8
   python sprmanfull.py ${1} ${1}.me${i} 8 5
done 

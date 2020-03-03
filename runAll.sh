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

out=$(echo "${1}" | sed -e 's/\./ /g' | awk '{print $1}')
echo "${out}"
./mergegwas.sh ${out}merg ${child}

for i in av hi lo; do
   python sprmanfull.py ${1} ${out}merg${i} 8
   python sprmanOvP.py  ${1} ${out}merg${i} 8 5
   ./sprmanTopN.sh      ${1} ${out}merg${i} 8 100
   exit
done 

#!/bin/sh
#Script that will make phenofile for "siblings"
#Cases will be the given file, and siblings will be cases 
#argv[1] output to compare it to 
#argv[2++] phenofiles to merge

bfile="/encrypted/e3001/maxat/alldata"
plinkSet="--geno 0.1 --maf 0.01"

out="${1}fek"
rm -f ${out}phe
for each in "$@"  
do
   if [ "${each}" == "${1}" ] ; then 
      continue 
   fi

   echo "${each}" 
   cat ${each} | awk '{if($3 == "2"){print $1}}' | wc -l
   cat ${each} | awk '{if($3 == 2){print $0}}' >> ${out}phe
done
cat ${2} | awk '{if($3 != 2){print $0}}' >> ${out}phe

#Remove duplicates
sort -k1,1 -k3rn,3 ${out}phe | awk '!seen[$1]++' > ${out}pheooO
mv ${out}pheooO ${out}phe

#TODO echo 


cat ${out}phe | awk '{if($3 == "2"){print $1}}' | wc -l

#Run Plink, make sure plink is installed
#plink --bfile ${bfile} --assoc counts ${plinkSet} --pheno ${out}phe --out ${out}
echo " "
echo " " 
#Run comparison between them
python sprmanfull.py ${1} ${out}.assoc 8
python sprmanOvP.py  ${1} ${out}.assoc 8 5 
./sprmanTopN.sh      ${1} ${out}.assoc 8 100

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

cat ${out}phe | awk '{if($3 == "2"){print $1}}' | wc -l

#Run Plink, make sure plink is installed
plink --bfile ${bfile} --assoc counts ${plinkSet} --pheno ${out}phe --out ${out}

echo " "
echo " " 
#Run comparison between them
#python sprmanfull.py ${1} ${out}.assoc 8
#python sprmanOvP.py  ${1} ${out}.assoc 8 5 
#./sprmanTopN.sh      ${1} ${out}.assoc 8 100

#exit
#Make a manhattan plot
lowestPVal=$(awk '{if(m== nulll || m > $9 && $9 != 0) {m = $9}} END{print m}' $1)
echo "${lowestPVal}"
typeTitle="Remade GWAS with children"
hi=$(cat ${out}.assoc | sort -k9 -g | head -2 | tail -1 | awk '{print $11}'| sed -e 's/\// /g' | awk '{print $NF}'  | sed -e 's/\./ /g' | awk '{print $1}')
echo "${hi}"
grep "${hi}" ${out}.assoc | awk '{print $2}' > ${out}.list

Rscript manPlot.r "${typeTitle}:${out}      Highest affect child: ${hi}" ${out}.assoc ${lowestPVal} ${out}.list


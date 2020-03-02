#!/bin/sh
#Script that will make phenofile for "siblings"
#Cases will be the given file, and siblings will be cases 
#argv[1] output
#argv[2++] phenofiles to merge

out="${1}"
rm -f ${out}
for each in "$@"  
do
   if [ "${each}" == "${1}" ] ; then 
      continue 
   fi

   echo "${each}" 
   cat ${each} | awk '{if($3 == "2"){print $1}}' | wc -l
   cat ${each} | awk '{if($3 == 2){print $0}}' >> ${out}
   
done

cat ${2} | awk '{if($3 != 2){print $0}}' >> ${out}

#Remove duplicates
sort -k1,1 -k3rn,3 ${out} | awk '!seen[$1]++' > ${out}ooO
mv ${out}ooO ${out}

cat ${out} | awk '{if($3 == "2"){print $1}}' | wc -l

#./GOATSscript.sh "${OF}" --geno 0.1 --maf 0.01

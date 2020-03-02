#!/bin/sh
#Script to take in a ICD code, extract HPO for that ICD, and then merge these together
#For now it will merge HPO with highest, lowest, and some sort of avarege P value

echo "${1}"
check=$(grep "${1}" ../HPO2ICD | awk '{print $1}')
list=$(echo ${check} | sed -e 's/\n/ /g' | sed -e 's/0000001//g')

echo "${list}"

#Merge the HPO in list

python mergegwas.py ${1}"avr.assoc"  avr  ${list}
sort -k3 -g merged/${1}avr.assoc.log > merged/${1}avr.log
rm merged/${1}avr.assoc.log
python mergegwas.py ${1}"high.assoc" high ${list}
sort -k3 -g merged/${1}high.assoc.log > merged/${1}high.log
rm merged/${1}high.assoc.log
python mergegwas.py ${1}"low.assoc"  low  ${list}
sort -k3 -g merged/${1}low.assoc.log > merged/${1}low.log
rm merged/${1}low.assoc.log

#Make manhattan plots of the newly merged gwas
rscripts="/encrypted/e3001/runar/genome/plinkGeno/rScripts"
typeTitle="MergedHPO"

module load R

lowestPVal=$(awk '{if(m== nulll || m > $9 && $9 != 0) {m = $9}} END{print m}' merged/${1}avr.assoc)
echo "${lowestPVal}"
HPO=$(sort -k9 -g merged/${1}avr.assoc | head -2 | tail -1 | awk '{print $11}')
echo "${HPO}"
grep "${HPO}" merged/${1}avr.log | awk '{print $1}' > merged/${1}avr.list

Rscript ${rscripts}/manPlotPNGhigh.r "${typeTitle}_AVR:${1}      Highest affect HPO: ${HPO}" merged/${1}avr.assoc ${lowestPVal} merged/${1}avr.list


lowestPVal=$(awk '{if(m== nulll || m > $9 && $9 != 0) {m = $9}} END{print m}' merged/${1}high.assoc)
echo "${lowestPVal}"
HPO=$(sort -k9 -g merged/${1}high.assoc | head -2 | tail -1 | awk '{print $11}')
echo "${HPO}"
grep "${HPO}" merged/${1}high.log | awk '{print $1}' > merged/${1}high.list
Rscript ${rscripts}/manPlotPNGhigh.r "${typeTitle}_HIGH:${1}      Highest affect HPO: ${HPO}" merged/${1}high.assoc ${lowestPVal} merged/${1}high.list 


lowestPVal=$(awk '{if(m== nulll || m > $9 && $9 != 0) {m = $9}} END{print m}' merged/${1}low.assoc)
echo "${lowestPVal}"
HPO=$(sort -k9 -g merged/${1}low.assoc |head -2 | tail -1 | awk '{print $11}')
echo "${HPO}" 
grep "${HPO}" merged/${1}low.log | awk '{print $1}' > merged/${1}low.list
Rscript ${rscripts}/manPlotPNGhigh.r "${typeTitle}_LOW:${1}      Highest affect HPO: ${HPO}" merged/${1}low.assoc ${lowestPVal} merged/${1}low.list


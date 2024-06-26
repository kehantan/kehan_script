#!/bin/sh

# list of conformations within cutoff in each directory 
# currently set to 7 angstrom


set -e 


# write compound that is less than or equal to 7 angstrom from COM of important amino acid residues to new file 
for i in CHEMBL*
do
	cd $i
#	echo $(pwd)
	for j in {1..27}
	do 
		a=$(awk NR==$j distance | awk '{print $4}') 
		if [ $(bc <<< "$a <= 7.000") -eq 1 ]
		then
			awk NR==$j distance >> distance_le_7
		fi
	done
	cd ../
done

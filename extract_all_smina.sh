#!/bin/sh

# extract all smina rescore result 


for i in CHEMBL*
do 
	cd $i
	echo $(pwd)
	for j in {1..3}
	do 
		for k in {1..9}
		do 
			a=$(grep Affinity smina_rescore_v"$j"_ligand_"$k".txt | awk '{print $2}')
			echo "$i v"$j" "$k" $a" >> tmp-smina
		done
	done
done 

sort -k 4n tmp-smina >> smina
rm tmp-smina

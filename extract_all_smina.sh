#!/bin/sh

# extract all smina rescore result 


set -e 


for i in CHEMBL*
do
	cd "$i"
	echo $(pwd)
	for j in {1..3}
	do 
		for k in {1..9}
		do 
			a=$(grep "Affinity" smina_rescore_v"$j"_ligand_"$k".txt | awk '{print $2}')
			echo "$i v"$j" "$k" $a" >> tmp-smina
		done
	done
	sort -k 4n tmp-smina >> smina 
	rm tmp-smina
	cd ../
done 


for i in CHEMBL*
do 
	cat "$i"/smina >> tmp-smina_all
done 


sort -k 4n tmp-smina_all >> smina_all
rm tmp-smina_all

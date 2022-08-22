#!/bin/sh

# extract all vinardo scoring result 


set -e 


for i in CHEMBL*
do 
	cd $i
	echo $(pwd)
	for j in {1..3}
	do 
		for k in {1..9}
		do 
			a=$(grep " Binding " vinardo_rescore_v"$j"_ligand_"$k".txt | awk '{print $7}')
			echo "$i v"$j" "$k" $a" >> tmp-vinardo
		done
	done
	sort -k 4n tmp-vinardo >> vinardo
	rm tmp-vinardo
	cd ../
done 


for i in CHEMBL*
do 
	cat "$i"/vinardo >> tmp-vinardo_all
done 


# sort 
sort -k 4n tmp-vinardo_all >> vinardo_all
rm tmp-vinardo_all

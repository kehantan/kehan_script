#!/bin/sh

## extract all vina binding affinity
## then sort according to binding affinity

set -e 


for i in CHEMBL*
do 
	cd $i
	echo $(pwd)
	for j in {1..3}
	do
		for k in {1..9}
		do 
			a=$(sed -n 39,49p log_v"$j".txt | awk NR==$k | awk '{print $1,$2}')
			echo "$i v"$j" $a" >> tmp-vina
		done
	done
	sort -k 4n tmp-vina >> vina
	rm tmp-vina
	cd ../
done


for i in CHEMBL*
do 
	cat "$i"/vina >> tmp-vina_all
done 


# sort according to binding affinity 
sort -k 4n tmp-vina_all >> vina_all
rm tmp-vina_all

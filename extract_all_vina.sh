#!/bin/sh

## extract all vina binding affinity
## then sort according to binding affinity


for i in CHEMBL*
do 
	for j in{1..3}
	do
		for k in {1..9}
		do 
			echo "$i v"$j" $(sed -n 39,49p "$i"/log_v"$j".txt | awk NR==$k | awk '{print $1,$2}')" >> tmp-vina
		done
	done
done

sork -k 4n tmp-vina >> vina

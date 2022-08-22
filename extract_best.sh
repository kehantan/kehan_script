#!/bin/sh

# extract compound with best binding affinity among all 27 conformations (3 runs * 9 conformations)


set -e 


# vina
for i in CHEMBL*
do 
	head -n 1 "$i"/vina >> tmp-vina_best
done

sort -k 4n tmp-vina_best >> vina_best
rm tmp-vina_best


# vinardo
for i in CHEMBL*
do 
	head -n 1 "$i"/vinardo >> tmp-vinardo_best
done

sort -k 4n tmp-vinardo_best >> vinardo_best
rm tmp-vinardo_best


# smina
for i in CHEMBL*
do 
	head -n 1 "$i"/smina >> tmp-smina_best
done 

sort -k 4n tmp-smina_best >> smina_best
rm tmp-smina_best

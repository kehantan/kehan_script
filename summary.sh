#!/bin/sh

# make summary file including
# ChEMBL ID, run #, conformation, number of conformations in binding site/total conformations, percentage

set -e 

rm -rf sum-vina_best_in_binding_site_lipinski_le1
rm -rf sum-vinardo_best_in_binding_site_lipinski_le1
rm -rf sum-smina_best_in_binding_site_lipinski_le1

# vina
count1=$(cat vina_best_in_binding_site_lipinski_le1 | wc -l)

for i in `seq 1 "$count1"`
do 
	a=$(awk NR==$i vina_best_in_binding_site_lipinski_le1 | awk '{print $1}')
	b=$(awk NR==$i vina_best_in_binding_site_lipinski_le1)
	c=$(grep "$a" in_binding_site-ge60percent | awk '{print $2,$3}')
	echo "$b $c" >> sum-vina_best_in_binding_site_lipinski_le1
done


# vinardo
count2=$(cat vinardo_best_in_binding_site_lipinski_le1 | wc -l)

for i in `seq 1 "$count2"`
do 
	a=$(awk NR==$i vinardo_best_in_binding_site_lipinski_le1 | awk '{print $1}')
	b=$(awk NR==$i vinardo_best_in_binding_site_lipinski_le1)
	c=$(grep "$a" in_binding_site-ge60percent | awk '{print $2,$3}')
	echo "$b $c" >> sum-vinardo_best_in_binding_site_lipinski_le1
done


# smina
count3=$(cat smina_best_in_binding_site_lipinski_le1 | wc -l)

for i in `seq 1 "$count3"`
do 
	a=$(awk NR==$i smina_best_in_binding_site_lipinski_le1 | awk '{print $1}')
	b=$(awk NR==$i smina_best_in_binding_site_lipinski_le1)
	c=$(grep "$a" in_binding_site-ge60percent | awk '{print $2,$3}')
	echo "$b $c" >> sum-smina_best_in_binding_site_lipinski_le1
done

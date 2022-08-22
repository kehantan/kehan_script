#!/bin/sh

# summary of all scoring and percentage of conformations in binding site

# cross check flow
# best binding affinity > binding site > lipinski rule


set -e 

rm -rf best_in_binding_site_lipinski
rm -rf exist_in_all_vina_vinardo_smina_best_in_binding_site_lipinski_le1
rm -rf sum

cat vina_best_in_binding_site_lipinski_le1 >> best_in_binding_site_lipinski
cat vinardo_best_in_binding_site_lipinski_le1 >> best_in_binding_site_lipinski
cat smina_best_in_binding_site_lipinski_le1 >> best_in_binding_site_lipinski


# check if a compound can be found in all 3 scoring approach 
for i in {1..152}
do 
	a=$(awk NR==$i vina_best | awk '{print $1}')
	if [[ $(grep "$a" best_in_binding_site_lipinski | wc -l) -eq 3 ]]
	then
		echo "$a" >> exist_in_all_vina_vinardo_smina_best_in_binding_site_lipinski_le1
	fi
done


# make summary 
# binding affinity calculated by different scoring functions
# percentage of docked conformations that is located in binding site 
count=$(cat exist_in_all_vina_vinardo_smina_best_in_binding_site_lipinski_le1 | wc -l)
for i in `seq 1 "$count"`
do 
	chembl=$(awk NR==$i exist_in_all_vina_vinardo_smina_best_in_binding_site_lipinski_le1)
	vina=$(grep "$chembl" vina_best | awk '{print $2,$3,$4}')
	vinardo=$(grep "$chembl" vinardo_best | awk '{print $2,$3,$4}')
	smina=$(grep "$chembl" smina_best | awk '{print $2,$3,$4}')
	percent=$(grep "$chembl" in_binding_site-ge60percent | awk '{print $2,$3}')
	echo "$chembl $vina $vinardo $smina $percent" >> sum
done 

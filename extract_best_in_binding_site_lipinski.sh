#! /bin/sh


#set -e 


count=$(cat lipinski_le1 | wc -l)

rm -rf vina_best_in_binding_site_lipinski_le1
rm -rf vinardo_best_in_binding_site_lipinski_le1
rm -rf smina_best_in_binding_site_lipinski_le1

for i in `seq 2 "$count"`
do
	a=$(awk NR==$i lipinski_le1 | awk '{print $1}')
	grep "$a" vina_best_in_binding_site >> vina_best_in_binding_site_lipinski_le1
	grep "$a" vinardo_best_in_binding_site >> vinardo_best_in_binding_site_lipinski_le1
	grep "$a" smina_best_in_binding_site >> smina_best_in_binding_site_lipinski_le1
done 

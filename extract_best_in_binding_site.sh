#!/bin/sh

## extract from best, which is also in binding site
## work specifically with greater than or equal to 60 percent of in_binding_site


set -e 


count=$(cat in_binding_site-ge60percent | wc -l)

# smina
for i in `seq 1 "$count"`
do
	a=$(awk NR==$i in_binding_site-ge60percent |awk '{print $1}')
	grep "$a" smina_best >> tmp-smina_best_in_binding_site
done


# vina
for i in `seq 1 "$count"`
do
	a=$(awk NR==$i in_binding_site-ge60percent |awk '{print $1}')
	grep "$a" vina_best >> tmp-vina_best_in_binding_site
done


# vinardo
for i in `seq 1 "$count"`
do
	a=$(awk NR==$i in_binding_site-ge60percent |awk '{print $1}')
	grep "$a" vinardo_best >> tmp-vinardo_best_in_binding_site
done


# sorting 
sort -k 4n tmp-smina_best_in_binding_site >> smina_best_in_binding_site
rm tmp-smina_best_in_binding_site

sort -k 4n tmp-vina_best_in_binding_site >> vina_best_in_binding_site
rm tmp-vina_best_in_binding_site

sort -k 4n tmp-vinardo_best_in_binding_site >> vinardo_best_in_binding_site
rm tmp-vinardo_best_in_binding_site


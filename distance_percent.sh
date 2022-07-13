#!/bin/sh

# find how many conformation is in the binding site
# for all 27 conformations in 3 runs
# as percentage


set -e


# get percentage
for i in CHEMBL*
do
	a=$(cat "$i"/distance_le_7 | wc -l)
	percentage=$(echo "scale=4; "$a"/27*100" | bc)
	echo "$i "$a"/27 "$percentage"" >> tmp-in_binding_site
done


#sort
sort -k 3nr tmp-in_binding_site >> in_binding_site-percent
rm tmp-in_binding_site

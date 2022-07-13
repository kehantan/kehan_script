#!/bin/sh

# get distance between two points in 3d space


for i in CHEMBL*
do 
	cd $i
	echo $(pwd)
	for j in {1..3}
	do
		for k in {1..9}
		do 
			x1=24.213
			y1=-16.191
			z1=10.939
			a=$(python3 /home/$USER/protein-science/scripts-and-tools/center_of_mass/center_of_mass.py "$i"_v"$j"_ligand_"$k".pdb)
			x2=$(echo $a | sed -e 's/\[//' | sed -e 's/\]//' | sed -e 's/\,/ /g' | awk '{print $1}')
			y2=$(echo $a | sed -e 's/\[//' | sed -e 's/\]//' | sed -e 's/\,/ /g' | awk '{print $2}')
			z2=$(echo $a | sed -e 's/\[//' | sed -e 's/\]//' | sed -e 's/\,/ /g' | awk '{print $3}')
			x=$(echo "$x1- $x2" | bc)
			y=$(echo "$y1- $y2" | bc)
			z=$(echo "$z1- $z2" | bc)
			xs=$(echo "$x"*"$x" | bc)
			ys=$(echo "$y"*"$y" | bc)
			zs=$(echo "$z"*"$z" | bc)
			xyzs=$(echo "$xs"+"$ys"+"$zs" | bc)
			d=$(echo "sqrt($xyzs)" | bc)
			echo "$i v"$j" "$k" $d" >> distance
		done
	done
	cd ../
done

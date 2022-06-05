#!/bin/bash
set -e

echo "exhaustiveness?"
read ex
echo "docking type? (blind/bsite)"
read type
echo "scoring? (vina/vinardo)"
read score

for i in {1..5}
do
	mkdir v"$i"
	cp out_v"$i".pdbqt v"$i"
done

for i in {1..5}
do 
	cd v"$i"
	vina_split --input out_v"$i".pdbqt
	cd ../
done

for i in {1..5}
do 
	cd v"$i"
	for j in {1..9}
	do 
		/home/silverbot/miniconda3/bin/obabel -i pdbqt out_v"$i"_ligand_"$j".pdbqt -o pdb -O "$score"_e"$ex"_"$type"_v"$i"_out_"$j".pdb
	done
	cd ../
done

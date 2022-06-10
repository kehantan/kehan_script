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

for i in {1..5}
do
	for j in {1..9}
	do
		sed -i -e 's/ATOM  /HETATM/g' v"$i"/"$score"_e"$ex"_"$type"_v"$i"_out_"$j".pdb
		python3 /home/$USER/pdb-tools-2.4.1/pdbtools/pdb_uniqname.py v"$i"/"$score"_e"$ex"_"$type"_v"$i"_out_"$j".pdb >> v"$i"/UNK_v"$i"_"$j".pdb
	done
done

# ligplot
for i in {1..5}
do 
	for j in {1..9}
	do 
		mkdir -p v"$i"/"$j"_ligplot/
		cp ../AB_clean.pdb v"$i"/"$j"_ligplot/com.pdb
		grep " UNK " v"$i"/UNK_v"$i"_"$j".pdb >> v"$i"/"$j"_ligplot/com.pdb
	done
done

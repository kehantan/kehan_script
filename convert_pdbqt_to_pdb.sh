#! /bin/sh

echo "ligand name?"
read lig


# split into individual conformations 
for i in {1..3}
do 
	vina_split --input out_v"$i".pdbqt
done 


# convert pdbqt to pdb 
for i in {1..3}
do 
	for j in {1..9}
	do 
		obabel -i pdbqt out_v"$i"_ligand_"$j".pdbqt -o pdb -O "$lig"_v"$i"_ligand_"$j".pdb
	done
done

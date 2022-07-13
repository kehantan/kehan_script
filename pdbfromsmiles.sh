#!/bin/sh

# convert smi to pdb


a=$(cat smiles_list | wc -l)

for i in `seq 1 $a` 
do 
  filename=$(awk NR==$i smiles_list | awk '{print $1}')
  smiles=$(awk NR==$i smiles_list | awk '{print $2}')
  echo "$smiles" > "$filename".smi
  obabel -i smi "$filename".smi -o pdb -O tmp-"$filename"-pdb --gen3d
  obabel -i pdb tmp-"$filename"-pdb -o pdb -O tmp-"$filename"-pdb-h -h
  python3 /home/$USER/pdb-tools-2.4.1/pdbtools/pdb_uniqname.py tmp-"$filename"-pdb-h > tmp-"$filename"-pdb-h-renum.pdb
  sed -i -e 's/UNL     1/UNL X 999/g' tmp-"$filename"-pdb-h-renum.pdb
  obminimize -ff UFF -n 5000 tmp-"$filename"-pdb-h-renum.pdb > "$filename".pdb
  rm tmp-*
done

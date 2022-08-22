#!/bin/sh

# create index file for heavy atoms of ligand 
# create ligand restraints for gromacs 
# 


set -e 
source /opt/gromacs-2021.2/bin/GMXRC


# select atoms to apply restraint
rm -f UNL_posre_index_choices.txt
echo "0 & ! a H*" >> UNL_posre_index_choices.txt
echo "q" >> UNL_posre_index_choices.txt


# create ligand restraint index file
gmx make_ndx -f UNL_GMX.gro -o index_UNL.ndx < UNL_posre_index_choices.txt


# generate restraint topology for ligand
echo 3 | gmx genrestr -f UNL_GMX.gro -n index_UNL.ndx -o posre_UNL.itp -fc 1000 1000 1000

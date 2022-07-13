#!/bin/sh
set -e 

source /opt/gromacs-2021.2/bin/GMXRC

echo " "
echo "###  $(pwd)  ###"
echo " "

# choice to create lig restraint index file
rm -f UNL_posre_index_choices.txt
echo "0 & ! a H*" >> UNL_posre_index_choices.txt
echo "q" >> UNL_posre_index_choices.txt

# create lig restraint index file
gmx make_ndx -f UNL_GMX.gro -o index_UNL.ndx < UNL_posre_index_choices.txt
echo 3 | gmx genrestr -f UNL_GMX.gro -n index_UNL.ndx -o posre_UNL.itp -fc 1000 1000 1000

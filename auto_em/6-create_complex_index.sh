#!/bin/sh

# create protein-ligand index file in gromacs


set -e 
source /opt/gromacs-2024.1/bin/GMXRC


# create protein ligand index file
rm -f index.ndx
rm -f choices.txt
echo "1|13" >> choices.txt
echo "q" >> choices.txt
gmx make_ndx -f em_steep.gro -o index.ndx < choices.txt

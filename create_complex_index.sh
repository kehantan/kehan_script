#!/bin/sh
set -e 

source /opt/gromacs-2021.2/bin/GMXRC

echo " "
echo "###  $(pwd)  ###"
echo " "

# create pro-lig index file
rm -f index.ndx
rm -f choices.txt
echo "1|13" >> choices.txt
echo "q" >> choices.txt
gmx make_ndx -f em_steep.gro -o index.ndx < choices.txt

#!/bin/sh
set -e 

source /opt/gromacs-2021.2/bin/GMXRC

echo " "
echo "###  $(pwd)  ###"
echo " "

# insert ligand atomtypes and topology into topol.top
sed -i -e "/forcefield.itp/a \#include \"UNL_atomtypes.dat\"" topol.top
sed -i -e "/forcefield.itp/{G;}" topol.top
sed -i -e "/water topology/i \#include \"UNL_GMX.itp\"\n\#ifdef POSRES\n\#include \"posre_UNL.itp\"\n\#endif \n" topol.top
echo "UNL   1" >> topol.top

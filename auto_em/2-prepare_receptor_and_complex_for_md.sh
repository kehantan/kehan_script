#!/bin/sh

# prepare protein and protein-ligand complex for gromacs


set -e 
source /opt/gromacs-2021.2/bin/GMXRC


# prepare protein
# this script use option 1, custom directory containing amber14 forcefield  
echo 1 | gmx pdb2gmx -f receptor.pdb -o processed.gro -water tip3p -ignh


# prepare complex 
rm -rf complex.gro
head -n -1 processed.gro >> complex.gro
grep " UNL " UNL*GMX.gro >> complex.gro
tail -n 1 processed.gro >> complex.gro
a=$(awk NR==2 UNL*GMX.gro)
b=$(awk NR==2 processed.gro)
c=$(echo "$a+$b" | bc) 
sed -i -e "2s/$b/$c/" complex.gro

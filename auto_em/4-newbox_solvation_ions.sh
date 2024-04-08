#!/bin/sh

# create newbox, add water and ions for gromacs


set -e 
source /opt/gromacs-2024.1/bin/GMXRC


# create newbox, solvation, add ions 
gmx editconf -f complex.gro -o newbox.gro -bt dodecahedron -d 1.0 -c
gmx solvate -cp newbox.gro -cs spc216.gro -p topol.top -o solv.gro
gmx grompp -f mdp/ions.mdp -c solv.gro -p topol.top -o ions.tpr
echo 15 | gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral

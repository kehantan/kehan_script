#!/bin/sh
set -e 

source /opt/gromacs-2021.2/bin/GMXRC

echo " "
echo "###  $(pwd)  ###"
echo " "

# energy minimisation
gmx editconf -f complex.gro -o newbox.gro -bt dodecahedron -d 1.0 -c
gmx solvate -cp newbox.gro -cs spc216.gro -p topol.top -o solv.gro
gmx grompp -f mdp/ions.mdp -c solv.gro -p topol.top -o ions.tpr
echo 15 | gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral
gmx grompp -f mdp/em_steep.mdp -c solv_ions.gro -p topol.top -o em_steep.tpr
gmx mdrun -v -deffnm em_steep
gmx grompp -f mdp/em_cg.mdp -c em_steep.gro -p topol.top -o em_cg.tpr
gmx mdrun -v -deffnm em_cg

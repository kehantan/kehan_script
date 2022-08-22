#!/bin/sh

# energy minimisation for gromacs 


set -e 
source /opt/gromacs-2021.2/bin/GMXRC


# steepest descent energy minimisation
gmx grompp -f mdp/em_steep.mdp -c solv_ions.gro -p topol.top -o em_steep.tpr
gmx mdrun -v -deffnm em_steep


# conjugated gradient energy minimisation
gmx grompp -f mdp/em_cg.mdp -c em_steep.gro -p topol.top -o em_cg.tpr
gmx mdrun -v -deffnm em_cg

#!/bin/sh

# for g_mmpbsa calculation in auto em


set -e 
source /opt/gromacs-2021.2/bin/GMXRC


# prepare dir for mmpbsa
mkdir -p g_mmpbsa/em/
cp -r /home/$USER/kehan/mmpbsa_file g_mmpbsa/


# actual mmpbsa
cd g_mmpbsa/em/ 


# generate complex file for mmpbsa calculation
echo 4 22 | gmx trjconv -s ../../em_cg.tpr -f ../../em_cg.gro -n ../../index.ndx -o em_cg_gro_processed_com.pdb -pbc mol -ur compact -center 


# tpr file generation for g_mmpbsa
# g_mmpbsa cannot read tpr files generated from newer version of GMX, have to use tpr file generated from GMX version 5.x.x
/opt/gromacs-5.1.2/bin/gmx grompp -f ../../mdp/em_cg.mdp -c ../../em_cg.gro -p ../../topol.top -o mmpbsa.tpr


# g_mmpbsa
echo 1 13 | g_mmpbsa -s mmpbsa.tpr -f em_cg_gro_processed_com.pdb -n ../../index.ndx -i ../mmpbsa_file/pbsa.mdp -pbsa -decomp -pdie 1


# get summary with the python script provided by g_mmpbsa 
python3 ../mmpbsa_file/MmPbSaStat.py -m energy_MM.xvg -a apolar.xvg -p polar.xvg


cd ../../

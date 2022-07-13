#!/bin/sh
set -e 

source /opt/gromacs-2021.2/bin/GMXRC

#echo "Receptor:"
#read REC
#echo $REC
#echo "Ligand:"
#read LIG
#echo UNL

echo " "
echo "###  $(pwd)  ###"
echo " "

# remember to:
# set receptor file. ie: REC=output.pdb
# set ligand 3 letter code. ie: LIG=IVM

#current_loc=$(echo $(pwd) | tr -t "/" "\n" | tail -n 1)
#receptor=$(echo $current_loc | tr -t "_" "\n" | awk NR==1)
#exhaust=$(echo $current_loc | tr -t "_" "\n" | awk NR==3)
#dock_type=$(echo $current_loc | tr -t "_" "\n" | awk NR==4)
#dock_run=$(echo $current_loc | tr -t "_" "\n" | awk NR==5)
#out_conf=$(echo $current_loc | tr -t "_" "\n" | awk NR==7)

# cp "$receptor"_UNL_"$exhaust"_"$dock_type"_"$dock_run"_out_"$out_conf"/UNL.acpype/{UNL_GMX.itp,UNL_GMX.gro} .


# separate acpype output into appropriate file
csplit -s -k UNL*GMX.itp /atomtypes/
rm xx00
mv xx01 tmp
csplit -s -k tmp /moleculetype/
rm tmp
mv xx00 UNL_atomtypes.dat
mv xx01 UNL_GMX.itp


# create protein and ligand complex
echo 1 | gmx pdb2gmx -f receptor.pdb -o processed.gro -water tip3p -ignh
head -n -1 processed.gro >> complex.gro
grep " UNL " UNL*GMX.gro >> complex.gro
tail -n 1 processed.gro >> complex.gro
a=$(awk NR==2 UNL_GMX.gro)
b=$(awk NR==2 processed.gro)
c=$(echo "$a+$b" | bc) 
sed -i -e "2s/$b/$c/" complex.gro


# insert ligand atomtypes and topology into topol.top
sed -i -e "/forcefield.itp/a \#include \"UNL_atomtypes.dat\"" topol.top
sed -i -e "/forcefield.itp/{G;}" topol.top
sed -i -e "/water topology/i \#include \"UNL_GMX.itp\"\n\#ifdef POSRES\n\#include \"posre_UNL.itp\"\n\#endif \n" topol.top
echo "UNL   1" >> topol.top


# energy minimisation
gmx editconf -f complex.gro -o newbox.gro -bt dodecahedron -d 1.0 -c
gmx solvate -cp newbox.gro -cs spc216.gro -p topol.top -o solv.gro
gmx grompp -f mdp/ions.mdp -c solv.gro -p topol.top -o ions.tpr
echo 15 | gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral
gmx grompp -f mdp/em_steep.mdp -c solv_ions.gro -p topol.top -o em_steep.tpr
gmx mdrun -v -deffnm em_steep
gmx grompp -f mdp/em_cg.mdp -c em_steep.gro -p topol.top -o em_cg.tpr
gmx mdrun -v -deffnm em_cg

# choice to create lig restraint index file
rm -f UNL_posre_index_choices.txt
echo "0 & ! a H*" >> UNL_posre_index_choices.txt
echo "q" >> UNL_posre_index_choices.txt

# create lig restraint index file
gmx make_ndx -f UNL_GMX.gro -o index_UNL.ndx < UNL_posre_index_choices.txt
echo 3 | gmx genrestr -f UNL_GMX.gro -n index_UNL.ndx -o posre_UNL.itp -fc 1000 1000 1000

# create pro-lig index file
rm -f index.ndx
rm -f choices.txt
echo "1|13" >> choices.txt
echo "q" >> choices.txt
gmx make_ndx -f em_steep.gro -o index.ndx < choices.txt

# prepare dir for mmpbsa
mkdir -p g_mmpbsa/em/
cp -r /home/$USER/kehan/mmpbsa_file g_mmpbsa/

# mmpbsa
cd g_mmpbsa/em/ 

echo 4 22 | gmx trjconv -s ../../em_cg.tpr -f ../../em_cg.gro -n ../../index.ndx -o em_cg_gro_processed_com.pdb -pbc mol -ur compact -center 
/opt/gromacs-5.1.2/bin/gmx grompp -f ../../mdp/em_cg.mdp -c ../../em_cg.gro -p ../../topol.top -o mmpbsa.tpr
echo 1 13 | g_mmpbsa -s mmpbsa.tpr -f em_cg_gro_processed_com.pdb -n ../../index.ndx -i ../mmpbsa_file/pbsa.mdp -pbsa -decomp -pdie 2
python3 ../mmpbsa_file/MmPbSaStat.py -m energy_MM.xvg -a apolar.xvg -p polar.xvg

cd ../../

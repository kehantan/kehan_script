#!/bin/sh
set -e 

source /opt/gromacs-2021.2/bin/GMXRC

#echo "Receptor:"
#read REC
#echo $REC
#echo "Ligand:"
#read LIG
#echo UNK

echo " "
echo "###  $(pwd)  ###"
echo " "

# remember to:
# set receptor file. ie: REC=output.pdb
# set ligand 3 letter code. ie: LIG=IVM

current_loc=$(echo $(pwd) | tr -t "/" "\n" | tail -n 1)
receptor=$(echo $current_loc | tr -t "_" "\n" | awk NR==1)
exhaust=$(echo $current_loc | tr -t "_" "\n" | awk NR==3)
dock_type=$(echo $current_loc | tr -t "_" "\n" | awk NR==4)
dock_run=$(echo $current_loc | tr -t "_" "\n" | awk NR==5)
out_conf=$(echo $current_loc | tr -t "_" "\n" | awk NR==7)

cp "$receptor"_UNK_"$exhaust"_"$dock_type"_"$dock_run"_out_"$out_conf"/UNK.acpype/{UNK_GMX.itp,UNK_GMX.gro} .


# separate acpype output into appropriate file
csplit -s -k UNK_GMX.itp /atomtypes/
rm xx00
mv xx01 tmp
csplit -s -k tmp /moleculetype/
rm tmp
mv xx00 UNK_atomtypes.dat
mv xx01 UNK_GMX.itp


# create protein and ligand complex
gmx pdb2gmx -f model.pdb -o processed.gro -water tip3p -ignh -ff amber99sb-ildn
head -n -1 processed.gro >> complex.gro
grep " UNK " UNK_GMX.gro >> complex.gro
tail -n 1 processed.gro >> complex.gro
a=$(awk NR==2 UNK_GMX.gro)
b=$(awk NR==2 processed.gro)
c=$(echo "$a+$b" | bc) 
sed -i -e "2s/$b/$c/" complex.gro


# insert ligand atomtypes and topology into topol.top
sed -i -e "/forcefield.itp/a \#include \"UNK_atomtypes.dat\"" topol.top
sed -i -e "/forcefield.itp/{G;}" topol.top
sed -i -e "/water topology/i \#include \"UNK_GMX.itp\"\n\#ifdef POSRES\n\#include \"posre_UNK.itp\"\n\#endif \n" topol.top
echo "UNK   1" >> topol.top


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
rm -f UNK_posre_index_choices.txt
echo "0 & ! a H*" >> UNK_posre_index_choices.txt
echo "q" >> UNK_posre_index_choices.txt

# create lig restraint index file
gmx make_ndx -f UNK_GMX.gro -o index_UNK.ndx < UNK_posre_index_choices.txt
echo 3 | gmx genrestr -f UNK_GMX.gro -n index_UNK.ndx -o posre_UNK.itp -fc 1000 1000 1000

# create pro-lig index file
rm -f index.ndx
rm -f choices.txt
echo "1|13" >> choices.txt
echo "q" >> choices.txt
gmx make_ndx -f em_steep.gro -o index.ndx < choices.txt


# prepare dir for mmpbsa
mkdir -p 3u1i_UNK_"$exhaust"_"$dock_type"_"$dock_run"_out_"$out_conf"_g_mmpbsa/em/
cp -r /home/silverbot/kehan/mmpbsa_file 3u1i_UNK_"$exhaust"_"$dock_type"_"$dock_run"_out_"$out_conf"_g_mmpbsa/


# mmpbsa
cd 3u1i_UNK_"$exhaust"_"$dock_type"_"$dock_run"_out_"$out_conf"_g_mmpbsa/em/ 

echo 4 22 | gmx trjconv -s ../../em_cg.tpr -f ../../em_cg.gro -n ../../index.ndx -o em_cg_gro_processed_com.pdb -pbc mol -ur compact -center 
/opt/gromacs-5.1.2/bin/gmx grompp -f ../../mdp/em_cg.mdp -c ../../em_cg.gro -p ../../topol.top -o mmpbsa.tpr
echo 1 13 | g_mmpbsa -s mmpbsa.tpr -f em_cg_gro_processed_com.pdb -n ../../index.ndx -i ../mmpbsa_file/pbsa.mdp -pbsa -decomp -pdie 2
python3 ../mmpbsa_file/MmPbSaStat.py -m energy_MM.xvg -a apolar.xvg -p polar.xvg

cd ../../

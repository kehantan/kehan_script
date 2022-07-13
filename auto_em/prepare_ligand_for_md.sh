#!/bin/sh

# edit ligand output file from acpype


set -e 

# separate acpype output into appropriate file
csplit -s -k UNL*GMX.itp /atomtypes/
rm xx00
mv xx01 tmp
csplit -s -k tmp /moleculetype/
rm tmp
mv xx00 UNL_atomtypes.dat
mv xx01 UNL_GMX.itp

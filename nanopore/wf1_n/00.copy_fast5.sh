#!/bin/bash -l

#SBATCH --job-name=copy_fast5
#SBATCH --output=%x.out
#SBATCH --account=pawsey0281
#SBATCH --clusters=zeus
#SBATCH --partition=copyq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=20G
#SBATCH --export=NONE 

#sample id and working directories
sample=
group=
scratch=

rsync -rP ${group}/fast5 ${scratch}/


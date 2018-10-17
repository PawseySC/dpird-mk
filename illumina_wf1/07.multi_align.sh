#!/bin/bash -l

#SBATCH --job-name=multi_align
#SBATCH --output=%x.out
#SBATCH --account=director2091
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=50G
#SBATCH --export=NONE 


# sample id and working directories
sample=
group=
scratch=

# shifter definitions
module load shifter
srun_cmd="srun --export=all"


cd $scratch
echo Group directory : $group
echo Scratch directory : $scratch
echo SLURM job id : $SLURM_JOB_ID


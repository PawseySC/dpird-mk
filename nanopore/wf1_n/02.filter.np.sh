#!/bin/bash -l

#SBATCH --job-name=filter.np
#SBATCH --output=%x.out
#SBATCH --account=pawsey0281
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=50G
#SBATCH --export=NONE 


#sample id and working directories
sample=
group=
scratch=

# shifter definitions
module load shifter
srun_cmd="srun --export=all"
filtlong_cont="quay.io/biocontainers/filtlong:0.2.0--he941832_2"
nanoplot_cont="quay.io/biocontainers/nanoplot:1.18.2--py36_1"


# running
cd $scratch
echo Group directory : $group
echo Scratch directory : $scratch
echo SLURM job id : $SLURM_JOB_ID

# filtering
echo TIME filter start $(date)
$srun_cmd shifter run $filtlong_cont filtlong \
	--min_mean_q 90 --min_length 2000 \
	pass.fastq > filtered.fastq
echo TIME filter end $(date)

# nanoplot
$srun_cmd shifter run $nanoplot_cont NanoPlot --fastq filtered.fastq
echo TIME np end $(date)

# copying output data back to group
cp -rp $scratch/filtered.fastq $scratch/filtered $group/

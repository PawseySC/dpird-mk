#!/bin/bash -l

#SBATCH --job-name=align_samples
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
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# shifter definitions
module load shifter
srun_cmd="srun --export=all"
mafft_cont="quay.io/biocontainers/mafft:7.407--0"

# running
echo Working directory : $(pwd)
echo SLURM job id : $SLURM_JOB_ID

# assumptions:
# running from clean directory
# directory contains all and only fasta files that need to be aligned

# building fasta input for mafft
cat consensus_*.fasta >input_align_samples.fasta

# multiple alignment of selected consensus sequences
$srun_cmd shifter run $mafft_cont mafft-linsi \
	--thread $OMP_NUM_THREADS \
	input_align_samples.fasta >output_align_samples.fasta

#!/bin/bash -l

#SBATCH --job-name=map_refseq
#SBATCH --output=%x.out
#SBATCH --account=director2091
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=50G
#SBATCH --export=NONE 
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

#sample id and working directories
sample=
group=
scratch=

# shifter definitions
module load shifter
srun_cmd="srun --export=all"
pomoxis_cont="dpirdmk/pomoxis:0.1.11"


# retrieve reference sequence
cp -p $group/REFSEQ.fasta $scratch/

# running
cd $scratch
echo Group directory : $group
echo Scratch directory : $scratch
echo SLURM job id : $SLURM_JOB_ID

echo TIME mapping start $(date)
$srun_cmd shifter run $pomoxis_cont init.sh mini_align \
	-r REFSEQ.fasta \
	-i filtered.fasta \
	-P -p mapped_refseq \
	-t $OMP_NUM_THREADS
echo TIME mapping end $(date)

# copying output data back to group
cp -p $scratch/mapped_refseq.bam* $group/

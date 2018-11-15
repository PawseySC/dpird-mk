#!/bin/bash -l

#SBATCH --job-name=polish
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
export nanopolish_cont="quay.io/biocontainers/nanopolish:0.10.2--h78a5b34_0"


# running
cd $scratch
echo Group directory : $group
echo Scratch directory : $scratch
echo SLURM job id : $SLURM_JOB_ID

echo TIME polish index start $(date)
$srun_cmd shifter run $nanopolish_cont nanopolish index \
	-d fast5 filtered.fastq
echo TIME polish index end $(date)

echo TIME polish variants start $(date)
$srun_cmd shifter run $nanopolish_cont nanopolish variants \
	--consensus \
	-o polished.vcf \
	-r filtered.fastq -b mapped_assembly.bam -g assembly_final.fa \
	-q dcm,dam --min-candidate-frequency 0.1 \
	-t $OMP_NUM_THREADS
echo TIME polish variants end $(date)

echo TIME polish consensus start $(date)
$srun_cmd shifter run $nanopolish_cont nanopolish vcf2fasta \
	-g assembly_final.fa polished.vcf \
	>consensus_assembly.fasta
echo TIME polish consensus end $(date)

# copying output data back to group
cp -p $scratch/consensus_assembly.fasta $group/

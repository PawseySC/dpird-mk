#!/bin/bash -l

#SBATCH --job-name=assemble
#SBATCH --output=%x.out
#SBATCH --account=director2091
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=120G
#SBATCH --export=NONE 
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# sample id and working directories
sample="3_1.Desktop_MPS_exercise"
group="/group/director2091/mdelapierre/illumina/$sample"
scratch="/scratch/director2091/mdelapierre/illumina/$sample"

# shifter definitions
module load shifter
srun_cmd="srun --export=all"
spades_cont="quay.io/biocontainers/spades:3.12.0--1"


cd $scratch

echo TIME assemble start $(date)
$srun_cmd shifter run $spades_cont spades.py \
	-s clean.fastq.gz \
	--only-assembler \
	-t $OMP_NUM_THREADS -m 120 \
	-o .
echo TIME assemble end $(date)

min_len=1000
awk -v min_len=$min_len -F _ '{ if( $1 == ">NODE" ){ if( $4 < min_len ) {exit} } ; print }' contigs.fasta >contigs_sub.fasta
echo TIME subset end $(date)

# copying output data back to group
cp -p $scratch/contigs_sub.fasta $group/

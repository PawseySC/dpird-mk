#!/bin/bash -l

#SBATCH --job-name=map_refseq_1
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
sample="3_1.Desktop_MPS_exercise"
group="/group/director2091/mdelapierre/illumina/$sample"
scratch="/scratch/director2091/mdelapierre/illumina/$sample"

# shifter definitions
module load shifter
srun_cmd="srun --export=all"
bbmap_cont="quay.io/biocontainers/bbmap:38.20--h470a237_0"
samtools_cont="marcodelapierre/samtools:1.9"
bcftools_cont="marcodelapierre/bcftools:1.9"


cd $scratch

cp -p $group/refseq_1.fasta $scratch/

echo TIME map-refseq start $(date)
$srun_cmd shifter run $bbmap_cont bbmap.sh \
	in=clean.fastq.gz ref=refseq_1.fasta out=mapped_refseq_1.sam \
	k=13 maxindel=16000 ambig=random
echo TIME map-refseq end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	view -b -o mapped_refseq_1.bam mapped_refseq_1.sam
echo TIME sam-refseq view end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	sort -o mapped_refseq_1_sorted.bam mapped_refseq_1.bam
echo TIME sam-refseq sort end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	index mapped_refseq_1_sorted.bam
echo TIME sam-refseq index end $(date)

# copying output data back to group
cp -p $scratch/mapped_refseq_1_sorted.bam* $group/

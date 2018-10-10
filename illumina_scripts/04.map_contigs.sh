#!/bin/bash -l

#SBATCH --job-name=map_contigs
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


cd $scratch

echo TIME map-contigs start $(date)
$srun_cmd shifter run $bbmap_cont bbmap.sh \
	in=clean.fastq.gz ref=contigs_sub.fasta out=mapped_contigs.sam \
	k=13 maxindel=16000 ambig=random
echo TIME map-contigs end $(date)

# copying output data back to group
cp -p $scratch/mapped_contigs.sam $group/

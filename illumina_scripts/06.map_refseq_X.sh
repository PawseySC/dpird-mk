#!/bin/bash -l

#SBATCH --job-name=map_refseq_X
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
blast_cont="quay.io/biocontainers/blast:2.7.1--h96bfa4b_5"
bbmap_cont="quay.io/biocontainers/bbmap:38.20--h470a237_0"
samtools_cont="marcodelapierre/samtools:1.9"
bcftools_cont="marcodelapierre/bcftools:1.9"


cd $scratch
echo Group directory : $group
echo Scratch directory : $scratch
echo SLURM job id : $SLURM_JOB_ID

# get ref sequence from BLAST db
seqid="$(head -1 blast_contigs_sub.tsv | cut -f 2)"

echo TIME map_refseq blastdb start $(date)
$srun_cmd shifter run $blast_cont  blastdbcmd \
	-db /group/data/blast/nt -entry $seqid \
	-line_length 60 \
	-out refseq_X.fasta
echo TIME map_refseq blastdb end $(date)

echo Header for refseq is : $( grep '^>' refseq_X.fasta )
sed -i '/^>/ s/ .*//g' refseq_X.fasta
echo TIME map_refseq header end $(date)

# alignment (sorted BAM file as final output)
echo TIME map_refseq bbmap start $(date)
$srun_cmd shifter run $bbmap_cont bbmap.sh \
	in=clean.fastq.gz ref=refseq_X.fasta out=mapped_refseq_X_unsorted.sam \
	k=13 maxindel=16000 ambig=random
echo TIME map_refseq bbmap end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	view -b -o mapped_refseq_X_unsorted.bam mapped_refseq_X_unsorted.sam
echo TIME map_refseq sam view end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	sort -o mapped_refseq_X.bam mapped_refseq_X_unsorted.bam
echo TIME map_refseq sam sort end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	index mapped_refseq_X.bam
echo TIME map_refseq sam index end $(date)

# depth data into text file
$srun_cmd shifter run $samtools_cont samtools \
    depth -aa mapped_refseq_X.bam >depth_refseq_X.dat
echo TIME map_refseq sam depth end $(date)

# creating consensus sequence
$srun_cmd shifter run $bcftools_cont bcftools \
    mpileup -Ou -f refseq_X.fasta mapped_refseq_X.bam \
    | shifter run $bcftools_cont bcftools \
    call --ploidy 1 -mv -Oz -o calls_refseq_X.vcf.gz
echo TIME map_refseq bcf mpileup/call end $(date)

$srun_cmd shifter run $bcftools_cont bcftools \
    tabix calls_refseq_X.vcf.gz
echo TIME map_refseq bcf tabix end $(date)

$srun_cmd shifter run $bcftools_cont bcftools \
    consensus -f refseq_X.fasta -o consensus_refseq_X.fasta calls_refseq_X.vcf.gz
echo TIME map_refseq bcf consensus end $(date)

# copying output data back to group
cp -p $scratch/mapped_refseq_X.bam* $scratch/depth_refseq_X.dat $scratch/consensus_refseq_X.fasta $group/

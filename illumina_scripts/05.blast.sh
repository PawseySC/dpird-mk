#!/bin/bash -l

#SBATCH --job-name=blast
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
blast_cont="quay.io/biocontainers/blast:2.7.1--h96bfa4b_5"


cd $scratch

# blasting
echo TIME blast start $(date)
$srun_cmd shifter run $blast_cont blastn \
	-query contigs_sub.fasta -db /group/data/blast/nt \
	-outfmt 11 -out blast_contigs_sub.asn \
	-max_hsps 50 \
	-word_size 28 -evalue 0.1 \
	-reward 1 -penalty -2 \
	-num_threads $SLURM_CPUS_PER_TASK
echo TIME blast end $(date)

# producing blast output in different formats
$srun_cmd shifter run $blast_cont blast_formatter \
	-archive blast_contigs_sub.asn \
	-outfmt 5 -out blast_contigs_sub.xml
echo TIME xml end $(date)

$srun_cmd shifter run $blast_cont blast_formatter \
	-archive blast_contigs_sub.asn \
	-outfmt 6 -out blast_unsort_default_contigs_sub.tsv
echo TIME tsv end $(date)

$srun_cmd shifter run $blast_cont blast_formatter \
	-archive blast_contigs_sub.asn \
	-outfmt "6 qaccver saccver pident length evalue bitscore stitle" -out blast_unsort_contigs_sub.tsv
echo TIME custom tsv end $(date)

sort -n -r -k 6 blast_unsort_contigs_sub.tsv >blast_contigs_sub.tsv
echo TIME sort custom tsv end $(date)

top_hits=1
head -$top_hits blast_contigs_sub.tsv | cut -f 2 >top_hits_seqid.tsv
export cnt=0
for seqid in $(cat top_hits_seqid.tsv) ; do 
 $srun_cmd shifter run $blast_cont  blastdbcmd \
	-db /group/data/blast/nt -entry $seqid \
	-line_length 60 \
	-out refseq_$((++cnt)).fasta
done
echo TIME get refseqs end $(date)

# copying output data back to group
cp -p $scratch/blast_contigs_sub.tsv $scratch/blast_contigs_sub.xml $scratch/refseq_*.fasta $group/

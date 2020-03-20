#!/bin/bash -l

#SBATCH --job-name=blast
#SBATCH --output=%x.out
#SBATCH --account=pawsey0281
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=06:00:00
#SBATCH --mem=60G
#SBATCH --export=NONE 
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# sample id and working directories
sample=
group=
scratch=

# shifter definitions
module load singularity
srun_cmd="srun --export=all"
samtools_cont="dpirdmk/samtools:1.9"
blast_cont="quay.io/biocontainers/blast:2.7.1--h96bfa4b_5"


# switch for reverse-complement
echo TIME revcom start $(date)
revcom="both"
if [ "$revcom" == "both" ] ; then
 $srun_cmd shifter run $samtools_cont samtools faidx \
    -i -o $group/contigs_sub_rc.fasta \
    $group/contigs_sub.fasta $(grep '^>' $group/contigs_sub.fasta | tr -d '>')
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
 prefix_contig_list="contigs_sub contigs_sub_rc"
elif [ "$revcom" == "yes" ] ; then
 $srun_cmd shifter run $samtools_cont samtools faidx \
	-i -o $group/contigs_sub_rc.fasta \
	$group/contigs_sub.fasta $(grep '^>' $group/contigs_sub.fasta | tr -d '>')
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
 prefix_contig_list="contigs_sub_rc"
else
 prefix_contig_list="contigs_sub"
fi
echo TIME revcom end $(date)

# start loop on standard / reverse-complement
for prefix_contig in $prefix_contig_list ; do
 echo "Now running for prefix : $prefix_contig"

 # copying input data to scratch
 for f in ${prefix_contig}.fasta ; do
  cp -p $group/$f $scratch/
 done
 
 # running
 cd $scratch
 echo Group directory : $group
 echo Scratch directory : $scratch
 echo SLURM job id : $SLURM_JOB_ID
 
 # blasting
 $srun_cmd shifter run $blast_cont blastn \
 	-query ${prefix_contig}.fasta -db /group/data/blast/nt \
 	-outfmt 11 -out blast_${prefix_contig}.asn \
 	-max_hsps 50 \
 	-word_size 28 -evalue 0.1 \
 	-reward 1 -penalty -2 \
 	-num_threads $OMP_NUM_THREADS
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
 echo TIME blast end $(date)
 
 # producing blast output in different formats
 $srun_cmd shifter run $blast_cont blast_formatter \
 	-archive blast_${prefix_contig}.asn \
 	-outfmt 5 -out blast_${prefix_contig}.xml
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
 echo TIME xml end $(date)
 
 $srun_cmd shifter run $blast_cont blast_formatter \
 	-archive blast_${prefix_contig}.asn \
 	-outfmt 6 -out blast_unsort_default_${prefix_contig}.tsv
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
 echo TIME tsv end $(date)
 
 $srun_cmd shifter run $blast_cont blast_formatter \
 	-archive blast_${prefix_contig}.asn \
 	-outfmt "6 qaccver saccver pident length evalue bitscore stitle" -out blast_unsort_${prefix_contig}.tsv
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
 echo TIME custom tsv end $(date)
 
 sort -n -r -k 6 blast_unsort_${prefix_contig}.tsv >blast_${prefix_contig}.tsv
 echo TIME sort custom tsv end $(date)
 
 # copying output data back to group
 cp -p $scratch/blast_${prefix_contig}.tsv $scratch/blast_${prefix_contig}.xml $group/

# end loop on standard / reverse-complement
done

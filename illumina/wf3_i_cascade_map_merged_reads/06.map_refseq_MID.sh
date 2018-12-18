#!/bin/bash -l

#SBATCH --job-name=map_refseq_MIDNUM
#SBATCH --output=%x.out
#SBATCH --account=director2091
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=06:00:00
#SBATCH --mem=10G
#SBATCH --export=NONE 
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

MID="MIDNUM"

# sample id and working directories
sample=
group=
scratch=

# shifter definitions
module load shifter
srun_cmd="srun --export=all"
blast_cont="quay.io/biocontainers/blast:2.7.1--h96bfa4b_5"
bbmap_cont="quay.io/biocontainers/bbmap:38.20--h470a237_0"
samtools_cont="dpirdmk/samtools:1.9"
bcftools_cont="dpirdmk/bcftools:1.8"

# input depending on run ID
if [ "$MID" == "1" ] ; then
 map_input="clean.fastq.gz"
else
 map_input="unmapped_refseq_$((MID-1)).fastq.gz"
fi

# copying input data to scratch
for f in $map_input ; do
 cp -p $group/$f $scratch/
done
cp -p $group/refseq_${MID}.fasta $scratch/ 2>/dev/null

# running
cd $scratch
echo Group directory : $group
echo Scratch directory : $scratch
echo SLURM job id : $SLURM_JOB_ID

seqid=
echo map_refseq run number : ${MID}
echo map_refseq refseq ID : ${seqid}

# get ref sequence from BLAST db
echo TIME map_refseq blastdb start $(date)
if [ ! -s refseq_${MID}.fasta ] ; then
 $srun_cmd shifter run $blast_cont  blastdbcmd \
	-db /group/data/blast/nt -entry ${seqid%/rc} \
	-line_length 60 \
	-out refseq_${MID}.fasta
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
 if [ "${seqid: -3}" == "/rc" ] ; then
  $srun_cmd shifter run $samtools_cont samtools faidx \
	-i -o refseq_${MID}_rc.fasta \
	refseq_${MID}.fasta ${seqid%/rc}
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
  mv refseq_${MID}_rc.fasta refseq_${MID}.fasta
  rm refseq_${MID}.fasta.fai
 fi
else
 echo "Refseq file refseq_${MID}.fasta already exists"
fi
echo TIME map_refseq blastdb end $(date)

echo Header for refseq is : $( grep '^>' refseq_${MID}.fasta )
sed -i '/^>/ s/ .*//g' refseq_${MID}.fasta
echo TIME map_refseq header end $(date)

# alignment (sorted BAM file as final output)
echo TIME map_refseq bbmap start $(date)
$srun_cmd shifter run $bbmap_cont bbmap.sh \
	in=$map_input ref=refseq_${MID}.fasta \
	out=mapped_refseq_${MID}_unsorted.sam \
	outu=unmapped_refseq_${MID}.fastq.gz \
	k=13 maxindel=16000 ambig=random \
	path=ref_${MID} \
	threads=$OMP_NUM_THREADS
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME map_refseq bbmap end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	view -b -o mapped_refseq_${MID}_unsorted.bam mapped_refseq_${MID}_unsorted.sam
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME map_refseq sam view end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	sort -o mapped_refseq_${MID}.bam mapped_refseq_${MID}_unsorted.bam
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME map_refseq sam sort end $(date)

$srun_cmd shifter run $samtools_cont samtools \
	index mapped_refseq_${MID}.bam
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME map_refseq sam index end $(date)

# depth data into text file
$srun_cmd shifter run $samtools_cont samtools \
    depth -aa mapped_refseq_${MID}.bam >depth_refseq_${MID}.dat
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME map_refseq sam depth end $(date)

# creating consensus sequence
$srun_cmd shifter run $bcftools_cont bcftools \
    mpileup -Ou -f refseq_${MID}.fasta mapped_refseq_${MID}.bam \
    | shifter run $bcftools_cont bcftools \
    call --ploidy 1 -mv -Oz -o calls_refseq_${MID}.vcf.gz
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME map_refseq bcf mpileup/call end $(date)

$srun_cmd shifter run $bcftools_cont bcftools \
    tabix calls_refseq_${MID}.vcf.gz
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME map_refseq bcf tabix end $(date)

$srun_cmd shifter run $bcftools_cont bcftools \
    consensus -f refseq_${MID}.fasta -o consensus_refseq_${MID}.fasta calls_refseq_${MID}.vcf.gz
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME map_refseq bcf consensus end $(date)

# copying output data back to group
cp -p $scratch/refseq_${MID}.fasta $scratch/mapped_refseq_${MID}.bam* $scratch/unmapped_refseq_${MID}.fastq.gz $scratch/depth_refseq_${MID}.dat $scratch/consensus_refseq_${MID}.fasta $group/

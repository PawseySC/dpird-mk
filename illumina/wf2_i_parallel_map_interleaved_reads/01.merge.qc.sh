#!/bin/bash -l

#SBATCH --job-name=merge.qc
#SBATCH --output=%x.out
#SBATCH --account=pawsey0281
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --mem=10G
#SBATCH --export=NONE 


# sample id and working directories
sample=
group=
scratch=

# container definitions
module load singularity
srun_cmd="srun --export=all"
bbmap_cont="quay.io/biocontainers/bbmap:38.20--h470a237_0"
fastqc_cont="quay.io/biocontainers/fastqc:0.11.7--4"


# copying input data to scratch
cp -p $group/R1.fastq.gz $group/R2.fastq.gz $scratch/

# running
cd $scratch
echo Group directory : $group
echo Scratch directory : $scratch
echo SLURM job id : $SLURM_JOB_ID

echo TIME merge start $(date)
$srun_cmd singularity exec docker://$bbmap_cont reformat.sh \
	in1=R1.fastq.gz in2=R2.fastq.gz \
	out=interleaved.fastq.gz
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME merge end $(date)

$srun_cmd singularity exec docker://$fastqc_cont fastqc interleaved.fastq.gz
if [ "$?" != "0" ] ; then echo "ERROR in workflow: last srun command failed. Exiting." ; exit 1 ; fi
echo TIME qc end $(date)

# copying output data back to group
cp -p $scratch/interleaved* $group/

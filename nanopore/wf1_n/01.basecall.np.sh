#!/bin/bash -l

#SBATCH --job-name=basecall.np
#SBATCH --output=%x.out
#SBATCH --account=pawsey0281
#SBATCH --clusters=zeus
#SBATCH --partition=longq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=28
#SBATCH --time=4-00:00:00
#SBATCH --mem=120G
#SBATCH --export=NONE 
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

#sample id and working directories
sample=
group=
scratch=

# shifter definitions
module load shifter
srun_cmd="srun --export=all"
albacore_cont="genomicpariscentre/albacore:2.3.3"
nanoplot_cont="quay.io/biocontainers/nanoplot:1.18.2--py36_1"


# copying input data to scratch
#cp -rp $group/fast5 $scratch/

# running
cd $scratch
echo Group directory : $group
echo Scratch directory : $scratch
echo SLURM job id : $SLURM_JOB_ID

# basecalling
echo TIME basecall start $(date)
$srun_cmd shifter run $albacore_cont read_fast5_basecaller.py \
	-i fast5 -r \
	-s . -o fastq,fast5 \
	--barcoding \
	-f FLO-MIN106 -k SQK-LSK108 \
	-t $OMP_NUM_THREADS
echo TIME basecall end $(date)

# nanoplot
$srun_cmd shifter run $nanoplot_cont NanoPlot --summary sequencing_summary.txt
echo TIME np end $(date)

# copying output data back to group
#cp -rp $scratch/workspace/pass $group/
cp -p $scratch/*.png $scratch/NanoStats.txt $scratch/NanoPlot-report.html $group/

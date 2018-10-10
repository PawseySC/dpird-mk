#!/bin/bash

# project id
account=director2091

# directory names
# some assumptions are in place:
# sample name = name of current directory
sample=$(basename $(pwd))
# storage directory = directory containing current directory (e.g. contains each sample as sub-directory)
basegroup=$(dirname $(pwd))
# scratch directory = 
# 1. if storage in group, reflects its name under scratch
# 2. if storage in scratch, gets a "_tmp" suffix
basescratch=${basegroup/group/scratch}
if [ $basescratch == $basegroup ] ; then
 basescratch=${basegroup}_tmp
fi
# compose full directory names
group="$basegroup/$sample"
scratch="$basescratch/$sample"


# SLURM script names
script_merge="01.merge.qc.sh"
script_trim="02.trim.qc.sh"
script_assemble="03.assemble.sh"
script_map_contigs="04.map_contigs.sh"
script_blast="05.blast.sh"

# apply definitions above in SLURM script files
sed -i "s;#SBATCH --account=.*;#SBATCH --account=$account;g" [01]*.sh
sed -i "s;sample=.*;sample=\"$sample\";g" [01]*.sh
sed -i "s;group=.*;group=\"$group\";g" [01]*.sh
sed -i "s;scratch=.*;scratch=\"$scratch\";g" [01]*.sh

# check for read files
if [ ! -s R1.fastq.gz -o ! -s R2.fastq.gz ] ; then
 echo One or both input read files R1.fastq.gz, R2.fastq.gz are missing. Exiting.
 exit
fi

# create scratch
mkdir -p $scratch

# workflow of job submissions
# merge and QC
jobid_merge=$(       sbatch --parsable                                      $script_merge       | cut -d ";" -f 1 )
# trim and QC
jobid_trim=$(        sbatch --parsable --dependency=afterok:$jobid_merge    $script_trim        | cut -d ";" -f 1 )
# assemble
jobid_assemble=$(    sbatch --parsable --dependency=afterok:$jobid_trim     $script_assemble    | cut -d ";" -f 1 )
# map to contigs
jobid_map_contigs=$( sbatch --parsable --dependency=afterok:$jobid_assemble $script_map_contigs | cut -d ";" -f 1 )
# blast
jobid_blast=$(       sbatch --parsable --dependency=afterok:$jobid_assemble $script_blast       | cut -d ";" -f 1 )


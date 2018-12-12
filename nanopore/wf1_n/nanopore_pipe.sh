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
script_copy_fast5="00.copy_fast5.sh"
script_basecall="01.basecall.np.sh"
script_filter="02.filter.np.sh"
script_map_refseq="03.map_refseq.sh"
script_assemble="04.assemble.sh"
script_map_assembly="05.map_assembly.sh"
script_polish="06.polish.sh"
# input dir
read_dir="fast5"


# check for read files
if [ ! -d $read_dir ] ; then
 echo "Directory $read_dir with read files is missing. Exiting."
 exit
fi

# apply definitions above in SLURM script files
list_script+="$script_copy_fast5"
list_script+=" $script_basecall"
list_script+=" $script_filter"
list_script+=" $script_map_refseq"
list_script+=" $script_assemble"
list_script+=" $script_map_assembly"
list_script+=" $script_polish"
sed -i "s;#SBATCH --account=.*;#SBATCH --account=$account;g" $list_script
sed -i "s;^ *sample=.*;sample=\"$sample\";g" $list_script
sed -i "s;^ *group=.*;group=\"$group\";g" $list_script
sed -i "s;^ *scratch=.*;scratch=\"$scratch\";g" $list_script

# create scratch
mkdir -p $scratch

echo Group directory : $group
echo Scratch directory : $scratch

# workflow of job submissions
# copy_fast5
jobid_copy_fast5=$(   sbatch --parsable                                          $script_copy_fast5   | cut -d ";" -f 1 )
echo Submitted script $script_copy_fast5 with job ID $jobid_copy_fast5
# basecall
jobid_basecall=$(     sbatch --parsable --dependency=afterok:$jobid_copy_fast5   $script_basecall     | cut -d ";" -f 1 )
echo Submitted script $script_basecall with job ID $jobid_basecall
# filter
jobid_filter=$(       sbatch --parsable --dependency=afterok:$jobid_basecall     $script_filter       | cut -d ";" -f 1 )
echo Submitted script $script_filter with job ID $jobid_filter
# map_refseq
jobid_map_refseq=$(   sbatch --parsable --dependency=afterok:$jobid_filter       $script_map_refseq   | cut -d ";" -f 1 )
echo Submitted script $script_map_refseq with job ID $jobid_map_refseq
# assemble
jobid_assemble=$(     sbatch --parsable --dependency=afterok:$jobid_filter       $script_assemble     | cut -d ";" -f 1 )
echo Submitted script $script_assemble with job ID $jobid_assemble
# map_assembly
jobid_map_assembly=$( sbatch --parsable --dependency=afterok:$jobid_assemble     $script_map_assembly | cut -d ";" -f 1 )
echo Submitted script $script_map_assembly with job ID $jobid_map_assembly
# polish
jobid_polish=$(       sbatch --parsable --dependency=afterok:$jobid_map_assembly $script_polish       | cut -d ";" -f 1 )
echo Submitted script $script_polish with job ID $jobid_polish


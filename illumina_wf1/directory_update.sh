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
list_script+="$script_merge"
list_script+=" $script_trim"
list_script+=" $script_assemble"
list_script+=" $script_map_contigs"
list_script+=" $script_blast"
sed -i "s;#SBATCH --account=.*;#SBATCH --account=$account;g" $list_script
sed -i "s;^ *sample=.*;sample=\"$sample\";g" $list_script
sed -i "s;^ *group=.*;group=\"$group\";g" $list_script
sed -i "s;^ *scratch=.*;scratch=\"$scratch\";g" $list_script

# create scratch
mkdir -p $scratch

echo Group directory : $group
echo Scratch directory : $scratch

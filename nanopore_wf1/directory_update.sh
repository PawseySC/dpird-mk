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
script_basecall="01.basecall.np.sh"
script_filter="02.filter.np.sh"
script_map_refseq="03.map_refseq.sh"
script_assemble="04.assemble.sh"
script_map_assembly="05.map_assembly.sh"
script_polish="06.polish.sh"


# apply definitions above in SLURM script files
list_script+="$script_basecall"
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

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


# apply definitions above in SLURM script files
sed -i "s;#SBATCH --account=.*;#SBATCH --account=$account;g" [01]*.sh
sed -i "s;^ *sample=.*;sample=\"$sample\";g" [01]*.sh
sed -i "s;^ *group=.*;group=\"$group\";g" [01]*.sh
sed -i "s;^ *scratch=.*;scratch=\"$scratch\";g" [01]*.sh

# create scratch
mkdir -p $scratch

echo Group directory : $group
echo Scratch directory : $scratch

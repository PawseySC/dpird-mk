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
script_map_refseq="06.map_refseq_MID.sh"
script_align="07.align_AID.sh"
# input file name(s)
read_file="clean.fastq.gz"
# file where list of SeqIDs from blasting is created
idlist_file="list_seqids"


# check for command arguments
if [ $# -eq 0 ] ; then
 echo "You need to provide at least one SeqID (from the BLAST output) as argument. Exiting."
 exit
fi

# check for read files
if [ ! -s $read_file ] ; then
 echo "Input read file $read_file is missing. Exiting."
 exit
fi

# apply definitions above in SLURM script files
list_script+="$script_map_refseq"
list_script+=" $script_align"
sed -i "s;#SBATCH --account=.*;#SBATCH --account=$account;g" $list_script
sed -i "s;^ *sample=.*;sample=\"$sample\";g" $list_script
sed -i "s;^ *group=.*;group=\"$group\";g" $list_script
sed -i "s;^ *scratch=.*;scratch=\"$scratch\";g" $list_script

# create scratch
mkdir -p $scratch

echo Group directory : $group
echo Scratch directory : $scratch

# generate required refseq SLURM scripts
numrefs=$(ls ${script_map_refseq/_MID/_[0-9]*} 2>/dev/null | wc -w)
if [ $numrefs -eq 0 ] ; then
 rm -f $idlist_file
fi
for (( i=1 ; i <= $# ; i++ )) ; do 
 scid=$((numrefs+i))
 sed -e "s/seqid=.*/seqid=${!i}/g" -e "s/MIDNUM/$scid/g" $script_map_refseq >${script_map_refseq/_MID/_$scid}
 echo SeqID ${!i} to script ${script_map_refseq/_MID/_$scid} >>$idlist_file
done

# workflow of job submissions
# maps to refseq
for (( i=1 ; i <= $# ; i++ )) ; do
 scid=$((numrefs+i))
 jobid_map_refseq=$( sbatch --parsable                                  ${script_map_refseq/_MID/_$scid} | cut -d ";" -f 1 )
 list_jobid+=:$jobid_map_refseq
 echo Submitted script ${script_map_refseq/_MID/_$scid} with job ID $jobid_map_refseq
done
# multiple alignment
#jobid_align=$(  sbatch --parsable --dependency=afterok:$list_jobid $script_align         | cut -d ";" -f 1 )
#echo Submitted script $script_align with job ID $jobid_align

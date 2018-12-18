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
# prefix/suffix of map_refseq consensus output files
prefix_map_in="refseq"
prefix_map_out="consensus_refseq"
suffix_map="fasta"


# check for command arguments
if [ $# -eq 0 ] ; then
 echo "There are two usage modes for this script."
 echo "1. Map reads to a set of reference sequences; "
 echo "   as argument, provide at least one refseq ID (from the BLAST output)."
 echo "2. Map reads to ref. sequences, then perform multiple alignment between those and a set of contig sequences; "
 echo "   as argument, provide at least one refseq ID (from the BLAST output) and one contig ID (from the assembled contigs file)."
 echo "** Note you can ask for the reverse-complement of any reference/contig sequence, by appending \"_rc\" or \"/rc\" to their ID."
 echo "No arguments provided. Exiting."
 exit
fi

# check for read files
if [ ! -s $read_file ] ; then
 echo "Input read file $read_file is missing. Exiting."
 exit
fi

# apply definitions above in SLURM script files
list_script+="${script_map_refseq/_MID/_*}"
list_script+=" ${script_align/_AID/_*}"
sed -i "s;#SBATCH --account=.*;#SBATCH --account=$account;g" $list_script
sed -i "s;^ *sample=.*;sample=\"$sample\";g" $list_script
sed -i "s;^ *group=.*;group=\"$group\";g" $list_script
sed -i "s;^ *scratch=.*;scratch=\"$scratch\";g" $list_script

# create scratch
mkdir -p $scratch

echo Group directory : $group
echo Scratch directory : $scratch

# classify input arguments
arg_list="$@"
arg_list=${arg_list//_rc/\/rc}
ref_list=$(echo $arg_list | xargs -n 1 | grep -v NODE | xargs)
ref_num=$( echo $ref_list | wc -w)
con_list=$(echo $arg_list | xargs -n 1 | grep NODE | xargs)
con_num=$( echo $con_list | wc -w)
if [ $ref_num -eq 0 ] ; then
 echo "At least one refseq ID (from the BLAST output) is required. Exiting."
 exit
fi

# generate required refseq SLURM scripts
refseq_files=$(ls ${prefix_map_in}_*.${suffix_map} 2>/dev/null)
refseq_num=$(echo $refseq_files | wc -w)
if [ $refseq_num -gt 0 ] ; then
 upper_num=$(for f in $refseq_files ; do tag=${f#${prefix_map_in}_} ; tag=${tag%.${suffix_map}} ; echo $tag ; done |sort -n -k 1 -r |head -1)
else
 upper_num=0
fi
for id in $ref_list ; do
 if [ "${id: -3}" == "/rc" ] ; then
  isrc="y"
 else
  isrc="n"
 fi
 found=0
 for file in $refseq_files ; do
  if [ "$isrc" == "y" ] ; then
   found=$(grep ">${id%/rc}" $file | grep -c "/rc")
  else
   found=$(grep ">${id%/rc}" $file | grep -cv "/rc")
  fi
  if [ "$found" == "1" ] ; then
   if [ ! -s ${prefix_map_out}${file#${prefix_map_in}} ] ; then
    runid=${file#${prefix_map_in}_}
    runid=${runid%.${suffix_map}}
    list_runid+="${runid} "
    sed -e "s/MIDNUM/$runid/g" -e "s;seqid=.*;seqid=${id};g" $script_map_refseq >${script_map_refseq/_MID/_$runid}
   fi
   break
  fi
 done
 if [ "$found" == "0" ] ; then
  : $((++upper_num))
  runid=${upper_num}
  list_runid+="${runid} "
  sed -e "s/MIDNUM/$runid/g" -e "s;seqid=.*;seqid=${id};g" $script_map_refseq >${script_map_refseq/_MID/_$runid}
 fi
done

# prepare SLURM script for multiple alignment (if applicable)
if [ $con_num -gt 0 ] ; then
 align_num=$(ls ${script_align/_AID/_[0-9]*} 2>/dev/null | wc -w)
 alid=$((++align_num))
 sed -e "s/AIDNUM/$alid/g" \
  -e "s;refseq_list=.*;refseq_list=\"${ref_list}\";g" \
  -e "s;contig_list=.*;contig_list=\"${con_list}\";g" \
  $script_align >${script_align/_AID/_$alid}
fi

# workflow of job submissions
# maps to refseq
runid=$(echo $list_runid |cut -d " " -f 1)
jobid_map_refseq=$(  sbatch --parsable                                        ${script_map_refseq/_MID/_$runid} | cut -d ";" -f 1 )
echo Submitted script ${script_map_refseq/_MID/_$runid} with job ID $jobid_map_refseq
for runid in $(echo $list_runid |cut -d " " -f 1 --complement) ; do
 jobid_map_refseq=$( sbatch --parsable --dependency=afterok:$jobid_map_refseq ${script_map_refseq/_MID/_$runid} | cut -d ";" -f 1 )
 echo Submitted script ${script_map_refseq/_MID/_$runid} with job ID $jobid_map_refseq
done
# multiple alignment (if applicable)
if [ $con_num -gt 0 ] ; then
 if [ "$list_runid" != "" ] ; then
  jobid_align=$(      sbatch --parsable --dependency=afterok:$jobid_map_refseq ${script_align/_AID/_$alid}       | cut -d ";" -f 1 )
 else
  jobid_align=$(      sbatch --parsable                                        ${script_align/_AID/_$alid}       | cut -d ";" -f 1 )
 fi
 echo Submitted script ${script_align/_AID/_$alid} with job ID $jobid_align
fi

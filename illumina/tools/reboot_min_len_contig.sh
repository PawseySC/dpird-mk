#!/bin/bash

if [ $# -eq 0 ] ; then
 echo "You need to provide as an argument the new minimum length of contigs to be used for blast and contig mapping. Exiting."
 exit
fi

min_len_contig=$1

bkp_dir="old_min_len_contig"
echo "Creating backup directory $bkp_dir"
mkdir -p $bkp_dir
cp -p 03.assemble.sh \
	contigs_sub.fasta \
	mapped_contigs_sub.bam* \
	depth_contigs_sub.dat \
	consensus_contigs_sub.fasta \
	blast_contigs_sub*.tsv \
	blast_contigs_sub*.xml \
	${bkp_dir}/

if [ $? != "0" ] ; then
 echo "Something went wrong in the backup, double-check directory content and try again. Exiting."
 exit
fi

echo "Removing previous outputs from blast and contig mapping"
rm contigs_sub.fasta \
	mapped_contigs_sub.bam* \
	depth_contigs_sub.dat \
	consensus_contigs_sub.fasta \
	blast_contigs_sub*.tsv \
	blast_contigs_sub*.xml

echo "New minimum length of contigs is : $min_len_contig"
echo "Recreating contigs_sub.fasta with new minimum length"
sed -i "s;^ *min_len_contig=.*;min_len_contig=$min_len_contig;g" 03.assemble.sh
awk -v min_len_contig=$min_len_contig -F _ '{ if( $1 == ">NODE" ){ if( $4 < min_len_contig ) {exit} } ; print }' contigs_ALL.fasta >contigs_sub.fasta

script_map_contigs="04.map_contigs.sh"
script_blast="05.blast.sh"
# map to contigs
jobid_map_contigs=$( sbatch --parsable $script_map_contigs | cut -d ";" -f 1 )
echo Re-submitted script $script_map_contigs with job ID $jobid_map_contigs
# blast
jobid_blast=$(       sbatch --parsable $script_blast       | cut -d ";" -f 1 )
echo Re-submitted script $script_blast with job ID $jobid_blast


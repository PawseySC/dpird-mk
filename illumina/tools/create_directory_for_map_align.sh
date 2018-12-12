#!/bin/bash

if [ $# -eq 0 ] ; then
 echo One argument required: destination directory for the map_align downstream pipe. Exiting.
 exit
fi

dest_dir=$1

mkdir $dest_dir

cp -p clean.fastq.gz \
	consensus_contigs_sub.fasta \
	blast_contigs_sub*.tsv \
	06.map_refseq_MID.sh \
	07.align_AID.sh \
	map_align_pipe.sh \
	${dest_dir}/

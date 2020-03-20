#!/bin/bash
# this script is to be run once only on a computer with Singularity, to install the containers relevant to the workflow

cont_bin="singularity"
module load singularity

packages="
quay.io/biocontainers/fastqc:0.11.7--4
quay.io/biocontainers/bbmap:38.20--h470a237_0
quay.io/biocontainers/spades:3.12.0--1
dpirdmk/samtools:1.9
dpirdmk/bcftools:1.8
quay.io/biocontainers/blast:2.7.1--h96bfa4b_5
quay.io/biocontainers/mafft:7.407--0
"

for p in $packages ; do
 echo "Pulling package " $p ".."
 $cont_bin exec docker://${p} echo pulled
done

exit

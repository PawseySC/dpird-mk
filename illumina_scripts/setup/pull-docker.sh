#!/bin/bash
# this script is to be run once only on a computer with Docker, to install the containers relevant to the workflow

cont_bin="docker"

packages="
quay.io/biocontainers/fastqc:0.11.7--4
quay.io/biocontainers/bbmap:38.20--h470a237_0
quay.io/biocontainers/spades:3.12.0--1
dpirdmk/samtools:1.9
dpirdmk/bcftools:1.9
quay.io/biocontainers/blast:2.7.1--h96bfa4b_5
"

for p in $packages ; do
 echo "Pulling package " $p ".."
 $cont_bin pull $p
done

exit

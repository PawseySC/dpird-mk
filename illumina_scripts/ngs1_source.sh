#!/bin/bash

#fastqc
export fastqc_cont="quay.io/biocontainers/fastqc:0.11.7--4"
export fastqc_bash="shifter run $fastqc_cont bash"
export fastqc="shifter run $fastqc_cont fastqc"

#bbmap
export bbmap_cont="quay.io/biocontainers/bbmap:38.20--h470a237_0"
export bbmap_bash="shifter run $bbmap_cont bash"
export bbduk_sh="shifter run $bbmap_cont bbduk.sh"
export bbmap_sh="shifter run $bbmap_cont bbmap.sh"
export bbmask_sh="shifter run $bbmap_cont bbmask.sh"
export bbmerge_sh="shifter run $bbmap_cont bbmerge.sh"
export bbnorm_sh="shifter run $bbmap_cont bbnorm.sh"
export stats_sh="shifter run $bbmap_cont stats.sh"

#spades
export spades_cont="quay.io/biocontainers/spades:3.12.0--1"
export spades_bash="shifter run $spades_cont bash"
export spades_py="shifter run $spades_cont spades.py"

#samtools
export samtools_cont="marcodelapierre/samtools:1.9"
export samtools_bash="shifter run $samtools_cont bash"
export samtools="shifter run $samtools_cont samtools"
export samtools_pl="shifter run $samtools_cont samtools.pl"
export plot_bamstats="shifter run $samtools_cont plot-bamstats"

#bcftools
export bcftools_cont="marcodelapierre/bcftools:1.9"
export bcftools_bash="shifter run $bcftools_cont bash"
export bcftools="shifter run $bcftools_cont bcftools"
export vcfutils_pl="shifter run $bcftools_cont vcfutils.pl"

#blast
export blast_cont="quay.io/biocontainers/blast:2.7.1--h96bfa4b_5"
export blast_bash="shifter run $blast_cont bash"
export blast_formatter="shifter run $blast_cont blast_formatter"
export blastdb_aliastool="shifter run $blast_cont blastdb_aliastool"
export blastdbcheck="shifter run $blast_cont blastdbcheck"
export blastdbcmd="shifter run $blast_cont blastdbcmd"
export blastdbcp="shifter run $blast_cont blastdbcp"
export blastn="shifter run $blast_cont blastn"
export blastp="shifter run $blast_cont blastp"
export blastx="shifter run $blast_cont blastx"
export convert2blastmask"=shifter run $blast_cont convert2blastmask"
export deltablast="shifter run $blast_cont deltablast"
export makeblastdb="shifter run $blast_cont makeblastdb"
export psiblast="shifter run $blast_cont psiblast"
export rpsblast="shifter run $blast_cont rpsblast"
export rpstblastn="shifter run $blast_cont rpstblastn"
export tblastn="shifter run $blast_cont tblastn"
export tblastx="shifter run $blast_cont tblastx"
export update_blastdb_pl="shifter run $blast_cont update_blastdb.pl"


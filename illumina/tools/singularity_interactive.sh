#!/bin/bash

#fastqc
export fastqc_cont='quay.io/biocontainers/fastqc:0.11.7--4'
alias fastqc_bash='singularity exec docker://$fastqc_cont bash'
alias fastqc='singularity exec docker://$fastqc_cont fastqc'

#bbmap
export bbmap_cont='quay.io/biocontainers/bbmap:38.20--h470a237_0'
alias bbmap_bash='singularity exec docker://$bbmap_cont bash'
alias bbduk_sh='singularity exec docker://$bbmap_cont bbduk.sh'
alias bbmap_sh='singularity exec docker://$bbmap_cont bbmap.sh'
alias bbmask_sh='singularity exec docker://$bbmap_cont bbmask.sh'
alias bbmerge_sh='singularity exec docker://$bbmap_cont bbmerge.sh'
alias bbnorm_sh='singularity exec docker://$bbmap_cont bbnorm.sh'
alias bbsplit_sh='singularity exec docker://$bbmap_cont bbsplit.sh'
alias stats_sh='singularity exec docker://$bbmap_cont stats.sh'

#spades
export spades_cont='quay.io/biocontainers/spades:3.12.0--1'
alias spades_bash='singularity exec docker://$spades_cont bash'
alias spades_py='singularity exec docker://$spades_cont spades.py'

#samtools
export samtools_cont='dpirdmk/samtools:1.9'
alias samtools_bash='singularity exec docker://$samtools_cont bash'
alias samtools='singularity exec docker://$samtools_cont samtools'
alias samtools_pl='singularity exec docker://$samtools_cont samtools.pl'
alias plot_bamstats='singularity exec docker://$samtools_cont plot-bamstats'

#bcftools
export bcftools_cont='dpirdmk/bcftools:1.8'
alias bcftools_bash='singularity exec docker://$bcftools_cont bash'
alias bcftools='singularity exec docker://$bcftools_cont bcftools'
alias vcfutils_pl='singularity exec docker://$bcftools_cont vcfutils.pl'

#blast
export blast_cont='quay.io/biocontainers/blast:2.7.1--h96bfa4b_5'
alias blast_bash='singularity exec docker://$blast_cont bash'
alias blast_formatter='singularity exec docker://$blast_cont blast_formatter'
alias blastdb_aliastool='singularity exec docker://$blast_cont blastdb_aliastool'
alias blastdbcheck='singularity exec docker://$blast_cont blastdbcheck'
alias blastdbcmd='singularity exec docker://$blast_cont blastdbcmd'
alias blastdbcp='singularity exec docker://$blast_cont blastdbcp'
alias blastn='singularity exec docker://$blast_cont blastn'
alias blastp='singularity exec docker://$blast_cont blastp'
alias blastx='singularity exec docker://$blast_cont blastx'
alias convert2blastmask'=singularity exec docker://$blast_cont convert2blastmask'
alias deltablast='singularity exec docker://$blast_cont deltablast'
alias makeblastdb='singularity exec docker://$blast_cont makeblastdb'
alias psiblast='singularity exec docker://$blast_cont psiblast'
alias rpsblast='singularity exec docker://$blast_cont rpsblast'
alias rpstblastn='singularity exec docker://$blast_cont rpstblastn'
alias tblastn='singularity exec docker://$blast_cont tblastn'
alias tblastx='singularity exec docker://$blast_cont tblastx'
alias update_blastdb_pl='singularity exec docker://$blast_cont update_blastdb.pl'


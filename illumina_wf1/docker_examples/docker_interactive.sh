#!/bin/bash

alias docker_it='docker run --rm -it -v $(pwd):/data -w /data'

#fastqc
export fastqc_cont='quay.io/biocontainers/fastqc:0.11.7--4'
alias fastqc_bash='docker_it $fastqc_cont bash'
alias fastqc='docker_it $fastqc_cont fastqc'

#bbmap
export bbmap_cont='quay.io/biocontainers/bbmap:38.20--h470a237_0'
alias bbmap_bash='docker_it $bbmap_cont bash'
alias bbduk_sh='docker_it $bbmap_cont bbduk.sh'
alias bbmap_sh='docker_it $bbmap_cont bbmap.sh'
alias bbmask_sh='docker_it $bbmap_cont bbmask.sh'
alias bbmerge_sh='docker_it $bbmap_cont bbmerge.sh'
alias bbnorm_sh='docker_it $bbmap_cont bbnorm.sh'
alias bbsplit_sh='docker_it $bbmap_cont bbsplit.sh'
alias stats_sh='docker_it $bbmap_cont stats.sh'

#spades
export spades_cont='quay.io/biocontainers/spades:3.12.0--1'
alias spades_bash='docker_it $spades_cont bash'
alias spades_py='docker_it $spades_cont spades.py'

#samtools
export samtools_cont='dpirdmk/samtools:1.9'
alias samtools_bash='docker_it $samtools_cont bash'
alias samtools='docker_it $samtools_cont samtools'
alias samtools_pl='docker_it $samtools_cont samtools.pl'
alias plot_bamstats='docker_it $samtools_cont plot-bamstats'

#bcftools
export bcftools_cont='dpirdmk/bcftools:1.9'
alias bcftools_bash='docker_it $bcftools_cont bash'
alias bcftools='docker_it $bcftools_cont bcftools'
alias vcfutils_pl='docker_it $bcftools_cont vcfutils.pl'

#blast
export blast_cont='quay.io/biocontainers/blast:2.7.1--h96bfa4b_5'
alias blast_bash='docker_it $blast_cont bash'
alias blast_formatter='docker_it $blast_cont blast_formatter'
alias blastdb_aliastool='docker_it $blast_cont blastdb_aliastool'
alias blastdbcheck='docker_it $blast_cont blastdbcheck'
alias blastdbcmd='docker_it $blast_cont blastdbcmd'
alias blastdbcp='docker_it $blast_cont blastdbcp'
alias blastn='docker_it $blast_cont blastn'
alias blastp='docker_it $blast_cont blastp'
alias blastx='docker_it $blast_cont blastx'
alias convert2blastmask'=docker_it $blast_cont convert2blastmask'
alias deltablast='docker_it $blast_cont deltablast'
alias makeblastdb='docker_it $blast_cont makeblastdb'
alias psiblast='docker_it $blast_cont psiblast'
alias rpsblast='docker_it $blast_cont rpsblast'
alias rpstblastn='docker_it $blast_cont rpstblastn'
alias tblastn='docker_it $blast_cont tblastn'
alias tblastx='docker_it $blast_cont tblastx'
alias update_blastdb_pl='docker_it $blast_cont update_blastdb.pl'


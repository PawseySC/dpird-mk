#!/bin/bash

#fastqc
export fastqc_cont='quay.io/biocontainers/fastqc:0.11.7--4'
alias fastqc_bash='shifter run $fastqc_cont bash'
alias fastqc='shifter run $fastqc_cont fastqc'

#bbmap
export bbmap_cont='quay.io/biocontainers/bbmap:38.20--h470a237_0'
alias bbmap_bash='shifter run $bbmap_cont bash'
alias bbduk_sh='shifter run $bbmap_cont bbduk.sh'
alias bbmap_sh='shifter run $bbmap_cont bbmap.sh'
alias bbmask_sh='shifter run $bbmap_cont bbmask.sh'
alias bbmerge_sh='shifter run $bbmap_cont bbmerge.sh'
alias bbnorm_sh='shifter run $bbmap_cont bbnorm.sh'
alias bbsplit_sh='shifter run $bbmap_cont bbsplit.sh'
alias stats_sh='shifter run $bbmap_cont stats.sh'

#spades
export spades_cont='quay.io/biocontainers/spades:3.12.0--1'
alias spades_bash='shifter run $spades_cont bash'
alias spades_py='shifter run $spades_cont spades.py'

#samtools
export samtools_cont='dpirdmk/samtools:1.9'
alias samtools_bash='shifter run $samtools_cont bash'
alias samtools='shifter run $samtools_cont samtools'
alias samtools_pl='shifter run $samtools_cont samtools.pl'
alias plot_bamstats='shifter run $samtools_cont plot-bamstats'

#bcftools
export bcftools_cont='dpirdmk/bcftools:1.8'
alias bcftools_bash='shifter run $bcftools_cont bash'
alias bcftools='shifter run $bcftools_cont bcftools'
alias vcfutils_pl='shifter run $bcftools_cont vcfutils.pl'

#blast
export blast_cont='quay.io/biocontainers/blast:2.7.1--h96bfa4b_5'
alias blast_bash='shifter run $blast_cont bash'
alias blast_formatter='shifter run $blast_cont blast_formatter'
alias blastdb_aliastool='shifter run $blast_cont blastdb_aliastool'
alias blastdbcheck='shifter run $blast_cont blastdbcheck'
alias blastdbcmd='shifter run $blast_cont blastdbcmd'
alias blastdbcp='shifter run $blast_cont blastdbcp'
alias blastn='shifter run $blast_cont blastn'
alias blastp='shifter run $blast_cont blastp'
alias blastx='shifter run $blast_cont blastx'
alias convert2blastmask'=shifter run $blast_cont convert2blastmask'
alias deltablast='shifter run $blast_cont deltablast'
alias makeblastdb='shifter run $blast_cont makeblastdb'
alias psiblast='shifter run $blast_cont psiblast'
alias rpsblast='shifter run $blast_cont rpsblast'
alias rpstblastn='shifter run $blast_cont rpstblastn'
alias tblastn='shifter run $blast_cont tblastn'
alias tblastx='shifter run $blast_cont tblastx'
alias update_blastdb_pl='shifter run $blast_cont update_blastdb.pl'


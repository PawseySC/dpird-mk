#!/bin/bash -l
export OMP_NUM_THREADS=16

shopt -s expand_aliases
alias docker_cmd='docker run --rm -v $(pwd):/data -w /data'

bbmap_cont="quay.io/biocontainers/bbmap:38.20--h470a237_0"
samtools_cont="dpirdmk/samtools:1.9"
bcftools_cont="dpirdmk/bcftools:1.8"


# alignment (sorted BAM file as final output)
echo TIME map_contigs bbmap start $(date)
docker_cmd $bbmap_cont bbmap.sh \
	in=clean.fastq.gz ref=contigs_sub.fasta out=mapped_contigs_sub_unsorted.sam \
	k=13 maxindel=16000 ambig=random \
	threads=$OMP_NUM_THREADS
echo TIME map_contigs bbmap end $(date)

docker_cmd $samtools_cont samtools \
    view -b -o mapped_contigs_sub_unsorted.bam mapped_contigs_sub_unsorted.sam
echo TIME map_contigs sam view end $(date)

docker_cmd $samtools_cont samtools \
    sort -o mapped_contigs_sub.bam mapped_contigs_sub_unsorted.bam
echo TIME map_contigs sam sort end $(date)

docker_cmd $samtools_cont samtools \
    index mapped_contigs_sub.bam
echo TIME map_contigs sam index end $(date)

# depth data into text file
docker_cmd $samtools_cont samtools \
	depth -aa mapped_contigs_sub.bam >depth_contigs_sub.dat
echo TIME map_contigs sam depth end $(date)

# creating consensus sequence
docker_cmd $bcftools_cont bcftools \
	mpileup -Ou -f contigs_sub.fasta mapped_contigs_sub.bam \
	| docker_cmd -i $bcftools_cont bcftools \
	call --ploidy 1 -mv -Oz -o calls_contigs_sub.vcf.gz
echo TIME map_contigs bcf mpileup/call end $(date)

docker_cmd $bcftools_cont bcftools \
	tabix calls_contigs_sub.vcf.gz
echo TIME map_contigs bcf tabix end $(date)

docker_cmd $bcftools_cont bcftools \
	consensus -f contigs_sub.fasta -o consensus_contigs_sub.fasta calls_contigs_sub.vcf.gz
echo TIME map_contigs bcf consensus end $(date)

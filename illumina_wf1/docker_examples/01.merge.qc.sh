#!/bin/bash

alias docker_cmd='docker run --rm -v $(pwd):/data -w /data'

bbmap_cont="quay.io/biocontainers/bbmap:38.20--h470a237_0"
fastqc_cont="quay.io/biocontainers/fastqc:0.11.7--4"


# running
echo TIME merge start $(date)
docker_cmd $bbmap_cont bbmerge.sh \
	in1=R1.fastq.gz in2=R2.fastq.gz \
	out=merged.fastq.gz
echo TIME merge end $(date)

docker_cmd $fastqc_cont fastqc merged.fastq.gz
echo TIME qc end $(date)

#!/bin/bash
module load shifter
samtools_cont="dpirdmk/samtools:1.9"

if [ "$#" -lt 1 ] ; then
 echo "Argument required: list of sequence file names to be reverse-complemented. Exiting."
 exit
fi

for f in "$@" ; do
 pre=${f%.*}
 runid=${pre#*_}
 pre=${pre%_*}
 suf=${f#*.}
 if [ "${runid}" == "${pre}" ] ; then
  out=${pre}_rc.$suf
 else
  out=${pre}_999${runid}.$suf
 fi
 shifter run $samtools_cont samtools faidx \
	-i -o $out  \
	$f $(grep '^>' $f | tr -d '>')
done

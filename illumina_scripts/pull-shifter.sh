#!/bin/bash
# this script is to be run once only on a computer with Shifter, to install the containers relevant to the workflow

cont_bin="shifter"
module load shifter

packages="
quay.io/biocontainers/fastqc:0.11.7--4
quay.io/biocontainers/bbmap:38.20--h470a237_0
quay.io/biocontainers/spades:3.12.0--1
marcodelapierre/samtools:1.9
marcodelapierre/bcftools:1.9
quay.io/biocontainers/blast:2.7.1--h96bfa4b_5
"

# for biocontainers with shifter, you will need an account at quay.io , where biocontainers are hosted
# for your own security, delete your credentials from this script once you have run it!
quser=""
qpassword=""

for p in $packages ; do

 echo "Pulling package " $p ".."

 if [ "${p:0:7}" == "quay.io" ] ; then
   $cont_bin pull --login $p << EOF
$quser
$qpassword
EOF

 else

  $cont_bin pull $p

 fi

done

exit

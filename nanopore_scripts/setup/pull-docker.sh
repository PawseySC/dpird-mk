#!/bin/bash
# this script is to be run once only on a computer with Docker, to install the containers relevant to the workflow

cont_bin="docker"

packages="
genomicpariscentre/albacore:2.3.3
quay.io/biocontainers/nanopolish:0.10.2--h78a5b34_0
"

for p in $packages ; do
 echo "Pulling package " $p ".."
 $cont_bin pull $p
done

exit

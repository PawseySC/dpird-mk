#!/bin/bash
# this script is to be run once only on a computer with Shifter, to install the containers relevant to the workflow

cont_bin="shifter"
module load shifter

packages="
genomicpariscentre/albacore:2.3.3
quay.io/biocontainers/nanopolish:0.10.2--h78a5b34_0
"

# for biocontainers with shifter, you will need an account at quay.io , where biocontainers are hosted
# for your own security, delete your credentials from this script once you have run it!
quser=""
qpassword=""

for p in $packages ; do

 echo "Pulling package " $p ".."

 if [ "${p:0:7}" == "quay.io" ] ; then
   sg $PAWSEY_PROJECT -c "$cont_bin pull --login $p" << EOF
$quser
$qpassword
EOF

 else

  sg $PAWSEY_PROJECT -c "$cont_bin pull $p"

 fi

done

exit

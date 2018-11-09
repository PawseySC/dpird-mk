#!/bin/bash

echo "WARNING: this is a script to delete files. This can results in unwanted data loss. Handle with care!"

dir=$(pwd)
rootdir=${dir#/}
rootdir=${rootdir%%/*}

if [ "$rootdir" != "scratch" ] ; then
 echo ""
 echo "Current location "$dir" is not under scratch. Exiting."
 echo "NOTE: no files have been deleted."
 exit
fi

if [ ! -s $dir/upstream_pipe.sh ] && [ ! -s $dir/nanopore_pipe.sh ] ; then
 echo ""
 echo "Current location "$dir" seems not to be an illumina/nanopore workflow scratch directory. Exiting."
 echo "NOTE: no files have been deleted."
 exit
fi

echo ""
echo "About to delete the contents of the following directory:"
echo "$dir"
echo ""
echo "Are you sure you want to proceed? [yes | NO]"

read answer
answer=$( echo $answer | tr '[:upper:]' '[:lower:]' )

if [ "$answer" == "y" ] || [ "$answer" == "yes" ] ; then

 echo ""
 rm -r ${dir}/*
 echo "KABOOOM!"
 if [ "$?" == "0" ] ; then
  echo "DONE: Files in "$dir" have been deleted. Exiting."
 else
  echo "NOTE: not all files in "$dir" have been deleted. Have a look. Exiting."
 fi
 exit

else

 echo ""
 echo "NOTE: you have decided not to proceed. No files have been deleted. Exiting."
 exit

fi

exit

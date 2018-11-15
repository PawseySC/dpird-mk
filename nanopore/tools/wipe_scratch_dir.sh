#!/bin/bash

echo "WARNING: this is a script to delete files. This can results in unwanted data loss. Handle with care!"

dir=$(pwd)
dirg=$dir
rootdir=${dir#/}
rootdir=${rootdir%%/*}

if [ "$rootdir" != "scratch" ] ; then
 if [ "$rootdir" == "group" ] ; then
  echo ""
  echo "Current location "$dir" is under group."
  dir=${dir/group/scratch}
  echo "Pipeline scripts still searched in "$dirg
  echo "Switching to same directory structure under scratch for deletion: "$dir
 else
  echo ""
  echo "Current location "$dir" is not under scratch nor group. Exiting."
  echo "NOTE: no files have been deleted."
  exit
 fi
fi

if [ ! -s $dirg/upstream_pipe.sh ] && [ ! -s $dirg/nanopore_pipe.sh ] ; then
 echo ""
 echo "Current location "$dirg" seems not to be an illumina/nanopore workflow scratch directory. Exiting."
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

#!/bin/bash

echo "WARNING: this is a script to delete files. This can result in unwanted data loss. Handle with care!"

dir=$(pwd)
dirgr=${dir/scratch/group}
dirsc=${dir/group/scratch}
rootdir=${dir#/}
rootdir=${rootdir%%/*}

if [ "$rootdir" != "scratch" ] && [ "$rootdir" != "group" ] ; then
 echo ""
 echo "Current location "$dir" is not under scratch nor group. Exiting."
 echo "NOTE: no files have been deleted."
 exit
fi

if [ ! -s "$dirgr/upstream_pipe.sh" ] && [ ! -s "$dirgr/nanopore_pipe.sh" ] ; then
 echo ""
 echo "Current location "$dirsc" seems not to be an illumina/nanopore workflow scratch directory. Exiting."
 echo "NOTE: no files have been deleted."
 exit
fi

echo ""
echo "Group   dir is: "$dirgr
echo "Scratch dir is: "$dirsc
echo ""
echo "About to delete the contents of the following directory:"
echo "$dirsc"
echo ""
echo "Are you sure you want to proceed? [yes | NO]"

read answer
answer=$( echo $answer | tr '[:upper:]' '[:lower:]' )

if [ "$answer" == "y" ] || [ "$answer" == "yes" ] ; then

 echo ""
 rm -r ${dirsc}/*
 echo "KABOOOM!"
 if [ "$?" == "0" ] ; then
  echo "DONE: Files in "$dirsc" have been deleted. Exiting."
 else
  echo "NOTE: not all files in "$dirsc" have been deleted. Have a look. Exiting."
 fi
 exit

else

 echo ""
 echo "NOTE: you have decided not to proceed. No files have been deleted. Exiting."
 exit

fi

exit

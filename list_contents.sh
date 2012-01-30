#!/bin/bash

# Script name:  First-level contents of directory
# Description:  Divides directories from files, prints files if a directories
#               or prints lines if a file.
#
# Usage:        ./list_contents.sh <a directory>
# Parameters:   <a directory> is exactly one, continuous, valid directory
#               VERY IMPORTANT directories should have no trailing backslash:
#               good: /home/direc
#               bad:  /home/direc/


# if the number of params is exactly 1 and the param is a directory
if [ $# -eq 1 -a -d $1 ]
then
    for direc in $( ls -d $1/*/ );
    do
	numfiles=$( ls -1 $direc | wc -l )
	echo "Directory $direc has $numfiles files"
    done

    for file in $( ls -l $1/* | grep "^-" | awk '{print $8;}' );
    do
	numlines=$( wc -l $file | awk '{print $1;}' )
	echo "File $file has $numlines lines"
    done
fi

# if the number of params is not exactly 1 or the param is not a directory 
if [ $# -ne 1 -o ! -d $1 ]
then
    echo "Uh oh, you didn't give one argument that is a directory"
fi

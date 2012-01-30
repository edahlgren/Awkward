#!/bin/bash

# Script name:   Home logger
# Description:   Records the date and kilobyte size of your home
#                directory
# Usage:         ./log.sh  
# Parameters:    none

# store your home directory here
home="/home/edahlgren/cmsc16200labs/hw01"
# code in the location of your usage.log file
log="$home/usage.log"

# get the output of the data command
datenow=$( date )

# use du to get the size of all files in home and get
size=$( du $home | grep "$home$" | awk '{print $1}' )

# append this to the end of your log file, the lab order specs
echo "[$datenow] $home $size" >> $log

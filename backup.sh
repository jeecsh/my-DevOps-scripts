#!/bin/bash

# Check if the number of arguments is correct
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# Check if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

targetDirectory=$1
destinationDirectory=$2

echo "argument1 is $1"
echo "argument2 is $2"

currentTS=$(date +%s)

backupFileName="backup-[$currentTS].tar.gz"

origAbsPath=$(pwd)

cd "$destinationDirectory" 
destDirAbsPath=$(pwd)

cd "$origAbsPath" 
cd "$targetDirectory"

yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

for file in $(ls)
do
if [ $(date -r "$file" +%s) -gt "$yesterdayTS" ]
  then
   toBackup+=($file)
  fi
done

tar -czvf "$backupFileName" "${toBackup[@]}"

mv $backupFileName $destDirAbsPath


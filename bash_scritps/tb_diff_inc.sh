#!/bin/bash

## Purpose: Report difference between two testbench directories
## Usage: ./tb_diff_inc.sh <dir_old> <dir_new>

echo "## COMPARING \"$1\" and \"$2\" ##" 
echo "----------------------------"  

## Check if outputfolder exists
if [[ ! -d diff_patches ]]
then
 echo Creating diff_patches/
 mkdir diff_patches
echo "----------------------------"  
fi
echo "To transform files from \"$1\" into \"$2\" run the following commands:" > diff_patches/README.txt
echo "" > diff_patches/README.txt

## Report file header
echo "#################" > rpt_diff.rpt
echo "## Diff Output ##" >> rpt_diff.rpt
echo "#################" >> rpt_diff.rpt

## Filter files with differences
readarray -t diff_output < <(diff -r -q $1 $2 | sort | grep differ )

## Write output report
echo " " >> rpt_diff.rpt
echo " " >> rpt_diff.rpt
echo Incremental differences between folders: $1 $2 >> rpt_diff.rpt

for line in "${diff_output[@]}"
do 
  echo $line >> rpt_diff.rpt
done

## Creates a diff command for each file
for line in "${diff_output[@]}"
do 
## Parse file names
 path=`echo $line | awk '{print $4}'`
 file_name=`basename  $path`
 diff_comand=`echo $line | awk '{print "diff -u",$2,$4}'`

## Write patch file
 eval $diff_comand > diff_patches/${file_name}.patch
 
## Write in report file
 echo " " >> rpt_diff.rpt
 echo " " >> rpt_diff.rpt
 echo $line | awk '{print "diff -u",$2,$4}'  >> rpt_diff.rpt
 eval $diff_comand >> rpt_diff.rpt
 echo  patch $file_name  ${file_name}.patch >> diff_patches/README.txt
 echo File diff_patches/${file_name}.patch created ! 
done

echo "----------------------------"  
echo Final report in rpt_diff.rpt
echo Patch file in diff_patches/

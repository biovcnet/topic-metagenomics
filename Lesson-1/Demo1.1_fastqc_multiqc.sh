#!/bin/bash

cd data

# run a loop to gunzip all fastq.gz files
for file in *.fastq.gz
do
gunzip ${file}
done

# make a directory for the output
mkdir 00_FastQC

# run a loop to run fastqc on all fastq files
for file in *.fastq;
do
fastqc ${file} -o 00_FastQC/
done

# run multiqc on all fastqc output files
multiqc .

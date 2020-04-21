#!/bin/bash
set -e #fail on any errors

## This script goes with the tutorial for Lesson2
## You can open the Binder here: https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab
## click "Terminal" to open the terminal emulator, which will also install this repo

## This tutorial will:
# 1) demonstrate the usage of Kraken2 for taxonomic classification using kmers
# 2) demonstrate the usage of bbtools/bbduk.sh for adapter trimming using kmers
# 3) demonstrate the usage of Krona for visualization of classification results

## KRAKEN2
# the full kraken2 manual can be found here: https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown

# due to time, space, and memory constraints on Binder, 
# we're going to use the SILVA rRNA database rather than 
# a more complete database containing millions of genes/proteins

# install the latest version of Kraken2 (conda install doesn't work due to ftp problems as of 4/16/2020)
bash Lesson-2/install-kraken2.sh

# add kraken executables to $PATH
export PATH=$PATH:`pwd`/kraken2-2.0.9-beta/

# add taxonomy database to $KRAKEN2_DB_PATH
export KRAKEN2_DB_PATH=`pwd`/kraken2-2.0.9-beta/

# move into data directory
cd data

# run kraken2 on forward reads from one sample using the silva database
kraken2 --db silva BOX-10-56-15377_S368_L001_R1_001.fastq.gz

# the output format looks like this
#C       M03580:108:000000000-CMLF3:1:2119:21705:24840   26856   301     0:70 1:5 0:40 44130:2 0:131 3:5 26856:2 0:6 26856:3 3303:1 3:2
#_C_lassified or _U_nclassified
#        Sequence ID
#                                                        taxonomy ID
#                                                                sequence length
#                                                                        the first 70 kmers mapped to taxid 0
#                                                                            the next 5 kmers mapped to taxid 1
#                                                                                      2 kmers mapped to taxid 44130

# run kraken2 and return the classifications in a Report format as 'kraken2_report.tsv' 
# with the raw data redirected to 'kraken2_raw.txt'
kraken2 --db silva --report kraken2_report.tsv BOX-10-56-15377_S368_L001_R1_001.fastq.gz > kraken2_raw.txt

# view the report
head kraken2_report.tsv

# notice that most of the reads were classified despite these samples being from shotgun metagenomes rather than amplicons
# that seems a little fishy, doesn't it?

## BBDUK
# the full manual for bbduk can be found here: https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbduk-guide/
# bbtools was installed using conda

# let's try trimming the sequences first using bbduk
# bbduk uses a kmer-matching approach to identify unwanted DNA strings (in this case, sequencing adapters) and then trim the reads
bbduk.sh in=BOX-10-56-15377_S368_L001_R1_001.fastq.gz out=trimmed_BOX-10-56-15377_S368_L001_R1_001.fastq.gz ref=adapters ktrim=r

# then run kraken2 again on the trimmed reads, and redirect the raw output to /dev/null
kraken2 --db silva --report kraken2_report_trimmed.tsv trimmed_BOX-10-56-15377_S368_L001_R1_001.fastq.gz > /dev/null

# view the report, notice that many fewer sequences were classified
head kraken2_report_trimmed.tsv

# kraken2 has a 'confidence' flag that is a value in the range of 0-1
kraken2 --db silva --confidence 0.50 --report kraken2_report_trimmed_confidence.tsv trimmed_BOX-10-56-15377_S368_L001_R1_001.fastq.gz > /dev/null

# view the report, notice that fewer than half of the sequences were confidently classified
head kraken2_report_trimmed_confidence.tsv

# run kraken2 and return the classifications in a MetaPhlan Report format as 'kraken2_report_mpa.tsv'
kraken2 --db silva --use-mpa-style --report kraken2_report_trimmed_mpa.tsv trimmed_BOX-10-56-15377_S368_L001_R1_001.fastq.gz > /dev/null

# view the report
head kraken2_report_trimmed_mpa.tsv

# trim the paired end sequences using bbduk

# bbtools author Brian Bushnell recommends the following options for adapter trimming
# ref=adapters # use the built in adapters.fa file containing all known Illumina adapters
# ktrim=r      # trim from the right (3') end of the sequence
# k=23         # use a kmer length of 23 bp
# mink=11      # allow a minimum kmer length of 11 bp at the end of the sequence
# hdist=1      # allow a maximum of 1 mismatch
# tbo          # trim by overlap
# tpe          # trim both reads to be the same length
# ow=t         # allow overwriting of existing files

bbduk.sh in=BOX-10-56-15377_S368_L001_R1_001.fastq.gz in2=BOX-10-56-15377_S368_L001_R2_001.fastq.gz out=trimmed_BOX-10-56-15377_S368_L001_R1_001.fastq.gz out2=trimmed_BOX-10-56-15377_S368_L001_R2_001.fastq.gz ref=adapters ktrim=r k=23 mink=11 hdist=1 tpe tbo ow=t

# run kraken2 on paired end data
kraken2 --db silva --report kraken2_report_trimmed_paired.tsv --paired trimmed_BOX-10-56-15377_S368_L001_R1_001.fastq.gz trimmed_BOX-10-56-15377_S368_L001_R2_001.fastq.gz > /dev/null

# view the report
head kraken2_report_trimmed_paired.tsv

# sort the report first by taxonomic level and then descending order of matches, then filter for only Genera 
sort -k4,4 -k2,2rn kraken2_report_trimmed_paired.tsv  | grep G | head

# run a loop to do adapter trimming and kraken2 classification for all samples
rm trimmed*
for prefix in `ls *.gz | cut -f1 -d'_' | sort -u`; do
echo $prefix
read1=( ${prefix}*_R1_001.fastq.gz ) #the parentheses assign the globbed filename to an array (of length 1)
read2=( ${prefix}*_R2_001.fastq.gz )

bbduk.sh in=${read1} in2=${read2} out=trimmed_${read1} out2=trimmed_${read2} ref=adapters ktrim=r k=23 mink=11 hdist=1 tbo ow=t
kraken2 --db silva --report kraken2_report_paired_${prefix}.tsv --paired trimmed_${read1} trimmed_${read2} > /dev/null
done

## KRONA
# the full Krona manual can be found here: https://github.com/marbl/Krona/wiki/KronaTools
# Krona was installed using conda

#to use the SILVA taxonomy we installed for Kraken2:
ktUpdateTaxonomy.sh --only-build ~/topic-metagenomics/kraken2-2.0.9-beta/silva/taxonomy/

# now run Krona on each output file
for prefix in `ls trimmed_*.gz | cut -f2 -d'_' | sort -u`; do
ktImportTaxonomy -o krona_${prefix}.html -t 5 -m 3 -tax ~/topic-metagenomics/kraken2-2.0.9-beta/silva/taxonomy/ kraken2_report_paired_${prefix}.tsv
done

# in the file explorer on the left, navigate to the topic-metagenomics/data directory
# double click one of the Krona output files to view it
# click "Trust HTML" in the upper left of the window that opens up

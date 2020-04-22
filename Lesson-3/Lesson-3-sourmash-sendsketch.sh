#!/bin/bash

cd data

#Download a genome from genbank:
curl -L -o shewanella.fa.gz http://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/178/875/GCF_000178875.2_ASM17887v2/GCF_000178875.2_ASM17887v2_genomic.fna.gz

#Compute a signature for this genome:
sourmash compute -k 31 --scaled=1000 shewanella.fa.gz

# take a look at the signatures
cat shewanella.fa.gz.sig | tr ',' '\n' | head -n20

# Building your own LCA (Last Common Ancestor) database

# Download some pre-computed signatures:
curl -L https://osf.io/bw8d7/download?version=1 -o delmont-subsample-sigs.tar.gz
tar xzf delmont-subsample-sigs.tar.gz

# Next, grab the associated taxonomy spreadsheet
curl -O -L https://github.com/ctb/2017-sourmash-lca/raw/master/tara-delmont-SuppTable3.csv

#convert DOS line endings to UNIX line endings
sed -i 's/\r/\n/g' tara-delmont-SuppTable3.csv

# Build a sourmash LCA database named delmont.lca.json:
sourmash lca index -f tara-delmont-SuppTable3.csv delmont.lca.json delmont-subsample-sigs/*.sig

# Using the LCA database to classify signatures
# We can now use delmont.lca.json to classify signatures with k-mers according to the database we just created. 
# (Note, the database is completely self-contained at this point.)

# Let’s classify a single signature:
sourmash lca classify --db delmont.lca.json --query shewanella.fa.gz.sig

# and you should see:

# == This is sourmash version 3.2.3. ==
# == Please cite Brown and Irber (2016), doi:10.21105/joss.00027. ==
# loaded 1 LCA databases. ksize=31, scaled=10000
# finding query signatures...
# outputting classifications to -
# ID,status,superkingdom,phylum,class,order,family,genus,species,strain
# "NC_016901.1 Shewanella baltica OS678, complete sequence",nomatch,,,,,,,,file 1 of 1)
# classified 1 signatures total

# You can classify a bunch of signatures and also specify an output location for the CSV:
sourmash lca classify --db delmont.lca.json --query delmont-subsample-sigs/*.sig -o delmont_out.csv


# The lca classify command supports multiple databases as well as multiple queries;
# e.g. sourmash lca classify --db delmont.lca.json other.lca.json will classify based on the combination of taxonomies in the two databases.


# Let's generate signatures for some metagenomic reads and classify them
# but first we'll clean them up a bit with bbduk
for prefix in `ls *.fastq.gz | cut -f1 -d'_' | sort -u`; do 

  R1=( ${prefix}*_R1_*.gz
  R1=( ${prefix}*_R2_*.gz
  
  # Remove optical duplicates
  # This means they are Illumina reads within a certain distance on the flowcell.
  clumpify.sh in1=$R1 in2=$R2 out=clumped.fq.gz dedupe optical ow=t

  # Remove low-quality regions by flowcell tile
  # All reads within a small unit of area called a micro-tile are averaged, then the micro-tile is either retained or discarded as a unit.
  filterbytile.sh in=clumped.fq.gz out=filtered_by_tile.fq.gz ow=t
  
  #Trim adapters
  # 'ordered' means to maintain the input order as produced by clumpify.sh
  bbduk.sh in=filtered_by_tile.fq.gz out=trimmed.fq.gz ktrim=r k=23 mink=11 hdist=1 tbo tpe minlen=70 ref=adapters ordered ow=t

  #Remove synthetic artifacts and spike-ins by kmer-matching
  # 'cardinality' will generate an accurate estimation of the number of unique kmers in the dataset using the LogLog algorithm
  bbduk.sh in=trimmed.fq.gz out=filtered.fq.gz k=31 ref=artifacts,phix ordered cardinality ow=t
  
  #Quality-trim and entropy filter the remaining reads.
  # 'entropy' means to filter out reads with low complexity
  # 'maq' is 'mininum average quality' to filter out overall poor reads
  bbduk.sh in=filtered.fq.gz out=qtrimmed_${file}.fq.gz qtrim=r trimq=10 minlen=70 ordered maxns=0 maq=8 entropy=.95 ow=t
  
  sourmash compute -k 31 --scaled=1000 qtrimmed_${file}.fq.gz
done

# Classify all of the signatures using the Delmont MAGs
sourmash lca classify --db delmont.lca.json --query *.sig -o meta_out.csv

# You can also summarize the taxonomic distribution of the content with lca summarize:
sourmash lca summarize --db delmont.lca.json --query *.sig

#which will show you:

# loaded 1 LCA databases. ksize=31, scaled=10000
# finding query signatures...
# ... loading CAT0113.0315.DNA_7 HWI-M02034:158:000000000-ADTW0:1:1101:17175:1474 1:N:0:TGACAT orig_bc=AAGCC new_bc=AAGCC bc_diffs=0 (f... loading CAT0113.0315.DNA_7 HWI-M02034:158:000000000-ADTW0:1:1101:17175:1474 2:N:0:TGACAT orig_bc=AAGCC new_bc=AAGCC bc_diffs=0 (floaded 14 signatures from 14 files total.
# 0.1%     12   Bacteria;Cyanobacteria;Chroococcales;Chroococcales;Cyanobium
# 0.1%     12   Bacteria;Cyanobacteria;Chroococcales;Chroococcales
# 0.1%     12   Bacteria;Cyanobacteria;Chroococcales
# 0.1%     12   Bacteria;Cyanobacteria
# 0.1%     12   Bacteria
# 0.1%      9   Eukaryota;Chlorophyta;Prasinophyceae;Mamiellales;Mamiellaceae;Micromonas
# 0.1%      9   Eukaryota;Chlorophyta;Prasinophyceae;Mamiellales;Mamiellaceae
# 0.1%      9   Eukaryota;Chlorophyta;Prasinophyceae;Mamiellales
# 0.1%      9   Eukaryota;Chlorophyta;Prasinophyceae
# 0.1%      9   Eukaryota;Chlorophyta
# 0.1%      9   Eukaryota

#You can also specify multiple databases and multiple query signatures on the command line; separate them with --db or --query.

 --threshold-bp 99
# And if you want to do an all-vs-all comparison for all signatures:
for sig in *.sig; do 
  sourmash gather ${sig} `ls *.sig | grep -v ${sig}`
done




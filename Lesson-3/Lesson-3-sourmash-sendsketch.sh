#!/bin/bash

cd data

# Building your own LCA database
# (This is an abbreviated version of this blog post, updated to use the sourmash lca commands.)

# Download some pre-computed signatures:

curl -L https://osf.io/bw8d7/download?version=1 -o delmont-subsample-sigs.tar.gz
tar xzf delmont-subsample-sigs.tar.gz

# Next, grab the associated taxonomy spreadsheet

curl -O -L https://github.com/ctb/2017-sourmash-lca/raw/master/tara-delmont-SuppTable3.csv

#convert DOS line endings to UNIX line endings

sed -i 's/\r/\n/g' tara-delmont-SuppTable3.csv

# replace 'na' with 'sp.' as species to avoid sourmash error

sed -i 's/na$/sp./' tara-delmont-SuppTable3.csv

# Build a sourmash LCA database named delmont.lca.json:

sourmash lca index tara-delmont-SuppTable3.csv delmont.lca.json delmont-subsample-sigs/*.sig

# Using the LCA database to classify signatures
# We can now use delmont.lca.json to classify signatures with k-mers according to the database we just created. (Note, the database is completely self-contained at this point.)

# Let’s classify a single signature:

sourmash lca classify --db delmont.lca.json --query delmont-subsample-sigs/TARA_RED_MAG_00003.fa.gz.sig

# and you should see:

# loaded 1 databases for LCA use.
# ksize=31 scaled=10000
# outputting classifications to stdout
# ID,status,superkingdom,phylum,class,order,family,genus,species
# TARA_RED_MAG_00003,found,Bacteria,Proteobacteria,Gammaproteobacteria,,,,
# classified 1 signatures total
# You can classify a bunch of signatures and also specify an output location for the CSV:

sourmash lca classify --db delmont.lca.json --query delmont-subsample-sigs/*.sig -o out.csv

# The lca classify command supports multiple databases as well as multiple queries; e.g. sourmash lca classify --db delmont.lca.json other.lca.json will classify based on the combination of taxonomies in the two databases.


#Next, download a genbank LCA database for k=31:

curl -L -o genbank-k31.lca.json.gz https://osf.io/4f8n3/download

#Download a random genome from genbank:

curl -L -o some-genome.fa.gz http://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/178/875/GCF_000178875.2_ASM17887v2/GCF_000178875.2_ASM17887v2_genomic.fna.gz

#Compute a signature for this genome:

sourmash compute -k 31 --scaled=1000 --name-from-first some-genome.fa.gz

#Now, classify the signature with sourmash lca classify,

sourmash lca classify --db genbank-k31.lca.json.gz --query some-genome.fa.gz.sig

#and this will give you a taxonomic identification of your genome bin, classified using all of the genbank microbial genomes:

#loaded 1 LCA databases. ksize=31, scaled=10000
#finding query signatures...
#outputting classifications to stdout
#ID,status,superkingdom,phylum,class,order,family,genus,species,strain
#... classifying NC_016901.1 Shewanella baltica OS678, complete genome (file 1 of"NC_016901.1 Shewanella baltica OS678, complete genome",found,Bacteria,Proteobacteria,Gammaproteobacteria,Alteromonadales,Shewanellaceae,Shewanella,Shewanella baltica,
#classified 1 signatures total

#You can also summarize the taxonomic distribution of the content with lca summarize:

sourmash lca summarize --db genbank-k31.lca.json.gz --query some-genome.fa.gz.sig

#which will show you:

#loaded 1 LCA databases. ksize=31, scaled=10000
#finding query signatures...
#loaded 1 signatures from 1 files total.
#97.9%   520   Bacteria;Proteobacteria;Gammaproteobacteria;Alteromonadales;Shewanellaceae;Shewanella
#97.9%   520   Bacteria;Proteobacteria;Gammaproteobacteria;Alteromonadales;Shewanellaceae
#97.9%   520   Bacteria;Proteobacteria;Gammaproteobacteria;Alteromonadales
#99.6%   529   Bacteria;Proteobacteria;Gammaproteobacteria
#99.6%   529   Bacteria;Proteobacteria
#99.6%   529   Bacteria
#45.4%   241   Bacteria;Proteobacteria;Gammaproteobacteria;Alteromonadales;Shewanellaceae;Shewanella;Shewanella baltica

#To apply this to your own genome(s), replace some-genome.fa.gz above with your own filename(s).

#You can also specify multiple databases and multiple query signatures on the command line; separate them with --db or --query.

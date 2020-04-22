#!/bin/bash

cd data

### SOURMASH DEMO

#Download a genome from genbank:
curl -L -o shewanella.fa.gz http://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/178/875/GCF_000178875.2_ASM17887v2/GCF_000178875.2_ASM17887v2_genomic.fna.gz

#Compute the MinHash signature for this genome using k=31 and scaled to 1/1000 of total signatures
sourmash compute -k 31 --scaled=1000 shewanella.fa.gz

# take a look at the signatures
cat shewanella.fa.gz.sig | tr ',' '\n' | head -n20

# For taxonomic classification, you'll want to use a proper database, available here:
# https://sourmash.readthedocs.io/en/latest/databases.html
# unfortunately they are too big to load in Binder so we will create our own mini-database

# Building your own LCA (Last Common Ancestor) database

# Download some pre-computed signatures from the TARA Oceans metagenome assembled genomes paper by Delmont et al.
curl -L https://osf.io/bw8d7/download?version=1 -o delmont-subsample-sigs.tar.gz
tar xzf delmont-subsample-sigs.tar.gz

# Next, grab the associated taxonomy spreadsheet
curl -O -L https://github.com/ctb/2017-sourmash-lca/raw/master/tara-delmont-SuppTable3.csv

# view the file
head tara-delmont-SuppTable3.csv

# convert DOS line endings to UNIX line endings
sed -i 's/\r/\n/g' tara-delmont-SuppTable3.csv

# Build a sourmash LCA database named delmont.lca.json:
sourmash lca index -f tara-delmont-SuppTable3.csv delmont.lca.json delmont-subsample-sigs/*.sig

# view the database
cat delmont.lca.json | tr ',' '\n' | head -n400

# Using the LCA database to classify signatures

# We can now use delmont.lca.json to classify signatures with k-mers according to the database we just created. 
# (Note, the database is completely self-contained at this point.)

# Let’s classify a single signature from the MAGs
sourmash lca classify --db delmont.lca.json --query delmont-subsample-sigs/TARA_ION_MAG_00058.fa.gz.sig

# and you should see:

# loaded 1 LCA databases. ksize=31, scaled=10000
# finding query signatures...
# outputting classifications to -
# ID,status,superkingdom,phylum,class,order,family,genus,species,strain
# TARA_ION_MAG_00058,found,Bacteria,Proteobacteria,Gammaproteobacteria,Pseudomonadales,Pseudomonadaceae,Pseudomonas,Pseudomonas_mendocina,
# classified 1 signatures total

# You can classify a bunch of signatures and also specify an output location for the CSV:
sourmash lca classify --db delmont.lca.json --query delmont-subsample-sigs/*.sig -o delmont_out.csv


# The lca classify command supports multiple databases as well as multiple queries;
# e.g. sourmash lca classify --db delmont.lca.json other.lca.json will classify based on the combination of taxonomies in the two databases.



## BBDUK DEMO

# Let's generate signatures for some metagenomic reads and classify them
# but first we'll clean them up a bit with bbtools

for prefix in `ls *_R1_*.fastq.gz | cut -f1 -d'_' | sort -u`; do 

  echo ${prefix}

  R1=( ${prefix}*_R1_*.gz )
  R1=( ${prefix}*_R2_*.gz )
  
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
  bbduk.sh in=filtered.fq.gz out=qtrimmed_${prefix}.fq.gz qtrim=r trimq=10 minlen=70 ordered maxns=0 maq=8 entropy=.95 ow=t
  
  # remove extra files
  rm clumped.fq.gz filtered_by_tile.fq.gz trimmed.fq.gz filtered.fq.gz

  # compute the minhash signatures
  sourmash compute -k 31 --scaled=1000 qtrimmed_${prefix}.fq.gz
  
done

# Classify all of the signatures using the Delmont MAGs
sourmash lca classify --db delmont.lca.json --query *.sig -o meta_out.csv

# view the report
cat meta_out.csv

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

# And finally if you want to do an all-vs-all comparison for all signatures:
sourmash compare --traverse-directory ./ *.sig -k 31 -o meta_comp

# and plot them on a heatmap
sourmash plot --pdf --labels meta_comp

# open topic-metagenomics/data/meta_comp.matrix.pdf in the browser


### SENDSKETCH DEMO

# bbtools has commands similar to sourmash

# SketchMaker: Creates one or more sketches from a fasta file
sketch.sh

# CompareSketch: Compares query sketches to others, and prints their kmer identity.
comparesketch.sh

# SendSketch: Compares query sketches to reference sketches hosted on a remote server via the Internet
# Can use these different databases with address=
# nt:      nt server
# refseq:  Refseq server
# silva:   Silva server

# Submit search to the genbank 'nt' sketch database 
sendsketch.sh in=qtrimmed_BOX-2-63-15088.fq.gz address=nt

# Query: M03580:108:000000000-CMLF3:1:1101:15093:1492 2:N:0:GACATGGT+CCATGAAC	DB: nt	SketchLen: 18257	Seqs: 97732 	Bases: 29417332	gSize: 19416865	GC: 0.458	Quality: 0.6750	File: BOX-2-63-15088_S79_L001_R2_001.fastq.gz
# WKID	KID	ANI	SSU	Complt	Contam	Matches	Unique	TaxID	gSize	gSeqs	taxName
# 0.27%	0.20%	80.57%	.	100.00%	0.62%	37	33	41875	14737K	7898	Bathycoccus prasinos
# 0.80%	0.05%	83.81%	.	100.00%	0.77%	10	7	335992	1308193	46	Candidatus Pelagibacter ubique HTCC1062
# 29.41%	0.03%	96.01%	.	100.00%	0.80%	5	2	542413	17686	1	uncultured bacterium ARCTIC24_F_09
# 12.20%	0.03%	92.63%	.	100.00%	0.80%	5	4	542402	31740	1	uncultured bacterium ARCTIC13_E_12
# 0.15%	0.02%	75.08%	.	100.00%	0.81%	3	3	212695	2113690	1272	uncultured Flavobacteriia bacterium
# 0.03%	0.02%	69.87%	.	100.00%	0.81%	3	0	70448	10300K	7826	Ostreococcus tauri
# 0.02%	0.02%	72.90%	.	93.77%	0.82%	3	0	296587	20567K	10128	Micromonas commoda
# 0.02%	0.01%	73.13%	.	73.82%	0.84%	3	0	9593	26202K	3953	Gorilla gorilla

# Submit search to the genbank 'refseq' sketch database
sendsketch.sh in=qtrimmed_BOX-2-63-15088.fq.gz address=refseq

# Query: M03580:108:000000000-CMLF3:1:1101:15093:1492 2:N:0:GACATGGT+CCATGAAC	DB: RefSeq	SketchLen: 36510	Seqs: 97732 	Bases: 29417332	gSize: 19437976	GC: 0.458	Quality: 0.6750	File: BOX-2-63-15088_S79_L001_R2_001.fastq.gz
# WKID	KID	ANI	SSU	Complt	Contam	Matches	Unique	TaxID	gSize	gSeqs	taxName
# 0.27%	0.20%	80.65%	.	100.00%	0.90%	74	71	41875	14645K	21	Bathycoccus prasinos
# 0.95%	0.06%	84.41%	.	100.00%	1.04%	23	3	1118158	1274423	1	Candidatus Pelagibacter ubique HTCC1040
# 0.48%	0.07%	82.26%	.	100.00%	1.02%	27	0	1822252	2969096	592	Erythrobacter sp. HI0077
# 0.47%	0.07%	82.25%	.	100.00%	1.02%	27	0	1822249	2970916	583	Erythrobacter sp. HI0074
# 0.43%	0.07%	81.97%	.	100.00%	1.03%	25	2	1306953	3057665	28	Erythrobacter citreus LAMA 915
# 0.42%	0.07%	81.88%	.	100.00%	1.03%	25	0	1822222	3129846	880	Erythrobacter sp. HI0019
# 0.42%	0.07%	81.88%	.	100.00%	1.03%	25	0	1822227	3130890	610	Erythrobacter sp. HI0028
# 0.07%	0.02%	76.90%	.	100.00%	1.08%	8	5	1327752	5846298	71	Idiomarina aquatica
# 0.10%	0.02%	77.85%	.	100.00%	1.08%	8	0	1822224	4208587	717	Sulfitobacter sp. HI0021
# 0.10%	0.02%	77.85%	.	100.00%	1.08%	8	0	1822226	4212479	458	Sulfitobacter sp. HI0027
# 0.09%	0.02%	77.42%	.	100.00%	1.08%	7	0	1822251	4097586	875	Sulfitobacter sp. HI0076
# 0.19%	0.01%	79.30%	.	100.00%	1.08%	5	1	2268451	1364070	1	Candidatus Pelagibacter sp. FZCC0015
# 0.18%	0.01%	79.14%	.	100.00%	1.08%	5	0	439493	1446246	1	Candidatus Pelagibacter sp. HTCC7211
# 0.06%	0.01%	76.37%	.	100.00%	1.09%	4	1	1869314	3544041	25	Erythrobacter sp. SAORIC-644
# 0.06%	0.01%	75.91%	.	100.00%	1.09%	4	0	1968541	3929301	6	Sulfitobacter sp. D7
# 0.05%	0.01%	75.88%	.	100.00%	1.09%	4	0	225422	3942123	42	Sulfitobacter indolifex
# 0.10%	0.01%	73.27%	.	100.00%	1.09%	3	2	2508687	1666689	1	Candidatus Thioglobus sp. NP1
# 0.12%	0.01%	78.18%	.	100.00%	1.09%	3	1	859653	1325178	1	alpha proteobacterium HIMB5
# 0.06%	0.01%	76.15%	.	100.00%	1.09%	3	2	2055892	2593616	1	Idiomarina sp. X4
# 0.13%	0.01%	78.55%	.	100.00%	1.09%	3	0	1977864	1199959	1	Candidatus Pelagibacter sp. RS39


# Submit search to the 'silva' sketch database
sendsketch.sh in=qtrimmed_BOX-2-63-15088.fq.gz address=silva

# Query: M03580:108:000000000-CMLF3:1:1101:15093:1492 2:N:0:GACATGGT+CCATGAAC	DB: Silva	SketchLen: 15	Seqs: 97732 	Bases: 29417332	gSize: 17328	GC: 0.458	Quality: 0.6750	File: BOX-2-63-15088_S79_L001_R2_001.fastq.gz
# WKID	KID	ANI	SSU	Complt	Contam	Matches	Unique	TaxID	gSize	gSeqs	taxName
# 53.33%	6.25%	97.71%	.	6.25%	46.67%	8	2	1561972	133927	94	seawater metagenome
# 53.33%	0.70%	97.72%	.	0.70%	46.67%	8	0	408172	1337367	1931	marine metagenome
# 40.00%	0.13%	96.69%	.	0.13%	60.00%	6	1	256318	5566707	48992	metagenome


# TaxServer: Starts a server that translates NCBI taxonomy.
# If you want to host your own online database
taxserver.sh








# Lesson 1: What is metagenomics?
## What kinds of questions can metagenomics be used to answer?
* Taxonomy -- classification
* Function -- hmms and orthology mapping
* Molecular evolution -- binning and phylogenomics
* Community Ecology -- network analysis
## Is metagenomics right for me?
* You should do amplicon sequencing instead if…
* You should do genome sequencing instead if…
* You should do transcriptomics instead if…

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/topic-metagenomics/master?urlpath=lab)

# Lesson 2: Taxonomic Classification using kmers (with adapter-trimmed reads)
* The power of kmers
* Choosing a metagenomics classifier
  * http://ccb.jhu.edu/software/choosing-a-metagenomics-classifier/
* Demo using kraken2, centrifuge, kaiju, etc.
* + Adapter trimming using cutadapt, bbduk, etc.

# Lesson 3: Taxonomic Classification using sketches (with adapter + quality filtered reads)
* How does MinHash work?
* Choosing a metagenomics sketcher
* Demo using mash, sourmash, sendsketch, etc.
* + Quality filtering using cutadapt, bbduk, etc.

# Lesson 4: Taxonomic Classification using mapping (with adapter + quality filtered reads)
* How does mapping work?
* Choosing a reference genome
* Choosing a metagenomic read mapper
* Demo using bowtie, bwa, bbmap, etc.

# Lesson 5: Functional Classification using HMMs (with adapter + quality filtered reads)
* How do HMMs work?
* What is an open reading frame?
* Choosing an hmm profiler
* Demo using hmmer, barrnap, etc.

# Lesson 6: Functional Classification using orthologs (with merged reads)
* What is the difference between a homolog and an ortholog?
* Choosing an orthology database
* Querying an orthology database
* Demo using InterProScan, MG-RAST, MGnify, etc.
* + Read merging using FLASH, bbmerge, etc.

# Lesson 7: Assembly (with error-corrected reads)
* How does sequence assembly work?
* What is a deBruijn graph?
* Choosing an assembler
* Demo using tadpole, megahit, SPAdes, etc.
* + Error correction using BayesHammer/SPAdes, tadpole, etc.

# Lesson 8: Assembly Quality and Statistics (with contigs)
* How do you determine the quality of an assembly?
* Choosing an assembly quality metric
* Demo using QUAST, etc.

# Lesson 9: Assembly Visualization (with assembly graph)
* What is an assembly graph useful for?
* Demo using Bandage

# Lesson 10: Binning (with contigs + reads)
* How does metagenomic binning work?
* Choosing a metagenomic binner
* Demo using metabat2, CONCOCT, etc.

# Lesson 11: Evaluating bins (with binned contigs)
* What are single-copy core genes?
* Choosing a bin evaluation tool
* Demo using CheckM, etc.

# Lesson 12: Phylogenomics (with binned contigs)
* What are single-copy core genes?
* Basics of sequence alignment
* Basics of phylogenetic tree construction
* Demo using GToTree, GTDBtk, etc.

# Lesson 13: Workflows -- Putting it all together
* A review of existing workflows
* Why you probably shouldn’t invent your own workflow
* What to do when you inevitably decide to invent your own workflow anyway
* Demo using SnakeMake, Nextflow, etc.

# Lesson 14: Workflow demo: Anvi’o 

# Lesson 15: Workflow demo: Online Portals
* MGnify
* MG-RAST
* Galaxy
* JGI
* Cyverse
* KBase
* etc

# Lesson 16: HPC
* How to use HPC to your advantage
* Common workload managers: slurm, moab, etc.

# Lesson 17: Publication -- Sharing your data, results, and code
* Why you should share your data
* How to deposit your data in GenBank, EBI, etc.
* How to share your results on Figshare, etc.
* How to share your code on Github, etc.
* Best practices for writing Methods

# Lesson 18: Publication -- Visualization
* Best practices for visualizing results
* Examples of bad visualizations
* Examples of good visualizations

# Lesson 19: Funding
* How to write a JGI New Investigator proposal
* How to get time on XSEDE


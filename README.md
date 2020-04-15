# Start Here: [TOPIC: Metagenomics](https://github.com/biovcnet/biovcnet.github.io/wiki/TOPIC:-Metagenomics)

---

# Released Lessons

# Lesson 1: What is metagenomics? [[Presentation]](https://docs.google.com/presentation/d/e/2PACX-1vSUJqDdgpz5yTPcOoHF_XLS1pxextNel7F8-i9j6YRgXkcKJg0rdneY00lcaoBzvJj-UxcTvhrJUoTH/pub?start=false&loop=false&delayms=600000)
## What kinds of questions can metagenomics be used to answer?
## Is metagenomics right for me?
## Yay! You got data! Now what?
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab) Quality Control Demo using FastQC and MultiQC [by Alexis Marshall]

---

# Planned Lessons

# Lesson 2: Taxonomic Classification using kmers
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* The power of kmers
* Choosing a metagenomics classifier
* Demo using kraken2, centrifuge, kaiju, etc.
* + Adapter trimming using cutadapt, bbduk, etc.

# Lesson 3: Taxonomic Classification using MinHash sketches
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* How does MinHash work?
* Choosing a metagenomics sketcher
* Demo using mash, sourmash, sendsketch, etc.
* + Quality filtering using cutadapt, bbduk, etc.

# Lesson 4: Taxonomic Classification using BWT mapping
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* How does mapping work?
* Choosing a reference genome
* Choosing a metagenomic read mapper
* Demo using bowtie, bwa, bbmap, etc.

# Lesson 5: Assembly
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-assembly/master?urlpath=lab)
* How does sequence assembly work?
* What is a deBruijn graph?
* Choosing an assembler
* Demo using tadpole, megahit, SPAdes, etc.
* + Error correction using BayesHammer/SPAdes, tadpole, etc.

# Lesson 8: Assembly Quality and Statistics
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-assembly/master?urlpath=lab)
* How do you determine the quality of an assembly?
* Choosing an assembly quality metric
* Demo using QUAST, etc.

# Lesson 9: Assembly Visualization
* What is an assembly graph useful for?
* Demo using Bandage

# Lesson 10: Binning
* How does metagenomic binning work?
* Choosing a metagenomic binner
* Demo using metabat2, CONCOCT, etc.

# Lesson 11: Evaluating bins
* What are single-copy core genes?
* Choosing a bin evaluation tool
* Demo using CheckM, etc.

# Lesson 12: Phylogenomics
* What are single-copy core genes?
* Basics of sequence alignment
* Basics of phylogenetic tree construction
* Demo using GToTree, GTDBtk, etc.

# Lesson 13: Workflows -- Putting it all together
* A review of existing workflows
* Why you probably shouldn’t invent your own workflow
* What to do when you inevitably decide to invent your own workflow anyway
* Demo using SnakeMake, Nextflow, etc.

# Lesson 14: Workflows: Online Portals
* Anvi’o
* MGnify
* MG-RAST
* Galaxy
* JGI
* Cyverse
* KBase
* etc

# [TOPIC: Metagenomics](https://github.com/biovcnet/biovcnet.github.io/wiki/TOPIC:-Metagenomics)

# Prerequisites for topic
* [A working Unix environment](https://github.com/biovcnet/biovcnet.github.io/wiki/1.-Setting-up-a-local-Linux-(or-Unix)-environment)
* [Experience with the command line](https://github.com/biovcnet/biovcnet.github.io/wiki/2.-Using-the-Command-line)

# Overview
This topic will cover:
* how to use shotgun metagenomic sequencing technologies to answer biological questions
* the methodologies used to perform metagenomic studies on the taxonomy, function, evolution, and ecology of microorganisms
* the intricacies of the specific tools and databases that can used for varying levels of specificity.


---

# Released Lessons

# [Lesson 1](https://github.com/biovcnet/topic-metagenomics/tree/master/Lesson-1): What is metagenomics?
* [[Presentation Slides]](https://github.com/biovcnet/topic-metagenomics/raw/master/Lesson-1/Metagenomics_Lesson_1.pdf) and [[Presentation Video]](https://youtu.be/EkmuvRQ2tWw) by Eric Collins
* What kinds of questions can metagenomics be used to answer?
* Is metagenomics right for me?
* Yay! You got data! Now what?
## Demo 1: Quality Control using FastQC and MultiQC
* [[Video Tutorial]](https://www.youtube.com/watch?v=7jRTyfdIXLo) by Alexis Marshall
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)

# [Lesson 2](https://github.com/biovcnet/topic-metagenomics/tree/master/Lesson-2): Taxonomic Classification using kmers
* [[Presentation Slides]](https://github.com/biovcnet/topic-metagenomics/raw/master/Lesson-2/Metagenomics%20Lesson%202.pdf) and [[Presentation Video]](https://www.youtube.com/watch?v=MpScSM_d3Vo) by Eric Collins
* The power of kmers
* Choosing a metagenomics classifier

## Demo 2: Taxonomic Classification and Adapter Trimming using k-mers
* [[Video Tutorial]](https://www.youtube.com/watch?v=HqPiWvjIrew) by Eric Collins
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* Programs used:
  * kraken2
  * bbduk
  * krona

---

# Planned Lessons

# Lesson 3: Taxonomic Classification using MinHash sketches
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* How does MinHash work?
* Choosing a metagenomics sketcher
* Demo using mash, sourmash, sendsketch, etc.
* + Quality filtering using cutadapt, bbduk, etc.

# Lesson 4: Taxonomic Classification using BWT mapping
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-assembly/master?urlpath=lab)
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

# Lesson 6: Assembly Quality and Statistics
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-assembly/master?urlpath=lab)
* How do you determine the quality of an assembly?
* Choosing an assembly quality metric
* Demo using QUAST, etc.

# Lesson 7: Assembly Visualization
* What is an assembly graph useful for?
* Demo using Bandage

# Lesson 8: Binning
* How does metagenomic binning work?
* Choosing a metagenomic binner
* Demo using metabat2, CONCOCT, etc.

# Lesson 9: Evaluating bins
* What are single-copy core genes?
* Choosing a bin evaluation tool
* Demo using CheckM, etc.

# Lesson 10: Phylogenomics
* What are single-copy core genes?
* Basics of sequence alignment
* Basics of phylogenetic tree construction
* Demo using GToTree, GTDBtk, etc.

# Lesson 11: Workflows -- Putting it all together
* A review of existing workflows
* Why you probably shouldn’t invent your own workflow
* What to do when you inevitably decide to invent your own workflow anyway
* Demo using SnakeMake, Nextflow, etc.

# Lesson 12: Workflows: Online Portals
* Anvi’o
* MGnify
* MG-RAST
* Galaxy
* JGI
* Cyverse
* KBase
* etc

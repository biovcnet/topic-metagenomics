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

## Demo 1.1: Quality Control using FastQC and MultiQC
* [[Video Tutorial]](https://www.youtube.com/watch?v=7jRTyfdIXLo) by Alexis Marshall
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* [[Bash script]](https://github.com/biovcnet/topic-metagenomics/blob/master/Lesson-1/Demo1.1_fastqc_multiqc.sh)
* Programs used:
  * fastqc
  * multiqc

# [Lesson 2](https://github.com/biovcnet/topic-metagenomics/tree/master/Lesson-2): Taxonomic Classification using k-mers
* [[Presentation Slides]](https://github.com/biovcnet/topic-metagenomics/raw/master/Lesson-2/Metagenomics%20Lesson%202.pdf) and [[Presentation Video]](https://www.youtube.com/watch?v=MpScSM_d3Vo) by Eric Collins
* The power of k-mers
* Choosing a k-mer classifier

## Demo 2.1: Taxonomic Classification and Adapter Trimming using k-mers
* [[Video Tutorial]](https://www.youtube.com/watch?v=HqPiWvjIrew) by Eric Collins
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* [[Bash script]](https://github.com/biovcnet/topic-metagenomics/blob/master/Lesson-2/Demo2.1_kraken2_bbduk_krona.sh)
* Programs used:
  * kraken2
  * bbduk
  * krona

## Demo 2.2: Adapter and quality trimming using trimmomatic
* [[Video Tutorial]](https://www.youtube.com/watch?v=Q4UU6k13090) by Ella Sieradzki
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* [[Bash script]](https://github.com/biovcnet/topic-metagenomics/blob/master/Lesson-2/Demo2.2_trimmomatic)
* Programs used:
  * fastqc
  * multiqc
  * trimmomatic

# [Lesson 3](https://github.com/biovcnet/topic-metagenomics/tree/master/Lesson-3): Taxonomic Classification using MinHash sketches
* [[Presentation Slides]](https://github.com/biovcnet/topic-metagenomics/raw/master/Lesson-3/Metagenomics_Lesson_3.pdf) and [[Presentation Video]](https://www.youtube.com/watch?v=6LfPzwe9dO8) by Eric Collins
* The Jaccard Index
* How does MinHash work?
* How do Bloom filters work?
* Choosing a MinHash sketcher

## Demo 3.1: Taxonomic Classification using sourmash and sendsketch, and quality trimming using bbduk
* [[Video Tutorial]](https://www.youtube.com/watch?v=RJC0gvWxqF4) by Eric Collins
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-qc/master?urlpath=lab)
* [[Bash script]](https://github.com/biovcnet/topic-metagenomics/blob/master/Lesson-3/Demo3.1_sourmash_bbduk_sendsketch.sh)
* Programs used:
  * sourmash
  * sendsketch
  * bbduk

# [Lesson 4](https://github.com/biovcnet/topic-metagenomics/tree/master/Lesson-4): Read mapping and read taxonomic classification
* [[Presentation Slides]](https://github.com/biovcnet/topic-metagenomics/raw/master/Lesson-4/Metagenomics_Lesson_4.pdf) and [[Presentation Video]](https://youtu.be/emUYU3m3XDU) by Luis Valentin and Ella Sieradzki
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-assembly/master?urlpath=lab)
* How does mapping work?
* Choosing a metagenomic read mapper
* The Burrows-Wheeler transform and using bowtie2

## Demo 4.1: Mapping reads with bbtools
* [[Video Tutorial]](https://youtu.be/RU-kU8Ei6Gk) by Ella Sieradzki
* [[Bash script]](https://github.com/biovcnet/topic-metagenomics/blob/master/Lesson-4/bbmap_tutorial.sh)
* Programs used:
  * bbmap
  * bbwrap
  * bbsplit

## Demo 4.2: Taxonomic classification of reads
* [[Video Tutorial]](https://youtu.be/AKWYVTga0Ug) by Ella Sieradzki
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-assembly/master?urlpath=lab)
* Programs used:
  * Kaiju
  * Centrifuge

# [Lesson 5](https://github.com/biovcnet/topic-metagenomics/tree/master/Lesson-5): Genome and Metagenome Assembly
* [[Presentation Slides]](https://github.com/biovcnet/topic-metagenomics/raw/master/Lesson-5/Metagenomics_Lesson_5_Assembly.pdf)
* Sequencing Statistics
* Overlap-Layout-Consensus assembly
* de Bruijn Graph assembly
* Assembly software

## Demo 5.1: Genome assembly
* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/biovcnet/metagenomics-binder-assembly/master?urlpath=lab)
* [[Bash Script]](https://github.com/biovcnet/topic-metagenomics/blob/master/Lesson-5/Demo5.1_spades.sh)
* Programs used:
  * bbduk
  * tadpole
  * spades
  * statswrapper
  
---

# Planned Lessons

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

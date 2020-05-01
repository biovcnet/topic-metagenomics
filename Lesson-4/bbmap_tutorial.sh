# In this tutorial we will learn how to map reads to reference genomes using bbtools

# The basic aligner in bbtools is called bbmap, and it is designed to map reads from 1 sample to 1 reference genome
# The quality of read mapping is determined using an inherent scoring algorithm 
# The score generated by the algorithm is called minratio, and it is a measure of the read mapping score divided by its best possible score (100% match, no indels)
# You can choose a preferred minratio for your own reads. However, since it's not a trivial number, you can also choose to just set the minimum %id of the read to the reference. For example, minid=0.9 means at least 90% of the bases in the read will match the reference at the mapping site.
# bbmap will use your set mind to calculate a corresponding minratio
# bbmap by default uses all available threads, so if you're using a shared machine you want to limit the number of threads.
# There is no need to unzip input files


cd data

# Here we map paired reads from sample SRR5780888 to reference genome DvH, set the minimum %ID to 95% and request that only mapped reads will be written into the output bam file with outm
# using outm is highly recommended because it reduces the size of the output file significantly

bbmap.sh ref=DvH_reference.fa.zip in1=SRR5780888_1.fastq.zip in2=SRR5780888_2.fastq.zip outm=DvH_SRR5780888_mapped.bam minid=0.95





# What if you have more that one sample to map to the genome?
# Use bbwrap

# Here we specify input files from 2 samples. bbmap will only create the reference once and then keep using it. We're setting the mapper to bbmap which is suitable for short reads. There are other specific mappers for PacBio reads.

bbwrap.sh ref=DvH_reference.fa.zip in1=SRR5780888_1.fastq.zip,SRR5780889_1.fastq.zip in2=SRR5780888_2.fastq.zip,SRR5780889_2.fastq.zip mapper=bbmap outm=DvH_888.bam,DvH_889.bam






# If you have more than one reference genome you should use bbsplit. Consider what to do with reads that map to more than one genome. Do you want to just keep the best hit? Keep all hits? Throw all ambiguously mapped reads? This depends on downstream analyses and on similarity between the reference genomes. You can choose what to do using the parameter ambigous2

bbsplit.sh -h

# ambiguous2=<best>    Set behavior only for reads that map ambiguously to multiple different references.
#                      Normal 'ambiguous=' controls behavior on all ambiguous reads;
#                      Ambiguous2 excludes reads that map ambiguously within a single reference.
#                      best   (use the first best site)
#                      toss   (consider unmapped)
#                      all   (write a copy to the output for each reference to which it maps)
#                      split   (write a copy to the AMBIGUOUS_ output for each reference to which it maps)




# Output types

# bbmap produces textual outputs that make your life easier later on. For example, you can get a summary of coverage statistics with covstats, data for a coverage histogram with covhist and coverage per base in the reference with basecov. Be aware that basecov generates very large files.

bbmap.sh ref=DvH_reference.fa.zip in1=SRR5780888_1.fastq.zip in2=SRR5780888_2.fastq.zip outm=DvH_SRR5780888_mapped.bam minid=0.95 covstats=DvH_SRR5780888_covstats.txt covhist=DvH_SRR5780888_covhist.txt




# If you have many read files and one reference genome (or set of genomes), you can use a loop in bash with bbmap/bbsplit.

cd ..

curdir="data/"

for f in ${curdir}*1.fastq.zip
do
	f2=$(echo $f | sed 's/1\.fastq\.zip/2\.fastq\.zip/')
	echo $f,$f2
	fbase=$(echo $f | cut -d "/" -f2 | sed 's/_.*//')
	echo $fbase
	bbmap.sh ref=${curdir}/DvH_reference.fa.zip in1=${f} in2=${f2} covstats=${curdir}${fbase}_covstats.txt covhist=${curdir}${fbase}_covhist.txt basecov=${curdir}${fbase}_basecov.txt outm=${curdir}${fbase}_mapped.bam minid=0.95
done

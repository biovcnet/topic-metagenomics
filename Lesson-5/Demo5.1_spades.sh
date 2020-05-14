cd data

# unzip files, concatenate R1's and R2's, and rezip
for file in *.fastq.zip; do unzip ${file}; done
cat SRR5780888_1.fastq SRR5780889_1.fastq | gzip > dvh_1.fastq.gz
cat SRR5780888_2.fastq SRR5780889_2.fastq | gzip > dvh_2.fastq.gz

# rezip individual files
for file in SRR*.fastq; do gzip ${file}; done

for prefix in `ls *_1.fastq.gz | cut -f1 -d'_' | sort -u`; do 

  echo ${prefix}

  R1=( ${prefix}*_1.fastq.gz )
  R2=( ${prefix}*_2.fastq.gz )
    
  #Trim adapters
  # 'ordered' means to maintain the input order as produced by clumpify.sh
  bbduk.sh in=${R1} in2=${R2} out=trimmed.fq.gz ktrim=r k=23 mink=11 hdist=1 tbo tpe minlen=70 ref=adapters ordered ow=t

  #Remove synthetic artifacts and spike-ins by kmer-matching
  # 'cardinality' will generate an accurate estimation of the number of unique kmers in the dataset using the LogLog algorithm
  bbduk.sh in=trimmed.fq.gz out=filtered.fq.gz k=31 ref=artifacts,phix ordered cardinality ow=t
  
  #Quality-trim and entropy filter the remaining reads.
  # 'entropy' means to filter out reads with low complexity
  # 'maq' is 'mininum average quality' to filter out overall poor reads
  bbduk.sh in=filtered.fq.gz out=${prefix}_qtrimmed.fq.gz qtrim=r trimq=10 minlen=70 ordered maxns=0 maq=8 entropy=.95 ow=t

  # Assembly using tadpole
  tadpole.sh in=${prefix}_qtrimmed.fq.gz out=tadpole_contigs.fasta k=124 ow=t prefilter=2 prepasses=auto
  
  # Assembly quality-trimmed reads using SPAdes
  spades.py -o ${prefix}_spades --12 ${prefix}_qtrimmed.fq.gz --only-assembler
  
  # calculate assembly statistics
  statswrapper.sh ${prefix}_spades/*.fasta tadpole_contigs.fasta > ${prefix}_stats.txt
  
  cat ${prefix}_stats.txt
  
  # remove extra files
  # rm trimmed.fq.gz filtered.fq.gz
  
done

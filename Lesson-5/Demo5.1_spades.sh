cd data

for prefix in `ls *_1.fastq.zip | cut -f1 -d'_' | sort -u`; do 

  echo ${prefix}

  R1=( ${prefix}*_1.fastq.zip )
  R2=( ${prefix}*_2.fastq.zip )
    
  #Trim adapters
  # 'ordered' means to maintain the input order as produced by clumpify.sh
  bbduk.sh in=${R1} in2=${R2} out=trimmed.fq.gz ktrim=r k=23 mink=11 hdist=1 tbo tpe minlen=70 ref=adapters ordered ow=t

  #Remove synthetic artifacts and spike-ins by kmer-matching
  # 'cardinality' will generate an accurate estimation of the number of unique kmers in the dataset using the LogLog algorithm
  bbduk.sh in=trimmed.fq.gz out=filtered.fq.gz k=31 ref=artifacts,phix ordered cardinality ow=t
  
  #Quality-trim and entropy filter the remaining reads.
  # 'entropy' means to filter out reads with low complexity
  # 'maq' is 'mininum average quality' to filter out overall poor reads
  bbduk.sh in=filtered.fq.gz out=qtrimmed_${prefix}.fq.gz qtrim=r trimq=10 minlen=70 ordered maxns=0 maq=8 entropy=.95 ow=t
  
  # Assembly using SPAdes
  spades.py -o $prefix --12 qtrimmed_${prefix}.fq.gz --only-assembler  --checkpoints all
  
  # calculate assembly statistics
  statswrapper.sh ${prefix}/*.fasta > ${prefix}_stats.txt
  
  cat ${prefix}_stats.txt
  
  # remove extra files
  rm clumped.fq.gz filtered_by_tile.fq.gz trimmed.fq.gz filtered.fq.gz
  
done

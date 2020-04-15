cd data

for file in *.fastq.gz
do
gunzip ${file}
done

mkdir 00_FastQC_RAW

for file in *.fastq;
do
fastqc ${file} -o 00_FastQC/
done

multiqc .

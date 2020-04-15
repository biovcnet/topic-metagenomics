cd data

for file in *.fastq.gz
do
gunzip ${file}
done

mkdir 00_FastQC

for file in *.fastq;
do
fastqc ${file} -o 00_FastQC/
done

multiqc .

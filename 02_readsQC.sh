#!/bin/sh
#Paramaters should be optimized depends on NGS reads.

threads=10

mkdir raw_fq trtim_fq fastp_html

for fq in *_1.fastq.gz; do
    f=${fq%_?.fastq.gz}
    echo ${f}
    time fastp -i ${f}_1.fastq.gz -I ${f}_2.fastq.gz -o ${f}_1_trim.fastq.gz -O ${f}_2_trim.fastq.gz -q 20 -h ${f}_fastp.html -w ${threads} -t 1 -T 1
    mv *_?.fastq.gz raw_fq
    mv *_?_trim.fastq.gz trim_fq
    mv *.html fastp_html
done


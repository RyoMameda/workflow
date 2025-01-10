#!/bin/sh

threads=10
fqdir=trim_fq

for tfq in ${fqdir}/*_1_trim.fastq.gz; do
    f=${tfq%_1_trim.fastq.gz}
    echo "${f} assembly"
    time megahit -1 ${f}_1_trim.fastq.gz -2 ${f}_2_trim.fastq.gz -o contig${f} -t ${threads}
    seqkit stats -a -T contig${f}/final.contigs.fa > contig${f}_statics.tsv
done

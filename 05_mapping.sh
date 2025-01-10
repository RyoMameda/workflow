#!/bin/sh

threads=10

# input and output file path
contig=megahit_outdir/final.contigs.fa
f=prodigal_output_file_name
bam=output_bam_file_name
fqdir=trim_fq
mgfq=trimmed_metagenomic_fastq
mtfq=trimmed_metatranscriptomic_fastq
#

# index
time bwa index -p index_${f}_bwa ${f}.fna

# mapping metagenomic reads
echo "${mgfq} mapped to ${bam}"
time bwa mem -t ${threads} index_${f}_bwa ${fqdir}/${mgfq}_1_trim.fastq.gz ${fqdir}/${mgfq}_2_trim.fastq.gz | samtools sort -@ ${threads} > mg_${bam}.bam
samtools flagstat -@ ${threads} mg_${bam}.bam > flagstat_mg_${bam}

# mapping metatranscriptomic reads
echo "${mtfq} mapped to ${bam}"
time bwa mem -t ${threads} index_${f}_bwa ${fqdir}/${mtfq}_1_trim.fastq.gz ${fqdir}/${mtfq}_2_trim.fastq.gz | samtools sort -@ ${threads} > mt_${bam}.bam
samtools flagstat -@ ${threads} mt_${bam}.bam > flagstat_mt_${bam}

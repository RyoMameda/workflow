#!/bin/sh

# input and output file path
contig=megahit_outdir/final.contigs.fa
output=output_file_name
#

prodigal -i ${contig} -o ${output}.gbk -p meta -q -a ${output}.faa -d ${output}.fna
# output file (prodigal.gbk) will not be used

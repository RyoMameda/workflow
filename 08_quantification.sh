#!/bin/sh

threads=10

# input and output file path
db=ref_data_dir_path
f=prodigal_output_file
bam=output_bam_file_name
#

# calculation of read counts
for bamf in *${bam}.bam
    do
    time featureCounts -T ${threads} -t CDS -g gene_id -a ${f}_annotation.gtf -o counts_${bam}.txt -p ${bamf}
done

# GPM calculation for metagenomic reads mapping results.
featureCounts2gpm.py --mg counts_${bam}.txt --gpm GPM_${bam}.txt

# TPM calculation for metatranscriptomic reads mapping results.
featureCounts2tpm.py --mt counts_${bam}.txt --tpm TPM_${bam}.txt

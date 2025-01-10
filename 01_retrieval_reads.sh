#!/bin/sh
# The SRR_Acc_list.txt file, which contains your desired SRR list, should be downloaded from NCBI.   

threads=10

prefetch --option-file SRR_Acc_list.txt
while IFS= read -r line; do
    echo "$line"
    time fasterq-dump "$line".sra -e ${threads} -p -S
    pigz *.fastq
done

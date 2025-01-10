#!/bin/sh

threads=10

# input and output file path
db=ref_data_dir_path
f=prodigal_output_file
swissprot=SwissProt_index
pfam=Pfam-A.hmm
#

# omission of rRNA from predicted protein-coding sequences
for index in ${db}/*nin; do
    filename=$(basename "${index}")
    rrna=${filename%.nin}
    echo "${f} ${rrna}"
    time blastn -num_threads ${threads} -db ${db}/${rrna} -query ${f}.fna -out ${f}_${rrna}.txt -outfmt "6 qseqid sseqid stitle evalue" -max_target_seqs 1 -evalue 0.1
done
cat ${f}_*.txt | awk '!x[$1]++' > ${f}_rRNAlist.txt
seqkit seq -n -i ${f}.fna > ${f}_proteinlist.txt
cat ${f}_rRNAlist.txt ${f}_proteinlist.txt | cut -f1 | sort | uniq -u > ${f}_list-rRNA.txt
seqkit seq -i ${f}.faa > mid.faa
seqkit grep -f ${f}_list-rRNA.txt mid.faa > ${f}-rRNA.faa
rm mid.faa ${f}_proteinlist.txt

# BLASTP with Swiss-Prot
time diamond blastp -p ${threads} -d ${db}/${swissprot} -o ${f}-rRNA_uniprot.txt -f 6 qseqid sseqid stitle evalue --quiet -q ${f}-rRNA.faa --top 1 -e 0.1 --sensitive --iterate
awk '!x[$1]++' ${f}-rRNA_uniprot.txt | cut -f1 > toplist.txt
cat toplist.txt ${f}_list-rRNA.txt | sort | uniq -u > ${f}_list-rRNA-uniprot.txt
seqkit grep -f ${f}_list-rRNA-uniprot.txt ${f}-rRNA.faa > ${f}-rRNA-uniprot.faa
rm toplist.txt ${f}_list-rRNA-uniprot.txt

# hmmscan with Pfam
# The number of parallel working processes is set to 8 by default, but you can adjust this based on the file size and your analysis environment.
seqkit split -p 8 ${f}-rRNA-uniprot.faa
time parallel 07_1_hmmscan.sh ${f}-rRNA-uniprot.faa.split/${f}-rRNA-uniprot.part_00{}.faa ${f}-rRNA-uniprot_pfam{}.txt ${db}/${pfam} ::: 1 2 3 4 5 6 7 8
cat ${f}-rRNA-uniprot_pfam*.txt | grep "#" -v > ${f}-rRNA-uniprot_pfam.txt

# concatenation annotation information into gtf formated file
07_2_faablastpfam2gtf4tpm.py --faa ${f}.faa --rrna ${f}_rRNAlist.txt --uniprot ${f}-rRNA_uniprot.txt --pfam ${f}-rRNA-uniprot_pfam.txt -o ${f}_annotation.gtf

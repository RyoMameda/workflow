#!/bin/sh

threads=10

# input and output file path
dir=db
#

cd ${db}

# rRNA data from NCBI
curl -O https://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz
curl -O https://ftp.ncbi.nlm.nih.gov/blast/db/18S_fungal_sequences.tar.gz
curl -O https://ftp.ncbi.nlm.nih.gov/blast/db/28S_fungal_sequences.tar.gz
curl -O https://ftp.ncbi.nlm.nih.gov/blast/db/LSU_eukaryote_rRNA.tar.gz
curl -O https://ftp.ncbi.nlm.nih.gov/blast/db/LSU_prokaryote_rRNA.tar.gz
curl -O https://ftp.ncbi.nlm.nih.gov/blast/db/SSU_eukaryote_rRNA.tar.gz
tar -zxvf *.tar.gz
# index files for BLASTN are included in tar archives

# Swiss-Prot data from UniProt
curl -O https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
# making BLASTP index files
pigz -d uniprot_sprot.fasta.gz
diamond makedb -in uniprot_sprot.fasta -db uniprot_sprot --threads ${threads}
pigz uniprot_sprot.fasta

# Pfam data from InterPro
curl -O https://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz

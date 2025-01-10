#!/usr/bin/env python3

import os
import argparse

def process_faa_file(faa_path, faa_inter_path):
    processed_lines = []

    with open(faa_path, 'r') as input_file:
        for line in input_file:
            if not line.startswith('>'):
                continue

            line = line.lstrip(">").replace(" # ", "\t")
            columns = line.strip().split("\t")
            if len(columns) >= 4:
                columns.insert(1, "predicted_protein_coding\tpredicted_CDS")
            if len(columns) >= 5:
                if int(columns[4]) == 1:
                    columns[4] = ".\t+\t0"
                elif int(columns[4]) == -1:
                    columns[4] = ".\t-\t0"
            if len(columns) >= 5:
                modified_line = "\t".join(columns[:5])
                processed_lines.append(modified_line)

    with open(faa_inter_path, 'w') as inter_file:
        for line in processed_lines:
            inter_file.write(line + "\n")

def process_rRNA_file(input_file, output_file):
    seen = set()
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            parts = line.strip().split('\t')
            if parts[0] not in seen:
                seen.add(parts[0])
                outfile.write(f"{parts[0]}\trRNA_{parts[1][:-1].replace('|', '_')}\n")

def process_uniprot_file(input_file, output_file):
    seen = set()
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            parts = line.strip().split('\t')
            if parts[0] not in seen:
                seen.add(parts[0])
                outfile.write(f"{parts[0]}\tUniProt_{parts[1].replace('sp|', '').replace('|', '_')}\n")

def process_pfam_file(input_file, output_file):
    seen = set()
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            parts = ' '.join(line.strip().split()).split(' ')
            if len(parts) >= 3 and parts[2] not in seen:
                seen.add(parts[2])
                outfile.write(f"{parts[2]}\tPfam_{parts[1]}_{parts[0]}\n")

def merge_files_and_output(faa_inter_path, annote_inter_path, output_path):
    with open(annote_inter_path, 'r') as f:
        b_data = {}
        for line in f:
            columns = line.strip().split('\t')
            if len(columns) > 1:
                b_data[columns[0]] = (columns[1])

    with open(faa_inter_path, 'r') as f, open(output_path, 'w') as out_file:
        for line in f:
            columns = line.strip().split('\t')
            append_data = b_data.get(columns[0], (""))
            combined_data = append_data if append_data != ("") else "hypothetical protein"
            gene_id_data = 'gene_id "' + combined_data + ';' + columns[0] + '"'
            columns.insert(9, gene_id_data)
            out_file.write('\t'.join(columns) + '\n')

def main():
    parser = argparse.ArgumentParser(description='Process files and output GTF.')
    parser.add_argument('--faa', required=True, help='Path to prodigal output faa file')
    parser.add_argument("--rrna", required=True, help="Path to the rNRA annotated output file")
    parser.add_argument("--uniprot", required=True, help="Path to the diamond output file")
    parser.add_argument("--pfam", required=True, help="Path to the hmmscan output file")
    parser.add_argument('-o', '--output', required=True, help='output GTF file')

    args = parser.parse_args()

    uniprot_output = "_inter_uniprot_temp.txt"
    rrna_output = "_inter_rRNA_temp.txt"
    pfam_output = "_inter_pfam_temp.txt"
    faa_inter_path = "_inter_prodigal_faainter.txt"
    annote_out_path = "_inter_prodigal_annote_out.txt"

    process_faa_file(args.faa, faa_inter_path)
    process_rRNA_file(args.rrna, rrna_output)
    process_uniprot_file(args.uniprot, uniprot_output)
    process_pfam_file(args.pfam, pfam_output)

    # Combine the two output files into the final output
    with open(annote_out_path, 'w') as final_output:
        with open(rrna_output, 'r') as rrna_temp, open(uniprot_output, 'r') as uniprot_temp, open(pfam_output, 'r') as pfam_temp:
            for line in rrna_temp:
                final_output.write(line)
            for line in uniprot_temp:
                final_output.write(line)
            for line in pfam_temp:
                final_output.write(line)

    merge_files_and_output(faa_inter_path, annote_out_path, args.output)

    os.remove(faa_inter_path)
    os.remove(annote_out_path)
    os.remove(uniprot_output)
    os.remove(pfam_output)
    os.remove(rrna_output)

if __name__ == "__main__":
    main()

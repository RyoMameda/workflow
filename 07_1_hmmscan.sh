#!/bin/sh

input_file="$1"
output_file="$2"
pfam_data="$3"
hmmscan --tblout "$output_file" --notextw -E 0.1 "$pfam_data" "$input_file"

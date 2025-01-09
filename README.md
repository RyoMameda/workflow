# Gene Expression Analysis Workflow in Complex Microbiomes
This workflow focuses on data-driven gene expression analysis in complex microbiomes. It utilizes both metagenomic and metatranscriptomic NGS data. The NGS data should consist of short reads, either retrieved from public databases or obtained directly from complex microbiome samples. The workflow is implemented through a series of shell and Python scripts. Numbers included in the script names correspond to the steps in the analysis described below.  

- 01 Retrieval of metagenomic and metatranscriptomic read data from public databases
- 02 Quality control of reads
- 03 Construction and quality assessment of metagenomic contigs
- 04 Prediction of protein-coding sequences
- 05 Mapping reads to metagenomic contigs and evaluation of mapping results
- 06 Annotation of predicted protein sequences
- 07 Quantification process

## Requierments
- Miniconda or Homebrew is required to install following software packages;
    - `pigz`
    - `sratools`
    - `fastp`
    - `megahit`
    - `seqkit`
    - `prodigal`
    - `bwa`
    - `samtools`
    - `blast`
    - `diamond`
    - `hmmer`
    - `subread`
    - `parallel`
    - Python version 3 or later

## Citing
If you use the scripts, please cite; To be submitted.  
We recommend also citing software packages listed at "Requirments".

This repository contains the code necessary for the comparative analysis of original proteomics data from Prakash et al 2023 and RNA-seq data from Hasel et al 2021 (PMID: 34413515). 

The notebook 'analysis.ipynb' contains the code for the comparative analysis, and requires the proteomics Excel file 'Rodent_TICI_VEH_CellularProteome_Mouse_Rat_imputed.xls' and RNA-seq salmon 'quant.sf' files as input. Code to preprocess the RNA-seq data and generate the 'quant.sf' files from FASTQ files (data available at NCBI GEO accession GSE165069) is located in the 'rnaseq_preprocessing' directory.

The 'analysis.ipynb' notebook uses R (4.1.3) implemented in jupyter-lab. All required dependencies can be installed via conda using the following line:

conda env create --name proteomics_rnaseq_analysis --file=environments.yml
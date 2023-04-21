This folder contains the code necessary for the quality control checking, adaptor trimming, and mapping with salmon for the preprocessing of RNA-sequencing data from Hasel et al 2021 from FASTQ files on a SLURM scheduler system. 

To run this pipeline, you should first create a folder for your experiment, and a subdirectory within that folder called 'fastq' containing the fastq files. Subdirectory folders containing bash scripts for each step of the pipeline should be located in the same folder.

Conda must be installed and a conda environment must be created with the proper dependencies installed. Run the following lines to set up the conda environment, provided you already have conda installed:

conda env create --name rnaseq_pipeline --file=environments.yml

Provided the proper file structure exists, the pipeline can then be run with the command 'sbatch rnaseq_pipeline_script.sh'.

Note that, 
1. users ought to change the .sh scripts in the provided pipeline so that the email contact reflects their own email address for the SLURM system to notify them. There are 5 .sh scripts that need to be edited for the pipeline to run: 'rnaseq_pipeline_script.sh', 'fastqc/pre_trimming/fastqc_script.sh', 'fastqc/post_trimming/fastqc_script.sh', 'multiqc/multiqc_script.sh', 'trimming/trimming_script.sh', 'salmon/salmon_script.sh'
2. users need to change each of the 4 .sh scripts which use the conda environment ('fastqc/pre_trimming/fastqc_script.sh', 'fastqc/post_trimming/fastqc_script.sh', 'multiqc/multiqc_script.sh', 'trimming/trimming_script.sh', 'salmon/salmon_script.sh'), changing the file path in the line 'source /file_path/anaconda3/bin/activate rnaseq_pipeline' so that it refers to their conda environment.
3. this pipeline uses salmon to map reads to the Rn6 reference transcriptome using the whole primary assembly genome as a decoy. The salmon index was created first using the bash script 'salmon/salmon_index.sh'. The transcriptome and genome fasta files were first downloaded and processed using the 'salmon/salmon_Rnor_6-0.sh' script.

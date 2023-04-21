#!/bin/bash
#SBATCH --partition=cpu_short # partition on which to run
#SBATCH --job-name=step5 # name 
#SBATCH --mail-type=ALL #Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=email #Where to send mail
#SBATCH --ntasks=1 #Run on # of CPUs
#SBATCH --mem-per-cpu=4gb #Job memory request ##max 128GB
#SBATCH --time=12:00:00 #Time limit hrs:min:sec
#SBATCH --output=./multiqc_reports/multiqc_script.log #Standard output and error log
#SBATCH --no-kill


source /file_path/anaconda3/bin/activate rnaseq_pipeline

# multiqc pre_trimming fastqc
multiqc ./fastqc/pre_trimming/ -o ./multiqc_reports/pre_trimming_fastqc

# multiqc trimming
multiqc ./trimming -o ./multiqc_reports/trimming

# multiqc post-trimming fastqc
multiqc ./fastqc/post_trimming -o ./multiqc_reports/post_trimming_fastqc

# multiqc salmon
multiqc ./salmon -o ./multiqc_reports/salmon



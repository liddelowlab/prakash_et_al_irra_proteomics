#!/bin/bash
#SBATCH --partition=cpu_short # partition on which to run
#SBATCH --job-name=sindex # name 
#SBATCH --mail-type=ALL #Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=email #Where to send mail
#SBATCH --ntasks=12 #Run on # of CPUs
#SBATCH --mem-per-cpu=32gb #Job memory request ##max 128GB
#SBATCH --time=12:00:00 #Time limit hrs:min:sec
#SBATCH --output=./salmon_index.log #Standard output and error log
#SBATCH --no-kill

#### USAGE: sbatch salmon_index.sh <k-mer length>
# where <k-mer_length> is an integer; k = 31 is optimal for reads 75 bp or greater; 21 bp for 50 bp data  

source /file_path/anaconda3/bin/activate rnaseq_pipeline

salmon index -t gentrome_mRatBN7.2.fa.gz -d decoys.txt -p 12 -i "../../rnaseq_pipeline_salmon_indices/mRatBN7_2_k""$1" --gencode -k $1

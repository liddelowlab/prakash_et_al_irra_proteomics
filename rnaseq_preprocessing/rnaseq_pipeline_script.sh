#!/bin/bash
#SBATCH --partition=cpu_short # partition on which to run
#SBATCH --job-name=rnapipe # name 
#SBATCH --mail-type=ALL #Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=email #Where to send mail
#SBATCH --ntasks=1 #Run on # of CPUs
#SBATCH --mem-per-cpu=4gb #Job memory request ##max 128GB
#SBATCH --time=12:00:00 #Time limit hrs:min:sec
#SBATCH --output=./rna_pipeline_script.log #Standard output and error log
#SBATCH --no-kill

# get current directory for altering file paths in dependent scripts
wd=$(pwd)

# get number of samples; to be used for altering number of threads used by the dependent scripts
# get unique samples array
cd "$wd""/fastq"
samples=()
for i in *.fastq.gz
do
  	samples+=(`echo $i | sed 's/\(.*\)_.*.fastq.gz/\1/'`)
done

echo ${samples[@]}

uniq_samples=($(echo "${samples[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

sn=${#uniq_samples[@]}

sn="$((sn-1))"

echo $sn

# get number of unique pairings for trimming
cd "$wd""/fastq"
samples2=()
for i in *.fastq.gz
do
  	samples2+=(`echo $i | sed 's/\(.*\)_.*.fastq.gz/\1/'`)
done

echo ${samples2[@]}

uniq_samples2=($(echo "${samples2[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

tn=${#uniq_samples2[@]}

tn="$((tn-1))"

echo $tn


# change back to working directory
cd $wd

#### RNA-seq pipeline in 5 steps

# Step 1: pre-trimming FastQC QC
step1=$(sbatch --parsable fastqc/pre_trimming/fastqc_script.sh $wd)

# Step 2: adaptor trimming with trim_galore
step2=$(sbatch --dependency=afterok:$step1 --parsable --array="0-""$tn" trimming/trimming_script.sh $wd)

# Step 3: post-trimming FastQC QC
step3=$(sbatch --dependency=afterok:$step2 --parsable fastqc/post_trimming/fastqc_script.sh $wd)

# Step 4: mapping with salmon
step4=$(sbatch --dependency=afterok:$step3 --parsable --array="0-""$sn" salmon/salmon_script.sh $wd)

# Step 5: summarizing with multiqc
step5=$(sbatch --dependency=afterok:$step4 --parsable multiqc_reports/multiqc_script.sh)

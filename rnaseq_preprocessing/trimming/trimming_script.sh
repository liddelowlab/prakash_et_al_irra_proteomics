#!/bin/bash
#SBATCH --partition=cpu_medium # partition on which to run
#SBATCH --job-name=step2 # name 
#SBATCH --mail-type=ALL #Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=michael.odea@nyulangone.org #Where to send mail
#SBATCH --ntasks=2 #Run on # of CPUs
#SBATCH --mem-per-cpu=8gb #Job memory request ##max 128GB
#SBATCH --time=5-00:00:00 #Time limit hrs:min:sec
#SBATCH --output=./trimming/trimming_%a.log #Standard output and error log
#SBATCH --no-kill

cd "$1""/fastq"

# get unique samples array
samples2=()
for i in *.fastq.gz
do
  	samples2+=(`echo $i | sed 's/\(.*\)_.*.fastq.gz/\1/'`)
done

echo ${samples2[@]}

uniq_samples2=($(echo "${samples2[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

echo ${uniq_samples2[@]}

source /gpfs/data/liddelowlab/mo2253/anaconda3/bin/activate rnaseq_pipeline

trim_galore --paired --output_dir ../trimming --cores 2 "${uniq_samples2[$SLURM_ARRAY_TASK_ID]}""_1.fastq.gz" "${uniq_samples2[$SLURM_ARRAY_TASK_ID]}""_2.fastq.gz"


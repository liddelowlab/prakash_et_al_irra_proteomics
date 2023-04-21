#!/bin/bash
#SBATCH --partition=cpu_medium # partition on which to run
#SBATCH --job-name=step4 # name 
#SBATCH --mail-type=ALL #Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=email #Where to send mail
#SBATCH --ntasks=4 #Run on # of CPUs
#SBATCH --mem-per-cpu=32gb #Job memory request ##max 128GB
#SBATCH --time=5-00:00:00 #Time limit hrs:min:sec
#SBATCH --output=./salmon/salmon_%a.log #Standard output and error log
#SBATCH --no-kill

cd ./trimming

# get unique samples array
samples=()
for i in *.fq.gz
do
	samples+=(`echo $i | sed 's/\(.*\)_.*_val_.*.fq.gz/\1/'`)
done

echo ${samples[@]}

uniq_samples=($(echo "${samples[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

echo ${uniq_samples[@]}

R1_files=($(ls "${uniq_samples[$SLURM_ARRAY_TASK_ID]}""_1_val_1.fq.gz"))
echo ${R1_files[@]}

R2_files=($(ls "${uniq_samples[$SLURM_ARRAY_TASK_ID]}""_2_val_2.fq.gz"))
echo ${R2_files[@]}

# run salmon

source /file_path/anaconda3/bin/activate rnaseq_pipeline

mkdir -p ../salmon/output/

salmon quant -i "../../rnaseq_pipeline_salmon_indices/mRatBN7_2_k21" -l A \
	-1 <(gunzip -c echo ${R1_files[@]}) -2 <(gunzip -c echo ${R2_files[@]}) \
	--validateMappings --seqBias --gcBias -p 4 --output="../salmon/output/""${uniq_samples[$SLURM_ARRAY_TASK_ID]}"

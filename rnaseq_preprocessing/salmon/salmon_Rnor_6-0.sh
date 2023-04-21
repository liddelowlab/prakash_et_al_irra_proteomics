#!/bin/bash

# running these commands to download Rn6 transcriptome and genome, and format them for salmon indexing

# get Rn6 transcriptome fasta file
wget https://ftp.ensembl.org/pub/release-108/fasta/rattus_norvegicus/cdna/Rattus_norvegicus.mRatBN7.2.cdna.all.fa.gz

# get genome fasta file
wget https://ftp.ensembl.org/pub/release-108/fasta/rattus_norvegicus/dna/Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz

grep "^>" <(gunzip -c Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz) | cut -d " " -f 1 > decoys.txt
sed -i.bak -e 's/>//g' decoys.txt

cat Rattus_norvegicus.mRatBN7.2.cdna.all.fa.gz Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz > gentrome_mRatBN7.2.fa.gz




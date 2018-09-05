#!/usr/bin/env bash

# Setup custom CLARK database
# Usage: ./db_setup <reference-tax_id mapping> <db_folder>
#
#        - <reference-tax_id mapping>   contig-tax_id mapping file
#        - <db_folder>                  path to a folder with custom reference genomes

if [ $# -lt 2 ]; then
    >&2 echo "Invalid number of arguments"
    >&2 echo "Usage: $0 <reference-tax_id mapping> <db_folder>"
    exit
fi

mapping=$(readlink -ev $1)
cd $(dirname $0)

if [ ! -d "CLARKSCV1.2.5" ]; then
    >&2 echo "CLARK folder not found, please first install CLARK using install.sh script."
    exit
fi

cd CLARKSCV1.2.5

# Put reference files into a custom db folder
mkdir -p DIR_DB/Custom
cp "$2/*.fasta DIR_DB/Custom"

# Reset any existing entries
./resetCustomDB.sh

# Taxonomic ID mapping based on supplied mapping file
paste <(ls DIR_DB/Custom/*.fasta) <(grep -P "CR_[0-9]+_Contig_0" \
    $mapping | sort | cut -f1,2) > DIR_DB/.custom.fileToAccssnTaxID

# Create the custom database
./set_targets.sh DIR_DB custom

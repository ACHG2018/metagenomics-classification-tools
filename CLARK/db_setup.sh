#!/usr/bin/env bash

# Setup custom CLARK database
# Usage: ./db_setup <reference-tax_id mapping> <db_folder> [<unique>]
#
#        - <reference-tax_id mapping>   contig-tax_id mapping file
#        - <db_folder>                  path to a folder with custom reference genomes
#        - [<unique>]                   If this argument is specified, each database file is mapped to a unique taxID.
#                                       Mapping taxonomic information is ignored.

if [ $# -lt 2 ]; then
    >&2 echo "Invalid number of arguments"
    >&2 echo "Usage: $0 <reference-tax_id mapping> <db_folder> [<unique>]"
    exit
fi

mapping=$(readlink -ev $1)
db=$(readlink -ev $2)
cd $(dirname $0)

if [ ! -d "CLARKSCV1.2.5.1" ]; then
    >&2 echo "CLARK folder not found, please first install CLARK using install.sh script."
    exit
fi

cd CLARKSCV1.2.5.1

# Put reference files into a custom db folder
mkdir -p DIR_DB/Custom
cp $db/*.fasta DIR_DB/Custom

# Reset any existing entries
./resetCustomDB.sh

if [ $# -eq 3 ] && [ $3 == "unique" ]; then
    >&2 echo "Building database with unique, arbitrary taxonomic IDs"
    # Create file-accession mapping
    paste <(ls DIR_DB/Custom/*.fasta | sort -V) <(grep -P "CR_[0-9]+_Contig_0" \
        $mapping | sort -V | cut -f1) <(ls DIR_DB/Custom/*.fasta \
        | sort -V | cut -f 3 -d_ | cut -f1 -d.) > DIR_DB/.custom.fileToAccssnTaxID
    # Create custom empty hiearchy file
    yes "UNKNOWN" | head -n $(wc -l DIR_DB/.custom.fileToAccssnTaxID | cut -f1 -d" ") > unknown
    paste <(cut -f1,3 DIR_DB/.custom.fileToAccssnTaxID) <(cut -f3 DIR_DB/.custom.fileToAccssnTaxID) \
        unknown unknown unknown unknown > DIR_DB/.custom.fileToTaxIDs
    rm unknown
else
    >&2 echo "Building database with real taxonomic IDs"
    paste <(ls DIR_DB/Custom/*.fasta) <(grep -P "CR_[0-9]+_Contig_0" \
        $mapping | sort | cut -f1,2) > DIR_DB/.custom.fileToAccssnTaxID
fi

# Create the custom database
./set_targets.sh DIR_DB custom

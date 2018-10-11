#!/usr/bin/env bash

# Setup custom Kraken2 database
# Usage: ./db_setup.sh <reference-tax_id-mapping> <db-directory>
#
#	<reference-tax_id-mapping> .tsv file consisting of contig-to-tax_id mappings
#	<db-directory> path to the custom database for Kraken2

if [[ $# -ne 2 ]]; then
	>&2 echo -e "\nInvalid number of arguments.\nUsage: $0 <reference-tax_id-mapping> <db-directory>\n"
	exit
fi

taxMap=$(readlink -e $1)
dbDir=$(readlink -e $2)
cd $(dirname $0)

if [[ ! -d "kraken2-master" ]]; then
	>&2 echo -e "\nKraken2 directory not found... First install Kraken2 by using install.sh\n"
	exit
fi

cd kraken2-master

# Create a directory for the custom database
mkdir customDB

# Download taxonomy information from NCBI
./kraken2-build --download-taxonomy --db customDB

# Add FASTA files to the database
ls $dbDir/*.fasta | xargs -n1 -P10 sh -c 'kraken2-build --add-to-library $0 --db customDB'

# Build database for Kraken2
kraken2-build --build --db customDB

# Build database for Bracken
#
# -k [int] : length of kmer used to build DB
# -l [int] : length of reads in samples
# -t [int] : number of threads
# -d [path] : path to Kraken2 DB

bracken-build -d customDB -t 4 -k 35 -l 151

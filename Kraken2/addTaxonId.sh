#!/usr/bin/env bash

MAPREF=../refGenomeUniqTaxMapping.tsv

# Input file name
file=$1

# Variable to store contig names
contigs=$(grep -oE "CR_[0-9]{1,3}_Contig_[0-9]{1,3}" $1)

# Create array containing all contigs within a .fasta file
contigArr=($(echo $contigs))
# Iterate through the array to update FASTA headers
for i in ${contigArr[@]}
do
	# Change cut to exclude additional taxonomy information extracted from MAPREF
	taxid=$(grep "$i\s" $MAPREF | cut -f2)
	newHead="$i|kraken:taxid|$taxid"
	sed -i -e "s%$i%$newHead%" $file
done

#!/usr/bin/env bash

# Run CLARK classification
# Usage: ./classify.sh <r1> <r2> <out_prefix>
#
#        - <r1>          forward reads
#        - <r2>          reverse reads
#        - <out_prefix>  output prefix
#
# Outputs:
#        - raw.csv       Each read mapped to taxonomic id
#        - abundance.txt Overall abundance estimation

if [ $# -lt 3 ]; then
    >&2 echo "Invalid number of arguments"
    >&2 echo "Usage: $0 <r1> <r2> <out_prefix>"
    exit
fi

r1=$(readlink -ev $1)
r2=$(readlink -ev $2)
current=$(readlink -ev .)

cd "$(dirname $0)/CLARKSCV1.2.5.1"

if [ ! -d "DIR_DB/Custom" ]; then
    >&2 echo "CLARK custom database not found. Please run db_setup.sh script first."
    exit
fi

# Clark classification
./classify_metagenome.sh -P $r1 $r2 \
    -R "${current}/$3_raw" --light

# Abundance estimation
./estimate_abundance.sh -F "${current}/$3_raw.csv" \
    -D DIR_DB > "${current}/$3_abundance.txt"

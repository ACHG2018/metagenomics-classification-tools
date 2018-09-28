#!/usr/bin/env bash

# Run CLARK classification
# Usage: ./classify.sh <r1> <r2> <out_prefix> <mapping> [<unique>]
#
#        - <r1>                         forward reads
#        - <r2>                         reverse reads
#        - <out_prefix>                 output prefix
#        - <reference-tax_id mapping>   contig-tax_id mapping file
#        - [<unique>]                   Unique, arbitrary mapping was used for the database.
#                                       For this mapping, a custom abundance estimation is used.
#
# Outputs:
#        - raw.csv       Each read mapped to taxonomic id
#        - abundance.txt Overall abundance estimation

if [ $# -lt 4 ]; then
    >&2 echo "Invalid number of arguments"
    >&2 echo "Usage: $0 <r1> <r2> <out_prefix> <mapping> [<unique>]"
    exit
fi

r1=$(readlink -ev $1)
r2=$(readlink -ev $2)
current=$(readlink -ev .)
mapping=$(readlink -ev $4)

cd "$(dirname $0)/CLARKSCV1.2.5.1"

if [ ! -d "DIR_DB/Custom" ]; then
    >&2 echo "CLARK custom database not found. Please run db_setup.sh script first."
    exit
fi

# Clark classification
./classify_metagenome.sh -P $r1 $r2 \
    -R "${current}/$3_raw" --light

# Abundance estimation
if [ $# -eq 5 ] && [ $5 == "unique" ]; then
    # Custom estimation needs to be used for arbitrary mapping
    tail -n+2 "${current}/$3_raw.csv" | cut -f3 -d, | sort | uniq -c  | \
        sort -k1,1nr | tr -s " " | tr " " "\t"  | cut -f2- > "${current}/$3.cnts"
    grep -P "CR_[0-9]+_Contig_0" $mapping | cut -f2,4 -d_ | \
        cut -f 1,3 | sed "s/_0//" > "${current}/$3.mapping"
    join -1 2 -2 1 <(sort -k2,2 "${current}/$3.cnts") <(sort -k1,1 "${current}/$3.mapping") | \
        sort -k2,2nr | awk 'BEGIN{print "Count Reference Species"} {a=$2; $2=$1; $1=a; print}' | \
        sed "s/\ /\t/" | sed "s/\ /\t/" > "${current}/$3_abundance.txt"
    rm "${current}/$3.mapping" "${current}/$3.cnts"
else
    ./estimate_abundance.sh -F "${current}/$3_raw.csv" \
        -D DIR_DB > "${current}/$3_abundance.txt"
fi

#!/usr/bin/env bash

# Run Bracken for abundance estimation
# Usage: ./classify.sh <num-threads> <db-dir> <sample-output-dir>
#
#	- <num-threads>		# of threads to run Bracken
#	- <db-dir>		Bracken DB directory
#	- <sample-output-dir>	Directory that contains sample report
#				output from Kraken2 runs
#
# Outputs:
#	- <input-sample-report>.bracken
#
# Note: The script assumes that 'bracken' is available in current environment

nt=$1
dbDir=$(readlink -ev $2)
soDir=$(readlink -ev $3)

if [[ $# != 3 ]]; then
	>&2 echo -e "\nInvalid # of arguments"
	>&2 echo -e "Usage: ./classify.sh <num-threads> <db-dir> <sample-output-dir>\n"
	exit 1
fi

if [[ ! -d $dbDir ]]; then
	>&2 echo -e "\nDatabase directory '$dbDir' does not exist\n"
	exit 1
fi

if [[ ! -d $soDir ]]; then
	>&2 echo -e "\nSample report directory '$soDir' does not exist\n"
	exit 1
fi

mkdir brackenResults

ls $soDir/*sample_result.txt | xargs -n1 bash -c 'bracken -d $dbDir -i $0 -o brackenResults/$(basename $0 _sample_result.txt).bracken -r 151 -l S -t $nt'

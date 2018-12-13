# Clark readme

This folder contains

 * scripts for installation and run of the [CLARK](http://clark.cs.ucr.edu/) metagenomics classification tool
 * Results for different sets of input files,

See [CLARK Wiki Page](https://github.com/ACHG2018/metagenomics-classification-tools/wiki/CLARK) for further details.

## Usage of the Scripts

Download and install CLARK
```
./install.sh
```

Build custom database, `reference_folder` is a path to the folder with the custom database
* _unique_ flag forces the script to treat each database entry as an individual species, even if they are taxonomically from the same species
```
./db_setup.sh ../refGenomeTaxMapping.tsv reference_folder [unique]
```

Run, `OUT` is the prefix for the output files
```
./classify.sh r1.fasta r2.fasta OUT ../refGenomeTaxMapping.tsv [unique]
```

## Example run

See [example run](https://github.com/ACHG2018/metagenomics-classification-tools/blob/master/CLARK/run_example.sh) in which these scripts were used to generate a result for https://precision.fda.gov/challenges/3.


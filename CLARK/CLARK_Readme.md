# Clark Results

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
```
./db_setup.sh ../refGenomeTaxMapping.tsv reference_folder
```

Run, `OUT` is the prefix for the output files
```
./classify.sh r1.fasta r2.fasta OUT
```


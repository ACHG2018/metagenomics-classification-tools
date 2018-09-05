# Clark Results

This folder contains scripts for installation and run of the [CLARK](http://clark.cs.ucr.edu/) metagenomics classification tool as well as results for a CLARK run on the testing `Hello_World` fasta file.

See [CLARK Wiki Page](https://github.com/ACHG2018/metagenomics-classification-tools/wiki/CLARK) for further details.

## Scripts Usage

Install
```
./install.sh
```

Build custom db
```
./db_setup.sh ../refGenomeTaxMapping.tsv reference_folder
```

Run
```
./classify.sh r1.fasta r2.fasta OUT
```

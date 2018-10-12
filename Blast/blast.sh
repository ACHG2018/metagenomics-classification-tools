#!/usr/bin/env bash
# Blast samples against custom database

### Install needed tools, hard-coded to use sudo though
sudo apt install ncbi-blast+
sudo apt-get install seqtk
sudo apt-get install fastx-toolkit

### Getting the source directory of a Bash script from within
cd `dirname $0`

wget http://vannberg.biology.gatech.edu/data/ChallengeDataSets.tar.gz
tar xzf ChallengeDataSets.tar.gz
rm ChallengeDataSets.tar.gz

wget http://vannberg.biology.gatech.edu/data/ChallengeDataSetsPt2.tar.gz
tar xzf ChallengeDataSetsPt2.tar.gz
rm ChallengeDataSetsPt2.tar.gz

wget http://vannberg.biology.gatech.edu/data/ChallengeRefGenomes.tar.gz
tar xzf ChallengeRefGenomes.tar.gz
rm ChallengeRefGenomes.tar.gz

## building custom db
cd ChallengeGenomes
cat CR*.fasta > precisionFDA.fasta
makeblastdb -in precisionFDA.fasta -dbtype nucl

# blast Challenge data against the reference
mkdir -p ../result/tmp_folder
 cd ../result
ls ../Challenge_Data_NTC_POS/*R{1,2}.fastq | xargs -n1 sh -c 'fastx_clipper -Q33 -l 1 -i $0 -o $0.filtered'
ls ../Challenge_Data_NTC_POS/*.filtered | xargs -n1 sh -c 'seqtk seq -a $0 > $0.fa'
ls ../Challenge_Data_NTC_POS/*.fa | xargs -n1 sh -c 'time blastn -db ../ChallengeGenomes/precisionFDA.fasta -query $0 -max_target_seqs 1 -max_hsps 1 -outfmt 6 -out $0.output'
cp ../Challenge_Data_NTC_POS/*.output ../result/tmp_folder
rm ../Challenge_Data_NTC_POS/*.filtered
rm ../Challenge_Data_NTC_POS/*.fa

ls ../Challenge_Data_Sets/*R{1,2}.fastq | xargs -n1 sh -c 'fastx_clipper -Q33 -l 1 -i $0 -o $0.filtered'
ls ../Challenge_Data_Sets/*.filtered | xargs -n1 sh -c 'seqtk seq -a $0 > $0.fa'
ls ../Challenge_Data_Sets/*.fa | xargs -n1 sh -c 'time blastn -db ../ChallengeGenomes/precisionFDA.fasta -query $0 -max_target_seqs 1 -max_hsps 1 -outfmt 6 -out $0.output'
cp ../Challenge_Data_Sets/*.output ../result/tmp_folder
rm ../Challenge_Data_Sets/*.filtered
rm ../Challenge_Data_Sets/*.fa 


mkdir result_merge_purpose
mkdir abundance

# generate results for merge purposes
ls ./tmp_folder/*R1.fq.*output | xargs -n1 sh -c 'cut -f 1,2 $0 | sed "s/\//|/g" | cut -d "|" -f 1,4 | sed "s/|/\t/" > $0.merge'
ls ./tmp_folder/*R1.fastq.*output | xargs -n1 sh -c 'cut -f 1,2 $0 | sed "s/|/\t/g" | cut -f 1,4 > $0.merge'
mv ./tmp_folder/*.merge ./result_merge_purpose/


# generate results for submission
ls ./tmp_folder/*.output | xargs -n1 sh -c 'cut -f 2 $0|cut -d "_" -f 1,2| sort | uniq -c | sort -n -r> $0.abundance'
ls ./tmp_folder/*.abundance | xargs -n1 sh -c '../counter3.pl $0 | sort -k1,1V > $0.count'
mv ./tmp_folder/*.count ./abundance/
paste ./abundance/*R1.*count | cut -f1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42 > ./abundance/Blast_abundance.csv



#!/usr/bin/env bash
# This run of clark treats each fasta file in the database as a separate species
# Final output for the competition is also generated based on this result

cd $(dirname $0)

wget http://vannberg.biology.gatech.edu/data/ChallengeDataSets.tar.gz
tar xzf ChallengeDataSets.tar.gz
rm ChallengeDataSets.tar.gz

wget http://vannberg.biology.gatech.edu/data/ChallengeDataSetsPt2.tar.gz
tar xzf ChallengeDataSetsPt2.tar.gz
rm ChallengeDataSetsPt2.tar.gz

wget http://vannberg.biology.gatech.edu/data/ChallengeRefGenomes.tar.gz
tar xzf ChallengeRefGenomes.tar.gz
rm ChallengeRefGenomes.tar.gz

git clone https://github.com/ACHG2018/metagenomics-classification-tools.git
cd metagenomics-classification-tools/CLARK
# Custom installation script
./install.sh
# Custom database treating each fasta file as a unique species
./db_setup.sh ../refGenomeTaxMapping.tsv ../../ChallengeGenomes unique

cd ../../

# Classify part 1
seq -w 10 | head -9 | xargs -I {} bash -c './metagenomics-classification-tools/CLARK/classify.sh Challenge_Data_Sets/C{}_R1.fq Challenge_Data_Sets/C{}_R2.fq C{} metagenomics-classification-tools/refGenomeTaxMapping.tsv unique'

seq 10 15 | xargs -I {} bash -c './metagenomics-classification-tools/CLARK/classify.sh Challenge_Data_Sets/C{}_R1.fastq Challenge_Data_Sets/C{}_R2.fastq C{} metagenomics-classification-tools/refGenomeTaxMapping.tsv unique'

# Classify part 2
seq 16 21 | xargs -I {} bash -c './metagenomics-classification-tools/CLARK/classify.sh Challenge_Data_NTC_POS/C{}_R1.fastq Challenge_Data_NTC_POS/C{}_R2.fastq C{} metagenomics-classification-tools/refGenomeTaxMapping.tsv unique'

# Convert the abundance file into a submission format
seq -w 21 | xargs -I {} bash -c "metagenomics-classification-tools/CLARK/prepare_submission.py C{}_abundance.txt submission_C{}"

# Create final two submission files
# Submission header
echo Reference,$(seq -w 21 | xargs -I{} echo C_{} | tr "\n" ",") | sed -E "s/,$//" > header

# Confidence for all inputs in one file
seq -w 21 | xargs -I {} bash -c "cut -f2 submission_C{}.confidence.tsv > C{}_C"
cat header <(paste <(cut -f1 submission_C01.confidence.tsv) C*_C | tail -n +2 | tr "\t" ",") > confidence.csv

# Abundance for all inputs in one file
seq -w 21 | xargs -I {} bash -c "cut -f2 submission_C{}.abundance.tsv > C{}_A"
cat header <(paste <(cut -f1 submission_C01.abundance.tsv) C*_A | tail -n +2 | tr "\t" ",") > abundance.csv


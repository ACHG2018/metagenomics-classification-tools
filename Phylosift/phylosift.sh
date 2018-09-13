#!/usr/bin/bash
#
#
# Download Phylosift
echo "downloading phylosift.."
wget "https://ndownloader.figshare.com/articles/5755404/versions/4"
echo "done!"
##########################################################################
#
#
#
# Download Challenge Data
echo "downloading datasets..."
wget "http://vannberg.biology.gatech.edu/data/ChallengeDataSets.tar.gz"
wget "http://vannberg.biology.gatech.edu/data/ChallengeDataSetsPt2.tar.gz"
wget "http://vannberg.biology.gatech.edu/data/ChallengeRefGenomes.tar.gz"
echo "done!"
echo "unzipping files..."
unzip 4
ls *.gz | xargs -I one  tar -xvzf one
ls *tgz | xargs -I one  tar -xvzf one
ls *bz2 | xargs -I one  tar -xvjf one
echo "done!"
##########################################################################
#
#
#
# Relocate Phylosift maker database
echo "creating folder for database..."
mkdir ~/share
mkdir ~/share/phylosift
mv -t ~/share/phylosift markers
mv -t ~/share/phylosift ncbi
echo "done!"
##########################################################################
#
#
#
# Prepare file list for running Phylosift
echo "Creating files list..."
cd "./Challenge_Data_Sets"
ls -d -1 "$PWD"/* > ../phylosift_v1.0.1/list.txt
cd ..
cd "./Challenge_Data_NTC_POS"
ls -d -1 "$PWD"/* >> ../phylosift_v1.0.1/list.txt
cd ..
cd "./phylosift_v1.0.1"
awk ' NR % 2 == 1 { print; }' list.txt > R1.txt
awk ' NR % 2 == 0 { print; }' list.txt > R2.txt
echo "done!"
##########################################################################
#
#
#
# Run Phylosift on Chanlleng Data
while read r1 <&3 && read r2 <&4; do
	echo "running phylosift on $r1 and $r2..."
	./phylosift all -f --paired "$r1" "$r2"
done 3<R1.txt 4<R2.txt
##########################################################################

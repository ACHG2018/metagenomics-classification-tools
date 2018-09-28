#!/usr/bin/env bash

# This script downloads and installs CLARK metagenomic sequence
# classification tool (http://clark.cs.ucr.edu/)

cd $(dirname $0)
wget http://clark.cs.ucr.edu/Download/CLARKV1.2.5.1.tar.gz
tar -xzvf CLARKV1.2.5.1.tar.gz
rm CLARKV1.2.5.1.tar.gz
cd CLARKSCV1.2.5.1
./install.sh

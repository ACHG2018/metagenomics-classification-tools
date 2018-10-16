#!/usr/bin/env bash

# Retrieve current directory for the install.sh script
cd $(dirname $0)

# Download source code from github
wget https://github.com/DerrickWood/kraken2/archive/master.zip
wget https://github.com/jenniferlu717/Bracken.git

unzip master.zip

rm master.zip
cd kraken2-master

# Install Kraken2
./install_kraken2.sh $(dirname $0)

cd $(dirname $0)
cd Bracken
./install_bracken.sh

cd $(dirname $0)

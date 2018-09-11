#!/bin/bash
#wget "https://ndownloader.figshare.com/articles/5755404/versions/4"
#unzip 4
#ls *tgz | xargs -I one  tar -xvzf one
#ls *bz2 | xargs -I one  tar -xvjf one
mkdir -p ~/share/phylosift
mv -t markers ~/share/phylosift
mv -t ncbi ~/share/phylosift
cd phylosift_v1.0.1
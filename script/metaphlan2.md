# Metaphlan2 #


## Installation ##

`conda install metaphlan2`

`docker pull segatalab/metaphlan2`

`hg clone https://bitbucket.org/biobakery/metaphlan2 `

Metaphlan2 is useable right out of package

## Test Data ##

The Following command downloads test data offered by metaphlan2 official site

`mkdir data`

`cd data`

`curl -O https://bitbucket.org/biobakery/biobakery/raw/tip/demos/biobakery_demos/data/metaphlan2/input/SRS014476-Supragingival_plaque.fasta.gz`

`curl -O https://bitbucket.org/biobakery/biobakery/raw/tip/demos/biobakery_demos/data/metaphlan2/input/SRS014494-Posterior_fornix.fasta.gz`

`curl -O https://bitbucket.org/biobakery/biobakery/raw/tip/demos/biobakery_demos/data/metaphlan2/input/SRS014459-Stool.fasta.gz`

After we get our data, we can run the following command:

`metaphlan2.py SRS014459-Stool.fasta.gz --input_type fasta --nproc 4 > SRS014459-Stool_profile.txt`

Where `SRS001459-Stool.fasta.gz`

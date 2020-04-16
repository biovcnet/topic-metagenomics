#!/bin/bash

cd ~/topic-metagenomics

# download and install Krona tools
wget https://github.com/marbl/Krona/releases/download/v2.7.1/KronaTools-2.7.1.tar
tar xvf KronaTools-2.7.1.tar

cd KronaTools-2.7.1

./install.pl --prefix ./

# to use most recent version of NCBI taxonomy:
#wget http://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
#mv taxdump.tar.gz taxonomy/

#to use the SILVA taxonomy from Kraken2:
cp ~/topic-metagenomics/kraken2-2.0.9-beta/silva/taxonomy/* ./taxonomy/
./updateTaxonomy.sh --only-build

export PATH=$PATH:`pwd`/bin

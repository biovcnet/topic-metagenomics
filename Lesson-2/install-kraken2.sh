#!/bin/bash

cd ~/topic-metagenomics

# download kraken2 source code
wget https://github.com/DerrickWood/kraken2/archive/v2.0.9-beta.tar.gz

# extract source code
tar xvzf v2.0.9-beta.tar.gz

# move into source code directory
cd kraken2-2.0.9-beta/

# run installation script
./install_kraken2.sh ./

# add kraken executables to $PATH
export PATH=$PATH:`pwd`

# due to time, space, and memory constraints on Binder, 
# we're going to use the SILVA rRNA database rather than 
# a more complete database containing millions of genes/proteins
# to build the standard database, which uses 100Gb, 
# you would do e.g. kraken2-build --standard --threads 4 --db standard

# build SILVA database
kraken2-build --db silva --special silva

# add database to $KRAKEN2_DB_PATH
export KRAKEN2_DB_PATH=`pwd`

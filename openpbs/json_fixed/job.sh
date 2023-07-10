#!/bin/bash -eu
#PBS -l select=1:ncpus=12
#PBS -l walltime=24:00:00

GIT_REF=json_leading_zeros

PREFIX=/apl/packages/util/openpbs/$GIT_REF

cd $PBS_O_WORKDIR
git clone https://github.com/CESNET/pbspro.git
cd pbspro
git checkout $GIT_REF 

./autogen.sh
./configure --prefix=${PREFIX}
make -j12
make install


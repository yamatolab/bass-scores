#!/bin/bash
#PBS -l select=1:ncpus=12
#PBS -l walltime=24:00:00

GIT_REF=2d6edc8

PREFIX=/apl/packages/util/openpbs/$GIT_REF

cd $PBS_O_WORKDIR
git clone https://github.com/openpbs/openpbs.git
cd openpbs
git checkout $GIT_REF 

./autogen.sh
./configure --prefix=${PREFIX}
make -j12
make install


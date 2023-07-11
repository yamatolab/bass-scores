#!/bin/bash -eu
#PBS -l select=1:ncpus=4
#PBS -l walltime=24:00:00

GIT_REF=json_leading_zeros

PREFIX=$PREFIX_APP_DIR/packages/util/openpbs/$GIT_REF

cd /lwork/users/$USER/$PBS_JOBID
git clone https://github.com/flat35hd99/pbspro.git
cd pbspro
git checkout $GIT_REF 

./autogen.sh
./configure --prefix=${PREFIX}
make -j `nproc`
make install


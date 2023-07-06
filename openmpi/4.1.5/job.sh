#!/bin/bash
#PBS -l select=1:ncpus=12
#PBS -l walltime=24:00:00

PREFIX=/apl/packages/util/openmpi/4.1.5
PBS_EXEC=/opt/openpbs

cd $PBS_O_WORKDIR
tar -xvf openmpi-4.1.5.tar.bz2
cd openmpi-4.1.5

./configure --prefix=${PREFIX} --with-tm=/opt/openpbs
make -j12
make install

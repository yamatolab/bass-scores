#!/bin/bash -eu
#PBS -l select=1:ncpus=4
#PBS -l walltime=24:00:00

## Build and install
## =================
VERSION="11.4.0"
PACKAGE_PREFIX=/apl/packages/util/gcc-toolset/$VERSION

WORK_DIR=/lwork/$USER/$PBS_JOBID
mkdir -p $WORK_DIR
cd $WORK_DIR

wget "http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-${VERSION}/gcc-${VERSION}.tar.xz"
tar -xvf "gcc-${VERSION}.tar.xz"

mkdir objdir
cd objdir
$PWD/../"gcc-${VERSION}"/configure --prefix=${PACKAGE_PREFIX} --enable-languages=c,c++,fortran
make -j `nproc`
make install

## Add module file
## ===============
mkdir -p /apl/modules/util/gcc-toolset
cat $TEMPLATE_MODULEFILE \
    | sed -e "s/TEMPLATE_PREFIX/${PACKAGE_PREFIX}/g" 
        > /apl/modules/util/gcc-toolset/${VERSION}

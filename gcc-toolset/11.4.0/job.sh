#!/bin/bash -eu
#PBS -l select=1:ncpus=4
#PBS -l walltime=24:00:00

## Build and install
## =================
software_kind=util
name=gcc-toolset
version="11.4.0"

PREFIX=$PREFIX_APP_DIR/packages/$software_kind/$name/$version

WORK_DIR=/lwork/users/$USER/$PBS_JOBID
cd $WORK_DIR

# Download source
wget "http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-${version}/gcc-${version}.tar.xz"
tar -xvf "gcc-${version}.tar.xz"

# Build
mkdir objdir
cd objdir
$PWD/../"gcc-${version}"/configure \
    --prefix=$PREFIX \
    --enable-languages=c,c++,fortran \
    --disable-multilib
make -j `nproc`
make install

# Create modulefile
module_file_path=$PREFIX_APP_DIR/modules/$software_kind/$name/$version
mkdir -p `dirname $module_file_path`
# Set template variables
export TEMPLATE_PREFIX=$PREFIX
envsubst < $APPLICATION_REPOSITORY_PATH/$name/template_modulefile > $module_file_path

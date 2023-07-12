#!/bin/bash -eu
#PBS -l select=1:ncpus=4
#PBS -l walltime=24:00:00

## Build and install
## =================
software_kind=util
name="openmpi"
version="4.1.5"
compiler="gcc-11.4.0"
module_loaded="gcc/11.4.0"

module load $module_loaded

PREFIX="${PREFIX_APP_DIR}/packages/${software_kind}/${name}/${version}-${compiler}"
MODULE_FILE_PATH="${PREFIX_APP_DIR}/modules/${software_kind}/${name}/${version}-${compiler}"

WORK_DIR=/lwork/users/$USER/$PBS_JOBID
cd $WORK_DIR

# Download source
wget "https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-${version}.tar.gz"
tar -xvf "openmpi-${version}.tar.gz"

# Build
cd "openmpi-${version}"
./configure --prefix=${PREFIX} --with-tm=/opt/openpbs
make -j `nproc`
make install

# Create modulefile
mkdir -p `dirname $MODULE_FILE_PATH`
# Set template variables
export TEMPLATE_PREFIX=$PREFIX
export TEMPLATE_DEPENDS_ON=$module_loaded
envsubst < $APPLICATION_REPOSITORY_PATH/$name/template_modulefile > $MODULE_FILE_PATH

## Ensure all users have executable permission for all directories
## and read permission for all files
find $PREFIX_APP_DIR/modules/$software_kind/$name -type d -exec chmod 755 {} \;
chmod 644 $MODULE_FILE_PATH

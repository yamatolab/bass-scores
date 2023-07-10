#!/bin/bash -eu
#PBS -l select=1:ncpus=4
#PBS -l walltime=03:00:00

# Implicit parameters
#  - PREFIX_APP_DIR (e.g. /apl)
#  - APPLICATION_REPOSITORY_PATH (e.g. /home/users/apl_manager/pbs-cluster-applications)

# Explicit parameters
software_kind=apl # or util
name=gromacs
version=2023.1

PREFIX=$PREFIX_APP_DIR/packages/$software_kind/$name/$version

# Prepare working directory
WORK_DIR=/lwork/users/$USER/$PBS_JOBID
mkdir -p $WORK_DIR
cd $WORK_DIR

# Download source
wget "https://ftp.gromacs.org/gromacs/gromacs-${version}.tar.gz"
tar -xvf "gromacs-${version}.tar.gz"
cd "gromacs-${version}"

# Build
./configure --prefix=$PREFIX
make -j `nproc`
make install

# Create modulefile
module_file_path=$PREFIX_APP_DIR/modules/$software_kind/$name/$version
mkdir -p `dirname $module_file_path`
# Set template variables
export TEMPLATE_PREFIX=$PREFIX
envsubst < $APPLICATION_REPOSITORY_PATH/$name/template_modulefile > $module_file_path

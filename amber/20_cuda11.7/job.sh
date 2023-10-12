#!/bin/bash -eu
#PBS -l select=1:ncpus=8:ngpus=1:host=pbs-worker11
#PBS -l walltime=24:00:00

# Parameters
software_kind=apl
name=amber
version=20_cuda10.2

PREFIX=$PREFIX_APP_DIR/packages/$software_kind/$name/$version

WORK_DIR=/lwork/users/$USER/$PBS_JOBID
cd $WORK_DIR

# Download source
cp $APPLICATION_REPOSITORY_PATH/src/Amber20.tar.bz2 .
cp $APPLICATION_REPOSITORY_PATH/src/AmberTools20.tar.bz2 .

# Build
tar -xvf Amber20.tar.bz2
tar -xvf AmberTools20.tar.bz2
cd amber20_src/build

module load cuda/10.2

cmake ../ \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCOMPILER=GNU  \
    -DMPI=FALSE -DCUDA=TRUE -DINSTALL_TESTS=TRUE \
    -DDOWNLOAD_MINICONDA=TRUE \
    2>&1 | tee cmake.log

# Create modulefile
module_file_path=$PREFIX_APP_DIR/modules/$software_kind/$name/$version
mkdir -p `dirname $module_file_path`
# Set template variables
# Commands below assume that TEMPLATE_PREFIX is used in template_modulefile
export TEMPLATE_PREFIX=$PREFIX
envsubst < $APPLICATION_REPOSITORY_PATH/$name/template_modulefile > $module_file_path

## Ensure all users have executable permission for all directories
## and read permission for all files
find $PREFIX_APP_DIR/modules/$software_kind/$name -type d -exec chmod 755 {} \;
chmod 644 $PREFIX_APP_DIR/modules/$software_kind/$name/$version

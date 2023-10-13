#!/bin/bash -eu
#PBS -l select=1:ncpus=8:ngpus=1:host=pbs-worker21
#PBS -l walltime=24:00:00

# Parameters
software_kind=apl
name=amber
version=20_cuda11.7

PREFIX=$PREFIX_APP_DIR/packages/$software_kind/$name/$version

WORK_DIR=/lwork/users/$USER/$PBS_JOBID
cd $WORK_DIR

# Download source
cp $APPLICATION_REPOSITORY_PATH/src/Amber20.tar.bz2 .
cp $APPLICATION_REPOSITORY_PATH/src/AmberTools20.tar.bz2 .

# Build
tar -xvf Amber20.tar.bz2
tar -xvf AmberTools20.tar.bz2
cd amber20_src/

# Apply official patches
source ~/miniconda3/bin/activate
AMBERSOURCE=`pwd`
echo 'y' | $AMBERSOURCE/update_amber --upgrade
$AMBERSOURCE/update_amber --update
conda deactivate

# http://archive.ambermd.org/202110/0196.html
rm AmberTools/src/leap/src/leap/getline.c
cp $APPLICATION_REPOSITORY_PATH/$name/$version/getline.c AmberTools/src/leap/src/leap/getline.c

#patch -u cmake/PythonBuildConfig.cmake \
#    -i $APPLICATION_REPOSITORY_PATH/$name/$version/fix_key_of_unix_prefix.patch
patch -u AmberTools/src/quick/cmake/UseMiniconda.cmake \
   -i $APPLICATION_REPOSITORY_PATH/$name/$version/fix_python_build.patch
patch -u cmake/UseMiniconda.cmake \
   -i $APPLICATION_REPOSITORY_PATH/$name/$version/fix_python_build_.patch

module load cuda/11.7

cd build
cmake ../ \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCOMPILER=GNU  \
    -DMPI=FALSE -DINSTALL_TESTS=TRUE \
    -DDOWNLOAD_MINICONDA=TRUE \
    -DBUILD_PYTHON=FALSE \
    2>&1 | tee cmake.log
make -j `nproc` 2>&1 | tee make.log
make install 2>&1 | tee make_install.log

mkdir -p $PREFIX/build_logs
cp cmake.log make.log make_install.log $PREFIX/build_logs

# Create modulefile
module_file_path=$PREFIX_APP_DIR/modules/$software_kind/$name/$version
mkdir -p `dirname $module_file_path`
# Set template variables
# Commands below assume that TEMPLATE_PREFIX is used in template_modulefile
export TEMPLATE_PREFIX=$PREFIX
envsubst '$TEMPLATE_PREFIX' \
   < $APPLICATION_REPOSITORY_PATH/$name/template_modulefile \
   > $module_file_path

## Ensure all users have executable permission for all directories
## and read permission for all files
find $PREFIX_APP_DIR/modules/$software_kind/$name -type d -exec chmod 755 {} \;
chmod 644 $PREFIX_APP_DIR/modules/$software_kind/$name/$version

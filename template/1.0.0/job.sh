#!/bin/bash -eu
#PBS -l select=1:ncpus=4
#PBS -l walltime=24:00:00

# Parameters
software_kind=CHANGEME # util or apl
name=CHANGEME
version=CHANGEME

PREFIX=$PREFIX_APP_DIR/packages/$software_kind/$name/$version

WORK_DIR=/lwork/users/$USER/$PBS_JOBID
cd $WORK_DIR

# Download source
# TODO: Write download command here

# Build
# TODO: Write build commands here

# Create modulefile
module_file_path=$PREFIX_APP_DIR/modules/$software_kind/$name/$version
mkdir -p `dirname $module_file_path`
# Set template variables
# TODO: Write template variables here
# Commands below assume that TEMPLATE_PREFIX is used in template_modulefile
export TEMPLATE_PREFIX=$PREFIX
envsubst '$TEMPLATE_PREFIX' \
    < $APPLICATION_REPOSITORY_PATH/$name/template_modulefile \
    > $module_file_path

## Ensure all users have executable permission for all directories
## and read permission for all files
find $PREFIX_APP_DIR/modules/$software_kind/$name -type d -exec chmod 755 {} \;
chmod 644 $PREFIX_APP_DIR/modules/$software_kind/$name/$version

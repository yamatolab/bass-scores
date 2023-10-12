#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N openmpi-4.0.7-gcc11 `dirname $0`/job.sh

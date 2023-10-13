#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N amber-20_cuda11.7 -m ae `dirname $0`/job.sh

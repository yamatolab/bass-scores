#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N amber-20_cuda10.2 `dirname $0`/job.sh

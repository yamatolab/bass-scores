#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N amber-22_cuda11.7_mpi -m ae `dirname $0`/job.sh

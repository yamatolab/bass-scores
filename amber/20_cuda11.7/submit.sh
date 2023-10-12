#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N template-1.0.0 `dirname $0`/job.sh

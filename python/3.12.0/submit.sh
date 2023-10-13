#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N python-3.12.0 `dirname $0`/job.sh

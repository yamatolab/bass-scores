#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N openpbs-4.1.6 `dirname $0`/job.sh

#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N charmm-c47b2 `dirname $0`/job.sh

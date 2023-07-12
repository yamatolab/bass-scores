#!/bin/bash

# Assume that the job.sh is in the same directory as this script
qsub -N gcc-toolset-11.4.0 `dirname $0`/job.sh

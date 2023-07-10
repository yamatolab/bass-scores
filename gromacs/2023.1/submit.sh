#!/bin/bash

qsub -N gromacs-2023.1 `dirname $0`/job.sh

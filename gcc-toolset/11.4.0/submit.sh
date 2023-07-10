#!/bin/bash

qsub -N gcc-toolset-11.4.0 -v TEMPLATE_MODULEFILE=$PWD/../template_modulefile job.sh

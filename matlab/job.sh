#!/bin/bash

#SBATCH -a 2-10
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00

casefolder="${PWD}/cases/${SLURM_ARRAY_TASK_ID}"
cd "${casefolder}"
echo "I'm running case ${SLURM_ARRAY_TASK_ID}, in folder ${casefolder}"

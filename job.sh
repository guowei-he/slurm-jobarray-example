#!/bin/bash

#SBATCH -a 2-18
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00

# Path to list of input commands
commands="./commands"

# Run the commands
command_list="${TMP}/${USER}-${SLURM_JOB_ID}-command"
awk "NR == $SLURM_ARRAY_TASK_ID {print; exit}" ${commands} > ${command_list}
echo "Doing line ${SLURM_ARRAY_TASK_ID}, $(cat ${command_list})"
source ${command_list}
echo "Finished line ${SLURM_ARRAY_TASK_ID}"
rm "${command_list}"

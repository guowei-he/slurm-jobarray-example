#!/bin/bash

#SBATCH -a 1-100
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00

### POSSIBLY NEED TO SOURCE .bashrc TO GET LIBRARY PATHS ###

# Path to list of input commands
commands="./commands"

# Run the commands
command_list="${TMP}/${USER}-${SLURM_JOB_ID}-command"
awk "NR == $SLURM_ARRAY_TASK_ID {print; exit}" ${commands} > ${command_list}
echo "Doing line ${SLURM_ARRAY_TASK_ID}, $(cat ${command_list})"
source ${command_list}
echo "Finished line ${SLURM_ARRAY_TASK_ID}"
rm -rf ${command_list}

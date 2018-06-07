#!/bin/bash

#SBATCH -a 90-101
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00

# Path to list of input commands
commands="./commands"

# Run the commands
my_command_file="${TMP}/${USER}-${SLURM_JOB_ID}-command"
awk "NR == $SLURM_ARRAY_TASK_ID {print; exit}" ${commands} > ${my_command_file}
echo "Doing line ${SLURM_ARRAY_TASK_ID}, $(cat ${my_command_file})"
source ${my_command_file}
echo "Finished line ${SLURM_ARRAY_TASK_ID}"
rm "${my_command_file}"

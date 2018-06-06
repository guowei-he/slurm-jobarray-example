#!/bin/bash
#
# This script bootsctrap the 100 cases from the given input file
#
# Input:
#   A text file storing all inputs. Each line a case.
#   A template folder containing the template jobs script, gms script, and possibly any gdx input.
#
# Output:
#   A bunch of folders. Each one will containing the job script from template, input and individual parameters.
#
# Parameters in gms:
#   Beta: CHANGEFLAGBETA
#   E1:   CHANGEFLAGE1
#   E2:   CHANGEFLAGE2
#

err() {
  echo "$@" >&2
  exit 1
}

main() {
  if [[ "$#" -ne 1 ]]; then
    err "Usage: $0 <input-file>"
  fi
  inputfile="$1"
  echo "Using ${inputfile}"
 
  template_directory="${PWD}/template"  
 
  # loop over each line
  ncases=$(wc -l ${inputfile}  | awk '{print $1}')
  echo "Generating ${ncases} cases"

  # create folder
  working_directory=${PWD}/cases
  if [[ -d ${working_directory} ]]; then
    err "${working_directory} already exists"
  fi
  mkdir ${working_directory}

  # copy input
  for icase in $(seq ${ncases}); do
    echo "Creating case ${icase}"
    icase_directory="${working_directory}/${icase}"
    mkdir ${icase_directory}
    e1=$(awk "NR == $icase {print; exit}" ${inputfile} | awk '{print $1}')
    echo "My E1 is ${e1}"
    e2=$(awk "NR == $icase {print; exit}" ${inputfile} | awk '{print $2}')
    echo "My E2 is ${e2}"
    beta=$(awk "NR == $icase {print; exit}" ${inputfile} | awk '{print $3}')
    echo "My Beta is ${beta}"
    echo

    target_gms_script="${icase_directory}/UpdatedModel.gms"

    cp "${template_directory}/UpdatedModel.gms" "${target_gms_script}"
#    cp "${template_directory}/JordanDataUp.gdx" ${icase_directory}/
    
    sed -i "s/CHANGEFLAGBETA/${beta}/" ${target_gms_script}
    sed -i "s/CHANGEFLAGE1/${e1}/" ${target_gms_script}
    sed -i "s/CHANGEFLAGE2/${e2}/" ${target_gms_script}
  done

  # create job array script
}

main "$@"


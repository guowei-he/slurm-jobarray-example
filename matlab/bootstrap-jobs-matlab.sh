#!/bin/bash
#
# This script bootsctrap the Matlab cases from the given input file
#
# Input:
#   A text file storing all inputs. Each line a case.
#   A template folder containing the template jobs script, gms script, and possibly any gdx input.
#
# Output:
#   A bunch of folders. Each one will containing the job script from template, input and individual parameters.
#
# Keyword:
#   CHANGEFLAGVAR<1-x>
#
# Author:
#   Guowei He <gh50@nyu.edu>
#

err() {
  echo "$@" >&2
  exit 1
}

main() {
  if [[ "$#" -ne 2 ]]; then
    err "Usage: $0 <inputfile> <templatefile>"
  fi
  inputfile="$1"
  echo "Using input: ${inputfile}"
  templatefile="$2"
  echo "Using template: ${templatefile}"

  # Keyword base
  keybase="CHANGEFLAGVAR" 

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
    target_file="${icase_directory}/$(basename ${templatefile})"

    cp "${templatefile}" "${target_file}"
    
    echo "Generating case ${icase} in ${target_file}"

    line=$(awk "NR == $icase {print; exit}" ${inputfile})
    iword=1
    for word in $line; do
      keyword="${keybase}${iword}"
      echo "Changed: ${word} with keyword ${keyword}"
      sed -i "s/${keyword}/${word}/g" "${target_file}"
      iword=$((iword + 1))
    done
    echo "Done"
    echo    
    
  done

}

main "$@"


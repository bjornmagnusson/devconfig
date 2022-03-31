#!/usr/bin/env bash

readonly package="validate.sh"
if [ ! $(command -v "yq") ]; then
    echo "Required software $software is missing"
    exit 1
fi
SOFTWARE_FILE="softwares.yaml"
SOFTWARE_YAML=$(yq read "$SOFTWARE_FILE")
if [[ $? != 0 ]]; then
  echo "Failed to find $SOFTWARE_FILE"
  exit 1
fi
readonly required_software=$(yq r $SOFTWARE_FILE 'required')
readonly recommended_software=$(yq r $SOFTWARE_FILE 'recommended')

echo "===== Required software ====="
for software in $required_software; do
    echo "* $software"
done

missing_software=()

for software in $required_software; do
    if [ ! $(command -v $software) ]; then
        echo "Required software $software is missing"
        missing_software+=($software)
    fi
done

if [ ${#missing_software[@]} -ne 0 ]; then
    echo "Required software is missing"
    exit 1
fi
echo "=============================="

echo "===== Recommended software ====="
for software in $recommended_software; do
    echo "* $software"
done

for software in $recommended_software; do
    if [ ! $(command -v $software) ]; then
        echo "Recommended software $software is missing"
        missing_software+=($software)
    fi
done
echo "=============================="
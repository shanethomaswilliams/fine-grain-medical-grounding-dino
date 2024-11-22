#!/bin/bash

if [ $# -eq 1 ]; then
    OUTPUT_DIR=$1
else
    OUTPUT_DIR="output-$(date '+%b-%d-%Y_%I-%M%p')"  # Example: output-Nov-21-2024_02-30PM
    echo "No output directory specified. Using: ${OUTPUT_DIR}"
fi

echo "Final OUTPUT_DIR is: ${OUTPUT_DIR}"

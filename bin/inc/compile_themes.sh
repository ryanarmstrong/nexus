#!/bin/bash

# Get the directory that this script is in.
script_dir=$(dirname $(readlink -f $0))

# Include Functions in build_functions.sh
. ${script_dir}/build_functions.sh
cd ${base_dir}

# Compile any SASS Compass projects found
compile_sass

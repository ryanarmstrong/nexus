#!/bin/bash

# header script
#
# This script grabs passed flags and sets up variables so scripts can be chained
# or run independantly.

# FLAG OPTIONS
#
# -dev
#   Sets the script to run in development mode. Currently this means that the
#   script will use the development version of the Drush Make file, and will
#   include .git directory.
#
# -webroot somevalue
#   The default webroot is 'www' but you can specifiy a different directory if
#   desired.
#
# -y
#   Skips all promts and assumes a 'confirm' action.

# Set the base directory
base_dir=$(git rev-parse --show-toplevel)
cd ${base_dir}

# VARIABLES
# Grab the command flags passed as arguments
options=$@
arguments=($options)
index=0

# Project variables
project_name="nexus"
human_project_name="Nexus"
webroot="webroot"

# Flag Defaults
development=0
force=0

# Set passed flags
for argument in $options
  do
    # Incrementing index
    index=`expr $index + 1`

    # The conditions
    case $argument in
      -webroot)
        webroot=${arguments[index]} ;;
      -dev)
        development=1
        echo "- Script is running in development mode." ;;
      -y)
        force=1 ;;
    esac
done

# Set the needed Drupal paths
webroot_dir=${base_dir}/${webroot}
profile_dir=${base_dir}/${project_name}

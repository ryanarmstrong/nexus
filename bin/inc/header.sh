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
# -deploy
#   Sets the script to run in deployment mode. 
#    - Script will use copy commands instead of symbolic links.
#    - credentials_dir will be set to '/data/apps/credentials' (Can be overriden)
#    - assets_source will be set to '/tmp' (Can be overriden)
# -webroot somevalue
#   The default webroot is 'www' but you can specifiy a different directory if
#   desired.
# -credentials_dir somevalue
#   The default location of the credentials.sh is 'bin/inc' but you can specifiy 
#   a different directory if desired.
# -assets_source somevalue
#   The default location of the assets.zip is the project root but you can specifiy 
#   a different directory if desired.

# Set the base directory
base_dir=$(git rev-parse --show-toplevel)
cd ${base_dir}

# VARIABLES
# Grab the command flags passed as arguments
options=$@
arguments=($options)
index=0

# Flag Defaults
development=0
deployment=0
force=0
credentials_dir=${base_dir}/bin/inc
assets_source=${base_dir}

# Checks
creds_set=0
assets_set=0

# Include the project settings.
. bin/inc/settings.sh

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
      -deploy)
        if [ "$creds_set" == '0' ];
          then
            credentials_dir=/data/apps/credentials
        fi
        if [ "$assets_set" == '0' ];
          then
            assets_source=/tmp
        fi
        deployment=1
        echo "- Script is running in deployment mode." ;;
      -credentials_dir)
        credentials_dir=${arguments[index]} 
        creds_set=1 ;;
      -assets_source)
        assets_source=${arguments[index]}
        assets_set=1 ;;
    esac
done

# Set the needed Drupal paths
webroot_dir=${base_dir}/${webroot}
profile_dir=${base_dir}/${project_name}

echo "- Webroot has been set to: ${webroot}"
echo "- Credentails directory has been set to: ${credentials_dir}"
echo "- Assets source has been set to: ${assets_source}"

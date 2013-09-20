#!/bin/bash

#
# VARIABLES
#
# Save the current directory to navigate back to later.
cwd=$(pwd)

# Get the directory that this script is in.
base_dir=$(git rev-parse --show-toplevel)

cd ${base_dir}

# Set the needed Drupal paths
modules_dir=${base_dir}/${webroot}/sites/all/modules/custom
features_dir=${base_dir}/${webroot}/sites/all/modules/features
themes_dir=${base_dir}/${webroot}/sites/all/themes
libraries_dir=${base_dir}/${webroot}/sites/all/libraries
translations_dir=${base_dir}/${webroot}/sites/all/translations
sites_dir=${base_dir}/${webroot}/sites

#
# FUNCTIONS
#

# Function: remove_site
#
# If it detects any settings*.php files, it will prompt the user to back them
# up. After that it deletes the webroot.
#
function remove_site {
  # Delete the webroot
  rm -rf ${webroot}
  echo "- Removing ${webroot}"
}

# Function: components_symlink
#
# Takes in a directory name (modules, features, themes) and looks for those
# directories in the root. It checks to make sure that directory exists, that it
# isn't a symbolic link, and that it has contents. It then symbolically links it
# to the appropriate place in the Drupal directory structure.
#
# $1 - The name of the component. Should be modules, themes, or features.
# $2 - The directory to place the symbolic link
#
function components_symlink {
  if [[ -d "${base_dir}/${1}" && ! -L "${base_dir}/${1}" ]] ; then
    if [ "$(ls -A ${base_dir}/${1})" ]; then
      # Drupal doesn't make a libraries folder on install. Create the directory
      # if it doesn't already exist.
      if [ ! -d "${2}" ]; then
        echo "- ${1} folder does not exist. Creating it."
        mkdir ${2}
      fi

      # Loop through each subfolder and create a symlink for it.
      for directory in $(find ${base_dir}/${1} -mindepth 1 -maxdepth 1)
      do
        # Create the symbolic link.
        echo "- Symbolically linking ${1}: ${directory}."
        ln -s ${directory} ${2}
      done

      # Look for any MAKEFILES and run them
      for file in $(find ${base_dir}/${1} -name '*.make')
      do
        if [ "$development" == '1' ];
          then
            # Run the MAKEFILE with the --working-copy flag to grab the .git directory
            echo '- Found' ${file} '. Running Drush Make in development mode.'
            echo ""
            cd ${base_dir}/${webroot}/sites/all
            drush make ${file} --working-copy --no-core --contrib-destination=. ./
            echo ""
            cd ${base_dir}
          else
            echo '- Found' ${file} '. Running Drush Make in production mode.'
            echo ""
            cd ${base_dir}/${webroot}/sites/all
            drush make ${file} --no-core --contrib-destination=. ./
            echo ""
            cd ${base_dir}
        fi
      done
    fi
  fi
}

# Function: components_copy
#
# Takes in a directory name (i.e libraries) and looks for those directories in
# the root. It checks to make sure that directory exists, that it isn't a symbolic
# link, and that it has contents. It then copies the contents to the appropriate
# place in the Drupal directory structure.
#
# $1 - The name of the component. Typically this will be libraries
# $2 - The directory to place the symbolic link
#
function components_copy {
  if [[ -d "${base_dir}/${1}" && ! -L "${base_dir}/${1}" ]] ; then
    if [ "$(ls -A ${base_dir}/${1})" ]; then
      echo "- Copying ${1}."
      # Drupal doesn't make a libraries folder on install. Create the directory
      # if it doesn't already exist.
      if [ ! -d "${2}" ]; then
        echo "- ${1} folder does not exist. Creating it."
        mkdir ${2}
      fi

      # Copy all of the contents of the root libraries into the Drupal libraries
      # directory
      cp -r ${base_dir}/${1}/* ${2}
    fi
  fi
}

# Function: compile_sass
#
# Finds any config.rb files and compiles the SASS code
#
function compile_sass {
  # Temp move settings
  # echo "Hi"
  for file in $(find -name config.rb | grep -v "${base_dir}/")
  do
    theme_dir=$(dirname ${file})
    echo '- Compiling ' ${theme_dir}
    cd ${theme_dir}
    compass compile
    cd ${base_dir}
  done
}

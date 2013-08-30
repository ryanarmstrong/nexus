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
modules_dir=${base_dir}/${webroot}/sites/all/modules
features_dir=${base_dir}/${webroot}/sites/all/features
themes_dir=${base_dir}/${webroot}/sites/all/themes
libraries_dir=${base_dir}/${webroot}/sites/all/libraries

#
# FUNCTIONS
#

# Function: backup_site
#
# Finds any settings*.php files in the webroot and moves them to the base_dir
# for temporary backup. It also moves the files directory if detected. Both
# will later be moved back into place by the function restore_site.
#
function backup_site {
  # Temp move settings
  for file in $(find -name settings*.php | grep -v "${base_dir}/${webroot}/sites/default/")
  do
    echo '- Backing up ' ${file}
    cp -f ${file} ${base_dir}/
  done

  # Temp move files directory
  echo '- Backing up files directory.'
  if [[ -d "${base_dir}/${webroot}/sites/default/files" ]] ; then
    mv ${base_dir}/${webroot}/sites/default/files ${base_dir}/files
  fi
}

# Function: remove_site
#
# If it detects any settings*.php files, it will prompt the user to back them
# up. After that it deletes the webroot.
#
function remove_site {
  # Look for a settings.php. Ask the user if they want to backup the site if
  # it exists.
  if [ -a ${base_dir}/${webroot}/sites/default/settings.php ] ;
    then
      if [ "$force" == '1' ];
        then
          echo "- Backing up the current site for restoration later."
          backup_site
        # Otherwise ask for permission to remove the webroot.
        else
          echo ""
          echo "- Would you like to backup and restore the existing site?"
          select yn in "Yes" "No"; do
            case $yn in
              Yes )
                backup_site
                break ;;
              No )
                echo ""
                echo "- Existing site deleted. Starting from scratch. Remember to clear out your database!"
                echo ""
                exit ;;
            esac
          done
      fi
    else
      # Nothing to backup
      echo "- No settings.php detected. No site to backup."
  fi

  # Delete the webroot
  rm -rf ${webroot}
  echo "- Removing ${webroot}"
}

# Function: restore_site
#
# Finds any settings*.php files in the base_dir and moves them  back into place
# in the webroot. If it detects a files dir in the base_dir it will also move
# that back into place. If it detects backed up settings*.php files but no file
# directory, it will create one. It then runs drush rr to be safe.
#
function restore_site {
  # Cleanup settings.php
  if [ -a ${base_dir}/settings.php ] ;then
    # Restore settings files
    for file in $(find . -name 'settings*.php')
    do
      echo '- Restoring ' ${file}
      mv -f ${file} ${base_dir}/${webroot}/sites/default/
    done

    # Cleanup files directory. This is nested within the check for the settings.php
    # So that it creates a files directory automatically if one isn't detected.
    # This eliminates the need to create a blank files directory in the root.
    #
    # This wouldn't prevent Drupal from loading, but you would get an error in
    # the status reportsaying that the files directory is missing.
    if [[ -d "${base_dir}/files" ]] ;
      then
        echo "- Temporary files directory detected. Restoring."
        mv ${base_dir}/files ${base_dir}/${webroot}/sites/default/files
      else
        echo "- Temporary files directory not detected. Creating an empty files directory."
        mkdir ${base_dir}/${webroot}/sites/default/files -m 755
    fi

    # Clear cache and rebuild the registry in case things moved around
    cd ${base_dir}/${webroot}/sites
    echo ""
    drush rr
    cd ${base_dir}
    echo ""
  fi
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
      # Modules need to go into the custom directory. Create that directory and
      # then add the path
      if [ "$1" == "modules" ];
        then
          echo "- Custom modules detected. Creating a custom directory."
          mkdir ${2}/custom
          custom="custom/"
        else
          custom=""
      fi
      for directory in $(find ${base_dir}/${1}/ -mindepth 1 -maxdepth 1 -type d)
      do
        # Create the symbolic link.
        echo "- Symbolically linking ${1}: ${directory}."
        ln -s ${directory} ${2}/${custom}
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
      echo "- Copying ${1} that couldn't be loaded via Drush Make."
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
